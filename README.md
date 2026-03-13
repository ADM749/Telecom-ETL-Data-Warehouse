# Telecom Data Warehouse ETL Pipeline

## Project Overview
This project is an end-to-end Data Engineering solution built for a telecom company. It processes high-volume transaction logs generated every 5 minutes by network cell towers, applies strict data quality and business transformation rules, and loads the cleaned data into a Microsoft SQL Server Data Warehouse.

## Architecture & Workflow

### 1. Extract
* Ingests 5-minute interval batch files containing core customer transactions.
* Reads raw, pipe-delimited (`|`) CSV data.

### 2. Transform (Python Engine)
The Python processing engine acts as the transformation layer, applying the following business rules:
* **Validation:** Checks for missing mandatory fields (`NOT NULL` constraints on Cell, LAC, and Timestamps) and validates Datetime formats.
* **Derivation:** Parses 14-digit `IMEI` strings to extract `TAC` (first 8 chars) and `SNR` (next 6 chars). Applies a `-99999` default for missing or invalid IMEIs.
* **Data Enrichment:** Performs a lookup against a Dimensional Reference table (`dim_imsi_reference`) to map the `IMSI` to a `Subscriber_ID`. 
* **Data Routing:** Separates the data stream into "Valid" and "Error" outputs.
* **File Management:** Automatically moves processed raw files into an `Archive` directory to prevent duplicate processing.

### 3. Load (SQL Server)
* Uses high-speed `BULK INSERT` to push the processed CSV files into the SQL Server database.
* **Fact Table (`fact_transaction`):** Stores clean, query-ready transactional data.
* **Error Table (`error_destination_output`):** Quarantines rejected records along with their specific `ErrorCode` and the original `FileName` for auditing.

## Technology Stack
* **Language:** Python 3.x (Built entirely using Python's standard libraries: `csv`, `datetime`, `shutil`—zero external dependencies required).
* **Database:** Microsoft SQL Server (T-SQL, Views, BULK INSERT).
* **Concepts:** Dimensional Modeling, ETL Routing, Batch Processing, Data Quality Enforcement.

## How to Run
1. Execute the SQL scripts in SSMS to create the `SSIS_Telecom_DB` database, tables, and reference data.
2. Run `python etl_no_install.py` to process the raw batches in the root directory.
3. Run the provided `BULK INSERT` SQL commands to load the generated `fact_transaction_output.csv` and `error_destination_output.csv` files into the database.
