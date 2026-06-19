-- DDL for WSS Table No. 14 _ Market Borrowings by the Government of India and State Governments_CLEAN.xlsx
-- Generated from: /Users/admin/Downloads/Final DBIE 2/WSS Table No. 14 _ Market Borrowings by the Government of India and State Governments_CLEAN.xlsx
-- Compatible with Oracle SQL Developer / Oracle Database
SET DEFINE OFF;

CREATE TABLE DBIE_F17_WSS_TABLE_NO_14_MARKE (
    ROW_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DATE DATE,
    GOVERNMENT_OF_INDIA_GROSS_AMOU NUMBER(10,3),
    GOVERNMENT_OF_INDIA_NET_AMOUNT NUMBER(10,3),
    STATE_GOVERNMENTS_GROSS_AMOUNT NUMBER(10,3),
    STATE_GOVERNMENTS_NET_AMOUNT_R NUMBER(11,5)
);

COMMENT ON TABLE DBIE_F17_WSS_TABLE_NO_14_MARKE IS 'Source file: WSS Table No. 14 _ Market Borrowings by the Government of India and State Governments_CLEAN.xlsx | Sheet: Report 1';
COMMENT ON COLUMN DBIE_F17_WSS_TABLE_NO_14_MARKE.DATE IS 'Excel column: Date';
COMMENT ON COLUMN DBIE_F17_WSS_TABLE_NO_14_MARKE.GOVERNMENT_OF_INDIA_GROSS_AMOU IS 'Excel column: Government_of_India_Gross_Amount_Raised';
COMMENT ON COLUMN DBIE_F17_WSS_TABLE_NO_14_MARKE.GOVERNMENT_OF_INDIA_NET_AMOUNT IS 'Excel column: Government_of_India_Net_Amount_Raised';
COMMENT ON COLUMN DBIE_F17_WSS_TABLE_NO_14_MARKE.STATE_GOVERNMENTS_GROSS_AMOUNT IS 'Excel column: State_Governments_Gross_Amount_Raised';
COMMENT ON COLUMN DBIE_F17_WSS_TABLE_NO_14_MARKE.STATE_GOVERNMENTS_NET_AMOUNT_R IS 'Excel column: State_Governments_Net_Amount_Raised';
