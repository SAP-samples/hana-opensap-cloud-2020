
@cds.persistence.exists 
Entity BUYER {
 	BUILDING: String(10) @title: '{i18n>building}'; 
	CITY: String(40) @title: '{i18n>city}'; 
	COMPANYNAME: String(80) @title: '{i18n>company}'; 
	COUNTRY_CODE: String(3) @title: '{i18n>country}'; 
	EMAIL: String(255) @title: '{i18n>email}'; 
	LEGALFORM: String(10) @title: '{i18n>legal}';  
	key ID: UUID @title: '{i18n>partnerId}'; 
	PARTNERROLE: Integer @title: '{i18n>partnerRole}';  
	POSTALCODE: String(10) @title: '{i18n>postalCode}';  
	REGION: String(4) @title: '{i18n>region}';  
	STREET: String(60)  @title: '{i18n>street}';  
}

@cds.persistence.exists 
Entity USER_DETAILS {
	 EMAIL: String(255)  @title: '{i18n>email}';  
	 FIRSTNAME: String(40) @title: '{i18n>fname}';
	 LASTNAME: String(40) @title: '{i18n>lname}';
     key ID: String(40) @title: '{i18n>userId}';	 
}
