# Create HDI Container Instances

```shell
cf create-service hana hdi-shared hana-opensap-cloud-2020-db -c '{"database_id": "XXXX"}'

cf create-service hana hdi-shared hana-opensap-cloud-2020-user-db -c '{"database_id": "XXXX"}'


cf create-service-key hana-opensap-cloud-2020-db default
cf create-service-key hana-opensap-cloud-2020-user-db default

cd ./db
hana-cli serviceKey hana-opensap-cloud-2020-db default

cd ./user_db
hana-cli serviceKey hana-opensap-cloud-2020-user-db default
```
