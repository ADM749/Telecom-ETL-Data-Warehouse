USE SSIS_Telecom_DB;
GO

-- 1. Create a View that skips the auto-generating 'id' column
IF OBJECT_ID('vw_fact_transaction') IS NOT NULL DROP VIEW vw_fact_transaction;
GO

CREATE VIEW vw_fact_transaction AS
SELECT transaction_id, imsi, subscriber_id, tac, snr, imei, cell, lac, event_type, event_ts
FROM fact_transaction;
GO

-- 2. Load the Valid Data into the View
BULK INSERT vw_fact_transaction
FROM 'E:\Source Files\Source Files\fact_transaction_output.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO

-- 3. Load the Error Data directly (This table already has matching columns)
BULK INSERT error_destination_output
FROM 'E:\Source Files\Source Files\error_destination_output.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO