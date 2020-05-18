using opensap.PurchaseOrder.Headers as Headers from '../db/schema';
using opensap.PurchaseOrder.Items as Items from '../db/schema';

service CatalogService {

    entity MyEntity {
        key ID : Integer;
    }


    entity POs @(
        title        : '{i18n>poService}',
        odata.draft.enabled: true,
        Capabilities : {
            InsertRestrictions : {Insertable : true},
            UpdateRestrictions : {Updatable : true},
            DeleteRestrictions : {Deletable : true}
        }
    ) as projection on Headers;

    entity POItems @(
        title        : '{i18n>poService}',
        odata.draft.enabled: true,        
        Capabilities : {
            InsertRestrictions : {Insertable : true},
            UpdateRestrictions : {Updatable : true},
            DeleteRestrictions : {Deletable : true}
        }
    ) as projection on Items;

}
