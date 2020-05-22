using {
    Currency,
    managed,
    temporal,
    sap,
    cuid
} from '@sap/cds/common';

using {opensap.common} from './common';

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

annotate Addresses with {
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
    address        : Association to one Addresses;
    currency       : Currency;
    salaryAmount   : Decimal(15, 2);
    accountNumber  : String(10);
    bankId         : String(10);
    bankName       : String(255);
    employeePicUrl : String(255);
}

annotate Employees with {
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

type PartnerRole : Integer enum {
    Customer = 1;
    Supplier = 2;
}

entity BusinessPartners : cuid, managed {
    partnerRole                  : PartnerRole;
    email                        : common.Email;
    phoneNumber                  : common.PhoneNumber;
    webAddress                   : String(1024);
    address                      : Association to one Addresses;
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
    description : '{i18n>businessParnters}'
) {
    ID          @(
        title       : '{i18n>partnerId}',
        description : '{i18n>partnerId}'
    );
    partnerRole @(
        title       : '{i18n>partnerRole}',
        description : '{i18n>partnerRole}'
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
        picUrl                       : String(255);
        width                        : Decimal(13, 3);
        depth                        : Decimal(13, 3);
        height                       : Decimal(13, 3);
        dimensionUnit                : String(3);
        @readonly createdByEmployee  : Association to one Employees
                                           on createdByEmployee.email = createdBy;
        @readonly modifiedByEmployee : Association to one Employees
                                           on modifiedByEmployee.email = modifiedBy;
}

annotate Products with @(
    title       : '{i18n>products}',
    description : '{i18n>products}'
) {
    typeCode      @(
        title       : '{i18n>typeCode}',
        description : '{i18n>typeCode}'
    );
    category      @(
        title       : '{i18n>category}',
        description : '{i18n>category}'
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
}
