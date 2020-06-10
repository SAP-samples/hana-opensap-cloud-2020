# Create SFLIGHT User Provided Service

```shell
cf cups CROSS_SCHEMA_SFLIGHT -p "{\"user\":\"CUPS_SFLIGHT\",\"password\":\"<Password>\",\"driver\":\"com.sap.db.jdbc.Driver\",\"tags\":[\"hana\"] , \"schema\" : \"SFLIGHT\" }"
```
