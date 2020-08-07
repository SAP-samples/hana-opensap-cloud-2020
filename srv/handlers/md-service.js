/* eslint-disable no-unused-vars */
const cds = require('@sap/cds')
module.exports = cds.service.impl(function () {

  const { Buyer, Products, ProductImages } = this.entities()

  this.before(['READ'], Buyer, async (po, req) => {
    console.log(`InBuyer`)
    // req.on('succeeded', () => {
    //   global.it || console.log(`< emitting: poChanged ${header.ID}`)
    //   this.emit('poChange', header)
    //  })
  })


  this.on(['CREATE'], Buyer, async (req) => {
    console.log(`InBuyerCreate`)
    console.log(req.data)
    req.reply('')
    //  const buyerData = req.data
    //  console(buyerData)
    // req.on('succeeded', () => {
    //   global.it || console.log(`< emitting: poChanged ${header.ID}`)
    //   this.emit('poChange', header)
    //  })
  })

  this.after('each', Products, async (row) =>{
   row.imageUrl = `/odata/v4/MasterDataService/ProductImages('${row.productId}')/image`
  })

  this.on('loadProductImages', async (req) => {
    req._.req.loggingContext.getTracer(__filename).info('Inside loadProductImages Handler')
    try {
      const fs = require("fs")
      const fileExists = require('fs').existsSync
      let products = await cds.run(SELECT.from(Products))
      for (let product of products) {
        let fileName = __dirname + `/images/${product.productId}.jpg`
        if (fileExists(fileName)) {
          let importData = fs.readFileSync(fileName)
          await cds.run(INSERT.into(ProductImages).columns(
            'product.productId', 'imageType', 'image'
          ).values(
             product.productId, 'image/jpeg', importData
           ))
          //await cds.run(UPDATE(Products).set({ imageType: 'image/jpeg', image: importData }).where({ productId: product.productId }))
        }
      }
      return true
    } catch (error) {
      req._.req.loggingContext.getLogger('/Application/loadProductImages').error(error)
      return false
    }
  })

})

