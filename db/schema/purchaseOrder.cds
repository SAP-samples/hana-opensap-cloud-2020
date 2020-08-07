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
    @cascade : {all}
    item                         : Composition of many Items
                                       on item.poHeader = $self;
    noteId                       : common.BusinessKey null;
    //    partner                      : UUID;
    partner                      : Association to one MD.BusinessPartners;
    lifecycleStatus              : common.StatusT default 'N';
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
        title            : '{i18n>partner_id}',
        description      : '{i18n>partner_id}',
        Common.ValueList : {
            CollectionPath : 'BusinessPartners',
            Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'partner_ID',
                ValueListProperty : 'ID'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'companyName'
            }
            ]
        }
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

define view![HeaderView] as
    select from Headers {
        ID                          as![PurchaseOrderId],
        createdByEmployee.ID        as![CreatedByEmployeeID],
        createdByEmployee.nameFirst as![CreatedByFirstName],
        createdByEmployee.nameLast  as![CreatedByLastName],
        createdByEmployee.loginName as![CreatedByLoginName],
        createdAt                   as![CreatedAt],
        partner.ID                  as![PartnerId],
        partner.companyName         as![CompanyName],
        currency.code               as![Currency],
        grossAmount                 as![GrossAmount],
        netAmount                   as![NetAmount],
        taxAmount                   as![TaxAmount]
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
        Search.defaultSearchElement,
         Common.ValueList : {
            CollectionPath : 'Products',
            Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'product_productId',
                ValueListProperty : 'productId'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'category'
            },            
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }                    
            ]
        }
    );

    deliveryDate @(
        title       : '{i18n>deliveryDate}',
        description : '{i18n>deliveryDate}'
    )
}


define view![ItemView] as
    select from Items {
        poHeader.partner  as![partner],
        product.productId as![ProductId],
        currency.code     as![CurrencyCode],
        grossAmount       as![Amount],
        netAmount         as![NetAmount],
        taxAmount         as![TaxAmount],
        quantity          as![Quantity],
        quantityUnit      as![QuantityUnit],
        deliveryDate      as![DeliveryDate1]
    };

define view![POView] as
    select from Headers {
        ID                     as![PURCHASEORDERID],
        partner.ID             as![PARTNERID],
        item.product.productId as![PRODUCTID],
        item.currency.code     as![CURRENCY],
        item.grossAmount       as![GROSSAMOUNT],
        item.netAmount         as![NETAMOUNT],
        item.taxAmount         as![TAXAMOUNT],
        item.quantity          as![QUANTITY],
        item.quantityUnit      as![QUANTITYUNIT],
        item.deliveryDate      as![DELIVERYDATE]
    };

define view![POWorklist] as
    select from Headers {
        key ID                         as![PurchaseOrderId],
            partner.ID                 as![PartnerId],
            partner.companyName        as![CompanyName],
            grossAmount                as![GrossAmount],
            currency.code              as![Currency],
            lifecycleStatus            as![LIFECYCLESTATUS],
            approvalStatus             as![APPROVALSTATUS],
            confirmStatus              as![CONFIRMSTATUS],
            orderingStatus             as![ORDERINGSTATUS],
        key item.ID                    as![PurchaseOrderItemId],
            item.product.productId     as![ProductId],
            item.product.name          as![ProductName],
            item.product.desc          as![ProductDesc],
            item.product.price         as![ProductPrice],
            //        item.product.picUrl        as![ProductURL],
            partner.address.city       as![ParnterCity],
            partner.address.postalCode as![ParnterPostalCode],
            item.grossAmount           as![GrossAmount_1],
            item.netAmount             as![NetAmount],
            item.taxAmount             as![TaxAmount],
            item.quantity              as![Quantity],
            item.quantityUnit          as![QuantityUnit],
            item.deliveryDate          as![DeliveryDate]
    };

define view![PURCHASE_ORDER_ITEM_VIEW] as
    select from Items {
        poHeader.ID         as![PO_ITEM_ID],
        poHeader.partner.ID as![PARTNER_ID],
        product             as![PRODUCT_ID],
        currency.code       as![CURRENCY_CODE],
        grossAmount         as![AMOUNT],
        netAmount           as![NET_AMOUNT],
        taxAmount           as![TAX_AMOUNT],
        quantity            as![QUANTITY],
        quantityUnit        as![QUANTITY_UNIT],
        deliveryDate        as![DELIVERY_DATE]
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
