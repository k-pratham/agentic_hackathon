-- DDL for Table No. 1.2 - Ownership of Deposits with Scheduled Commercial Banks - Population Group-Wise_CLEAN-Final.xlsx
-- Generated from: /Users/admin/Downloads/Final DBIE 2/Table No. 1.2 - Ownership of Deposits with Scheduled Commercial Banks - Population Group-Wise_CLEAN-Final.xlsx
-- Compatible with Oracle SQL Developer / Oracle Database
SET DEFINE OFF;

CREATE TABLE DBIE_F13_TABLE_NO_1_2_OWNERSHI (
    ROW_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SECTOR_OF_THE_ECONOMY_AMOUNT_I VARCHAR2(85 CHAR),
    RURAL NUMBER(11,4),
    SEMI_URBAN NUMBER(11,4),
    URBAN NUMBER(11,4),
    METROPOLITAN NUMBER(12,4),
    TOTAL NUMBER(12,4)
);

COMMENT ON TABLE DBIE_F13_TABLE_NO_1_2_OWNERSHI IS 'Source file: Table No. 1.2 - Ownership of Deposits with Scheduled Commercial Banks - Population Group-Wise_CLEAN-Final.xlsx | Sheet: Sheet3';
COMMENT ON COLUMN DBIE_F13_TABLE_NO_1_2_OWNERSHI.SECTOR_OF_THE_ECONOMY_AMOUNT_I IS 'Excel column: SECTOR_OF_THE_ECONOMY_Amount_in_INR_Crores';
COMMENT ON COLUMN DBIE_F13_TABLE_NO_1_2_OWNERSHI.RURAL IS 'Excel column: Rural';
COMMENT ON COLUMN DBIE_F13_TABLE_NO_1_2_OWNERSHI.SEMI_URBAN IS 'Excel column: Semi-Urban';
COMMENT ON COLUMN DBIE_F13_TABLE_NO_1_2_OWNERSHI.URBAN IS 'Excel column: Urban';
COMMENT ON COLUMN DBIE_F13_TABLE_NO_1_2_OWNERSHI.METROPOLITAN IS 'Excel column: Metropolitan';
COMMENT ON COLUMN DBIE_F13_TABLE_NO_1_2_OWNERSHI.TOTAL IS 'Excel column: TOTAL';
