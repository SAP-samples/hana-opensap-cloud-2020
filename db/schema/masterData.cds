using {
    Currency,
    managed,
    temporal,
    sap,
    cuid
} from '@sap/cds/common';

using {opensap.common} from './common';
using {opensap.PurchaseOrder} from './purchaseOrder';

namespace opensap.MD;

entity Addresses : cuid, temporal {
    city        : String(40);
    postalCode  : String(10);
    street      : String(60);
    building    : String(10);
    country     : Association to one sap.common.Countries;
    region      : String(4);
    addressType : String(2);
    latitude    : Double;
    longitude   : Double;
}

annotate Addresses with  {
    ID          @title : '{i18n>addressId}';
    city        @title : '{i18n>city}';
    postalCode  @title : '{i18n>postalCode}';
    street      @title : '{i18n>street}';
    building    @title : '{i18n>building}';
    country     @title : '{i18n>country}';
    region      @title : '{i18n>region}';
    addressType @title : '{i18n>addressType}';
    latitude    @title : '{i18n>latitude}';
    longitude   @title : '{i18n>longitude}';
};


entity Employees : cuid, temporal {
    nameFirst      : String(40);
    nameMiddle     : String(40);
    nameLast       : String(40);
    nameInitials   : String(10);
    sex            : common.Gender;
    language       : String(1);
    phoneNumber    : common.PhoneNumber;
    email          : common.Email;
    loginName      : String(12);
    @cascade : {all}
    address        : Composition of one Addresses;
    currency       : Currency;
    salaryAmount   : Decimal(15, 2);
    accountNumber  : String(10);
    bankId         : String(10);
    bankName       : String(255);
    employeePicUrl : String(255);
}

annotate Employees with  {
    ID             @title : '{i18n>employeeId}';
    nameFirst      @title : '{i18n>fname}';
    nameMiddle     @title : '{i18n>mname}';
    nameLast       @title : '{i18n>lname}';
    nameInitials   @title : '{i18n>initials}';
    language       @title : '{i18n>language}';
    loginName      @title : '{i18n>loginName}';
    address        @title : '{i18n>address}';
    salaryAmount   @title : '{i18n>salaryAmount}';
    accountNumber  @title : '{i18n>accountNumber}';
    bankId         @title : '{i18n>bankId}';
    bankName       @title : '{i18n>bankName}';
    employeePicUrl @title : '{i18n>employeePicUrl}';
};

define view NewYorkEmployees as
    select from Employees as emp {
        nameFirst,
        nameLast,
        address.ID   as ![ADDID],
        address.city as CITY
    }
    where
        'New York' = address.city;

type PartnerRole : Integer enum {
    Customer = 1;
    Supplier = 2;
}

entity BusinessPartners : cuid, managed {
    partnerRole                  : PartnerRole default 1;
    email                        : common.Email;
    phoneNumber                  : common.PhoneNumber;
    webAddress                   : String(1024);
    @cascade : {all}
    address                      : Composition of one Addresses;
    companyName                  : String(80);
    legalForm                    : String(10);
    currency                     : Currency;
    @readonly createdByEmployee  : Association to one Employees
                                       on createdByEmployee.email = createdBy;
    @readonly modifiedByEmployee : Association to one Employees
                                       on modifiedByEmployee.email = modifiedBy;
}


annotate BusinessPartners with @(
    title       : '{i18n>businessParnters}',
    description : '{i18n>businessParnters}',
) {
    ID          @(
        title       : '{i18n>partnerId}',
        description : '{i18n>partnerId}'
    );
    partnerRole @(
        title       : '{i18n>partnerRole}',
        description : '{i18n>partnerRole}',
        assert.enum
    );
    webAddress  @(
        title       : '{i18n>web}',
        description : '{i18n>web}'
    );
    address     @(
        title       : '{i18n>address}',
        description : '{i18n>address}'
    );
    companyName @(
        title       : '{i18n>company}',
        description : '{i18n>company}'
    );
    legalForm   @(
        title       : '{i18n>legal}',
        description : '{i18n>legal}'
    );
}

define view BPAddrExt as
    select from BusinessPartners {
        ID,
        address.street || ', ' || address.city as FULLADDRESS
    };

define view BPView as
    select from BusinessPartners
    mixin {
        ORDERS : Association[ * ] to PurchaseOrder.Headers
                     on ORDERS.partner.ID = $projection.ID;
    }
    into {
        BusinessPartners.ID,
        ORDERS
    };

