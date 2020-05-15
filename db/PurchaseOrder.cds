using {
    Currency,
    managed,
    sap,
    cuid
} from '@sap/cds/common';

namespace opensap.PurchaseOrder;

type BusinessKey : String(10);
type SDate : DateTime;
type AmountT : Decimal(15, 2);

type QuantityT : Decimal(13, 3)@(
    title         : '{i18n>quantity}',
    Measures.Unit : Units.Quantity
);

type UnitT : String(3)@title : '{i18n>quantityUnit}';
type StatusT : String(1);


entity Headers : managed, cuid {
    PURCHASEORDERID : Integer                       @(
        title               : '{i18n>po_id}',
        Common.FieldControl : #Mandatory,
        Search.defaultSearchElement,
        Common.Label        : '{i18n>po_id}'
    );
    items           : Association to many Items
                          on items.POHEADER = $self @(
                              title  : '{i18n>po_items}',
                              Common : {Text : {
                                  $value                 : ITEMS.PRODUCT,
                                  ![@UI.TextArrangement] : #TextOnly
                              }}
                          );
    NOTEID          : BusinessKey null              @title : '{i18n>notes}';
    PARTNER         : BusinessKey                   @title : '{i18n>partner_id}';
    CURRENCY        : Currency;
    GROSSAMOUNT     : AmountT                       @(
        title                : '{i18n>grossAmount}',
        Measures.ISOCurrency : currency
    );
    NETAMOUNT       : AmountT                       @(
        title                : '{i18n>netAmount}',
        Measures.ISOCurrency : currency
    );
    TAXAMOUNT       : AmountT                       @(
        title                : '{i18n>taxAmount}',
        Measures.ISOCurrency : currency
    );
    LIFECYCLESTATUS : StatusT                       @(
        title               : '{i18n>lifecycle}',
        Common.FieldControl : #ReadOnly
    );
    APPROVALSTATUS  : StatusT                       @(
        title               : '{i18n>approval}',
        Common.FieldControl : #ReadOnly
    );
    CONFIRMSTATUS   : StatusT                       @(
        title               : '{i18n>confirmation}',
        Common.FieldControl : #ReadOnly
    );
    ORDERINGSTATUS  : StatusT                       @(
        title               : '{i18n>ordering}',
        Common.FieldControl : #ReadOnly
    );
    INVOICINGSTATUS : StatusT                       @(
        title               : '{i18n>invoicing}',
        Common.FieldControl : #ReadOnly
    );
}

entity Items : cuid {
    POHEADER     : Association to Headers @title : '{i18n>poService}';
    PRODUCT      : BusinessKey            @(
        title               : '{i18n>product}',
        Common.FieldControl : #Mandatory,
        Search.defaultSearchElement
    );
    NOTEID       : BusinessKey null;
    CURRENCY     : Currency;
    GROSSAMOUNT  : AmountT                @(
        title                : '{i18n>grossAmount}',
        Measures.ISOCurrency : currency
    );
    NETAMOUNT    : AmountT                @(
        title                : '{i18n>netAmount}',
        Measures.ISOCurrency : currency
    );
    TAXAMOUNT    : AmountT                @(
        title                : '{i18n>taxAmount}',
        Measures.ISOCurrency : currency
    );
    QUANTITY     : QuantityT;
    QUANTITYUNIT : UnitT;
    DELIVERYDATE : SDate                  @title : '{i18n>deliveryDate}';
}


define view ItemView as
    select from Items {
        POHEADER.PURCHASEORDERID,
        POHEADER.PARTNER,
        PRODUCT,
        CURRENCY,
        GROSSAMOUNT,
        NETAMOUNT,
        TAXAMOUNT,
        QUANTITY,
        QUANTITYUNIT,
        DELIVERYDATE
    };
