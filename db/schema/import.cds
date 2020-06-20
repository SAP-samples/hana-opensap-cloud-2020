using {cuid} from '@sap/cds/common';

@cds.persistence.exists
entity BUYER {
        BUILDING     : String(10) @title : '{i18n>building}';
        CITY         : String(40) @title : '{i18n>city}';
        COMPANYNAME  : String(80) @title : '{i18n>company}';
        COUNTRY_CODE : String(3)  @title : '{i18n>country}';
        EMAIL        : String(255)@title : '{i18n>email}';
        LEGALFORM    : String(10) @title : '{i18n>legal}';
    key ID           : UUID       @title : '{i18n>partnerId}';
        PARTNERROLE  : Integer    @title : '{i18n>partnerRole}';
        POSTALCODE   : String(10) @title : '{i18n>postalCode}';
        REGION       : String(4)  @title : '{i18n>region}';
        STREET       : String(60) @title : '{i18n>street}';
}

@cds.persistence.exists
entity USERDATA_USER_LOCAL : cuid {
    EMAIL     : String(255)@title : '{i18n>email}'  @assert.format : '^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    FIRSTNAME : String(40) @title : '{i18n>fname}';
    LASTNAME  : String(40) @title : '{i18n>lname}';
//  key ID: String(40) @title: '{i18n>userId}';
}

annotate USERDATA_USER_LOCAL with {
    ID @title : '{i18n>userId}'; // @odata.Type:'Edm.String';
};
