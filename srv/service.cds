using {
    opensap.PurchaseOrder.Headers as Headers,
    opensap.PurchaseOrder.Items as Items
} from '../db/schema';
using {
    opensap.MD.Addresses as Addr,
    opensap.MD.Employees as Empl,
    opensap.MD.BusinessPartners as BP,
    opensap.MD.Products as Prod,
    opensap.MD
} from '../db/schema';

service POService @(requires:'authenticated-user') @(impl: './handlers/po-service.js') @(path: '/POService') {
    
    @readonly
    entity Addresses        as projection on Addr;

    @readonly
    entity Employees        as projection on Empl;

    @readonly
    entity BusinessPartners as projection on BP;

    @readonly
    entity Products as projection on Prod;

    entity POs @(
        title               : '{i18n>poService}',
        odata.draft.enabled : true
    )                       as projection on Headers;

   event poChange : {
       po:  POs;
   }

    entity POItems @(
        title               : '{i18n>poService}',
        odata.draft.enabled : true
    )                       as projection on Items;

    function sleep() returns Boolean;

}

service MasterDataService @(requires:'authenticated-user') @(path: '/MasterDataService') {
    entity Addresses as projection on Addr;
    entity Employees as projection on Empl;

    entity BusinessPartners @(
        title               : '{i18n>businessParnters}',
        odata.draft.enabled : true
    )                as projection on BP;

    entity Products @(
        title               : '{i18n>products}'
    )                as projection on Prod;

}
