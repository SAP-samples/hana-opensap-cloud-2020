const dbClass = require("sap-hdbext-promisfied")
const circuitBreaker = require('opossum')
const PrometheusMetrics = require('opossum-prometheus')
const breakerOptions = {
  timeout: 3000, // If our function takes longer than 3 seconds, trigger a failure
  errorThresholdPercentage: 50, // When 50% of requests fail, trip the circuit
  resetTimeout: 10000 // After 10 seconds, try again.
}
async function sleep(req) {
  let db = new dbClass(req)
  const hdbext = require("@sap/hdbext")
  const sp = await db.loadProcedurePromisified(hdbext, null, 'sleep')
  const results = await db.callProcedurePromisified(sp, [])
  return results
}
const breaker = new circuitBreaker(sleep, breakerOptions)
const prometheus = new PrometheusMetrics([breaker])
breaker.fallback(() => {
  return false
})
breaker.on('open', () => {
  console.log(`Circuit Breaker has been opened!`)  
  console.log(prometheus.metrics)
})
breaker.on('close', () => {
  console.log(`Circuit Breaker has been closed`)
  console.log(prometheus.metrics)
})
breaker.on('halfOpen', () => {
  console.log(`Circuit Breaker is half open`)
  console.log(prometheus.metrics)
})

const cds = require('@sap/cds')
module.exports = cds.service.impl(function () {

  const { POs, POnoDraft } = this.entities()

  this.after(['CREATE', 'UPDATE', 'DELETE'], [POs, POnoDraft], async (po, req) => {
    const header = req.data
    req.on('succeeded', () => {
      global.it || console.log(`< emitting: poChanged ${header.ID}`)
      this.emit('poChange', header.ID)
    })
  })

  this.on('sleep', async (req) => {
    if (req._.req.db) {
      req._.req.loggingContext.getTracer(__filename).info('Inside CDS Sleep Function Handler')
     
      try {
        if (!await breaker.fire(req._.req.db)) {
          throw { "Error": "Query Timeout" }
        }
        return true
      } catch (error) {
        req._.req.loggingContext.getLogger('/Application/CDSSleep').error(error)
        req._.req.db.abort()
        return false
      }
    }
    return false
  })

})


