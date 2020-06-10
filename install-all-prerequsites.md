# Prerequsite Installation Instructions

## Install SFLIGHT

This exercise requires that you have the SFLIGHT catalog schema installed in your system and a database user who has access to this schema.
You can find more information on loading SFLIGHT into your system, if it doesn’t exist already, here:
[https://blogs.sap.com/2018/12/18/howto-import-sflight-sample-data-into-sap-hana-from-a-local-computer/](https://blogs.sap.com/2018/12/18/howto-import-sflight-sample-data-into-sap-hana-from-a-local-computer/)

## SQL Commands in Tenant

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

## CF Commands

[Create HDI Containers](create-hdi.md)

[Create Audit Log](create-auditlog.md)

[Create User Provided Service for SFLIGHT Schema](create-cups-sflight.md)

[Create HTTP Destination User Provided Service](create-httpdest-images.md)

[Create UAA](create-uaa.md)
