using {
    Currency,
    managed,
    sap,
    cuid
} from '@sap/cds/common';

using {opensap.common} from './common';
using {opensap.MD} from './masterData';

namespace opensap.PurchaseOrder;


entity Headers : managed, cuid, common.Amount {
    item                         : Association to many Items
                                       on item.poHeader = $self;
    noteId                       : common.BusinessKey null;
    //    partner                      : UUID;
    partner                      : Association to one MD.BusinessPartners;
    lifecycleStatus              : common.StatusT default 1;
    approvalStatus               : common.StatusT;
    confirmStatus                : common.StatusT;
    orderingStatus               : common.StatusT;
    invoicingStatus              : common.StatusT;
    @readonly createdByEmployee  : Association to one MD.Employees
                                       on createdByEmployee.email = createdBy;
    @readonly modifiedByEmployee : Association to one MD.Employees
                                       on modifiedByEmployee.email = modifiedBy;
}

annotate Headers with @(
    title       : '{i18n>poService}',
    description : '{i18n>poService}'
) {
    ID              @(
        title       : '{i18n>po_id}',
        description : '{i18n>po_id}',
    );

    items           @(
        title       : '{i18n>po_items}',
        description : '{i18n>po_items}',
        Common      : {Text : {
            $value                 : ITEMS.PRODUCT,
            ![@UI.TextArrangement] : #TextOnly
        }}
    );

    noteId          @(
        title       : '{i18n>notes}',
        description : '{i18n>notes}'
    );

    partner         @(
        title       : '{i18n>partner_id}',
        description : '{i18n>partner_id}'
    );

    lifecycleStatus @(
        title               : '{i18n>lifecycle}',
        description         : '{i18n>lifecycle}',
        Common.FieldControl : #ReadOnly
    );

    approvalStatus  @(
        title               : '{i18n>approval}',
        description         : '{i18n>approval}',
        Common.FieldControl : #ReadOnly
    );

    confirmStatus   @(
        title               : '{i18n>confirmation}',
        description         : '{i18n>confirmation}',
        Common.FieldControl : #ReadOnly
    );

    orderingStatus  @(
        title               : '{i18n>ordering}',
        description         : '{i18n>ordering}',
        Common.FieldControl : #ReadOnly
    );

    invoicingStatus @(
        title               : '{i18n>invoicing}',
        description         : '{i18n>invoicing}',
        Common.FieldControl : #ReadOnly
    );

};

entity Items : cuid, common.Amount, common.Quantity {
    poHeader     : Association to Headers;
    product      : Association to one MD.Products; //common.BusinessKey;
    noteId       : common.BusinessKey null;
    deliveryDate : common.SDate;
}

annotate Items with {
    ID           @(
        title       : '{i18n>internal_id}',
        description : '{i18n>internal_id}',
    );

    product      @(
        title               : '{i18n>product}',
        description         : '{i18n>product}',
        Common.FieldControl : #Mandatory,
        Search.defaultSearchElement
    );

    deliveryDate @(
        title       : '{i18n>deliveryDate}',
        description : '{i18n>deliveryDate}'
    )
}


define view ItemView as
    select from Items {
        poHeader.partner  as![partner],
        product.productId as![productId],
        currency,
        grossAmount,
        netAmount,
        taxAmount,
        quantity,
        quantityUnit,
        deliveryDate
    };


define view POHeaderConsumption as
    select from Headers {
        @UI.lineItem   : [{importance : Importance.High}]
        @UI.fieldGroup : [{position : 10}]
        ID,

        @UI.lineItem   : [{importance : Importance.Medium}]
        @UI.fieldGroup : [{position : 20}]
        @valueList     : {
            collectionPath       : 'SupplierVH',
            searchSupported      : false,
            parameterInOut       : [{
                localDataProperty : 'PARTNER_PARTNERID',
                valueListProperty : 'Supplier_Id'
            }],
            parameterDisplayOnly : [{valueListProperty : 'Supplier_CompanyName'}]
        }
        partner.ID                   as partnerID,

        @UI.lineItem   : [{importance : Importance.High}]
        @UI.fieldGroup : [{position : 30}]
        partner.companyName,

        @UI.lineItem   : [{importance : Importance.High}]
        @UI.fieldGroup : [{position : 40}]
        partner.address.city,

        @UI.fieldGroup : [{position : 41}]
        modifiedAt,

        @UI.fieldGroup : [{position : 42}]
        modifiedByEmployee.loginName as ![modifiedBy],

        @UI.fieldGroup : [{position : 43}]
        createdAt,

        @UI.fieldGroup : [{position : 44}]
        createdByEmployee.loginName  as ![createdBy],


        @UI.lineItem   : [{importance : 'High'}]
        @UI.fieldGroup : [{position : 50}]
        grossAmount,


        @UI.fieldGroup : [{position : 51}]
        netAmount,

        @UI.fieldGroup : [{position : 52}]
        taxAmount,

        @UI.lineItem   : [{importance : 'Low'}]
        @UI.fieldGroup : [{position : 60}]
        currency.code,


        @UI.fieldGroup : [{position : 61}]
        noteId,

        @UI.lineItem   : [{importance : 'High'}]
        @UI.fieldGroup : [{position : 70}]
        approvalStatus,

        @UI.fieldGroup : [{position : 71}]
        confirmStatus,

        @UI.fieldGroup : [{position : 72}]
        lifecycleStatus,


        @UI.fieldGroup : [{position : 73}]
        orderingStatus
    };

define view POItemConsumption as
    select from Items {
        @UI.lineItem   : [{importance : Importance.High}]
        @UI.fieldGroup : [{position : 10}]
        poHeader.ID,

        @UI.lineItem   : [{importance : Importance.High}]
        @UI.fieldGroup : [{position : 30}]
        product.productId,

        @UI.lineItem   : [{importance : Importance.High}]
        @UI.fieldGroup : [{position : 40}]
        product.name,

        @UI.lineItem   : [{importance : 'High'}]
        @UI.fieldGroup : [{position : 50}]
        grossAmount,

        @UI.fieldGroup : [{position : 51}]
        netAmount,

        @UI.fieldGroup : [{position : 52}]
        taxAmount,

        @UI.lineItem   : [{importance : 'Low'}]
        @UI.fieldGroup : [{position : 60}]
        currency.code,

        @UI.lineItem   : [{importance : 'High'}]
        @UI.fieldGroup : [{position : 70}]
        quantity,

        @UI.lineItem   : [{importance : 'Low'}]
        @UI.fieldGroup : [{position : 71}]
        quantityUnit,

        @UI.lineItem   : [{importance : 'High'}]
        @UI.fieldGroup : [{position : 80}]
        deliveryDate,

        @UI.lineItem   : [{importance : 'High'}]
        @UI.fieldGroup : [{position : 81}]
        product.category
    };