view BPOrdersView as
    select from BPView {
        ID,
        ORDERS[lifecycleStatus = 'N'].ID as orderId
    };

view BPOrders2View as
    select from BPView {
        ID,
        ORDERS[lifecycleStatus = 'N'].ID          as orderId,
        ORDERS[lifecycleStatus = 'N'].grossAmount as grossAmt

    };

view BPOrders3View as
    select from BPView {
        ID,
        ORDERS[lifecycleStatus = 'N'].ID          as orderId,
        ORDERS[lifecycleStatus = 'N'].grossAmount as grossAmt,
        ORDERS[lifecycleStatus = 'N'].item[netAmount > 200].product.productId,
        ORDERS[lifecycleStatus = 'N'].item[netAmount > 200].netAmount

    };

define view BuyerView as
    select from BusinessPartners {
        key ID                          as![Id],
            email                       as![EmailAddress],
            companyName                 as![CompanyName],
            address.city                as![City],
            address.postalCode          as![PostalCode],
            address.street              as![Street],
            address.building            as![Building],
            address.country.code        as![Country],
            address.country.name        as![CountryName],
            address.region              as![Region],
            createdByEmployee.loginName as![CreatedBy]
    }
    where
        partnerRole = 1;

define view SupplierView as
    select from BusinessPartners {
        key ID                          as![Id],
            email                       as![EmailAddress],
            companyName                 as![CompanyName],
            address.city                as![City],
            address.postalCode          as![PostalCode],
            address.street              as![Street],
            address.building            as![Building],
            address.country.code        as![Country],
            address.country.name        as![CountryName],
            address.region              as![Region],
            createdByEmployee.loginName as![CreatedBy]
    }
    where
        partnerRole = 2;

define view BPViewWithDesc as
    select from BusinessPartners {
        ID,
        partnerRole,
        case
            when
                partnerRole = 1
            then
                'Buyer'
            when
                partnerRole = 2
            then
                'Supplier'
        end as![PartnerRoleDesc],
        email,
        companyName
    };

define view BusinessPartnersView with parameters IM_PR : String(1) as
    select from BPViewWithDesc {
        ID,
        partnerRole,
        PartnerRoleDesc email,
        companyName
    }
    where
        partnerRole = : IM_PR;

define view partnerRoles as
    select from BusinessPartners {
            @UI.lineItem       : [{importance : Importance.High}]
            @UI.fieldGroup     : [{position : 10}]
            @EndUserText.label : [{
                language : 'EN',
                text     : 'Partner Role'
            }]
        key partnerRole,

            @UI.lineItem       : [{importance : Importance.High}]
            @UI.fieldGroup     : [{position : 20}]
            @EndUserText.label : [{
                language : 'EN',
                text     : 'Role Description'
            }]
            case
                when
                    partnerRole = 1
                then
                    'Buyer'
                when
                    partnerRole = 2
                then
                    'Supplier'
            end as![PARTNERDESC] : String,
    }
    group by
        partnerRole
    order by
        partnerRole;

define view SupplierViewVH as
    select from SupplierView {
        @UI.lineItem       : [{importance : Importance.High}]
        @UI.fieldGroup     : [{position : 10}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Supplier ID'
        }]
        Id          as![Supplier_Id],

        @UI.lineItem       : [{importance : Importance.High}]
        @UI.fieldGroup     : [{position : 20}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Supplier Name'
        }]
        CompanyName as![Supplier_CompanyName]
    };

entity Products : managed, common.Quantity {
    key productId                    : String(10);
        typeCode                     : String(2);        
        category                     : String(40);
        name                         : localized String;
        desc                         : localized String;
        partner                      : Association to one MD.BusinessPartners;
        weightMeasure                : Decimal(13, 3);
        weightUnit                   : String(3);
        currency                     : Currency;
        price                        : Decimal(15, 2);
        //        picUrl                       : String(255);
        width                        : Decimal(13, 3);
        depth                        : Decimal(13, 3);
        height                       : Decimal(13, 3);
        dimensionUnit                : String(3);
        @readonly createdByEmployee  : Association to one Employees
                                           on createdByEmployee.email = createdBy;
        @readonly modifiedByEmployee : Association to one Employees
                                           on modifiedByEmployee.email = modifiedBy;
        imageUrl                     : String @(UI : {
            IsImageURL,
            HiddenFilter
        });
        @cascade : {all}
        image                        : Composition of one ProductImages;
}

