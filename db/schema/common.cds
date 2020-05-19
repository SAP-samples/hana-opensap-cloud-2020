using {sap, Currency} from '@sap/cds/common';

extend sap.common.Currencies with {
  // Currencies.code = ISO 4217 alphabetic three-letter code
  // with the first two letters being equal to ISO 3166 alphabetic country codes
  // See also:
  // [1] https://www.iso.org/iso-4217-currency-codes.html
  // [2] https://www.currency-iso.org/en/home/tables/table-a1.html
  // [3] https://www.ibm.com/support/knowledgecenter/en/SSZLC2_7.0.0/com.ibm.commerce.payments.developer.doc/refs/rpylerl2mst97.htm
  numcode  : Integer;
  exponent : Integer; //> e.g. 2 --> 1 Dollar = 10^2 Cent
  minor    : String; //> e.g. 'Cent'
}

extend sap.common.Countries {
  code1           : Integer;
  alpha3          : String(3);
  iso             : String(16);
  region          : String(20);
  sub_region      : String(40);
  region_code     : String(3);
  sub_region_code : String(3);
  regions         : Composition of many sap.common_countries.Regions
                      on regions.country = $self.code;
}

annotate sap.common.Countries with {
  code1           @(
    title        : '{i18n>code1}',
    Common.Label : '{i18n>code1}'
  );
  alpha3          @(
    title        : '{i18n>alpha3}',
    Common.Label : '{i18n>alpha3}'
  );
  iso             @(
    title        : '{i18n>iso}',
    Common.Label : '{i18n>iso}'
  );
  region          @(
    title        : '{i18n>region}',
    Common.Label : '{i18n>region}'
  );
  sub_region      @(
    title        : '{i18n>sub_region}',
    Common.Label : '{i18n>sub_region}'
  );
  region_code     @(
    title        : '{i18n>region_code}',
    Common.Label : '{i18n>region_code}'
  );
  sub_region_code @(
    title        : '{i18n>sub_region_code}',
    Common.Label : '{i18n>sub_region_code}'
  );
};

context opensap.common {
  type BusinessKey : String(10);
  type SDate : DateTime;

  type AmountT : Decimal(15, 2)@(
    Semantics.amount.currencyCode : 'CURRENCY_code',
    sap.unit                      : 'CURRENCY_code'
  );

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
}

context sap.common_countries {

  entity Regions {
    key country     : String(3);
    key sub_code    : String(5);
        toCountries : Association to one sap.common.Countries
                        on toCountries.code = $self.country;
        name        : String(80);
        type        : String(80);
  }

  annotate Regions with {
    country  @(
      title        : '{i18n>country}',
      Common.Label : '{i18n>country}'
    );
    sub_code @(
      title        : '{i18n>sub_code}',
      Common.Label : '{i18n>sub_code}'
    );

    name     @(
      title               : '{i18n>name}',
      Common.FieldControl : #Mandatory,
      Search.defaultSearchElement,
      Common.Label        : '{i18n>name}'
    );
    type     @(
      title        : '{i18n>type}',
      Common.Label : '{i18n>type}'
    );
  }
}


define view iso_countries_regions as
  select from sap.common_countries.Regions {
    country          as COUNTRY_CODE,
    toCountries.name as COUNTRY_NAME,
    sub_code,
    name,
    type
  };

define view iso_us_states as
  select from sap.common_countries.Regions {
    sub_code,
    name
  }
  where
        country = 'US'
    and type    = 'State';

define view iso_us_states_and_territories as
  select from sap.common_countries.Regions {
    sub_code,
    name
  }
  where
    country = 'US';
