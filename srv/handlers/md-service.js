const cds = require('@sap/cds')
module.exports = cds.service.impl(function () {

  const { Buyer } = this.entities()
  
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

})

