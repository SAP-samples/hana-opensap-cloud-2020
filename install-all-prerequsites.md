## Install SFLIGHT:
This exercise requires that you have the SFLIGHT catalog schema installed in your system and a database user who has access to this schema.
You can find more information on loading SFLIGHT into your system, if it doesn’t exist already, here:
https://blogs.sap.com/2018/12/18/howto-import-sflight-sample-data-into-sap-hana-from-a-local-computer/

## SQL Commands in Tenant:
```SQL
CREATE USER CUPS_SFLIGHT PASSWORD "<Password>" SET PARAMETER CLIENT = '001' SET USERGROUP DEFAULT;
ALTER USER CUPS_SFLIGHT DISABLE PASSWORD LIFETIME;
GRANT SELECT ON SCHEMA SFLIGHT TO CUPS_SFLIGHT WITH GRANT OPTION;
GRANT SELECT METADATA ON SCHEMA SFLIGHT to CUPS_SFLIGHT WITH GRANT OPTION;
```

```SQL
CREATE ROLE SFLIGHT_CONTAINER_ACCESS;
GRANT SELECT, SELECT METADATA ON SCHEMA SFLIGHT TO SFLIGHT_CONTAINER_ACCESS WITH GRANT OPTION;
GRANT SFLIGHT_CONTAINER_ACCESS TO CUPS_SFLIGHT WITH ADMIN OPTION;
```

CF Commands:
![Create Audit Log](create-auditlog.md)
cf cups CROSS_SCHEMA_SFLIGHT -p "{\"user\":\"CUPS_SFLIGHT\",\"password\":\"<Password>\",\"driver\":\"com.sap.db.jdbc.Driver\",\"tags\":[\"hana\"] , \"schema\" : \"SFLIGHT\" }"

cf cups sap.hana.democontent.epm.services.images -p "{\"host\":\"www.loc.gov\",\"port\":\"80\",\"tags\":[\"xshttpdest\"] }"

cf create-service xsuaa space openSAP-ex-uaa -c xs-security.json

cf create-service auditlog-management default openSAP-ex-log