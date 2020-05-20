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


type Gender : String(1) enum {
    male         = 'M';
    female       = 'F';
    nonBinary    = 'N';
    noDisclosure = 'D';
    selfDescribe = 'S';
}

annotate Gender with @(
    title       : '{i18n>gender}',
    description : '{i18n>gender}'
);


entity Employees : cuid, temporal {
    nameFirst      : String(40);
    nameMiddle     : String(40);
    nameLast       : String(40);
    nameInitials   : String(10);
    sex            : Gender;
    language       : String(1);
    phoneNumber    : String(30);
    email          : String(255);
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
    phoneNumber    @title : '{i18n>phoneNumber}';
    email          @title : '{i18n>email}';
    loginName      @title : '{i18n>loginName}';
    address        @title : '{i18n>address}';
    salaryAmount   @title : '{i18n>salaryAmount}';
    accountNumber  @title : '{i18n>accountNumber}';
    bankId         @title : '{i18n>bankId}';
    bankName       @title : '{i18n>bankName}';
    employeePicUrl @title : '{i18n>employeePicUrl}';
};
