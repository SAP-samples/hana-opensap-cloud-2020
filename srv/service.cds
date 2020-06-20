using {
    opensap.PurchaseOrder.Headers as Headers,
    opensap.PurchaseOrder.Items as Items,
    opensap.PurchaseOrder.POWorklist as POWorklist
} from '../db/schema';
using {
    opensap.MD.Addresses as Addr,
    opensap.MD.Employees as Empl,
    opensap.MD.BusinessPartners as BP,
    opensap.MD.Products as Prod,
    opensap.MD.BuyerView as BuyerViewNative,
    opensap.MD
} from '../db/schema';

using BUYER as BuyerView from '../db/schema';
using USER_DETAILS as UserDetails from '../db/schema';

service POService @(impl : './handlers/po-service.js')@(path : '/POService') {

    @readonly
    entity Addresses                             as projection on Addr;

    @readonly
    entity Employees                             as projection on Empl;

    @readonly
    entity BusinessPartners                      as projection on BP;

    @readonly
    entity Buyer                                 as projection on BuyerView;

    @readonly
    entity Products                              as projection on Prod;

    entity POs @(
        title               : '{i18n>poService}',
        odata.draft.enabled : true
    )                                            as projection on Headers {
        * , item : redirected to POItems
    };

    entity POnoDraft @(
        title               : '{i18n>poService}',
        odata.draft.enabled : false
    )                                            as projection on Headers {
        * , item : redirected to POItemsNoDraft
    };

    event poChange : {
        po : POs;
    }

    entity POItems @(title : '{i18n>poService}') as projection on Items {
        * , poHeader : redirected to POs
    };

    entity POItemsNoDraft @(
        title               : '{i18n>poService}',
        odata.draft.enabled : false
    )                                            as projection on Items {

        * , poHeader : redirected to POnoDraft
    };

    @readonly
    entity PO_Worklist                           as projection on POWorklist;

    function sleep() returns Boolean;

}

service MasterDataService @(impl : './handlers/md-service.js')@(path : '/MasterDataService') {
    entity Addresses                                             as projection on Addr;
    entity Employees                                             as projection on Empl;
    entity User                                                  as projection on UserDetails;
    entity BusinessPartners @(title : '{i18n>businessParnters}') as projection on BP;

    entity Products @(title : '{i18n>products}')                 as projection on Prod {
        * , partner : redirected to BusinessPartners
    };

    entity Buyer                                                 as projection on BuyerViewNative;
}
