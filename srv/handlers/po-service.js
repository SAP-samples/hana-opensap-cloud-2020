const cds = require('@sap/cds')
module.exports = cds.service.impl(function () {

  const { POs } = this.entities()

  this.after(['CREATE', 'UPDATE', 'DELETE'], POs, async (po, req) => {
    const header = req.data
    req.on('succeeded', () => {
      global.it || console.log(`< emitting: poChanged ${header.ID}`)
      this.emit('poChange', header)
    })
  })


  this.on('sleep', async (req) => {
    console.log('sleep')
    return true
  })

})


