using {
    Currency,
    managed,
    sap,
    cuid
} from '@sap/cds/common';

namespace opensap.PurchaseOrder;

type BusinessKey : String(10);
type SDate : DateTime;
type AmountT : Decimal(15, 2) @(Measures.ISOCurrency : CURRENCY_code);

type QuantityT : Decimal(13, 3)@(
    title         : '{i18n>quantity}',
    Measures.Unit : Units.Quantity
);

type UnitT : String(3)@title : '{i18n>quantityUnit}';

type StatusT : Integer enum {
    new        = 1;
    incomplete = 2;
    inprocess  = 3;
    completed  = 4;
    billed     = 5;
    received   = 6;
}

abstract entity amount {
    CURRENCY    : Currency;
    GROSSAMOUNT : AmountT;
    NETAMOUNT   : AmountT;
    TAXAMOUNT   : AmountT;
}

annotate amount with {
    GROSSAMOUNT @(title : '{i18n>grossAmount}');
    NETAMOUNT   @(title : '{i18n>netAmount}');
    TAXAMOUNT   @(title : '{i18n>taxAmount}');
}

abstract entity quantity {
    QUANTITY     : QuantityT;
    QUANTITYUNIT : UnitT;
}

entity Headers : managed, cuid, amount {
    PURCHASEORDERID : Integer;
    items           : Association to many Items
                          on items.POHEADER = $self;
    NOTEID          : BusinessKey null;
    PARTNER         : BusinessKey @title : '{i18n>partner_id}';
    LIFECYCLESTATUS : StatusT default 1;
    APPROVALSTATUS  : StatusT;
    CONFIRMSTATUS   : StatusT;
    ORDERINGSTATUS  : StatusT;
    INVOICINGSTATUS : StatusT;
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

entity Items : cuid, amount, quantity {
    POHEADER     : Association to Headers;
    PRODUCT      : BusinessKey;
    NOTEID       : BusinessKey null;
    DELIVERYDATE : SDate;
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
        POHEADER.PURCHASEORDERID as![PURCHASEORDERID],
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