annotate Products with @(
    title       : '{i18n>products}',
    description : '{i18n>products}'
) {
    productId     @(
        title            : '{i18n>product}',
        description      : '{i18n>product}',
        Common.ValueList : {
            CollectionPath : 'Products',
            Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'productId',
                ValueListProperty : 'productId'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
            ]
        }
    );
    typeCode      @(
        title       : '{i18n>typeCode}',
        description : '{i18n>typeCode}'
    );
    category      @(
        title       : '{i18n>category}',
        description : '{i18n>category}',
        Common.ValueList: {entity: 'productCategoryVH', type: #fixed}
    );
    name          @(
        title       : '{i18n>name}',
        description : '{i18n>name}'
    );
    desc          @(
        title       : '{i18n>desc}',
        description : '{i18n>desc}'
    );
    partner       @(
        title       : '{i18n>supplier}',
        description : '{i18n>supplier}'
    );
    weightMeasure @(
        title       : '{i18n>weightMeasure}',
        description : '{i18n>weightMeasure}'
    );
    weightUnit    @(
        title       : '{i18n>weightUnit}',
        description : '{i18n>weightUnit}'
    );
    price         @(
        title       : '{i18n>price}',
        description : '{i18n>price}'
    );
    picUrl        @(
        title       : '{i18n>picUrl}',
        description : '{i18n>picUrl}'
    );
    width         @(
        title       : '{i18n>width}',
        description : '{i18n>width}'
    );
    depth         @(
        title       : '{i18n>depth}',
        description : '{i18n>depth}'
    );
    height        @(
        title       : '{i18n>height}',
        description : '{i18n>height}'
    );
    dimensionUnit @(
        title       : '{i18n>dimensionUnit}',
        description : '{i18n>dimensionUnit}'
    );
    imageUrl      @(
        title       : '{i18n>productImage}',
        description : '{i18n>productImage}'
    );
}

entity ProductImages {
    key product   : Association to Products;
        image     : LargeBinary @Core.MediaType : imageType;
        imageType : String      @Core.IsMediaType;
}

annotate ProductImages with {
    image     @(
        title       : '{i18n>productImage}',
        description : '{i18n>productImage}'
    );
    imageType @(
        title       : '{i18n>productImageType}',
        description : '{i18n>productImageType}'
    );
};

entity ProductLog {
    key PRODUCTID : String(10);
    key LOGID     : Integer;
    key DATETIME  : DateTime;
    key USERNAME  : String(80);
        LOGTEXT   : String(500);
};

define view ProductViewSub as
    select from Products as prod {
        productId as ![Product_Id],
        (
            select from PurchaseOrder.Items as a {
                sum(
                    grossAmount
                ) as SUM
            }
            where
                a.product.productId = prod.productId
        )         as PO_SUM
    };

define view ProductView as
    select from Products
    mixin {
        PO_ORDERS : Association[ * ] to PurchaseOrder.ItemView
                        on PO_ORDERS.ProductId = $projection.![Product_Id];
    }
    into {
        productId                  as![Product_Id],
        name,
        desc,
        category                   as![Product_Category],
        currency.code              as![Product_Currency],
        price                      as![Product_Price],
        typeCode                   as![Product_TypeCode],
        weightMeasure              as![Product_WeightMeasure],
        weightUnit                 as![Product_WeightUnit],
        partner.ID                 as![Supplier_Id],
        partner.companyName        as![Supplier_CompanyName],
        partner.address.city       as![Supplier_City],
        partner.address.postalCode as![Supplier_PostalCode],
        partner.address.street     as![Supplier_Street],
        partner.address.building   as![Supplier_Building],
        partner.address.country    as![Supplier_Country],
        PO_ORDERS
    };

define view ProductsValueHelp as
    select from Products {
        @UI.lineItem       : [{importance : Importance.High}]
        @UI.fieldGroup     : [{position : 10}]
        @EndUserText.label : [
        {
            language : 'EN',
            text     : 'Product ID'
        },
        {
            language : 'DE',
            text     : 'Produkt ID'
        }
        ]
        productId,

        @UI.lineItem       : [{importance : Importance.High}]
        @UI.fieldGroup     : [{position : 20}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Product Name'
        }]
        name
    };

