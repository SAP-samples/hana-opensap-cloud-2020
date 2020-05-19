namespace log;

Entity collectChangeCount {
 	![no_changes]: Integer  @title: 'no_changes' ; 
	![employee]: String(5000)  @title: 'employee' ; 
}

Entity collectCreateCount {
 	![no_create]: Integer  @title: 'no_create' ; 
	![employee]: String(5000)  @title: 'employee' ; 
}

Entity collectdata {
 	![val]: Integer  @title: 'val' ; 
}

Entity errors {
 	![ERROR_TIMESTAMP]: Timestamp  @title: 'ERROR_TIMESTAMP' ; 
	![OBJECT_SCHEMA_NAME]: String(256)  @title: 'OBJECT_SCHEMA_NAME' ; 
	![OBJECT_NAME]: String(256)  @title: 'OBJECT_NAME' ; 
	![PARAMETER]: String(256)  @title: 'PARAMETER' ; 
	![SQL_ERROR_CODE]: Integer  @title: 'SQL_ERROR_CODE' ; 
	![SQL_ERROR_MESSAGE]: String(5000)  @title: 'SQL_ERROR_MESSAGE' ; 
}

Entity info {
 	![TIMESTAMP]: Timestamp  @title: 'TIMESTAMP' ; 
	![NAME]: String(256)  @title: 'NAME' ; 
	![SCHEMA]: String(256)  @title: 'SCHEMA' ; 
}

Entity messages {
 	![ERROR_TIMESTAMP]: Timestamp  @title: 'ERROR_TIMESTAMP' ; 
	![OBJECT_SCHEMA_NAME]: String(256)  @title: 'OBJECT_SCHEMA_NAME' ; 
	![OBJECT_NAME]: String(256)  @title: 'OBJECT_NAME' ; 
	![PARAMETER]: String(256)  @title: 'PARAMETER' ; 
	![SQL_ERROR_CODE]: Integer  @title: 'SQL_ERROR_CODE' ; 
	![SQL_ERROR_MESSAGE]: String(5000)  @title: 'SQL_ERROR_MESSAGE' ; 
}

