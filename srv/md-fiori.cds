using MasterDataService as mds from './service';


annotate mds.Addresses with @( // header-level annotations
    // ---------------------------------------------------------------------------
    // List Report
    // ---------------------------------------------------------------------------
    // Address List
    UI        : {
        LineItem            : [
        {
            $Type             : 'UI.DataField',
            Value             : city,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : street,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : region,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : country.name,
            ![@UI.Importance] : #Medium
        }
        ],
        PresentationVariant : {SortOrder : [
        {
            $Type      : 'Common.SortOrderType',
            Property   : ID,
            Descending : false
        },
        {
            $Type      : 'Common.SortOrderType',
            Property   : city,
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
            TypeName       : '{i18n>addrService}',
            TypeNamePlural : '{i18n>addrServices}',
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
            Value : city
        }
        ]},
        FieldGroup #Details            : {Data : [

        {
            $Type             : 'UI.DataField',
            Value             : street,
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataField',
            Value : postalCode
        },
        {
            $Type : 'UI.DataField',
            Value : country_code
        },
        {
            $Type                   : 'UI.DataField',
            Value                   : country.name,
            ![@Common.FieldControl] : #ReadOnly
        },
        {
            $Type : 'UI.DataField',
            Value : region
        },
        {
            $Type : 'UI.DataField',
            Value : building
        }

        ]},
        FieldGroup #AdministrativeData : {Data : [
        {
            $Type : 'UI.DataField',
            Value : validFrom
        },
        {
            $Type : 'UI.DataField',
            Value : validTo
        }
        ]}
    },
    // Page Facets
    UI.Facets : [{
        $Type  : 'UI.CollectionFacet',
        ID     : 'AddrDetails',
        Label  : '{i18n>details}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>details}',
            Target : '@UI.FieldGroup#Details'
        }]
    }]
);

annotate mds.BusinessPartners with @( // header-level annotations
// ---------------------------------------------------------------------------
// List Report
// ---------------------------------------------------------------------------
// Address List
UI : {
    LineItem            : [
    {
        $Type             : 'UI.DataField',
        Value             : ID,
        ![@UI.Importance] : #High
    },
    {
        $Type             : 'UI.DataField',
        Value             : companyName,
        ![@UI.Importance] : #High
    },
    {
        $Type             : 'UI.DataField',
        Value             : email,
        ![@UI.Importance] : #High
    },
    {
        $Type             : 'UI.DataField',
        Value             : address.country.name,
        ![@UI.Importance] : #Medium
    },
    {
        $Type                : 'UI.DataField',
        Value                : partnerRole,
        ![@UI.Importance]    : #Low
    }
    ],
    PresentationVariant : {SortOrder : [
    {
        $Type      : 'Common.SortOrderType',
        Property   : createdAt,
        Descending : false
    },
    {
        $Type      : 'Common.SortOrderType',
        Property   : ID,
        Descending : false
    }
    ]}
});


annotate mds.Products with @( // header-level annotations
    // ---------------------------------------------------------------------------
    // List Report
    // ---------------------------------------------------------------------------
    // Address List
    UI        : {
        LineItem            : [
        {
            $Type             : 'UI.DataField',
            Value             : productId,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : category,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : name,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : imageUrl,
            ![@UI.Importance] : #High
        }
        ],
        PresentationVariant : {SortOrder : [{
            $Type      : 'Common.SortOrderType',
            Property   : productId,
            Descending : false
        }]}
    },
    UI        : {
        HeaderInfo                     : {
            TypeName       : '{i18n>product}',
            TypeNamePlural : '{i18n>products}',
            Title          : {Value : productId},
            Description    : {Value : name},
            ImageUrl       : imageUrl
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
            Value : productId
        },
        {
            $Type : 'UI.DataField',
            Value : name
        }
        ]},
        FieldGroup #Details            : {Data : [

        {
            $Type             : 'UI.DataField',
            Value             : typeCode,
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataField',
            Value : desc
        },
        {
            $Type : 'UI.DataField',
            Value : partner_ID
        },
        {
            $Type                   : 'UI.DataField',
            Value                   : partner.companyName,
            ![@Common.FieldControl] : #ReadOnly
        },
        {
            $Type : 'UI.DataField',
            Value : price
        },
        {
            $Type : 'UI.DataField',
            Value : currency_code
        },
        {
            $Type                   : 'UI.DataField',
            Value                   : currency.symbol,
            ![@Common.FieldControl] : #ReadOnly
        }


        ]},
        FieldGroup #AdministrativeData : {Data : [
        {
            $Type : 'UI.DataField',
            Value : createdBy
        },
        {
            $Type : 'UI.DataField',
            Value : modifiedBy
        },
        {
            $Type : 'UI.DataField',
            Value : createdAt
        },
        {
            $Type : 'UI.DataField',
            Value : modifiedAt
        }
        ]}
    },
    // Page Facets
    UI.Facets : [{
        $Type  : 'UI.CollectionFacet',
        ID     : 'ProdDetails',
        Label  : '{i18n>details}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>details}',
            Target : '@UI.FieldGroup#Details'
        }]
    }],
);