define view productCategoryVH as
    select from Products distinct {
        @UI.lineItem       : [{importance : Importance.High}]
        @UI.fieldGroup     : [{position : 10}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Product Category'
        }]
       key category as![Product_Category]
    };

define view ProductsConsumption as
    select from Products {
        @UI.lineItem       : [{importance : Importance.High}]
        @UI.fieldGroup     : [{position : 10}]
        @EndUserText.label : [
        {
            language : 'EN',
            text     : 'Product ID'
        },
        {
            language : 'DE',
            text     : 'Produkt ID'
        }
        ]
        @valueList         : {
            collectionPath       : 'ProductsVH',
            searchSupported      : false,
            parameterInOut       : [{
                localDataProperty : 'Product_Id',
                valueListProperty : 'Product_Id'
            }],
            parameterDisplayOnly : [{valueListProperty : 'Product_Name'}]
        }
        productId                  as![Product_Id],

        @UI.lineItem       : [{importance : Importance.High}]
        @UI.fieldGroup     : [{position : 20}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Product Category'
        }]
        @valueList         : {
            collectionPath  : 'ProductCatVh',
            searchSupported : false,
            parameterInOut  : [{
                localDataProperty : 'Product_Category',
                valueListProperty : 'Product_Category'
            }]
        }
        category                   as![Product_Category],

        @UI.lineItem       : [{importance : Importance.Medium}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Currency'
        }]
        @UI.fieldGroup     : [{position : 30}]
        currency.code              as![Product_Currency],

        @UI.lineItem       : [{importance : Importance.Medium}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Product Price'
        }]
        @UI.fieldGroup     : [{exclude : true}]
        price                      as![Product_Price],

        @UI.lineItem       : [{importance : Importance.Medium}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Type Code'
        }]
        @UI.fieldGroup     : [{position : 40}]
        typeCode                   as![Product_TypeCode],

        @UI.lineItem       : [{importance : Importance.Medium}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Weight'
        }]
        @UI.fieldGroup     : [{exclude : true}]
        weightMeasure              as![Product_WeightMeasure],

        @UI.lineItem       : [{importance : Importance.Low}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Weight Unit'
        }]
        @UI.fieldGroup     : [{exclude : true}]
        weightUnit                 as![Product_WeightUnit],

        @UI.lineItem       : [{importance : Importance.Medium}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Supplier ID'
        }]
        @UI.fieldGroup     : [{position : 50}]
        @valueList         : {
            collectionPath       : 'SupplierVH',
            searchSupported      : false,
            parameterInOut       : [{
                localDataProperty : 'Supplier_Id',
                valueListProperty : 'Supplier_Id'
            }],
            parameterDisplayOnly : [{valueListProperty : 'Supplier_CompanyName'}]
        }
        partner.ID                 as![Supplier_Id],

        @UI.lineItem       : [{importance : Importance.High}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Supplier'
        }]
        @UI.fieldGroup     : [{position : 60}]
        partner.companyName        as![Supplier_CompanyName],

        @UI.lineItem       : [{importance : Importance.Medium}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Supplier City'
        }]
        @UI.fieldGroup     : [{position : 70}]
        partner.address.city       as![Supplier_City],
        partner.address.postalCode as![Supplier_PostalCode],
        partner.address.street     as![Supplier_Street],
        partner.address.building   as![Supplier_Building],

        @UI.lineItem       : [{importance : Importance.Medium}]
        @EndUserText.label : [{
            language : 'EN',
            text     : 'Supplier Country'
        }]
        @UI.fieldGroup     : [{position : 80}]
        @valueList         : {
            collectionPath       : 'Countries',
            searchSupported      : false,
            parameterInOut       : [{
                localDataProperty : 'Supplier_Country',
                valueListProperty : 'CODE'
            }],
            parameterDisplayOnly : [{valueListProperty : 'NAME'}]
        }
        partner.address.country    as![Supplier_Country]
    };

define view ProductValuesView as
    select from ProductView {
        Product_Id,
        PO_ORDERS.CurrencyCode as![CurrencyCode],
        sum(
            PO_ORDERS.Amount
        )                      as![POGrossAmount]
    }
    group by
        Product_Id,
        PO_ORDERS.CurrencyCode;
