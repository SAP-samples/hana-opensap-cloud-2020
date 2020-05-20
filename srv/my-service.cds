using {
    opensap.PurchaseOrder.Headers as Headers,
    opensap.PurchaseOrder.Items as Items
} from '../db/schema';
using {
    opensap.MD.Addresses as Addr,
    opensap.MD.Employees as Empl,
    opensap.MD
} from '../db/schema';

service POService {

    @readonly
    entity Addresses as projection on Addr;

    @readonly
    entity Employees as projection on Empl;

    entity POs @(
        title               : '{i18n>poService}',
        odata.draft.enabled : true
    )                as projection on Headers;

    entity POItems @(
        title               : '{i18n>poService}',
        odata.draft.enabled : true
    )                as projection on Items;

}

service MasterDataService {
    entity Addresses as projection on Addr;
    entity Employees as projection on Empl;

}
