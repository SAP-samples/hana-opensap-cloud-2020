@cds.persistence.exists 
Entity "MD_Addresses" {
 key 	![ADDRESSID]: Integer  @title: 'ADDRESSID: Address ID' ; 
	![CITY]: String(40)  @title: 'CITY: City' ; 
	![POSTALCODE]: String(10)  @title: 'POSTALCODE: Postal Code' ; 
	![STREET]: String(60)  @title: 'STREET: Street' ; 
	![BUILDING]: String(10)  @title: 'BUILDING: Building Number' ; 
	![COUNTRY]: String(3)  @title: 'COUNTRY: Country' ; 
	![REGION]: String(4)  @title: 'REGION: Region Otherwise Known as State in some countries' ; 
	![ADDRESSTYPE]: String(2)  @title: 'ADDRESSTYPE: Address Type' ; 
	![VALIDITY_STARTDATE]: Date  @title: 'VALIDITY_STARTDATE: Start Date' ; 
	![VALIDITY_ENDDATE]: Date  @title: 'VALIDITY_ENDDATE: End Date' ; 
	![LATITUDE]: Double  @title: 'LATITUDE: Geo Latitude' ; 
	![LONGITUDE]: Double  @title: 'LONGITUDE: Geo Longitude' ; 
	![POINT]: **UNSUPPORTED TYPE - ST_POINT  @title: 'POINT: Geo Point' ; 
}

@cds.persistence.exists 
Entity "MD_BusinessPartner" {
 key 	![PARTNERID]: Integer  @title: 'PARTNERID: Partner ID' ; 
	![PARTNERROLE]: String(3)  @title: 'PARTNERROLE: Partner Role - Customer or Supplier' ; 
	![EMAILADDRESS]: String(255)  @title: 'EMAILADDRESS: Email Address' ; 
	![PHONENUMBER]: String(30)  @title: 'PHONENUMBER: Phone Number' ; 
	![FAXNUMBER]: String(30)  @title: 'FAXNUMBER: Fax Number' ; 
	![WEBADDRESS]: String(1024)  @title: 'WEBADDRESS: Web Site Address' ; 
	![ADDRESSES_ADDRESSID]: Integer  @title: 'ADDRESSES_ADDRESSID: Address Association' ; 
	![COMPANYNAME]: String(80)  @title: 'COMPANYNAME: Company Name' ; 
	![LEGALFORM]: String(10)  @title: 'LEGALFORM: Legal Form' ; 
	![HISTORY_CREATEDBY_EMPLOYEEID]: Integer  @title: 'HISTORY_CREATEDBY_EMPLOYEEID: Created By' ; 
	![HISTORY_CREATEDAT]: Date  @title: 'HISTORY_CREATEDAT: Created Date' ; 
	![HISTORY_CHANGEDBY_EMPLOYEEID]: Integer  @title: 'HISTORY_CHANGEDBY_EMPLOYEEID: Last Changed By' ; 
	![HISTORY_CHANGEDAT]: Date  @title: 'HISTORY_CHANGEDAT: Changed Date' ; 
	![CURRENCY]: String(5)  @title: 'CURRENCY: Currency' ; 
}

@cds.persistence.exists 
Entity "MD_Employees" {
 key 	![EMPLOYEEID]: Integer  @title: 'EMPLOYEEID: Employee ID' ; 
	![NAME_FIRST]: String(40)  @title: 'NAME_FIRST: First or Given Name' ; 
	![NAME_MIDDLE]: String(40)  @title: 'NAME_MIDDLE: Middle Name' ; 
	![NAME_LAST]: String(40)  @title: 'NAME_LAST: Family Name' ; 
	![NAME_INITIALS]: String(10)  @title: 'NAME_INITIALS: Initials' ; 
	![SEX]: String(1)  @title: 'SEX: Gender' ; 
	![LANGUAGE]: String(1)  @title: 'LANGUAGE: Primary Spoken Language' ; 
	![PHONENUMBER]: String(30)  @title: 'PHONENUMBER: Primary Phone Number' ; 
	![EMAILADDRESS]: String(255)  @title: 'EMAILADDRESS: Email Address' ; 
	![LOGINNAME]: String(12)  @title: 'LOGINNAME: Login Username' ; 
	![ADDRESSES_ADDRESSID]: Integer  @title: 'ADDRESSES_ADDRESSID: Address Association' ; 
	![VALIDITY_STARTDATE]: Date  @title: 'VALIDITY_STARTDATE: Start Date' ; 
	![VALIDITY_ENDDATE]: Date  @title: 'VALIDITY_ENDDATE: End Date' ; 
	![CURRENCY]: String(5)  @title: 'CURRENCY: Document Currency' ; 
	![SALARYAMOUNT]: Decimal(15, 2)  @title: 'SALARYAMOUNT: Salary Amount' ; 
	![ACCOUNTNUMBER]: String(10)  @title: 'ACCOUNTNUMBER: Bank Account Number' ; 
	![BANKID]: String(10)  @title: 'BANKID: Bank ID' ; 
	![BANKNAME]: String(255)  @title: 'BANKNAME: Bank Name' ; 
	![EMPLOYEEPICURL]: String(255)  @title: 'EMPLOYEEPICURL: Employee Picture URL' ; 
}

@cds.persistence.exists 
Entity "MD_Products" {
 key 	![PRODUCTID]: String(10)  @title: 'PRODUCTID: Product ID' ; 
	![TYPECODE]: String(2)  @title: 'TYPECODE: Type Code' ; 
	![CATEGORY]: String(40)  @title: 'CATEGORY: Product Category' ; 
	![HISTORY_CREATEDBY_EMPLOYEEID]: Integer  @title: 'HISTORY_CREATEDBY_EMPLOYEEID: Created By' ; 
	![HISTORY_CREATEDAT]: Date  @title: 'HISTORY_CREATEDAT: Create Date' ; 
	![HISTORY_CHANGEDBY_EMPLOYEEID]: Integer  @title: 'HISTORY_CHANGEDBY_EMPLOYEEID: Last Changed By' ; 
	![HISTORY_CHANGEDAT]: Date  @title: 'HISTORY_CHANGEDAT: Last Changed By' ; 
	![NAMEID]: Integer  @title: 'NAMEID: Product Name' ; 
	![DESCID]: Integer  @title: 'DESCID: Product Description' ; 
	![SUPPLIER_PARTNERID]: Integer  @title: 'SUPPLIER_PARTNERID: Supplier Association' ; 
	![TAXTARIFFCODE]: Integer  @title: 'TAXTARIFFCODE: Tax Tariff Code' ; 
	![QUANTITYUNIT]: String(3)  @title: 'QUANTITYUNIT: Quantity Unit' ; 
	![WEIGHTMEASURE]: Decimal(13, 3)  @title: 'WEIGHTMEASURE: Weight' ; 
	![WEIGHTUNIT]: String(3)  @title: 'WEIGHTUNIT: Weight Unit' ; 
	![CURRENCY]: String(5)  @title: 'CURRENCY: Currency' ; 
	![PRICE]: Decimal(15, 2)  @title: 'PRICE: Price' ; 
	![PRODUCTPICURL]: String(255)  @title: 'PRODUCTPICURL: Product Picture URL' ; 
	![WIDTH]: Decimal(13, 3)  @title: 'WIDTH: Width' ; 
	![DEPTH]: Decimal(13, 3)  @title: 'DEPTH: Depth' ; 
	![HEIGHT]: Decimal(13, 3)  @title: 'HEIGHT: Height' ; 
	![DIMENSIONUNIT]: String(3)  @title: 'DIMENSIONUNIT: Dimension Unit' ; 
}

