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
    UI.Facets : [
    {
        $Type  : 'UI.CollectionFacet',
        ID     : 'AddrDetails',
        Label  : '{i18n>details}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>details}',
            Target : '@UI.FieldGroup#Details'
        }]
    }
    ] 
);
