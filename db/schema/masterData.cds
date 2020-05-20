using {
    Currency,
    managed,
    temporal,
    sap,
    cuid
} from '@sap/cds/common';

using { opensap.common } from './common';
namespace opensap.MD;

Entity Addresses : cuid, temporal {
	![CITY]: String(40)  @title: 'CITY: City' ; 
	![POSTALCODE]: String(10)  @title: 'POSTALCODE: Postal Code' ; 
	![STREET]: String(60)  @title: 'STREET: Street' ; 
	![BUILDING]: String(10)  @title: 'BUILDING: Building Number' ; 
	![COUNTRY]: String(3)  @title: 'COUNTRY: Country' ; 
	![REGION]: String(4)  @title: 'REGION: Region Otherwise Known as State in some countries' ; 
	![ADDRESSTYPE]: String(2)  @title: 'ADDRESSTYPE: Address Type' ; 
	![LATITUDE]: Double  @title: 'LATITUDE: Geo Latitude' ; 
	![LONGITUDE]: Double  @title: 'LONGITUDE: Geo Longitude' ; 
}