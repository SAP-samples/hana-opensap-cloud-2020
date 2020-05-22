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
    product      : common.BusinessKey;
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
        poHeader.partner as![partner],
        product,
        currency,
        grossAmount,
        netAmount,
        taxAmount,
        quantity,
        quantityUnit,
        deliveryDate
    };
