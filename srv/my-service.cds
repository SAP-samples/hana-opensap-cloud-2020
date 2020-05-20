using {
    opensap.PurchaseOrder.Headers as Headers,
    opensap.PurchaseOrder.Items as Items
} from '../db/schema';
using {opensap.MD.Addresses as Addr} from '../db/schema';

service POService {

    entity POs @(
        title               : '{i18n>poService}',
        odata.draft.enabled : true,
        Capabilities        : {
            InsertRestrictions : {Insertable : true},
            UpdateRestrictions : {Updatable : true},
            DeleteRestrictions : {Deletable : true}
        }
    ) as projection on Headers;

    entity POItems @(
        title               : '{i18n>poService}',
        odata.draft.enabled : true,
        Capabilities        : {
            InsertRestrictions : {Insertable : true},
            UpdateRestrictions : {Updatable : true},
            DeleteRestrictions : {Deletable : true}
        }
    ) as projection on Items;

}

service MasterDataService {
    entity Addresses @(Capabilities : {
        InsertRestrictions : {Insertable : true},
        UpdateRestrictions : {Updatable : true},
        DeleteRestrictions : {Deletable : true}
    }) as projection on Addr;

}
