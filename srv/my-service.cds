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

    entity Addresses @(Capabilities : {
        InsertRestrictions : {Insertable : false},
        UpdateRestrictions : {Updatable : false},
        DeleteRestrictions : {Deletable : false}
    }) as projection on Addr;

    entity Employees @(Capabilities : {
        InsertRestrictions : {Insertable : false},
        UpdateRestrictions : {Updatable : false},
        DeleteRestrictions : {Deletable : false}
    }) as projection on Empl;

    entity POs @(
        title               : '{i18n>poService}',
        odata.draft.enabled : true,
        Capabilities        : {
            InsertRestrictions : {Insertable : true},
            UpdateRestrictions : {Updatable : true},
            DeleteRestrictions : {Deletable : true}
        }
    )  as projection on Headers;

    entity POItems @(
        title               : '{i18n>poService}',
        odata.draft.enabled : true,
        Capabilities        : {
            InsertRestrictions : {Insertable : true},
            UpdateRestrictions : {Updatable : true},
            DeleteRestrictions : {Deletable : true}
        }
    )  as projection on Items;

}

service MasterDataService {
    entity Addresses @(Capabilities : {
        InsertRestrictions : {Insertable : true},
        UpdateRestrictions : {Updatable : true},
        DeleteRestrictions : {Deletable : true}
    }) as projection on Addr;

    entity Employees @(Capabilities : {
        InsertRestrictions : {Insertable : true},
        UpdateRestrictions : {Updatable : true},
        DeleteRestrictions : {Deletable : true}
    }) as projection on Empl;

}
