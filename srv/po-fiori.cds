using POService as pos from './my-service';


annotate pos.POs with @( // header-level annotations
    // ---------------------------------------------------------------------------
    // List Report
    // ---------------------------------------------------------------------------
    // POs List
    UI        : {
        LineItem            : [
        {
            $Type             : 'UI.DataField',
            Value             : ID,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : PARTNER,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : GROSSAMOUNT,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : CURRENCY_code,
            ![@UI.Importance] : #Medium
        },
        ],
        PresentationVariant : {SortOrder : [
        {
            $Type      : 'Common.SortOrderType',
            Property   : ID,
            Descending : false
        },
        {
            $Type      : 'Common.SortOrderType',
            Property   : PARTNER,
            Descending : false
        }
        ]}
    },

    // ---------------------------------------------------------------------------
    // Object Page
    // ---------------------------------------------------------------------------
    // Page Header
    UI        : {
        HeaderInfo                     : {
            TypeName       : '{i18n>poService}',
            TypeNamePlural : '{i18n>poServices}',
            Title          : {Value : ID},
        },
        HeaderFacets                   : [
        {
            $Type             : 'UI.ReferenceFacet',
            Target            : '@UI.FieldGroup#Description',
            ![@UI.Importance] : #Medium
        },
        {
            $Type             : 'UI.ReferenceFacet',
            Target            : '@UI.FieldGroup#AdministrativeData',
            ![@UI.Importance] : #Medium
        }
        ],
        FieldGroup #Description        : {Data : [
        {
            $Type : 'UI.DataField',
            Value : ID
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER
        }
        ]},
        FieldGroup #Details            : {Data : [

        {
            $Type             : 'UI.DataField',
            Value             : NOTEID,
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataField',
            Value : GROSSAMOUNT
        },
        {
            $Type : 'UI.DataField',
            Value : NETAMOUNT
        },
        {
            $Type : 'UI.DataField',
            Value : TAXAMOUNT
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code
        },
        ]},
        FieldGroup #AdministrativeData : {Data : [
        {
            $Type : 'UI.DataField',
            Value : createdBy
        },
        {
            $Type : 'UI.DataField',
            Value : createdAt
        },
        {
            $Type : 'UI.DataField',
            Value : modifiedBy
        },
        {
            $Type : 'UI.DataField',
            Value : modifiedAt
        }
        ]}
    },
    // Page Facets
    UI.Facets : [
    {
        $Type  : 'UI.CollectionFacet',
        ID     : 'PODetails',
        Label  : '{i18n>details}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>details}',
            Target : '@UI.FieldGroup#Details'
        }]
    },
    {
        $Type  : 'UI.ReferenceFacet',
        Label  : '{i18n>po_items}',
        Target : 'items/@UI.LineItem'
    }
    ]
);

annotate pos.POItems with @( // header-level annotations
// ---------------------------------------------------------------------------
// List Report
// ---------------------------------------------------------------------------
// PO Items List
UI : {
    LineItem            : [
    {
        $Type             : 'UI.DataField',
        Value             : PRODUCT,
        ![@UI.Importance] : #High
    },
    {
        $Type             : 'UI.DataField',
        Value             : DELIVERYDATE,
        ![@UI.Importance] : #High
    },
    {
        $Type             : 'UI.DataField',
        Value             : QUANTITY,
        ![@UI.Importance] : #High
    },
    {
        $Type             : 'UI.DataField',
        Value             : QUANTITYUNIT,
        ![@UI.Importance] : #High
    }
    ],
    PresentationVariant : {SortOrder : [{
        $Type      : 'Common.SortOrderType',
        Property   : PRODUCT,
        Descending : false
    }]}
});
