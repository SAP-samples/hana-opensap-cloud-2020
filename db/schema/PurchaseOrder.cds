using {
    Currency,
    managed,
    sap,
    cuid
} from '@sap/cds/common';

using { opensap.common } from './common';
namespace opensap.PurchaseOrder;



entity Headers : managed, cuid, common.amount {
    items           : Association to many Items
                          on items.POHEADER = $self;
    NOTEID          : common.BusinessKey null;
    PARTNER         : UUID @title : '{i18n>partner_id}';
    LIFECYCLESTATUS : common.StatusT default 1;
    APPROVALSTATUS  : common.StatusT;
    CONFIRMSTATUS   : common.StatusT;
    ORDERINGSTATUS  : common.StatusT;
    INVOICINGSTATUS : common.StatusT;
}

annotate Headers with @(
    title       : '{i18n>poService}',
    description : '{i18n>poService}'
) {
    ID              @(
        title       : '{i18n>internal_id}',
        description : '{i18n>internal_id}',
    );

    PURCHASEORDERID @(
        title               : '{i18n>po_id}',
        description         : '{i18n>po_id}',
        Common.FieldControl : #Mandatory,
        Search.defaultSearchElement,
        Common.Label        : '{i18n>po_id}'
    );

    items           @(
        title       : '{i18n>po_items}',
        description : '{i18n>po_items}',
        Common      : {Text : {
            $value                 : ITEMS.PRODUCT,
            ![@UI.TextArrangement] : #TextOnly
        }}
    );

    NOTEID          @(
        title       : '{i18n>notes}',
        description : '{i18n>notes}'
    );

    PARTNER         @(
        title       : '{i18n>partner_id}',
        description : '{i18n>partner_id}'
    );

    LIFECYCLESTATUS @(
        title               : '{i18n>lifecycle}',
        description         : '{i18n>lifecycle}',
        Common.FieldControl : #ReadOnly
    );

    APPROVALSTATUS  @(
        title               : '{i18n>approval}',
        description         : '{i18n>approval}',
        Common.FieldControl : #ReadOnly
    );

    CONFIRMSTATUS   @(
        title               : '{i18n>confirmation}',
        description         : '{i18n>confirmation}',
        Common.FieldControl : #ReadOnly
    );

    ORDERINGSTATUS  @(
        title               : '{i18n>ordering}',
        description         : '{i18n>ordering}',
        Common.FieldControl : #ReadOnly
    );

    INVOICINGSTATUS @(
        title               : '{i18n>invoicing}',
        description         : '{i18n>invoicing}',
        Common.FieldControl : #ReadOnly
    );

};

entity Items : cuid, common.amount, common.quantity {
    POHEADER     : Association to Headers;
    PRODUCT      : common.BusinessKey;
    NOTEID       : common.BusinessKey null;
    DELIVERYDATE : common.SDate;
}

annotate Items with {
    ID           @(
        title       : '{i18n>internal_id}',
        description : '{i18n>internal_id}',
    );

    PRODUCT      @(
        title               : '{i18n>product}',
        description         : '{i18n>product}',
        Common.FieldControl : #Mandatory,
        Search.defaultSearchElement
    );

    DELIVERYDATE @(
        title       : '{i18n>deliveryDate}',
        description : '{i18n>deliveryDate}'
    )
}


define view ItemView as
    select from Items {
        POHEADER.PARTNER         as![PARTNER],
        PRODUCT,
        CURRENCY,
        GROSSAMOUNT,
        NETAMOUNT,
        TAXAMOUNT,
        QUANTITY,
        QUANTITYUNIT,
        DELIVERYDATE
    };
