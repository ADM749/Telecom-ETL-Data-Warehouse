# Telecom-ETL-Data-Warehouse
An end-to-end Python and SQL Server ETL pipeline for telecom data. It processes 5-minute CSV transaction batches, applying strict data quality rules to parse IMEIs and map IMSI subscriber IDs. Valid records are bulk-loaded into a Data Warehouse fact table, while failures are routed to an error table for auditing. Zero external dependencies used.
