-- DDL for Daily Exchange Rate of the Indian Rupee_CLEAN-Final.xlsx
-- Generated from: /Users/admin/Downloads/Final DBIE 2/Daily Exchange Rate of the Indian Rupee_CLEAN-Final.xlsx
-- Compatible with Oracle SQL Developer / Oracle Database
SET DEFINE OFF;

CREATE TABLE DBIE_F01_DAILY_EXCHANGE_RATE_O (
    ROW_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DATE DATE,
    US_DOLLAR NUMBER(6,4),
    POUND_STERLING NUMBER(7,4),
    EURO NUMBER(7,4),
    JAPANESE_YEN NUMBER(6,4)
);

COMMENT ON TABLE DBIE_F01_DAILY_EXCHANGE_RATE_O IS 'Source file: Daily Exchange Rate of the Indian Rupee_CLEAN-Final.xlsx | Sheet: Daily Foreign Exchange Spot Rat';
COMMENT ON COLUMN DBIE_F01_DAILY_EXCHANGE_RATE_O.DATE IS 'Excel column: Date';
COMMENT ON COLUMN DBIE_F01_DAILY_EXCHANGE_RATE_O.US_DOLLAR IS 'Excel column: US_Dollar';
COMMENT ON COLUMN DBIE_F01_DAILY_EXCHANGE_RATE_O.POUND_STERLING IS 'Excel column: Pound_Sterling';
COMMENT ON COLUMN DBIE_F01_DAILY_EXCHANGE_RATE_O.EURO IS 'Excel column: Euro';
COMMENT ON COLUMN DBIE_F01_DAILY_EXCHANGE_RATE_O.JAPANESE_YEN IS 'Excel column: Japanese_Yen';
