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
    opensap.MD.ProductImages as ProdImages,
    opensap.MD.productCategoryVH as prodCat,
    opensap.MD.BuyerView as BuyerViewNative,
    opensap.MD.partnerRoles as partRoles,
    opensap.MD
} from '../db/schema';

using BUYER as BuyerView from '../db/schema';
using USERDATA_USER_LOCAL as UserDetails from '../db/schema';

service POService @(impl : './handlers/po-service.js')@(path : '/odata/v4/POService') {


    @readonly
    entity Addresses                             as projection on Addr;

    @readonly
    entity Employees                             as projection on Empl;

    @readonly
    entity BusinessPartners                      as projection on BP;

    @readonly
    entity Buyer                                 as projection on BuyerView;

    @readonly
    entity Products @(cds.redirection.target:false)                            as projection on Prod;

    @readonly
    view productCategoryVH  @(cds.redirection.target:false)  as select from prodCat;

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
        po : type of POs:ID;
    }

    entity POItems @(title : '{i18n>poService}') as projection on Items {
        * , poHeader : redirected to POs, product : redirected to Products
    };

    entity POItemsNoDraft @(
        title               : '{i18n>poService}',
        odata.draft.enabled : false
    )                                            as projection on Items {

        * , poHeader : redirected to POnoDraft, product : redirected to Products
    };

    @readonly
    view PO_Worklist as select from POWorklist;


    function sleep() returns Boolean;

}

service MasterDataService @(impl : './handlers/md-service.js')@(path : '/odata/v4/MasterDataService') {
    entity Addresses                                             as projection on Addr;
    entity Employees                                             as projection on Empl;
    entity User                                                  as projection on UserDetails;
    entity BusinessPartners @(title : '{i18n>businessParnters}') as projection on BP;

    entity Products @(title : '{i18n>products}')                 as projection on Prod {
        * , partner : redirected to BusinessPartners
    };

    @readonly
    view productCategoryVH as select from prodCat;

    view partnerRoles as select from partRoles;
    view Buyer as select from BuyerViewNative;

    entity ProductImages                                         as projection on ProdImages {
        * , product : redirected to Products
    };

    function loadProductImages() returns Boolean;
}
