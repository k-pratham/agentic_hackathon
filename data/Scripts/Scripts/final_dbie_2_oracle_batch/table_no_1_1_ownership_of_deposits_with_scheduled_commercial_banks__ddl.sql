-- DDL for Table No. 1.1 - Ownership of Deposits with Scheduled Commercial Banks_CLEAN-Final.xlsx
-- Generated from: /Users/admin/Downloads/Final DBIE 2/Table No. 1.1 - Ownership of Deposits with Scheduled Commercial Banks_CLEAN-Final.xlsx
-- Compatible with Oracle SQL Developer / Oracle Database
SET DEFINE OFF;

CREATE TABLE DBIE_F12_TABLE_NO_1_1_OWNERSHI (
    ROW_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SECTOR_OF_THE_ECONOMY_INR_CROR VARCHAR2(85 CHAR),
    CURRENT NUMBER(11,4),
    SAVING NUMBER(11,4),
    TERM NUMBER(12,4),
    TOTAL NUMBER(12,4)
);

COMMENT ON TABLE DBIE_F12_TABLE_NO_1_1_OWNERSHI IS 'Source file: Table No. 1.1 - Ownership of Deposits with Scheduled Commercial Banks_CLEAN-Final.xlsx | Sheet: Report 1';
COMMENT ON COLUMN DBIE_F12_TABLE_NO_1_1_OWNERSHI.SECTOR_OF_THE_ECONOMY_INR_CROR IS 'Excel column: Sector_of_the_Economy_INR_Crores';
COMMENT ON COLUMN DBIE_F12_TABLE_NO_1_1_OWNERSHI.CURRENT IS 'Excel column: Current';
COMMENT ON COLUMN DBIE_F12_TABLE_NO_1_1_OWNERSHI.SAVING IS 'Excel column: Saving';
COMMENT ON COLUMN DBIE_F12_TABLE_NO_1_1_OWNERSHI.TERM IS 'Excel column: Term';
COMMENT ON COLUMN DBIE_F12_TABLE_NO_1_1_OWNERSHI.TOTAL IS 'Excel column: Total';
