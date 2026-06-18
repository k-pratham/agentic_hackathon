-- ====================================================================
-- RBI Handbook of Statistics on Indian Economy - Oracle SQL Schema
-- Generated from DBIE (Database on Indian Economy) dataset catalogue
-- 
-- Total Tables: 114
-- Covering: 244 Handbook tables mapped to 114 unique DBIE datasets
-- 
-- Run this script in Oracle SQL Developer or SQL*Plus
-- ====================================================================

SET ECHO ON
SET FEEDBACK ON

PROMPT Creating 114 database tables for RBI Handbook of Statistics...

-- ================================================================
-- TABLE: AGR_INDEX_MJR_CRPS_RN
-- DBIE Dataset: Agricultural Index - Major crops
-- Sector: Real Sector:Agriculture
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 16, Table 18
-- ================================================================

CREATE TABLE AGR_INDEX_MJR_CRPS_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_TE_1981_82, BY_TE_1993_94, BY_TE_2007_08
    CROP_CLASSIFICATION              VARCHAR2(50),  -- e.g. ALL_CRPS, FDGRAINS, FG_CEREALS, FG_CE_CC, FG_CE_RI
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE AGR_INDEX_MJR_CRPS_RN IS 'DBIE: AGR_INDEX_MJR_CRPS_RN - Agricultural Index - Major crops | Real Sector:Agriculture | Agricultural Index - Major crops';
COMMENT ON COLUMN AGR_INDEX_MJR_CRPS_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN AGR_INDEX_MJR_CRPS_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN AGR_INDEX_MJR_CRPS_RN.CROP_CLASSIFICATION IS 'DBIE dimension: Classification of Crops';
COMMENT ON COLUMN AGR_INDEX_MJR_CRPS_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN AGR_INDEX_MJR_CRPS_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN AGR_INDEX_MJR_CRPS_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN AGR_INDEX_MJR_CRPS_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: AGR_PROD_RN
-- DBIE Dataset: Agricultural Production
-- Sector: Real Sector:Agriculture
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 17
-- ================================================================

CREATE TABLE AGR_PROD_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    CROP_CLASSIFICATION              VARCHAR2(50),  -- e.g. FDGRNS, CERLS, CC, RI, WH
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE AGR_PROD_RN IS 'DBIE: AGR_PROD_RN - Agricultural Production | Real Sector:Agriculture | Agricultural Production';
COMMENT ON COLUMN AGR_PROD_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN AGR_PROD_RN.CROP_CLASSIFICATION IS 'DBIE dimension: Classification of Crops';
COMMENT ON COLUMN AGR_PROD_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN AGR_PROD_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN AGR_PROD_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN AGR_PROD_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: AMAGG_RN
-- DBIE Dataset: Average Monetary Aggregates
-- Sector: Financial Sector:Monetary Statistics
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 41, Table 65, Table 172, Table 230
-- ================================================================

CREATE TABLE AMAGG_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MONEY_STOCK_COMPONENT            VARCHAR2(50),  -- e.g. CMS1, CMS11, CMS1102, CMS1101, CMS11011
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. ANNUAL_AVE
    MONEY_STOCK_SOURCE               VARCHAR2(50),  -- e.g. SMS2, SMS4, SMS1, SMS3, SMS5
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE AMAGG_RN IS 'DBIE: AMAGG_RN - Average Monetary Aggregates | Financial Sector:Monetary Statistics | Average Monetary Aggregates';
COMMENT ON COLUMN AMAGG_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN AMAGG_RN.MONEY_STOCK_COMPONENT IS 'DBIE dimension: Components of Money Stock';
COMMENT ON COLUMN AMAGG_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN AMAGG_RN.MONEY_STOCK_SOURCE IS 'DBIE dimension: Sources of Money Stock';
COMMENT ON COLUMN AMAGG_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN AMAGG_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN AMAGG_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN AMAGG_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: ANN_GDP_FACT_CST_RN
-- DBIE Dataset: Annual Gross Value Added at Basic Prices
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 3, Table 7, Table 8, Table 154, Table 156
-- ================================================================

CREATE TABLE ANN_GDP_FACT_CST_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1999_2000, BY_2004_05, BY_2011_12
    GDP_COMPONENT                    VARCHAR2(50),  -- e.g. CECN_AGR_FOR_FISH, CEXP_CHG_STOCK, CECN_CONST, CEXP_DISCP, CECN_ELCTY_GAS_WTR_OTH
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CNST_PRC, CURR_PRC
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE ANN_GDP_FACT_CST_RN IS 'DBIE: ANN_GDP_FACT_CST_RN - Annual Gross Value Added at Basic Prices | Real Sector:National Income | Annual Gross Value Added at Basic Prices';
COMMENT ON COLUMN ANN_GDP_FACT_CST_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN ANN_GDP_FACT_CST_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN ANN_GDP_FACT_CST_RN.GDP_COMPONENT IS 'DBIE dimension: Components of GDP';
COMMENT ON COLUMN ANN_GDP_FACT_CST_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN ANN_GDP_FACT_CST_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN ANN_GDP_FACT_CST_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN ANN_GDP_FACT_CST_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN ANN_GDP_FACT_CST_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: ANN_SURV_INDS_RN
-- DBIE Dataset: Details captured under Annual Survey of Industries
-- Sector: Real Sector:Industrial Statistics
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 32
-- ================================================================

CREATE TABLE ANN_SURV_INDS_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INDUSTRY                         VARCHAR2(50),  -- e.g. DEPREC, FIX_CAP, FUEL_CONS, GROSS_CAP_FORM, GRS_FXD_CAP_FORM
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE ANN_SURV_INDS_RN IS 'DBIE: ANN_SURV_INDS_RN - Details captured under Annual Survey of Industries | Real Sector:Industrial Statistics | Details captured under Annual Survey of Industries';
COMMENT ON COLUMN ANN_SURV_INDS_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN ANN_SURV_INDS_RN.INDUSTRY IS 'DBIE dimension: Industry';
COMMENT ON COLUMN ANN_SURV_INDS_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN ANN_SURV_INDS_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN ANN_SURV_INDS_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN ANN_SURV_INDS_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: AREA_UNDER_CULT_RN
-- DBIE Dataset: Area Under Cultivation
-- Sector: Real Sector:Agriculture
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 19, Table 20
-- ================================================================

CREATE TABLE AREA_UNDER_CULT_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    CROP_CLASSIFICATION              VARCHAR2(50),  -- e.g. FDGRNS, CERLS, CC, RI, WH
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE AREA_UNDER_CULT_RN IS 'DBIE: AREA_UNDER_CULT_RN - Area Under Cultivation | Real Sector:Agriculture | Area Under Cultivation';
COMMENT ON COLUMN AREA_UNDER_CULT_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN AREA_UNDER_CULT_RN.CROP_CLASSIFICATION IS 'DBIE dimension: Classification of Crops';
COMMENT ON COLUMN AREA_UNDER_CULT_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN AREA_UNDER_CULT_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN AREA_UNDER_CULT_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN AREA_UNDER_CULT_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: AUC_LAF_RN
-- DBIE Dataset: Auction under LAF
-- Sector: Financial Markets:Money Market
-- Frequency: Daily
-- Handbook Tables: Table 80, Table 81
-- ================================================================

CREATE TABLE AUC_LAF_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. AMT, CUT_OFF_RT, NUM, PERIOD_DAYS
    BID_TYPE                         VARCHAR2(50),  -- e.g. BIDS_ACCEPTED, BIDS_RECEIVED, N_A
    LAF_TYPE                         VARCHAR2(50),  -- e.g. FIX_REPO, VAR_REPO, FIX_REV_REPO, VAR_REV_REPO
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE AUC_LAF_RN IS 'DBIE: AUC_LAF_RN - Auction under LAF | Financial Markets:Money Market | Auction under LAF';
COMMENT ON COLUMN AUC_LAF_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN AUC_LAF_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN AUC_LAF_RN.BID_TYPE IS 'DBIE dimension: Type of Bids';
COMMENT ON COLUMN AUC_LAF_RN.LAF_TYPE IS 'DBIE dimension: Type of Liquidity Adjustment Facilities';
COMMENT ON COLUMN AUC_LAF_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN AUC_LAF_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN AUC_LAF_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN AUC_LAF_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: AVG_NFTY_RN
-- DBIE Dataset: Average of Nifty 50
-- Sector: Financial Markets:Equity and Corporate Debt Market
-- Frequency: Monthly
-- Handbook Tables: Table 78, Table 79, Table 179, Table 181
-- ================================================================

CREATE TABLE AVG_NFTY_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. AVG
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE AVG_NFTY_RN IS 'DBIE: AVG_NFTY_RN - Average of Nifty 50 | Financial Markets:Equity and Corporate Debt Market | Average of Nifty 50';
COMMENT ON COLUMN AVG_NFTY_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN AVG_NFTY_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN AVG_NFTY_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN AVG_NFTY_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN AVG_NFTY_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN AVG_NFTY_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: BAL_SHT_NGNBFI_AW_RN
-- DBIE Dataset: Balance Sheet of Non-Government Non-Banking Financial and Investment (NGNBF&I) Companies - Activity wise
-- Sector: Corporate Sector:Non-Government Non-Banking Financial and Investment Companies
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 45, Table 46, Table 49, Table 52, Table 59, Table 60, Table 72, Table 167, Table 168, Table 169
-- ================================================================

CREATE TABLE BAL_SHT_NGNBFI_AW_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    ACTIVITY_CATEGORY                VARCHAR2(50),  -- e.g. AC_ALL_ACT, AC_AST_FIN, AC_DIV, AC_LN_FIN, AC_MISC
    BALANCE_SHEET_ITEM               VARCHAR2(50),  -- e.g. NCA_TTL_AST, TTL_AST, CURR_AST, CA_CCE, CA_CCE_BWB
    REFERENCE_TIME                   VARCHAR2(50),  -- e.g. CURR_FIN_YR, PREV_FIN_YR, PREV_TO_PREV_FIN_YR
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE BAL_SHT_NGNBFI_AW_RN IS 'DBIE: BAL_SHT_NGNBFI_AW_RN - Balance Sheet of Non-Government Non-Banking Financial and Investment (NGNBF&I) Companies - Activity wise | Corporate Sector:Non-Government Non-Banking Financial and Investment Companies | Balance Sheet of Non-Government Non-Banking Financial and Investment (NGNBF&I) Companies - Activity wise';
COMMENT ON COLUMN BAL_SHT_NGNBFI_AW_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN BAL_SHT_NGNBFI_AW_RN.ACTIVITY_CATEGORY IS 'DBIE dimension: Activity wise Category';
COMMENT ON COLUMN BAL_SHT_NGNBFI_AW_RN.BALANCE_SHEET_ITEM IS 'DBIE dimension: Balance Sheet items';
COMMENT ON COLUMN BAL_SHT_NGNBFI_AW_RN.REFERENCE_TIME IS 'DBIE dimension: Reference Time';
COMMENT ON COLUMN BAL_SHT_NGNBFI_AW_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN BAL_SHT_NGNBFI_AW_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN BAL_SHT_NGNBFI_AW_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN BAL_SHT_NGNBFI_AW_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: BAL_SHT_NGNBFI_LIAB_AW_RN
-- DBIE Dataset: Balance Sheet of Non-Government Non-Banking Financial and Investment(NGNBF&I) Companies-Liabilities
-- Sector: Corporate Sector:Non-Government Non-Banking Financial and Investment Companies
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 42, Table 84
-- ================================================================

CREATE TABLE BAL_SHT_NGNBFI_LIAB_AW_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    ACTIVITY_CATEGORY                VARCHAR2(50),  -- e.g. AC_ALL_ACT, AC_AST_FIN, AC_DIV, AC_LN_FIN, AC_MISC
    BALANCE_SHEET_ITEM               VARCHAR2(50),  -- e.g. CAP_EQU_LIA, LIB_CL, LIB_CL_OCL, LIB_CL_STB, LIB_CL_STB_USEC_DEP
    REFERENCE_TIME                   VARCHAR2(50),  -- e.g. CURR_FIN_YR, PREV_FIN_YR, PREV_TO_PREV_FIN_YR
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE BAL_SHT_NGNBFI_LIAB_AW_RN IS 'DBIE: BAL_SHT_NGNBFI_LIAB_AW_RN - Balance Sheet of Non-Government Non-Banking Financial and Investment(NGNBF&I) Companies-Liabilities | Corporate Sector:Non-Government Non-Banking Financial and Investment Companies | Balance Sheet of Non-Government Non-Banking Financial and Investment(NGNBF&I) Companies-Liabilities';
COMMENT ON COLUMN BAL_SHT_NGNBFI_LIAB_AW_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN BAL_SHT_NGNBFI_LIAB_AW_RN.ACTIVITY_CATEGORY IS 'DBIE dimension: Activity wise Category';
COMMENT ON COLUMN BAL_SHT_NGNBFI_LIAB_AW_RN.BALANCE_SHEET_ITEM IS 'DBIE dimension: Balance Sheet items';
COMMENT ON COLUMN BAL_SHT_NGNBFI_LIAB_AW_RN.REFERENCE_TIME IS 'DBIE dimension: Reference Time';
COMMENT ON COLUMN BAL_SHT_NGNBFI_LIAB_AW_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN BAL_SHT_NGNBFI_LIAB_AW_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN BAL_SHT_NGNBFI_LIAB_AW_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN BAL_SHT_NGNBFI_LIAB_AW_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: BAL_SHT_PUB_CAP_LIA_RN
-- DBIE Dataset: Balance Sheet of Public Limited Companies-Capital Liabilities
-- Sector: Corporate Sector:Non-Government Non-Financial Public Limited Companies
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 67, Table 178
-- ================================================================

CREATE TABLE BAL_SHT_PUB_CAP_LIA_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BALANCE_SHEET_ITEM               VARCHAR2(50),  -- e.g. CAP_CURR_LIA_CURR_BORR_SEC, CAP_EQU_LIA, LIB_CL, CAP_CURR_LIA_CURR_BORR, CAP_CURR_LIA_CURR_BORR_COMM_PAPR
    REFERENCE_TIME                   VARCHAR2(50),  -- e.g. CURR_YR, PREV_TO_PREV, PREV_YR
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE BAL_SHT_PUB_CAP_LIA_RN IS 'DBIE: BAL_SHT_PUB_CAP_LIA_RN - Balance Sheet of Public Limited Companies-Capital Liabilities | Corporate Sector:Non-Government Non-Financial Public Limited Companies | Balance Sheet of Public Limited Companies-Capital Liabilities';
COMMENT ON COLUMN BAL_SHT_PUB_CAP_LIA_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN BAL_SHT_PUB_CAP_LIA_RN.BALANCE_SHEET_ITEM IS 'DBIE dimension: Balance Sheet items';
COMMENT ON COLUMN BAL_SHT_PUB_CAP_LIA_RN.REFERENCE_TIME IS 'DBIE dimension: Reference Time';
COMMENT ON COLUMN BAL_SHT_PUB_CAP_LIA_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN BAL_SHT_PUB_CAP_LIA_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN BAL_SHT_PUB_CAP_LIA_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN BAL_SHT_PUB_CAP_LIA_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: BAL_SHT_PUB_RN
-- DBIE Dataset: Balance Sheet of Public Limited Companies
-- Sector: Corporate Sector:Non-Government Non-Financial Public Limited Companies
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 66, Table 70
-- ================================================================

CREATE TABLE BAL_SHT_PUB_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BALANCE_SHEET_ITEM               VARCHAR2(50),  -- e.g. TTL_CU_N_NONC, ADO_INC_TAX, CAN_BB, CAN_BB_CID, CAN_BB_FDQB
    REFERENCE_TIME                   VARCHAR2(50),  -- e.g. CURR_YR, PREV_TO_PREV, PREV_YR
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE BAL_SHT_PUB_RN IS 'DBIE: BAL_SHT_PUB_RN - Balance Sheet of Public Limited Companies | Corporate Sector:Non-Government Non-Financial Public Limited Companies | Balance Sheet of Public Limited Companies';
COMMENT ON COLUMN BAL_SHT_PUB_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN BAL_SHT_PUB_RN.BALANCE_SHEET_ITEM IS 'DBIE dimension: Balance Sheet items';
COMMENT ON COLUMN BAL_SHT_PUB_RN.REFERENCE_TIME IS 'DBIE dimension: Reference Time';
COMMENT ON COLUMN BAL_SHT_PUB_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN BAL_SHT_PUB_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN BAL_SHT_PUB_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN BAL_SHT_PUB_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: BCCI_MER_TRD_RN
-- DBIE Dataset: Broad Commodity Composition of India's Merchandise Trade
-- Sector: External Sector:International Trade
-- Frequency: Monthly
-- Handbook Tables: Table 189
-- ================================================================

CREATE TABLE BCCI_MER_TRD_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    TRADE_COMMODITY                  VARCHAR2(50),  -- e.g. TERM_TRD_EXP, COMM_NON_OIL1, COMM_OIL1, TERM_TRD_IMP, COMM_NON_OIL
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE BCCI_MER_TRD_RN IS 'DBIE: BCCI_MER_TRD_RN - Broad Commodity Composition of India''s Merchandise Trade | External Sector:International Trade | Broad Commodity Composition of India''s Merchandise Trade';
COMMENT ON COLUMN BCCI_MER_TRD_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN BCCI_MER_TRD_RN.TRADE_COMMODITY IS 'DBIE dimension: Foreign Trade Commodities';
COMMENT ON COLUMN BCCI_MER_TRD_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN BCCI_MER_TRD_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN BCCI_MER_TRD_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN BCCI_MER_TRD_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: BK_VAL_RAT_BSE_RN
-- DBIE Dataset: Book Value Ratio of BSE
-- Sector: Financial Markets:Equity and Corporate Debt Market
-- Frequency: Monthly
-- Handbook Tables: Table 126, Table 182, Table 244
-- ================================================================

CREATE TABLE BK_VAL_RAT_BSE_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. AVG
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE BK_VAL_RAT_BSE_RN IS 'DBIE: BK_VAL_RAT_BSE_RN - Book Value Ratio of BSE | Financial Markets:Equity and Corporate Debt Market | Book Value Ratio of BSE';
COMMENT ON COLUMN BK_VAL_RAT_BSE_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN BK_VAL_RAT_BSE_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN BK_VAL_RAT_BSE_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN BK_VAL_RAT_BSE_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN BK_VAL_RAT_BSE_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN BK_VAL_RAT_BSE_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: BOP_INDI_RN
-- DBIE Dataset: Balance Of Payments Indicators
-- Sector: External Sector:International Trade
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 61, Table 129, Table 130, Table 240
-- ================================================================

CREATE TABLE BOP_INDI_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BOP_INDICATOR                    VARCHAR2(50),  -- e.g. CAP_ACC, FI_TO_EXP, FI_TO_GDP, CUR_AC, CAD_TO_GDP
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE BOP_INDI_RN IS 'DBIE: BOP_INDI_RN - Balance Of Payments Indicators | External Sector:International Trade | Balance Of Payments Indicators';
COMMENT ON COLUMN BOP_INDI_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN BOP_INDI_RN.BOP_INDICATOR IS 'DBIE dimension: Category of BOP Indicator';
COMMENT ON COLUMN BOP_INDI_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN BOP_INDI_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN BOP_INDI_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN BOP_INDI_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CCSG_DEF_RN
-- DBIE Dataset: Combined Central & State Government Deficit
-- Sector: Public Finance:Cental & State Govt Finance(Combined)
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 96, Table 106, Table 110
-- ================================================================

CREATE TABLE CCSG_DEF_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    DEFICIT_TYPE                     VARCHAR2(50),  -- e.g. DEF1, DEF4, DEF9, DEF6
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CCSG_DEF_RN IS 'DBIE: CCSG_DEF_RN - Combined Central & State Government Deficit | Public Finance:Cental & State Govt Finance(Combined) | Combined Central & State Government Deficit';
COMMENT ON COLUMN CCSG_DEF_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CCSG_DEF_RN.DEFICIT_TYPE IS 'DBIE dimension: Type of Deficit';
COMMENT ON COLUMN CCSG_DEF_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CCSG_DEF_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CCSG_DEF_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CCSG_DEF_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CCSG_RECPT_RN
-- DBIE Dataset: Combined Central & State Government Receipts
-- Sector: Public Finance:Cental & State Govt Finance(Combined)
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 102
-- ================================================================

CREATE TABLE CCSG_RECPT_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    RECEIPT_TYPE                     VARCHAR2(50),  -- e.g. GR1, GR12, GR11, OTHERS, GR1101
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CCSG_RECPT_RN IS 'DBIE: CCSG_RECPT_RN - Combined Central & State Government Receipts | Public Finance:Cental & State Govt Finance(Combined) | Combined Central & State Government Receipts';
COMMENT ON COLUMN CCSG_RECPT_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CCSG_RECPT_RN.RECEIPT_TYPE IS 'DBIE dimension: Type of Government Receipts';
COMMENT ON COLUMN CCSG_RECPT_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CCSG_RECPT_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CCSG_RECPT_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CCSG_RECPT_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CCS_EXP_RN
-- DBIE Dataset: Combined Central & State Expenditures
-- Sector: Public Finance:Cental & State Govt Finance(Combined)
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 101, Table 104, Table 238
-- ================================================================

CREATE TABLE CCS_EXP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    TYPE_OF_GOVERNMENT_EXPENDITURE   VARCHAR2(50),  -- e.g. GE3, GE31, GE32, GE33, GE1
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CCS_EXP_RN IS 'DBIE: CCS_EXP_RN - Combined Central & State Expenditures | Public Finance:Cental & State Govt Finance(Combined) | Combined Central & State Expenditures';
COMMENT ON COLUMN CCS_EXP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CCS_EXP_RN.TYPE_OF_GOVERNMENT_EXPENDITURE IS 'DBIE dimension: Type of Government Expenditures';
COMMENT ON COLUMN CCS_EXP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CCS_EXP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CCS_EXP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CCS_EXP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CENT_SEC_DEL_PRJ_RN
-- DBIE Dataset: Central Sector Delayed Projects
-- Sector: Real Sector:Industrial Statistics
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 34, Table 35
-- ================================================================

CREATE TABLE CENT_SEC_DEL_PRJ_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    PROJECT_DETAIL                   VARCHAR2(50),  -- e.g. DEL_COST_OVRN, DEL_NON_ANT, DEL_NBR_PRJ, DEL_ORG_EST
    SECTOR                           VARCHAR2(50),  -- e.g. IIP_ATM_ENG, IIP_CVL_AVN, IIP_COAL, IIP_FRTZ, IIP_FIN
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CENT_SEC_DEL_PRJ_RN IS 'DBIE: CENT_SEC_DEL_PRJ_RN - Central Sector Delayed Projects | Real Sector:Industrial Statistics | Central Sector Delayed Projects';
COMMENT ON COLUMN CENT_SEC_DEL_PRJ_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CENT_SEC_DEL_PRJ_RN.PROJECT_DETAIL IS 'DBIE dimension: Delayed Project Details';
COMMENT ON COLUMN CENT_SEC_DEL_PRJ_RN.SECTOR IS 'DBIE dimension: Sector';
COMMENT ON COLUMN CENT_SEC_DEL_PRJ_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CENT_SEC_DEL_PRJ_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CENT_SEC_DEL_PRJ_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CENT_SEC_DEL_PRJ_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CERTI_DEPO_RN
-- DBIE Dataset: Certificates of Deposit
-- Sector: Financial Markets:Money Market
-- Frequency: Fortnightly
-- Handbook Tables: Table 213
-- ================================================================

CREATE TABLE CERTI_DEPO_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. ISSUED_FORTNIGHT, MAX_RATE, MIN_RATE, TOT_AMT_OUST
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CERTI_DEPO_RN IS 'DBIE: CERTI_DEPO_RN - Certificates of Deposit | Financial Markets:Money Market | Certificates of Deposit';
COMMENT ON COLUMN CERTI_DEPO_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CERTI_DEPO_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN CERTI_DEPO_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CERTI_DEPO_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CERTI_DEPO_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CERTI_DEPO_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CGL_RN
-- DBIE Dataset: Central Government Liabilities
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 107
-- ================================================================

CREATE TABLE CGL_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    LIABILITY_TYPE                   VARCHAR2(50),  -- e.g. TTL_LIABLITIES, TL2, TL1, TL11, TL1103
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CGL_RN IS 'DBIE: CGL_RN - Central Government Liabilities | Public Finance:Central Govt Finance | Central Government Liabilities';
COMMENT ON COLUMN CGL_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CGL_RN.LIABILITY_TYPE IS 'DBIE dimension: Type of Liabilities';
COMMENT ON COLUMN CGL_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CGL_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CGL_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CGL_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CG_BOR_RN
-- DBIE Dataset: Central Government Borrowings
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 220
-- ================================================================

CREATE TABLE CG_BOR_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BORROWING_TYPE                   VARCHAR2(50),  -- e.g. CGB, CGB1, CGB2, CGB23, CGB21
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CG_BOR_RN IS 'DBIE: CG_BOR_RN - Central Government Borrowings | Public Finance:Central Govt Finance | Central Government Borrowings';
COMMENT ON COLUMN CG_BOR_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CG_BOR_RN.BORROWING_TYPE IS 'DBIE dimension: Central Government Borrowing of GFD';
COMMENT ON COLUMN CG_BOR_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CG_BOR_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CG_BOR_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CG_BOR_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CG_DEFM_RN
-- DBIE Dataset: Central Government Deficit Monthly
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Monthly
-- Handbook Tables: Table 188
-- ================================================================

CREATE TABLE CG_DEFM_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CG_DEFM_RN IS 'DBIE: CG_DEFM_RN - Central Government Deficit Monthly | Public Finance:Central Govt Finance | Central Government Deficit Monthly';
COMMENT ON COLUMN CG_DEFM_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CG_DEFM_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CG_DEFM_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CG_DEFM_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CG_DEFM_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CG_DEF_RN
-- DBIE Dataset: Central Government Deficit
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 89
-- ================================================================

CREATE TABLE CG_DEF_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    DEFICIT_TYPE                     VARCHAR2(50),  -- e.g. CE5, CGR3, DEF1, DEF4, DEF2
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CG_DEF_RN IS 'DBIE: CG_DEF_RN - Central Government Deficit | Public Finance:Central Govt Finance | Central Government Deficit';
COMMENT ON COLUMN CG_DEF_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CG_DEF_RN.DEFICIT_TYPE IS 'DBIE dimension: Type of Deficit';
COMMENT ON COLUMN CG_DEF_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CG_DEF_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CG_DEF_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CG_DEF_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CG_DEV_NDEV_EXP_RN
-- DBIE Dataset: Devlopmental and Non-Devlopmental  Expenditures - Central Government
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 93
-- ================================================================

CREATE TABLE CG_DEV_NDEV_EXP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    EXPENDITURE_TYPE                 VARCHAR2(50),  -- e.g. CE1, CE11, CE1101, CE1102, CE12
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CG_DEV_NDEV_EXP_RN IS 'DBIE: CG_DEV_NDEV_EXP_RN - Devlopmental and Non-Devlopmental  Expenditures - Central Government | Public Finance:Central Govt Finance | Devlopmental and Non-Devlopmental  Expenditures - Central Government';
COMMENT ON COLUMN CG_DEV_NDEV_EXP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CG_DEV_NDEV_EXP_RN.EXPENDITURE_TYPE IS 'DBIE dimension: Type of Central Governments Expenditures';
COMMENT ON COLUMN CG_DEV_NDEV_EXP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CG_DEV_NDEV_EXP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CG_DEV_NDEV_EXP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CG_DEV_NDEV_EXP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CG_EXP_RN
-- DBIE Dataset: Central Government Expenditures
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 92
-- ================================================================

CREATE TABLE CG_EXP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    EXPENDITURE_TYPE                 VARCHAR2(50),  -- e.g. CE2, CE22, CE2202, CE220201, CE220202
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CG_EXP_RN IS 'DBIE: CG_EXP_RN - Central Government Expenditures | Public Finance:Central Govt Finance | Central Government Expenditures';
COMMENT ON COLUMN CG_EXP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CG_EXP_RN.EXPENDITURE_TYPE IS 'DBIE dimension: Type of Central Governments Expenditures';
COMMENT ON COLUMN CG_EXP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CG_EXP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CG_EXP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CG_EXP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CG_RECPT_RN
-- DBIE Dataset: Central Government Receipts
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 90, Table 91
-- ================================================================

CREATE TABLE CG_RECPT_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    RECEIPT_TYPE                     VARCHAR2(50),  -- e.g. TTL_RECEIPTS, CGR2, CGR26, CGR27, CGR21
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CG_RECPT_RN IS 'DBIE: CG_RECPT_RN - Central Government Receipts | Public Finance:Central Govt Finance | Central Government Receipts';
COMMENT ON COLUMN CG_RECPT_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CG_RECPT_RN.RECEIPT_TYPE IS 'DBIE dimension: Type of Central Government''s Receipts';
COMMENT ON COLUMN CG_RECPT_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CG_RECPT_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CG_RECPT_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CG_RECPT_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CHG_FIN_ASS_HOUSE_SEC_RN
-- DBIE Dataset: Changes in Financial Assets of the Household Sector
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 12
-- ================================================================

CREATE TABLE CHG_FIN_ASS_HOUSE_SEC_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    FINANCIAL_ASSETS                 VARCHAR2(50),  -- e.g. FA_CHNG_FIN_ASS, FA_BNK_DEP, FA_CLM_GOV, FA_CURR, FA_LIF_INS_FND
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CURR_PRC
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CHG_FIN_ASS_HOUSE_SEC_RN IS 'DBIE: CHG_FIN_ASS_HOUSE_SEC_RN - Changes in Financial Assets of the Household Sector | Real Sector:National Income | Changes in Financial Assets of the Household Sector';
COMMENT ON COLUMN CHG_FIN_ASS_HOUSE_SEC_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CHG_FIN_ASS_HOUSE_SEC_RN.FINANCIAL_ASSETS_2 IS 'DBIE dimension: Financial assets';
COMMENT ON COLUMN CHG_FIN_ASS_HOUSE_SEC_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN CHG_FIN_ASS_HOUSE_SEC_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CHG_FIN_ASS_HOUSE_SEC_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CHG_FIN_ASS_HOUSE_SEC_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CHG_FIN_ASS_HOUSE_SEC_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CI_NGNBFI_AW_RN
-- DBIE Dataset: Combined Income, Expenditure and Appropriation Accounts for Non-Government Non-Banking Financial and Investment (NGNBF&I) Companies - Activity wise
-- Sector: Corporate Sector:Non-Government Non-Banking Financial and Investment Companies
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 57
-- ================================================================

CREATE TABLE CI_NGNBFI_AW_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    ACTIVITY_CATEGORY                VARCHAR2(50),  -- e.g. AC_ALL_ACT, AC_AST_FIN, AC_DIV, AC_LN_FIN, AC_MISC
    ITEMS                            VARCHAR2(50),  -- e.g. GRP_ENA_EBT, GRP_ENA_LCT, GRP_ENA_NP, GRP_ENA_NP_DIV, GRP_ENA_NP_PR
    REFERENCE_TIME                   VARCHAR2(50),  -- e.g. CURR_FIN_YR, PREV_FIN_YR, PREV_TO_PREV_FIN_YR
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CI_NGNBFI_AW_RN IS 'DBIE: CI_NGNBFI_AW_RN - Combined Income, Expenditure and Appropriation Accounts for Non-Government Non-Banking Financial and Investment (NGNBF&I) Companies - Activity wise | Corporate Sector:Non-Government Non-Banking Financial and Investment Companies | Combined Income, Expenditure and Appropriation Accounts for Non-Government Non-Banking Financial and Investment (NGNBF&I) Companies - Activity wise';
COMMENT ON COLUMN CI_NGNBFI_AW_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CI_NGNBFI_AW_RN.ACTIVITY_CATEGORY IS 'DBIE dimension: Activity wise Category';
COMMENT ON COLUMN CI_NGNBFI_AW_RN.ITEMS_2 IS 'DBIE dimension: Items';
COMMENT ON COLUMN CI_NGNBFI_AW_RN.REFERENCE_TIME IS 'DBIE dimension: Reference Time';
COMMENT ON COLUMN CI_NGNBFI_AW_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CI_NGNBFI_AW_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CI_NGNBFI_AW_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CI_NGNBFI_AW_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: COM_PAPER_RN
-- DBIE Dataset: Commercial Paper
-- Sector: Financial Markets:Money Market
-- Frequency: Fortnightly
-- Handbook Tables: Table 44, Table 54, Table 55, Table 63, Table 166, Table 211, Table 212
-- ================================================================

CREATE TABLE COM_PAPER_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. AMT, ISSUED_FORTNIGHT, MAX_RATE, MIN_RATE
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE COM_PAPER_RN IS 'DBIE: COM_PAPER_RN - Commercial Paper | Financial Markets:Money Market | Commercial Paper';
COMMENT ON COLUMN COM_PAPER_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN COM_PAPER_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN COM_PAPER_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN COM_PAPER_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN COM_PAPER_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN COM_PAPER_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CPI_AGR_AVG_YRND_RN
-- DBIE Dataset: Consumer Price Index - Agriculture Labourer(Average/Year end)
-- Sector: Real Sector:Prices & Wages
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 37
-- ================================================================

CREATE TABLE CPI_AGR_AVG_YRND_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1960-61, BY_1986-87
    COMMODITY                        VARCHAR2(50),  -- e.g. C_GIAG, C_GIAG_CBF, C_GIAG_FG, C_GIAG_FL, C_GIAG_MS
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. ANNUAL_AVE, YR_END
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CPI_AGR_AVG_YRND_RN IS 'DBIE: CPI_AGR_AVG_YRND_RN - Consumer Price Index - Agriculture Labourer(Average/Year end) | Real Sector:Prices & Wages | Consumer Price Index - Agriculture Labourer(Average/Year end)';
COMMENT ON COLUMN CPI_AGR_AVG_YRND_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CPI_AGR_AVG_YRND_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN CPI_AGR_AVG_YRND_RN.COMMODITY IS 'DBIE dimension: Commodity';
COMMENT ON COLUMN CPI_AGR_AVG_YRND_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN CPI_AGR_AVG_YRND_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CPI_AGR_AVG_YRND_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CPI_AGR_AVG_YRND_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CPI_AGR_AVG_YRND_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CPI_ALRL_ST_RN
-- DBIE Dataset: Consumer Price Index - Agriculture and Rural Labourer(State wise)
-- Sector: Real Sector:Prices & Wages
-- Frequency: Monthly
-- Handbook Tables: Table 162
-- ================================================================

CREATE TABLE CPI_ALRL_ST_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_JULY_1986_JUNE_1987
    STATE                            VARCHAR2(50),  -- e.g. ALL_INDIA, ALLS, CR, MP, UP
    LABOURER_TYPE                    VARCHAR2(50),  -- e.g. AL, RL
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CPI_ALRL_ST_RN IS 'DBIE: CPI_ALRL_ST_RN - Consumer Price Index - Agriculture and Rural Labourer(State wise) | Real Sector:Prices & Wages | Consumer Price Index - Agriculture and Rural Labourer(State wise)';
COMMENT ON COLUMN CPI_ALRL_ST_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CPI_ALRL_ST_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN CPI_ALRL_ST_RN.STATE IS 'DBIE dimension: State';
COMMENT ON COLUMN CPI_ALRL_ST_RN.LABOURER_TYPE IS 'DBIE dimension: Type of Labourers';
COMMENT ON COLUMN CPI_ALRL_ST_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CPI_ALRL_ST_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CPI_ALRL_ST_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CPI_ALRL_ST_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CPI_ANN_AVG_VAR_RN
-- DBIE Dataset: Consumer Price Index - Annual Average/Variation
-- Sector: Real Sector:Prices & Wages
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 235, Table 242
-- ================================================================

CREATE TABLE CPI_ANN_AVG_VAR_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1986-87, BY_1960, BY_1982, BY_2001, BY_2012
    GEOGRAPHICAL_COVERAGE            VARCHAR2(50),  -- e.g. ALL_INDIA, COMB_RUR_URB, N_A, RUR, URB
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. ANNUAL_AVE, ANL_VAR
    CPI_TYPE                         VARCHAR2(50),  -- e.g. AL, CPI_AIGI, CPI_AIGI_FB, IW_FG, IW_FGB
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CPI_ANN_AVG_VAR_RN IS 'DBIE: CPI_ANN_AVG_VAR_RN - Consumer Price Index - Annual Average/Variation | Real Sector:Prices & Wages | Consumer Price Index - Annual Average/Variation';
COMMENT ON COLUMN CPI_ANN_AVG_VAR_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CPI_ANN_AVG_VAR_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN CPI_ANN_AVG_VAR_RN.GEOGRAPHICAL_COVERAGE IS 'DBIE dimension: Geographical coverage';
COMMENT ON COLUMN CPI_ANN_AVG_VAR_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN CPI_ANN_AVG_VAR_RN.CPI_TYPE IS 'DBIE dimension: Type of CPI';
COMMENT ON COLUMN CPI_ANN_AVG_VAR_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CPI_ANN_AVG_VAR_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CPI_ANN_AVG_VAR_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CPI_ANN_AVG_VAR_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: CSURYCOM_M_RN
-- DBIE Dataset: Commercial Survey Component Monthly
-- Sector: Financial Sector:Monetary Statistics
-- Frequency: Monthly
-- Handbook Tables: Table 171
-- ================================================================

CREATE TABLE CSURYCOM_M_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    COMM_SURVEY_COMPONENT            VARCHAR2(50),  -- e.g. CCS1, CCS11, CCS12, CCS1202, CCS1201
    MERGER_CATEGORY                  VARCHAR2(50),  -- e.g. CCS1_IM, N_A, CCS12_IM
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE CSURYCOM_M_RN IS 'DBIE: CSURYCOM_M_RN - Commercial Survey Component Monthly | Financial Sector:Monetary Statistics | Commercial Survey Component Monthly';
COMMENT ON COLUMN CSURYCOM_M_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN CSURYCOM_M_RN.COMM_SURVEY_COMPONENT IS 'DBIE dimension: Components of Commercial Survey';
COMMENT ON COLUMN CSURYCOM_M_RN.MERGER_CATEGORY IS 'DBIE dimension: Components and sources (Merger)';
COMMENT ON COLUMN CSURYCOM_M_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN CSURYCOM_M_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN CSURYCOM_M_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN CSURYCOM_M_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: DIG_GDP_RN
-- DBIE Dataset: Debt Indicators of Government as percentage to GDP
-- Sector: Public Finance:Cental & State Govt Finance(Combined)
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 239
-- ================================================================

CREATE TABLE DIG_GDP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    LIABILITY_TYPE                   VARCHAR2(50),  -- e.g. LT3, LT4, LT1, LT11, LT12
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE DIG_GDP_RN IS 'DBIE: DIG_GDP_RN - Debt Indicators of Government as percentage to GDP | Public Finance:Cental & State Govt Finance(Combined) | Debt Indicators of Government as percentage to GDP';
COMMENT ON COLUMN DIG_GDP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN DIG_GDP_RN.LIABILITY_TYPE IS 'DBIE dimension: Liability Type';
COMMENT ON COLUMN DIG_GDP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN DIG_GDP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN DIG_GDP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN DIG_GDP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: DIR_FR_TRD_RN
-- DBIE Dataset: Direction of Foreign Trade
-- Sector: External Sector:International Trade
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 114, Table 115, Table 122, Table 123, Table 190, Table 191
-- ================================================================

CREATE TABLE DIR_FR_TRD_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    COUNTRY                          VARCHAR2(50),  -- e.g. CCT_COUN, CCT_DC_AF, CCT_DC_AF_BEN, CCT_DC_AF_EGY, CCT_DC_AF_KEN
    TRADE_TYPE                       VARCHAR2(50),  -- e.g. TERM_TRD_EXP, TERM_TRD_IMP
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE DIR_FR_TRD_RN IS 'DBIE: DIR_FR_TRD_RN - Direction of Foreign Trade | External Sector:International Trade | Direction of Foreign Trade';
COMMENT ON COLUMN DIR_FR_TRD_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN DIR_FR_TRD_RN.COUNTRY IS 'DBIE dimension: Country';
COMMENT ON COLUMN DIR_FR_TRD_RN.TRADE_TYPE IS 'DBIE dimension: Type of Trade';
COMMENT ON COLUMN DIR_FR_TRD_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN DIR_FR_TRD_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN DIR_FR_TRD_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN DIR_FR_TRD_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: EARN_RAT_BSE_RN
-- DBIE Dataset: Earning Ratio of BSE
-- Sector: Financial Markets:Equity and Corporate Debt Market
-- Frequency: Monthly
-- Handbook Tables: Table 243
-- ================================================================

CREATE TABLE EARN_RAT_BSE_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. AVG
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE EARN_RAT_BSE_RN IS 'DBIE: EARN_RAT_BSE_RN - Earning Ratio of BSE | Financial Markets:Equity and Corporate Debt Market | Earning Ratio of BSE';
COMMENT ON COLUMN EARN_RAT_BSE_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN EARN_RAT_BSE_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN EARN_RAT_BSE_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN EARN_RAT_BSE_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN EARN_RAT_BSE_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN EARN_RAT_BSE_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: EXP_PRIN_COMM_RN
-- DBIE Dataset: Export of Principal commodities
-- Sector: External Sector:International Trade
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 118, Table 119
-- ================================================================

CREATE TABLE EXP_PRIN_COMM_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    COMMODITY_TYPE                   VARCHAR2(50),  -- e.g. N_TTL_EXP, N_EPC_CARPET, N_EPC_CHW, N_EPC_CERMIC_PRDCS_GLSWRE, N_EPC_CELS_PREPS_MISS_PROC_ITMS
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE EXP_PRIN_COMM_RN IS 'DBIE: EXP_PRIN_COMM_RN - Export of Principal commodities | External Sector:International Trade | Export of Principal commodities';
COMMENT ON COLUMN EXP_PRIN_COMM_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN EXP_PRIN_COMM_RN.COMMODITY_TYPE IS 'DBIE dimension: Types of Commodity';
COMMENT ON COLUMN EXP_PRIN_COMM_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN EXP_PRIN_COMM_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN EXP_PRIN_COMM_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN EXP_PRIN_COMM_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: EXP_SEL_PRIN_COMM_RN
-- DBIE Dataset: Exports of Select Commodities to Principal Countries
-- Sector: External Sector:International Trade
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 116, Table 117, Table 120, Table 121, Table 125
-- ================================================================

CREATE TABLE EXP_SEL_PRIN_COMM_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    COMMODITY_TYPE                   VARCHAR2(50),  -- e.g. EPC_CARPET, EPC_CASHEW, EPC_CASH_NUT_SHL_LIQ, EPC_CHEM, EPC_CFF
    COUNTRY                          VARCHAR2(50),  -- e.g. AU, BD, BE, BR, CA
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE EXP_SEL_PRIN_COMM_RN IS 'DBIE: EXP_SEL_PRIN_COMM_RN - Exports of Select Commodities to Principal Countries | External Sector:International Trade | Exports of Select Commodities to Principal Countries';
COMMENT ON COLUMN EXP_SEL_PRIN_COMM_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN EXP_SEL_PRIN_COMM_RN.COMMODITY_TYPE IS 'DBIE dimension: Types of Commodity';
COMMENT ON COLUMN EXP_SEL_PRIN_COMM_RN.COUNTRY IS 'DBIE dimension: Country';
COMMENT ON COLUMN EXP_SEL_PRIN_COMM_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN EXP_SEL_PRIN_COMM_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN EXP_SEL_PRIN_COMM_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN EXP_SEL_PRIN_COMM_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: EXTR_ASSIST_RN
-- DBIE Dataset: External assistance
-- Sector: External Sector:International Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 141
-- ================================================================

CREATE TABLE EXTR_ASSIST_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    EXTERNAL_ASSIST_CATEGORY         VARCHAR2(50),  -- e.g. TTL_AUTH, GRNT, LN, DSP_TTL, AMORT
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE EXTR_ASSIST_RN IS 'DBIE: EXTR_ASSIST_RN - External assistance | External Sector:International Finance | External assistance';
COMMENT ON COLUMN EXTR_ASSIST_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN EXTR_ASSIST_RN.EXTERNAL_ASSIST_CATEGORY IS 'DBIE dimension: Category of External assistance';
COMMENT ON COLUMN EXTR_ASSIST_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN EXTR_ASSIST_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN EXTR_ASSIST_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN EXTR_ASSIST_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FICG_GDP_RN
-- DBIE Dataset: Fiscal Indicators of the Central Government as per centage to GDP
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 236
-- ================================================================

CREATE TABLE FICG_GDP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INDICATOR_GDP                    VARCHAR2(50),  -- e.g. IN1202, IN12021, IN11, IN13, IN07
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FICG_GDP_RN IS 'DBIE: FICG_GDP_RN - Fiscal Indicators of the Central Government as per centage to GDP | Public Finance:Central Govt Finance | Fiscal Indicators of the Central Government as per centage to GDP';
COMMENT ON COLUMN FICG_GDP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FICG_GDP_RN.INDICATOR_GDP IS 'DBIE dimension: Indicators (As percentage to GDP)';
COMMENT ON COLUMN FICG_GDP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FICG_GDP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FICG_GDP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FICG_GDP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FIN_RATIOS_IND_RN
-- DBIE Dataset: Financial Ratios- Industry group-wise
-- Sector: Corporate Sector:Finances of FDI Companies
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 153
-- ================================================================

CREATE TABLE FIN_RATIOS_IND_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INDUSTRY_CLASSIFICATION          VARCHAR2(50),  -- e.g. ICC_ALL_INDS, ICC_MANF, ICC_MFG, ICC_CHE_PRDS_PHAR_MED_BOT_PRDS, ICC_MFG_CHEM_CD
    REFERENCE_TIME                   VARCHAR2(50),  -- e.g. CURR_YR, PREV_TO_PREV, PREV_YR
    FIN_RATIO_TYPE                   VARCHAR2(50),  -- e.g. AUTR, AUTR_EXP_SAL, AUTR_GVA_GFA, AUTR_INV_SAL, AUTR_SAL_GFA
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FIN_RATIOS_IND_RN IS 'DBIE: FIN_RATIOS_IND_RN - Financial Ratios- Industry group-wise | Corporate Sector:Finances of FDI Companies | Financial Ratios- Industry group-wise';
COMMENT ON COLUMN FIN_RATIOS_IND_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FIN_RATIOS_IND_RN.INDUSTRY_CLASSIFICATION IS 'DBIE dimension: Industry Wise classification';
COMMENT ON COLUMN FIN_RATIOS_IND_RN.REFERENCE_TIME IS 'DBIE dimension: Reference Time';
COMMENT ON COLUMN FIN_RATIOS_IND_RN.FIN_RATIO_TYPE IS 'DBIE dimension: Types of Financial Ratios';
COMMENT ON COLUMN FIN_RATIOS_IND_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FIN_RATIOS_IND_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FIN_RATIOS_IND_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FIN_RATIOS_IND_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FIN_RATIOS_RN
-- DBIE Dataset: Financial Ratios
-- Sector: Corporate Sector:Finances of FDI Companies
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 232
-- ================================================================

CREATE TABLE FIN_RATIOS_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    REFERENCE_TIME                   VARCHAR2(50),  -- e.g. CURR_YR, PREV_TO_PREV, PREV_YR
    FIN_RATIO_TYPE                   VARCHAR2(50),  -- e.g. AUTR, AUTR_EXP_SAL, AUTR_GVA_GFA, AUTR_INV_SAL, AUTR_SAL_GFA
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FIN_RATIOS_RN IS 'DBIE: FIN_RATIOS_RN - Financial Ratios | Corporate Sector:Finances of FDI Companies | Financial Ratios';
COMMENT ON COLUMN FIN_RATIOS_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FIN_RATIOS_RN.REFERENCE_TIME IS 'DBIE dimension: Reference Time';
COMMENT ON COLUMN FIN_RATIOS_RN.FIN_RATIO_TYPE IS 'DBIE dimension: Types of Financial Ratios';
COMMENT ON COLUMN FIN_RATIOS_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FIN_RATIOS_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FIN_RATIOS_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FIN_RATIOS_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FISG_GDP_RN
-- DBIE Dataset: Fiscal Indicators of the State Government as per centage to GDP
-- Sector: Public Finance:State Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 237
-- ================================================================

CREATE TABLE FISG_GDP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INDICATOR_GDP                    VARCHAR2(50),  -- e.g. IND6, IND8, IND5, IND2, IND3
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FISG_GDP_RN IS 'DBIE: FISG_GDP_RN - Fiscal Indicators of the State Government as per centage to GDP | Public Finance:State Govt Finance | Fiscal Indicators of the State Government as per centage to GDP';
COMMENT ON COLUMN FISG_GDP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FISG_GDP_RN.INDICATOR_GDP IS 'DBIE dimension: Indicators (As percentage to GDP)';
COMMENT ON COLUMN FISG_GDP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FISG_GDP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FISG_GDP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FISG_GDP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FOREXRT_AVG_RN
-- DBIE Dataset: FOREIGN EXCHANGE RATE AVERAGE
-- Sector: Financial Markets:Forex Market
-- Frequency: Monthly
-- Handbook Tables: Table 38, Table 163
-- ================================================================

CREATE TABLE FOREXRT_AVG_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    CURRENCY                         VARCHAR2(50),  -- e.g. EUR, JPY, GBP, SDR, USD
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. AVG, MON_END
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FOREXRT_AVG_RN IS 'DBIE: FOREXRT_AVG_RN - FOREIGN EXCHANGE RATE AVERAGE | Financial Markets:Forex Market | FOREIGN EXCHANGE RATE AVERAGE';
COMMENT ON COLUMN FOREXRT_AVG_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FOREXRT_AVG_RN.CURRENCY IS 'DBIE dimension: Currency';
COMMENT ON COLUMN FOREXRT_AVG_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN FOREXRT_AVG_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FOREXRT_AVG_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FOREXRT_AVG_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FOREXRT_AVG_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FOREXRT_HL_RN
-- DBIE Dataset: FOREIGN EXCHANGE RATE HIGH LOW
-- Sector: Financial Markets:Forex Market
-- Frequency: Monthly
-- Handbook Tables: Table 205
-- ================================================================

CREATE TABLE FOREXRT_HL_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    CURRENCY                         VARCHAR2(50),  -- e.g. EUR, JPY, GBP, SDR, USD
    RATE_RANGE                       VARCHAR2(50),  -- e.g. HIGH, LOW
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FOREXRT_HL_RN IS 'DBIE: FOREXRT_HL_RN - FOREIGN EXCHANGE RATE HIGH LOW | Financial Markets:Forex Market | FOREIGN EXCHANGE RATE HIGH LOW';
COMMENT ON COLUMN FOREXRT_HL_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FOREXRT_HL_RN.CURRENCY IS 'DBIE dimension: Currency';
COMMENT ON COLUMN FOREXRT_HL_RN.RATE_RANGE IS 'DBIE dimension: Range of Rates';
COMMENT ON COLUMN FOREXRT_HL_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FOREXRT_HL_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FOREXRT_HL_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FOREXRT_HL_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FOREX_RATE_AFY_RN
-- DBIE Dataset: Exchange rate of indian rupees
-- Sector: Financial Markets:Forex Market
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 135, Table 136, Table 137, Table 138, Table 139, Table 140
-- ================================================================

CREATE TABLE FOREX_RATE_AFY_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    CURRENCY                         VARCHAR2(50),  -- e.g. EUR, JPY, GBP, SDR, USD
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. AVG, YR_END
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FOREX_RATE_AFY_RN IS 'DBIE: FOREX_RATE_AFY_RN - Exchange rate of indian rupees | Financial Markets:Forex Market | Exchange rate of indian rupees';
COMMENT ON COLUMN FOREX_RATE_AFY_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FOREX_RATE_AFY_RN.CURRENCY IS 'DBIE dimension: Currency';
COMMENT ON COLUMN FOREX_RATE_AFY_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN FOREX_RATE_AFY_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FOREX_RATE_AFY_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FOREX_RATE_AFY_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FOREX_RATE_AFY_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FOREX_RATE_D_RN
-- DBIE Dataset: EXCHANGE RATE OF THE INDIAN RUPEE DAILY
-- Sector: Financial Markets:Forex Market
-- Frequency: Daily
-- Handbook Tables: Table 222
-- ================================================================

CREATE TABLE FOREX_RATE_D_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    CURRENCY                         VARCHAR2(50),  -- e.g. EUR, JPY, GBP, USD
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FOREX_RATE_D_RN IS 'DBIE: FOREX_RATE_D_RN - EXCHANGE RATE OF THE INDIAN RUPEE DAILY | Financial Markets:Forex Market | EXCHANGE RATE OF THE INDIAN RUPEE DAILY';
COMMENT ON COLUMN FOREX_RATE_D_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FOREX_RATE_D_RN.CURRENCY IS 'DBIE dimension: Currency';
COMMENT ON COLUMN FOREX_RATE_D_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FOREX_RATE_D_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FOREX_RATE_D_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FOREX_RATE_D_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FOREX_RATE_RN
-- DBIE Dataset: EXCHANGE RATE OF THE INDIAN RUPEE
-- Sector: Financial Markets:Forex Market
-- Frequency: Monthly
-- Handbook Tables: Table 204, Table 206
-- ================================================================

CREATE TABLE FOREX_RATE_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    CURRENCY                         VARCHAR2(50),  -- e.g. EUR, JPY, GBP, USD
    RATE_RANGE                       VARCHAR2(50),  -- e.g. BID_HIGH, BID_LOW, OFR_HIGH, OFR_LOW
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FOREX_RATE_RN IS 'DBIE: FOREX_RATE_RN - EXCHANGE RATE OF THE INDIAN RUPEE | Financial Markets:Forex Market | EXCHANGE RATE OF THE INDIAN RUPEE';
COMMENT ON COLUMN FOREX_RATE_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FOREX_RATE_RN.CURRENCY IS 'DBIE dimension: Currency';
COMMENT ON COLUMN FOREX_RATE_RN.RATE_RANGE IS 'DBIE dimension: Range of Rates';
COMMENT ON COLUMN FOREX_RATE_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FOREX_RATE_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FOREX_RATE_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FOREX_RATE_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FR_EXG_RESV_RN
-- DBIE Dataset: Foreign Exchange Reserves
-- Sector: External Sector:Forex Reserve
-- Frequency: Weekly
-- Handbook Tables: Table 147, Table 207, Table 209, Table 210, Table 214
-- ================================================================

CREATE TABLE FR_EXG_RESV_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    FOREX_RESERVE_COMPONENT          VARCHAR2(50),  -- e.g. FER_TTL, FER_FR_CURR_ASS, FER_GLD, FER_RES_TRN_POS, FER_SDR
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FR_EXG_RESV_RN IS 'DBIE: FR_EXG_RESV_RN - Foreign Exchange Reserves | External Sector:Forex Reserve | Foreign Exchange Reserves';
COMMENT ON COLUMN FR_EXG_RESV_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FR_EXG_RESV_RN.FOREX_RESERVE_COMPONENT IS 'DBIE dimension: Components of Forex Reserve';
COMMENT ON COLUMN FR_EXG_RESV_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FR_EXG_RESV_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FR_EXG_RESV_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FR_EXG_RESV_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FR_INV_INFLW_RN
-- DBIE Dataset: Foreign Investment Inflows
-- Sector: External Sector:International Finance
-- Frequency: Monthly
-- Handbook Tables: Table 146
-- ================================================================

CREATE TABLE FR_INV_INFLW_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INVESTMENT_CATEGORY_OLD          VARCHAR2(50),  -- e.g. INV_FII, INV_CAT_DI_IND, INV_EQT, EQT_ACQ_SHAR, EQT_CAP_UNINC_BOD
    INVESTMENT_CATEGORY              VARCHAR2(50),  -- e.g. INV_FII, INV_CAT_NET_FR_DIR_INV, INV_CAT_NFDI_DI_IND, INV_CAT_NFDI_DII_GROSS_INF_INV, INV_EQT
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FR_INV_INFLW_RN IS 'DBIE: FR_INV_INFLW_RN - Foreign Investment Inflows | External Sector:International Finance | Foreign Investment Inflows';
COMMENT ON COLUMN FR_INV_INFLW_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FR_INV_INFLW_RN.INVESTMENT_CATEGORY_OLD IS 'DBIE dimension: Investment Category(Old Items - Inflows)';
COMMENT ON COLUMN FR_INV_INFLW_RN.INVESTMENT_CATEGORY IS 'DBIE dimension: Investment Category(Inflows)';
COMMENT ON COLUMN FR_INV_INFLW_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FR_INV_INFLW_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FR_INV_INFLW_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FR_INV_INFLW_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FR_LIB_ASSTS_MUT_RN
-- DBIE Dataset: Foreign Liabilities and Assets for Mutual Fund and Assets Management Companies
-- Sector: External Sector:International Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 71, Table 75, Table 76, Table 77, Table 82, Table 83, Table 85, Table 86, Table 87
-- ================================================================

CREATE TABLE FR_LIB_ASSTS_MUT_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    LIA_ASSET_TYPE                   VARCHAR2(50),  -- e.g. FLA_FR_ASS, FLA_FR_ASS_DS, FLA_FR_ASS_ES, FLA_FR_LIB, FLA_OTH_FR_ASS
    ENTITY_TYPE                      VARCHAR2(50),  -- e.g. ASST_MGMT_COMP, MTL_FND_COMP
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FR_LIB_ASSTS_MUT_RN IS 'DBIE: FR_LIB_ASSTS_MUT_RN - Foreign Liabilities and Assets for Mutual Fund and Assets Management Companies | External Sector:International Finance | Foreign Liabilities and Assets for Mutual Fund and Assets Management Companies';
COMMENT ON COLUMN FR_LIB_ASSTS_MUT_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FR_LIB_ASSTS_MUT_RN.LIA_ASSET_TYPE IS 'DBIE dimension: Liabilities and Assets';
COMMENT ON COLUMN FR_LIB_ASSTS_MUT_RN.ENTITY_TYPE IS 'DBIE dimension: Entity Type';
COMMENT ON COLUMN FR_LIB_ASSTS_MUT_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FR_LIB_ASSTS_MUT_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FR_LIB_ASSTS_MUT_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FR_LIB_ASSTS_MUT_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FR_LIB_MUT_NRH_RN
-- DBIE Dataset: Foreign Liabilities for Mutual Fund-Non Resident Holding
-- Sector: External Sector:International Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 144, Table 145
-- ================================================================

CREATE TABLE FR_LIB_MUT_NRH_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    LIA_ASSET_TYPE                   VARCHAR2(50),  -- e.g. FLA_FR_LIB
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. FAC_VAL, MRKT_VAL, FLA_OTH_FR_LIB
    ENTITY_TYPE                      VARCHAR2(50),  -- e.g. MTL_FND_COMP
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FR_LIB_MUT_NRH_RN IS 'DBIE: FR_LIB_MUT_NRH_RN - Foreign Liabilities for Mutual Fund-Non Resident Holding | External Sector:International Finance | Foreign Liabilities for Mutual Fund-Non Resident Holding';
COMMENT ON COLUMN FR_LIB_MUT_NRH_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FR_LIB_MUT_NRH_RN.LIA_ASSET_TYPE IS 'DBIE dimension: Liabilities and Assets';
COMMENT ON COLUMN FR_LIB_MUT_NRH_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN FR_LIB_MUT_NRH_RN.ENTITY_TYPE IS 'DBIE dimension: Entity Type';
COMMENT ON COLUMN FR_LIB_MUT_NRH_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FR_LIB_MUT_NRH_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FR_LIB_MUT_NRH_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FR_LIB_MUT_NRH_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: FW_PRE_RN
-- DBIE Dataset: FORWARD PREMIA (INTER-BANK)
-- Sector: Financial Markets:Forex Market
-- Frequency: Monthly
-- Handbook Tables: Table 73, Table 208, Table 223
-- ================================================================

CREATE TABLE FW_PRE_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MONTHLY_AVG_TYPE                 VARCHAR2(50),  -- e.g. 1_MON, 3_MON, 6_MON
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE FW_PRE_RN IS 'DBIE: FW_PRE_RN - FORWARD PREMIA (INTER-BANK) | Financial Markets:Forex Market | FORWARD PREMIA (INTER-BANK)';
COMMENT ON COLUMN FW_PRE_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN FW_PRE_RN.MONTHLY_AVG_TYPE IS 'DBIE dimension: Monthly Average';
COMMENT ON COLUMN FW_PRE_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN FW_PRE_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN FW_PRE_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN FW_PRE_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: GOVT_LIAB_RN
-- DBIE Dataset: Combined Central and State Government Liabilities
-- Sector: Public Finance:Cental & State Govt Finance(Combined)
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 108, Table 109
-- ================================================================

CREATE TABLE GOVT_LIAB_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    LIABILITY_TYPE                   VARCHAR2(50),  -- e.g. LT3, LT4, LT1, LT11, LT12
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE GOVT_LIAB_RN IS 'DBIE: GOVT_LIAB_RN - Combined Central and State Government Liabilities | Public Finance:Cental & State Govt Finance(Combined) | Combined Central and State Government Liabilities';
COMMENT ON COLUMN GOVT_LIAB_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN GOVT_LIAB_RN.LIABILITY_TYPE IS 'DBIE dimension: Liability Type';
COMMENT ON COLUMN GOVT_LIAB_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN GOVT_LIAB_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN GOVT_LIAB_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN GOVT_LIAB_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: GOV_TR_BILL_OUTSD_RN
-- DBIE Dataset: Govt of India Treasury Bills Outstanding
-- Sector: Financial Markets:Government Securities Market
-- Frequency: Weekly
-- Handbook Tables: Table 217, Table 218, Table 219
-- ================================================================

CREATE TABLE GOV_TR_BILL_OUTSD_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    HOLDER_TYPE                      VARCHAR2(50),  -- e.g. BANKS, OTHER, PRIMARY_DEALERS, STATE_GOVT
    INSTRUMENT_TYPE                  VARCHAR2(50),  -- e.g. 182_DAY, 364_DAY, 91_DAY, CMB
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE GOV_TR_BILL_OUTSD_RN IS 'DBIE: GOV_TR_BILL_OUTSD_RN - Govt of India Treasury Bills Outstanding | Financial Markets:Government Securities Market | Govt of India Treasury Bills Outstanding';
COMMENT ON COLUMN GOV_TR_BILL_OUTSD_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN GOV_TR_BILL_OUTSD_RN.HOLDER_TYPE IS 'DBIE dimension: Holder Type Description';
COMMENT ON COLUMN GOV_TR_BILL_OUTSD_RN.INSTRUMENT_TYPE IS 'DBIE dimension: Instrument Type';
COMMENT ON COLUMN GOV_TR_BILL_OUTSD_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN GOV_TR_BILL_OUTSD_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN GOV_TR_BILL_OUTSD_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN GOV_TR_BILL_OUTSD_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: GROSS_NET_CAP_FRM_RN
-- DBIE Dataset: Gross Net Capital Formation
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 53, Table 95, Table 180
-- ================================================================

CREATE TABLE GROSS_NET_CAP_FRM_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_2004_05, BY_2011_12
    CAPITAL_FORMATION_CATEGORY       VARCHAR2(50),  -- e.g. GNCF_CHG_STOCKS, GNCF_GCF, GNCF_GDCF, GNCF_GFCF, GNCF_NCF
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CNST_PRC, CURR_PRC
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE GROSS_NET_CAP_FRM_RN IS 'DBIE: GROSS_NET_CAP_FRM_RN - Gross Net Capital Formation | Real Sector:National Income | Gross Net Capital Formation';
COMMENT ON COLUMN GROSS_NET_CAP_FRM_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN GROSS_NET_CAP_FRM_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN GROSS_NET_CAP_FRM_RN.CAPITAL_FORMATION_CATEGORY IS 'DBIE dimension: Categories of Gross Net Capital Formation';
COMMENT ON COLUMN GROSS_NET_CAP_FRM_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN GROSS_NET_CAP_FRM_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN GROSS_NET_CAP_FRM_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN GROSS_NET_CAP_FRM_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN GROSS_NET_CAP_FRM_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: GROSS_STATE_DOM_PRD_RN
-- DBIE Dataset: Gross State Domestic Product
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 4
-- ================================================================

CREATE TABLE GROSS_STATE_DOM_PRD_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1999_2000, BY_2004_05, BY_2011_12
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CNST_PRC, CURR_PRC
    STATE                            VARCHAR2(50),  -- e.g. ALL_INDIA, ALLS, CR, CHHT, MP
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE GROSS_STATE_DOM_PRD_RN IS 'DBIE: GROSS_STATE_DOM_PRD_RN - Gross State Domestic Product | Real Sector:National Income | Gross State Domestic Product';
COMMENT ON COLUMN GROSS_STATE_DOM_PRD_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN GROSS_STATE_DOM_PRD_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN GROSS_STATE_DOM_PRD_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN GROSS_STATE_DOM_PRD_RN.STATE IS 'DBIE dimension: State';
COMMENT ON COLUMN GROSS_STATE_DOM_PRD_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN GROSS_STATE_DOM_PRD_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN GROSS_STATE_DOM_PRD_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN GROSS_STATE_DOM_PRD_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: GSEC_TO_RN
-- DBIE Dataset: Turnover In Government Securities Market
-- Sector: Financial Markets:Government Securities Market
-- Frequency: Weekly
-- Handbook Tables: Table 187, Table 216
-- ================================================================

CREATE TABLE GSEC_TO_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    AVG_TURNOVER                     VARCHAR2(50),  -- e.g. OUTR_TRANSC, OR_GOVT_SEC, OR_STATE_GOVT_SEC, RBI, TR_BILL
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE GSEC_TO_RN IS 'DBIE: GSEC_TO_RN - Turnover In Government Securities Market | Financial Markets:Government Securities Market | Turnover In Government Securities Market';
COMMENT ON COLUMN GSEC_TO_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN GSEC_TO_RN.AVG_TURNOVER IS 'DBIE dimension: Daily Average Turnover';
COMMENT ON COLUMN GSEC_TO_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN GSEC_TO_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN GSEC_TO_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN GSEC_TO_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: GWT_RT_NGNBFI_AW_RN
-- DBIE Dataset: Growth Rate Indicators for Non-Government Non-Banking Financial and Investment (NGNBF&I) Companies - Activity wise
-- Sector: Corporate Sector:Non-Government Non-Banking Financial and Investment Companies
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 56
-- ================================================================

CREATE TABLE GWT_RT_NGNBFI_AW_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    ACTIVITY_CATEGORY                VARCHAR2(50),  -- e.g. AC_ALL_ACT, AC_AST_FIN, AC_DIV, AC_LN_FIN, AC_MISC
    ITEMS                            VARCHAR2(50),  -- e.g. GRP_BORRW, GRP_BORRW_BNKS, GRP_DEP_PROV, GRP_DIV_PAID, GRP_FI_DIV_RCV
    REFERENCE_TIME                   VARCHAR2(50),  -- e.g. CURR_FIN_YR, PREV_FIN_YR
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE GWT_RT_NGNBFI_AW_RN IS 'DBIE: GWT_RT_NGNBFI_AW_RN - Growth Rate Indicators for Non-Government Non-Banking Financial and Investment (NGNBF&I) Companies - Activity wise | Corporate Sector:Non-Government Non-Banking Financial and Investment Companies | Growth Rate Indicators for Non-Government Non-Banking Financial and Investment (NGNBF&I) Companies - Activity wise';
COMMENT ON COLUMN GWT_RT_NGNBFI_AW_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN GWT_RT_NGNBFI_AW_RN.ACTIVITY_CATEGORY IS 'DBIE dimension: Activity wise Category';
COMMENT ON COLUMN GWT_RT_NGNBFI_AW_RN.ITEMS_2 IS 'DBIE dimension: Items';
COMMENT ON COLUMN GWT_RT_NGNBFI_AW_RN.REFERENCE_TIME IS 'DBIE dimension: Reference Time';
COMMENT ON COLUMN GWT_RT_NGNBFI_AW_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN GWT_RT_NGNBFI_AW_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN GWT_RT_NGNBFI_AW_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN GWT_RT_NGNBFI_AW_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: IFT_OIL_NON_OIL_RN
-- DBIE Dataset: India's Foreign Trade - Oil & Non-Oil
-- Sector: External Sector:International Trade
-- Frequency: Monthly
-- Handbook Tables: Table 15, Table 192, Table 193
-- ================================================================

CREATE TABLE IFT_OIL_NON_OIL_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    TRADE_COMMODITY                  VARCHAR2(50),  -- e.g. TERM_TRD_EXP, TERM_TRD_IMP, TERM_TTL_TRD_BAL
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE IFT_OIL_NON_OIL_RN IS 'DBIE: IFT_OIL_NON_OIL_RN - India''s Foreign Trade - Oil & Non-Oil | External Sector:International Trade | India''s Foreign Trade - Oil & Non-Oil';
COMMENT ON COLUMN IFT_OIL_NON_OIL_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN IFT_OIL_NON_OIL_RN.TRADE_COMMODITY IS 'DBIE dimension: Foreign Trade Commodities';
COMMENT ON COLUMN IFT_OIL_NON_OIL_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN IFT_OIL_NON_OIL_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN IFT_OIL_NON_OIL_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN IFT_OIL_NON_OIL_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: IIP_MANF_SEC_ANN_RN
-- DBIE Dataset: Indian Industrial Production Manufacturing Sector Anually
-- Sector: Real Sector:Industrial Statistics
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 28, Table 158, Table 159
-- ================================================================

CREATE TABLE IIP_MANF_SEC_ANN_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1980_81, BY_1993_94, BY_2004_05, BY_2011_12
    IP_CLASSIFICATION                VARCHAR2(50),  -- e.g. USE_BAS_GDS, USE_CAP_GDS, USE_CONS_DUR, USE_CONS_GDS, USE_CONS_NON_DUR
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE IIP_MANF_SEC_ANN_RN IS 'DBIE: IIP_MANF_SEC_ANN_RN - Indian Industrial Production Manufacturing Sector Anually | Real Sector:Industrial Statistics | Indian Industrial Production Manufacturing Sector Anually';
COMMENT ON COLUMN IIP_MANF_SEC_ANN_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN IIP_MANF_SEC_ANN_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN IIP_MANF_SEC_ANN_RN.IP_CLASSIFICATION IS 'DBIE dimension: Industrial Production Classification';
COMMENT ON COLUMN IIP_MANF_SEC_ANN_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN IIP_MANF_SEC_ANN_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN IIP_MANF_SEC_ANN_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN IIP_MANF_SEC_ANN_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: IMPT_PETRL_PRD_RN
-- DBIE Dataset: Imports of Petroleum Products
-- Sector: Real Sector:Industrial Statistics
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 33
-- ================================================================

CREATE TABLE IMPT_PETRL_PRD_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    PETROLEUM_PRODUCT_TYPE           VARCHAR2(50),  -- e.g. PETR_CRD_OIL, PETR_OIL_LUB
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE IMPT_PETRL_PRD_RN IS 'DBIE: IMPT_PETRL_PRD_RN - Imports of Petroleum Products | Real Sector:Industrial Statistics | Imports of Petroleum Products';
COMMENT ON COLUMN IMPT_PETRL_PRD_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN IMPT_PETRL_PRD_RN.PETROLEUM_PRODUCT_TYPE IS 'DBIE dimension: Types of Petroleum Products';
COMMENT ON COLUMN IMPT_PETRL_PRD_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN IMPT_PETRL_PRD_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN IMPT_PETRL_PRD_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN IMPT_PETRL_PRD_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: IND_EXTRN_DEBT_RN
-- DBIE Dataset: India's External Debt
-- Sector: External Sector:External Debt
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 148, Table 149
-- ================================================================

CREATE TABLE IND_EXTRN_DEBT_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    DEBT_INDICATOR                   VARCHAR2(50),  -- e.g. CON_DBT_AS_PER_TTL_DBT, DBT_SERV_RATIO, DBT_STK_GDP, N_A, STD_AS_PER_TTL_DBT
    EXTERNAL_DEBT_TYPE               VARCHAR2(50),  -- e.g. GROSS_TTL_DBT, LTD_MULT, LTD_BILT, LB_GOVT_BORW, BI_GB_CONCESSION
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE IND_EXTRN_DEBT_RN IS 'DBIE: IND_EXTRN_DEBT_RN - India''s External Debt | External Sector:External Debt | India''s External Debt';
COMMENT ON COLUMN IND_EXTRN_DEBT_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN IND_EXTRN_DEBT_RN.DEBT_INDICATOR IS 'DBIE dimension: External Debt Indicator';
COMMENT ON COLUMN IND_EXTRN_DEBT_RN.EXTERNAL_DEBT_TYPE IS 'DBIE dimension: Type of External Debt';
COMMENT ON COLUMN IND_EXTRN_DEBT_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN IND_EXTRN_DEBT_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN IND_EXTRN_DEBT_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN IND_EXTRN_DEBT_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: IND_OVR_BOP_RN
-- DBIE Dataset: India's Overall Balance of Payments
-- Sector: External Sector:International Trade
-- Frequency: Quarterly - Financial Year
-- Handbook Tables: Table 127, Table 128, Table 194, Table 195, Table 196, Table 197
-- ================================================================

CREATE TABLE IND_OVR_BOP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BOP_CATEGORY                     VARCHAR2(50),  -- e.g. MON_MOV, MV_FER, MV_IMF, OVR_BAL, CAP_ACC
    TRANSACTION_TYPE                 VARCHAR2(50),  -- e.g. TRANC_CRD, TRANC_DEB, TRANC_NET
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE IND_OVR_BOP_RN IS 'DBIE: IND_OVR_BOP_RN - India''s Overall Balance of Payments | External Sector:International Trade | India''s Overall Balance of Payments';
COMMENT ON COLUMN IND_OVR_BOP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN IND_OVR_BOP_RN.BOP_CATEGORY IS 'DBIE dimension: Indias Overall Balance of Payments Categories';
COMMENT ON COLUMN IND_OVR_BOP_RN.TRANSACTION_TYPE IS 'DBIE dimension: Transaction Type';
COMMENT ON COLUMN IND_OVR_BOP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN IND_OVR_BOP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN IND_OVR_BOP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN IND_OVR_BOP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: INTR_INV_POS_IND_BPM6_RN
-- DBIE Dataset: International Investment Position of India BPM6
-- Sector: External Sector:International Finance
-- Frequency: Quarterly - Financial Year
-- Handbook Tables: Table 202, Table 203
-- ================================================================

CREATE TABLE INTR_INV_POS_IND_BPM6_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INVESTMENT_TYPE                  VARCHAR2(50),  -- e.g. IIA_NET_IIP, IIP_AST, IIA_DI, IIA_DI_EIFS, IIA_DI_EIFS_BFE_CPU_IFSU
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE INTR_INV_POS_IND_BPM6_RN IS 'DBIE: INTR_INV_POS_IND_BPM6_RN - International Investment Position of India BPM6 | External Sector:International Finance | International Investment Position of India BPM6';
COMMENT ON COLUMN INTR_INV_POS_IND_BPM6_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN INTR_INV_POS_IND_BPM6_RN.INVESTMENT_TYPE IS 'DBIE dimension: International Investment Type';
COMMENT ON COLUMN INTR_INV_POS_IND_BPM6_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN INTR_INV_POS_IND_BPM6_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN INTR_INV_POS_IND_BPM6_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN INTR_INV_POS_IND_BPM6_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: INTR_INV_POS_IND_RN
-- DBIE Dataset: International Investment Position of India BPM5
-- Sector: External Sector:International Finance
-- Frequency: Quarterly - Financial Year
-- Handbook Tables: Table 198, Table 199, Table 200, Table 201
-- ================================================================

CREATE TABLE INTR_INV_POS_IND_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INVESTMENT_TYPE                  VARCHAR2(50),  -- e.g. IIA_NET_IIP, IIT_AST, IIA_DIR_INV_ABR, IIA_DIA_EQT_CAP_RE, IIA_DIA_ECRE_CAE
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE INTR_INV_POS_IND_RN IS 'DBIE: INTR_INV_POS_IND_RN - International Investment Position of India BPM5 | External Sector:International Finance | International Investment Position of India BPM5';
COMMENT ON COLUMN INTR_INV_POS_IND_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN INTR_INV_POS_IND_RN.INVESTMENT_TYPE IS 'DBIE dimension: International Investment Types';
COMMENT ON COLUMN INTR_INV_POS_IND_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN INTR_INV_POS_IND_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN INTR_INV_POS_IND_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN INTR_INV_POS_IND_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: INVI_CAT_TRANS_RN
-- DBIE Dataset: Invisibles By Category of Transactions
-- Sector: External Sector:International Trade
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 133, Table 134
-- ================================================================

CREATE TABLE INVI_CAT_TRANS_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INVISIBLES_CATEGORY              VARCHAR2(50),  -- e.g. IC_INCM, IC_INCM_PYMTS, IC_INCM_RCPTS, IC_INCM_COMP_EMPL, IC_INCM_COMP_EMPL_PYMTS
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE INVI_CAT_TRANS_RN IS 'DBIE: INVI_CAT_TRANS_RN - Invisibles By Category of Transactions | External Sector:International Trade | Invisibles By Category of Transactions';
COMMENT ON COLUMN INVI_CAT_TRANS_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN INVI_CAT_TRANS_RN.INVISIBLES_CATEGORY IS 'DBIE dimension: Invisibles Categories';
COMMENT ON COLUMN INVI_CAT_TRANS_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN INVI_CAT_TRANS_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN INVI_CAT_TRANS_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN INVI_CAT_TRANS_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: INX_CORE_INF_INDS_GWT_RN
-- DBIE Dataset: Index Numbers of Core/Infrastructure Industries - Growth Rates
-- Sector: Real Sector:Industrial Statistics
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 62, Table 227, Table 228, Table 229
-- ================================================================

CREATE TABLE INX_CORE_INF_INDS_GWT_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1993_94, BY_2004_05, BY_2011_12
    CORE_INDUSTRY_TYPE               VARCHAR2(50),  -- e.g. INF_CEMENT, INF_COAL, INF_COMP_INDX, INF_CRD_OIL, INF_ELECTY
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE INX_CORE_INF_INDS_GWT_RN IS 'DBIE: INX_CORE_INF_INDS_GWT_RN - Index Numbers of Core/Infrastructure Industries - Growth Rates | Real Sector:Industrial Statistics | Index Numbers of Core/Infrastructure Industries - Growth Rates';
COMMENT ON COLUMN INX_CORE_INF_INDS_GWT_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN INX_CORE_INF_INDS_GWT_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN INX_CORE_INF_INDS_GWT_RN.CORE_INDUSTRY_TYPE IS 'DBIE dimension: Types of Core/Infrastructure Industries';
COMMENT ON COLUMN INX_CORE_INF_INDS_GWT_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN INX_CORE_INF_INDS_GWT_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN INX_CORE_INF_INDS_GWT_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN INX_CORE_INF_INDS_GWT_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: INX_CORE_INF_INDS_RN
-- DBIE Dataset: Index Numbers of Core/Infrastructure Industries
-- Sector: Real Sector:Industrial Statistics
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 30
-- ================================================================

CREATE TABLE INX_CORE_INF_INDS_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1993_94, BY_2004_05, BY_2011_12
    CORE_INDUSTRY_TYPE               VARCHAR2(50),  -- e.g. INF_CEMENT, INF_COAL, INF_CRD_OIL, INF_CRD_PETR, INF_ELECTY
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE INX_CORE_INF_INDS_RN IS 'DBIE: INX_CORE_INF_INDS_RN - Index Numbers of Core/Infrastructure Industries | Real Sector:Industrial Statistics | Index Numbers of Core/Infrastructure Industries';
COMMENT ON COLUMN INX_CORE_INF_INDS_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN INX_CORE_INF_INDS_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN INX_CORE_INF_INDS_RN.CORE_INDUSTRY_TYPE IS 'DBIE dimension: Types of Core/Infrastructure Industries';
COMMENT ON COLUMN INX_CORE_INF_INDS_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN INX_CORE_INF_INDS_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN INX_CORE_INF_INDS_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN INX_CORE_INF_INDS_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: INX_INDS_PROD_RN
-- DBIE Dataset: Index of Industrial Production
-- Sector: Real Sector:Industrial Statistics
-- Frequency: Monthly
-- Handbook Tables: Table 27, Table 29, Table 160
-- ================================================================

CREATE TABLE INX_INDS_PROD_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1993_94, BY_2004_05, BY_2011_12
    IP_CLASSIFICATION                VARCHAR2(50),  -- e.g. SEC_BAS_CHEM_PROD, USE_BAS_GDS, SEC_BAS_MTL_ALLOY, SEC_BEV_TOB, USE_CAP_GDS
    IIP_TYPE                         VARCHAR2(50),  -- e.g. IIP_DETAILED, IIP_SEC_BASED, IIP_USE_BASED
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE INX_INDS_PROD_RN IS 'DBIE: INX_INDS_PROD_RN - Index of Industrial Production | Real Sector:Industrial Statistics | Index of Industrial Production';
COMMENT ON COLUMN INX_INDS_PROD_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN INX_INDS_PROD_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN INX_INDS_PROD_RN.IP_CLASSIFICATION IS 'DBIE dimension: Industrial Production Classification';
COMMENT ON COLUMN INX_INDS_PROD_RN.IIP_TYPE IS 'DBIE dimension: Index of Industrial Production Type';
COMMENT ON COLUMN INX_INDS_PROD_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN INX_INDS_PROD_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN INX_INDS_PROD_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN INX_INDS_PROD_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: INX_NBR_TERM_FR_TRD_RN
-- DBIE Dataset: General Index Numbers and Terms of Foreign Trade
-- Sector: External Sector:External Sector Indices
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 48, Table 124
-- ================================================================

CREATE TABLE INX_NBR_TERM_FR_TRD_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1978_79, BY_1999_2000, BY_2012_2013
    INDEX_TYPE                       VARCHAR2(50),  -- e.g. INDX_QUANT, EXP1, IMP2, TERM_TRD, TERM_TRD_GROSS
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE INX_NBR_TERM_FR_TRD_RN IS 'DBIE: INX_NBR_TERM_FR_TRD_RN - General Index Numbers and Terms of Foreign Trade | External Sector:External Sector Indices | General Index Numbers and Terms of Foreign Trade';
COMMENT ON COLUMN INX_NBR_TERM_FR_TRD_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN INX_NBR_TERM_FR_TRD_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN INX_NBR_TERM_FR_TRD_RN.INDEX_TYPE IS 'DBIE dimension: Types of Indexes';
COMMENT ON COLUMN INX_NBR_TERM_FR_TRD_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN INX_NBR_TERM_FR_TRD_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN INX_NBR_TERM_FR_TRD_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN INX_NBR_TERM_FR_TRD_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: INX_NEER_REER_A_RN
-- DBIE Dataset: Indices of REER/NEER Annually
-- Sector: External Sector:External Sector Indices
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 31
-- ================================================================

CREATE TABLE INX_NEER_REER_A_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_2004_05, BY_2015_16
    CURRENCY_BASKET                  VARCHAR2(50),  -- e.g. CURR_BASK_36CURR, CURR_BASK_40CURR
    RATE_TYPE                        VARCHAR2(50),  -- e.g. NEER, REER
    AVERAGE_TYPE                     VARCHAR2(50),  -- e.g. REP_CY_ANN_AVG, REP_FY_ANN_AVG
    TRADE_WEIGHT_TYPE                VARCHAR2(50),  -- e.g. EXP_WTS, TRD_WTS
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE INX_NEER_REER_A_RN IS 'DBIE: INX_NEER_REER_A_RN - Indices of REER/NEER Annually | External Sector:External Sector Indices | Indices of REER/NEER Annually';
COMMENT ON COLUMN INX_NEER_REER_A_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN INX_NEER_REER_A_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN INX_NEER_REER_A_RN.CURRENCY_BASKET IS 'DBIE dimension: Currency Basket';
COMMENT ON COLUMN INX_NEER_REER_A_RN.RATE_TYPE IS 'DBIE dimension: Type of Rate';
COMMENT ON COLUMN INX_NEER_REER_A_RN.AVERAGE_TYPE IS 'DBIE dimension: Type of Average';
COMMENT ON COLUMN INX_NEER_REER_A_RN.TRADE_WEIGHT_TYPE IS 'DBIE dimension: Type of Trade Weights';
COMMENT ON COLUMN INX_NEER_REER_A_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN INX_NEER_REER_A_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN INX_NEER_REER_A_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN INX_NEER_REER_A_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: KCI_BOP_RN
-- DBIE Dataset: Key components of India's Overall Balance of Payments
-- Sector: External Sector:International Trade
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 131, Table 132
-- ================================================================

CREATE TABLE KCI_BOP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BOP_COMPONENT                    VARCHAR2(50),  -- e.g. MON_MOV, NET_IMF, RESERVES, SDR_ALLC, OVR_BAL
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE KCI_BOP_RN IS 'DBIE: KCI_BOP_RN - Key components of India''s Overall Balance of Payments | External Sector:International Trade | Key components of India''s Overall Balance of Payments';
COMMENT ON COLUMN KCI_BOP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN KCI_BOP_RN.BOP_COMPONENT IS 'DBIE dimension: Components of Indias BOP';
COMMENT ON COLUMN KCI_BOP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN KCI_BOP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN KCI_BOP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN KCI_BOP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: LNA_SCB_SR_OCC_BSR1_A_RN
-- DBIE Dataset: Loans and Advances of SCBs State and Occupation wise BSR1 Annual
-- Sector: Financial Sector
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 58
-- ================================================================

CREATE TABLE LNA_SCB_SR_OCC_BSR1_A_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. AMT_OUTSD, CRLIM
    OCCUPATION_GROUP                 VARCHAR2(50),  -- e.g. T, 1
    STATE                            VARCHAR2(50),  -- e.g. ALL_INDIA, ALLS, CR, CHHT, MP
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE LNA_SCB_SR_OCC_BSR1_A_RN IS 'DBIE: LNA_SCB_SR_OCC_BSR1_A_RN - Loans and Advances of SCBs State and Occupation wise BSR1 Annual | Financial Sector | Loans and Advances of SCBs State and Occupation wise BSR1 Annual';
COMMENT ON COLUMN LNA_SCB_SR_OCC_BSR1_A_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN LNA_SCB_SR_OCC_BSR1_A_RN.MEASURE_TYPE IS 'DBIE dimension: Measure Type';
COMMENT ON COLUMN LNA_SCB_SR_OCC_BSR1_A_RN.OCCUPATION_GROUP IS 'DBIE dimension: Occupation Group';
COMMENT ON COLUMN LNA_SCB_SR_OCC_BSR1_A_RN.STATE IS 'DBIE dimension: State';
COMMENT ON COLUMN LNA_SCB_SR_OCC_BSR1_A_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN LNA_SCB_SR_OCC_BSR1_A_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN LNA_SCB_SR_OCC_BSR1_A_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN LNA_SCB_SR_OCC_BSR1_A_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MACRO_ECN_AGG_RN
-- DBIE Dataset: Macro Economic Aggregates
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 1, Table 2
-- ================================================================

CREATE TABLE MACRO_ECN_AGG_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1999_2000, BY_2004_05, BY_2011_12
    INDICATOR_TYPE                   VARCHAR2(50),  -- e.g. NII_CONS_FX_CAP, NII_GROSS_DOM_CAP_FRM, NII_GDP_FACT_CST, NII_GDP_MARK_CST, NII_GDP_PUB_SEC
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CNST_PRC, CURR_PRC
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MACRO_ECN_AGG_RN IS 'DBIE: MACRO_ECN_AGG_RN - Macro Economic Aggregates | Real Sector:National Income | Macro Economic Aggregates';
COMMENT ON COLUMN MACRO_ECN_AGG_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MACRO_ECN_AGG_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN MACRO_ECN_AGG_RN.INDICATOR_TYPE IS 'DBIE dimension: National Income Indicators';
COMMENT ON COLUMN MACRO_ECN_AGG_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN MACRO_ECN_AGG_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MACRO_ECN_AGG_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MACRO_ECN_AGG_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MACRO_ECN_AGG_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MACRO_ECN_AGG_RTS_RN
-- DBIE Dataset: Macro Economic Aggregate Rates
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 225, Table 226
-- ================================================================

CREATE TABLE MACRO_ECN_AGG_RTS_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_2004_05, BY_2011_12
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. ANN_GRWT_RT, INV_RT, SAV_RT
    INDICATOR_TYPE                   VARCHAR2(50),  -- e.g. NII_GDP_FACT_CST, NII_GNP_BAS_PRC, NII_GNP_FACT_PRC, NII_GDP, NII_GROSS_DOM_PRD
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CNST_PRC, CURR_PRC
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MACRO_ECN_AGG_RTS_RN IS 'DBIE: MACRO_ECN_AGG_RTS_RN - Macro Economic Aggregate Rates | Real Sector:National Income | Macro Economic Aggregate Rates';
COMMENT ON COLUMN MACRO_ECN_AGG_RTS_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MACRO_ECN_AGG_RTS_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN MACRO_ECN_AGG_RTS_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN MACRO_ECN_AGG_RTS_RN.INDICATOR_TYPE IS 'DBIE dimension: National Income Indicators';
COMMENT ON COLUMN MACRO_ECN_AGG_RTS_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN MACRO_ECN_AGG_RTS_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MACRO_ECN_AGG_RTS_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MACRO_ECN_AGG_RTS_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MACRO_ECN_AGG_RTS_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MIN_SUP_PRICE_RN
-- DBIE Dataset: Minimum Support Price
-- Sector: Real Sector:Agriculture
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 24, Table 25
-- ================================================================

CREATE TABLE MIN_SUP_PRICE_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    CROP_CLASSIFICATION              VARCHAR2(50),  -- e.g. FDGRNS, FG_PL_ARH, FG_PL_GRM, FG_MAI, FG_PL_MOG
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MIN_SUP_PRICE_RN IS 'DBIE: MIN_SUP_PRICE_RN - Minimum Support Price | Real Sector:Agriculture | Minimum Support Price';
COMMENT ON COLUMN MIN_SUP_PRICE_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MIN_SUP_PRICE_RN.CROP_CLASSIFICATION IS 'DBIE dimension: Classification of Crops';
COMMENT ON COLUMN MIN_SUP_PRICE_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MIN_SUP_PRICE_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MIN_SUP_PRICE_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MIN_SUP_PRICE_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MONTRY_RATIOS_RN
-- DBIE Dataset: Monetary Ratios
-- Sector: Financial Sector:Monetary Statistics
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 233
-- ================================================================

CREATE TABLE MONTRY_RATIOS_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    RATIOS                           VARCHAR2(50),  -- e.g. RO4, RO2, RO6, RO1, RO3
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MONTRY_RATIOS_RN IS 'DBIE: MONTRY_RATIOS_RN - Monetary Ratios | Financial Sector:Monetary Statistics | Monetary Ratios';
COMMENT ON COLUMN MONTRY_RATIOS_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MONTRY_RATIOS_RN.RATIOS_2 IS 'DBIE dimension: Ratios';
COMMENT ON COLUMN MONTRY_RATIOS_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MONTRY_RATIOS_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MONTRY_RATIOS_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MONTRY_RATIOS_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MRKT_BOR_CSG_RN
-- DBIE Dataset: Market Borrowings of Governments
-- Sector: Public Finance:Cental & State Govt Finance(Combined)
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 105
-- ================================================================

CREATE TABLE MRKT_BOR_CSG_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    AMOUNT_TYPE                      VARCHAR2(50),  -- e.g. GROS, NET
    MARKET_BORROWING_TYPE            VARCHAR2(50),  -- e.g. MB1, MB11, MB12
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MRKT_BOR_CSG_RN IS 'DBIE: MRKT_BOR_CSG_RN - Market Borrowings of Governments | Public Finance:Cental & State Govt Finance(Combined) | Market Borrowings of Governments';
COMMENT ON COLUMN MRKT_BOR_CSG_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MRKT_BOR_CSG_RN.AMOUNT_TYPE IS 'DBIE dimension: Amount Type';
COMMENT ON COLUMN MRKT_BOR_CSG_RN.MARKET_BORROWING_TYPE IS 'DBIE dimension: Market Borrowings';
COMMENT ON COLUMN MRKT_BOR_CSG_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MRKT_BOR_CSG_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MRKT_BOR_CSG_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MRKT_BOR_CSG_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MRKT_INFO_BSE_D_RN
-- DBIE Dataset: Market Information BSE
-- Sector: Financial Markets:Equity and Corporate Debt Market
-- Frequency: Daily
-- Handbook Tables: Table 64, Table 88, Table 185
-- ================================================================

CREATE TABLE MRKT_INFO_BSE_D_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BSE_INFO_TYPE                    VARCHAR2(50),  -- e.g. EQTY_TO, MRKT_CAP, TRD_VOL
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MRKT_INFO_BSE_D_RN IS 'DBIE: MRKT_INFO_BSE_D_RN - Market Information BSE | Financial Markets:Equity and Corporate Debt Market | Market Information BSE';
COMMENT ON COLUMN MRKT_INFO_BSE_D_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MRKT_INFO_BSE_D_RN.BSE_INFO_TYPE IS 'DBIE dimension: BSE Market Information Type';
COMMENT ON COLUMN MRKT_INFO_BSE_D_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MRKT_INFO_BSE_D_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MRKT_INFO_BSE_D_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MRKT_INFO_BSE_D_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MRKT_INFO_NSE_D_RN
-- DBIE Dataset: Market Information NSE
-- Sector: Financial Markets:Equity and Corporate Debt Market
-- Frequency: Daily
-- Handbook Tables: Table 186
-- ================================================================

CREATE TABLE MRKT_INFO_NSE_D_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    NSE_INFO_TYPE                    VARCHAR2(50),  -- e.g. EQTY_TO, MRKT_CAP, TRD_VOL
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MRKT_INFO_NSE_D_RN IS 'DBIE: MRKT_INFO_NSE_D_RN - Market Information NSE | Financial Markets:Equity and Corporate Debt Market | Market Information NSE';
COMMENT ON COLUMN MRKT_INFO_NSE_D_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MRKT_INFO_NSE_D_RN.NSE_INFO_TYPE IS 'DBIE dimension: NSE Market Information Type';
COMMENT ON COLUMN MRKT_INFO_NSE_D_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MRKT_INFO_NSE_D_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MRKT_INFO_NSE_D_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MRKT_INFO_NSE_D_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MSC_F_RN
-- DBIE Dataset: Money Stock Components_Fortnightly
-- Sector: Financial Sector:Monetary Statistics
-- Frequency: Fortnightly
-- Handbook Tables: Table 39, Table 164
-- ================================================================

CREATE TABLE MSC_F_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    COMPONENT                        VARCHAR2(50),  -- e.g. CF5, CF1, CF15, CF16, CF4
    MERGER_CATEGORY                  VARCHAR2(50),  -- e.g. CF5_IM, N_A, CF4_IM
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MSC_F_RN IS 'DBIE: MSC_F_RN - Money Stock Components_Fortnightly | Financial Sector:Monetary Statistics | Money Stock Components_Fortnightly';
COMMENT ON COLUMN MSC_F_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MSC_F_RN.COMPONENT IS 'DBIE dimension: Components';
COMMENT ON COLUMN MSC_F_RN.MERGER_CATEGORY IS 'DBIE dimension: Components and sources (Merger)';
COMMENT ON COLUMN MSC_F_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MSC_F_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MSC_F_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MSC_F_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MSS_F_RN
-- DBIE Dataset: Money Stock Sources_Fortnightly
-- Sector: Financial Sector:Monetary Statistics
-- Frequency: Fortnightly
-- Handbook Tables: Table 40, Table 165
-- ================================================================

CREATE TABLE MSS_F_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MERGER_CATEGORY                  VARCHAR2(50),  -- e.g. SF2_IM, SF5_IM, SF1_IM, SF12_IM, N_A
    SOURCE_TYPE                      VARCHAR2(50),  -- e.g. SF2, SF22, SF21, SF5, SF51
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MSS_F_RN IS 'DBIE: MSS_F_RN - Money Stock Sources_Fortnightly | Financial Sector:Monetary Statistics | Money Stock Sources_Fortnightly';
COMMENT ON COLUMN MSS_F_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MSS_F_RN.MERGER_CATEGORY IS 'DBIE dimension: Components and sources (Merger)';
COMMENT ON COLUMN MSS_F_RN.SOURCE_TYPE IS 'DBIE dimension: Sources';
COMMENT ON COLUMN MSS_F_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MSS_F_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MSS_F_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MSS_F_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: MSURYCOM_F_RN
-- DBIE Dataset: Monetary Survey Components_Fortnightly
-- Sector: Financial Sector:Monetary Statistics
-- Frequency: Fortnightly
-- Handbook Tables: Table 170
-- ================================================================

CREATE TABLE MSURYCOM_F_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MON_SURVEY_COMPONENT             VARCHAR2(50),  -- e.g. CMSR1, CMSR11, CMSR1101, CMSR11013, CMSR11012
    MERGER_CATEGORY                  VARCHAR2(50),  -- e.g. CMSR11012_IM, CMSR110120202_IM, CMSR1_IM, CMSR11_IM, N_A
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE MSURYCOM_F_RN IS 'DBIE: MSURYCOM_F_RN - Monetary Survey Components_Fortnightly | Financial Sector:Monetary Statistics | Monetary Survey Components_Fortnightly';
COMMENT ON COLUMN MSURYCOM_F_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN MSURYCOM_F_RN.MON_SURVEY_COMPONENT IS 'DBIE dimension: Components of Monetary Survey';
COMMENT ON COLUMN MSURYCOM_F_RN.MERGER_CATEGORY IS 'DBIE dimension: Components and sources (Merger)';
COMMENT ON COLUMN MSURYCOM_F_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN MSURYCOM_F_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN MSURYCOM_F_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN MSURYCOM_F_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: NET_SDP_FAC_CST_RN
-- DBIE Dataset: Net State Domestic Product at Factor cost
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 5, Table 6
-- ================================================================

CREATE TABLE NET_SDP_FAC_CST_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1980_81, BY_1993_94, BY_1999_2000, BY_2004_05, BY_2011_12
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CNST_PRC, CURR_PRC
    STATE                            VARCHAR2(50),  -- e.g. ALL_INDIA, ALLS, CR, CHHT, MP
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE NET_SDP_FAC_CST_RN IS 'DBIE: NET_SDP_FAC_CST_RN - Net State Domestic Product at Factor cost | Real Sector:National Income | Net State Domestic Product at Factor cost';
COMMENT ON COLUMN NET_SDP_FAC_CST_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN NET_SDP_FAC_CST_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN NET_SDP_FAC_CST_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN NET_SDP_FAC_CST_RN.STATE IS 'DBIE dimension: State';
COMMENT ON COLUMN NET_SDP_FAC_CST_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN NET_SDP_FAC_CST_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN NET_SDP_FAC_CST_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN NET_SDP_FAC_CST_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: NOT_COIN_RN
-- DBIE Dataset: Notes & Coin in Circulation
-- Sector: Financial Sector:Monetary Statistics
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 150, Table 151, Table 152
-- ================================================================

CREATE TABLE NOT_COIN_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    DENOMINATION                     VARCHAR2(50),  -- e.g. NCC03, NCC02, NCC06, NCC09, NCC12
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE NOT_COIN_RN IS 'DBIE: NOT_COIN_RN - Notes & Coin in Circulation | Financial Sector:Monetary Statistics | Notes & Coin in Circulation';
COMMENT ON COLUMN NOT_COIN_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN NOT_COIN_RN.DENOMINATION IS 'DBIE dimension: Denomination';
COMMENT ON COLUMN NOT_COIN_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN NOT_COIN_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN NOT_COIN_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN NOT_COIN_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: NRI_DEPOSITS_IN_OUT_A_RN
-- DBIE Dataset: NRI Deposits Inflow/Outflow Annually
-- Sector: External Sector:International Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 47, Table 50, Table 74
-- ================================================================

CREATE TABLE NRI_DEPOSITS_IN_OUT_A_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    NRI_SCHEME_TYPE                  VARCHAR2(50),  -- e.g. TTL, FXD_DEP_OVRS_FCBOD, FXD_DEP_OVRS_FCON, FXD_DEP_OVRS_FCNRA, FXD_DEP_OVRS_FCNRB
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE NRI_DEPOSITS_IN_OUT_A_RN IS 'DBIE: NRI_DEPOSITS_IN_OUT_A_RN - NRI Deposits Inflow/Outflow Annually | External Sector:International Finance | NRI Deposits Inflow/Outflow Annually';
COMMENT ON COLUMN NRI_DEPOSITS_IN_OUT_A_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN NRI_DEPOSITS_IN_OUT_A_RN.NRI_SCHEME_TYPE IS 'DBIE dimension: Inflows and Outflows Under Various Schemes';
COMMENT ON COLUMN NRI_DEPOSITS_IN_OUT_A_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN NRI_DEPOSITS_IN_OUT_A_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN NRI_DEPOSITS_IN_OUT_A_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN NRI_DEPOSITS_IN_OUT_A_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: NRI_DEPOSITS_OUTS_RN
-- DBIE Dataset: NRI Deposits Outstanding Monthly
-- Sector: External Sector:International Finance
-- Frequency: Monthly
-- Handbook Tables: Table 142, Table 143
-- ================================================================

CREATE TABLE NRI_DEPOSITS_OUTS_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    NRI_DEPOSIT_TYPE                 VARCHAR2(50),  -- e.g. FXD_DEP_OVRS_NRI_DEP, FXD_DEP_OVRS_FCNRB_NRI, FXD_DEP_OVRS_NRERA_NRI, FXD_DEP_OVRS_NRO_NRI
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE NRI_DEPOSITS_OUTS_RN IS 'DBIE: NRI_DEPOSITS_OUTS_RN - NRI Deposits Outstanding Monthly | External Sector:International Finance | NRI Deposits Outstanding Monthly';
COMMENT ON COLUMN NRI_DEPOSITS_OUTS_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN NRI_DEPOSITS_OUTS_RN.NRI_DEPOSIT_TYPE IS 'DBIE dimension: Type of FD account opened for depositing income earned overseas.';
COMMENT ON COLUMN NRI_DEPOSITS_OUTS_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN NRI_DEPOSITS_OUTS_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN NRI_DEPOSITS_OUTS_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN NRI_DEPOSITS_OUTS_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: OPN_MKT_OP_RN
-- DBIE Dataset: Open market operations of RBI
-- Sector: Financial Markets:Government Securities Market
-- Frequency: Monthly
-- Handbook Tables: Table 174
-- ================================================================

CREATE TABLE OPN_MKT_OP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    TRANSACTION_TYPE                 VARCHAR2(50),  -- e.g. NET_SL_PUR, PUR, SALE
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE OPN_MKT_OP_RN IS 'DBIE: OPN_MKT_OP_RN - Open market operations of RBI | Financial Markets:Government Securities Market | Open market operations of RBI';
COMMENT ON COLUMN OPN_MKT_OP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN OPN_MKT_OP_RN.TRANSACTION_TYPE IS 'DBIE dimension: Transaction Type';
COMMENT ON COLUMN OPN_MKT_OP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN OPN_MKT_OP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN OPN_MKT_OP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN OPN_MKT_OP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: PATT_LU_UAII_RN
-- DBIE Dataset: Pattern of Land Use & Use of Agriculltural inputs in India
-- Sector: Real Sector:Agriculture
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 23
-- ================================================================

CREATE TABLE PATT_LU_UAII_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    LAND_USE_CATEGORY                VARCHAR2(50),  -- e.g. AREA_UNDER_HIGH_YIELD_VARIETIES, CONSM_FERTZ, CONSM_PESTC, GROSS_IRR_AREA, GROSS_SOWN_AREA
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE PATT_LU_UAII_RN IS 'DBIE: PATT_LU_UAII_RN - Pattern of Land Use & Use of Agriculltural inputs in India | Real Sector:Agriculture | Pattern of Land Use & Use of Agriculltural inputs in India';
COMMENT ON COLUMN PATT_LU_UAII_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN PATT_LU_UAII_RN.LAND_USE_CATEGORY IS 'DBIE dimension: Selected Categories of Land Use & Agricultural inputs';
COMMENT ON COLUMN PATT_LU_UAII_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN PATT_LU_UAII_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN PATT_LU_UAII_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN PATT_LU_UAII_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: PDS_AGR_PROD_RN
-- DBIE Dataset: Public Distribution System of agriculture produce
-- Sector: Real Sector:Agriculture
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 26, Table 51
-- ================================================================

CREATE TABLE PDS_AGR_PROD_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    PDS_COMMODITY                    VARCHAR2(50),  -- e.g. OFFTAKE, RIC, WHE, PROCUREMENT, RI
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE PDS_AGR_PROD_RN IS 'DBIE: PDS_AGR_PROD_RN - Public Distribution System of agriculture produce | Real Sector:Agriculture | Public Distribution System of agriculture produce';
COMMENT ON COLUMN PDS_AGR_PROD_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN PDS_AGR_PROD_RN.PDS_COMMODITY IS 'DBIE dimension: Distribution of Commodities';
COMMENT ON COLUMN PDS_AGR_PROD_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN PDS_AGR_PROD_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN PDS_AGR_PROD_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN PDS_AGR_PROD_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: PER_CAP_NET_SDP_RN
-- DBIE Dataset: Per Capita Net State Domestic Product at Factor Cost
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 9, Table 10
-- ================================================================

CREATE TABLE PER_CAP_NET_SDP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1980_81, BY_1993_94, BY_1999_2000, BY_2004_05, BY_2011_12
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CNST_PRC, CURR_PRC
    STATE                            VARCHAR2(50),  -- e.g. ALL_INDIA, ALLS, CR, CHHT, MP
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE PER_CAP_NET_SDP_RN IS 'DBIE: PER_CAP_NET_SDP_RN - Per Capita Net State Domestic Product at Factor Cost | Real Sector:National Income | Per Capita Net State Domestic Product at Factor Cost';
COMMENT ON COLUMN PER_CAP_NET_SDP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN PER_CAP_NET_SDP_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN PER_CAP_NET_SDP_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN PER_CAP_NET_SDP_RN.STATE IS 'DBIE dimension: State';
COMMENT ON COLUMN PER_CAP_NET_SDP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN PER_CAP_NET_SDP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN PER_CAP_NET_SDP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN PER_CAP_NET_SDP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: PRF_LNGNFC_ANN_RN
-- DBIE Dataset: Performance of Listed Non-Government Non-Financial Companies Annually
-- Sector: Corporate Sector:Listed Non-Government Non-Financial Companies
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 69
-- ================================================================

CREATE TABLE PRF_LNGNFC_ANN_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    PERFORMANCE_INDICATOR            VARCHAR2(50),  -- e.g. DEPRC, EBITDA, EBT_BEFORE_NOP, EXPD, EXPD_OTH
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE PRF_LNGNFC_ANN_RN IS 'DBIE: PRF_LNGNFC_ANN_RN - Performance of Listed Non-Government Non-Financial Companies Annually | Corporate Sector:Listed Non-Government Non-Financial Companies | Performance of Listed Non-Government Non-Financial Companies Annually';
COMMENT ON COLUMN PRF_LNGNFC_ANN_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN PRF_LNGNFC_ANN_RN.PERFORMANCE_INDICATOR IS 'DBIE dimension: Performance Indicators';
COMMENT ON COLUMN PRF_LNGNFC_ANN_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN PRF_LNGNFC_ANN_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN PRF_LNGNFC_ANN_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN PRF_LNGNFC_ANN_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: PRF_LNGNFC_IND_QTR_RN
-- DBIE Dataset: Performance Indicators – Industry-wise Growth Rates (Y-o-Y per cent) Quarterly
-- Sector: Corporate Sector:Listed Non-Government Non-Financial Companies
-- Frequency: Quarterly - Financial Year
-- Handbook Tables: Table 231
-- ================================================================

CREATE TABLE PRF_LNGNFC_IND_QTR_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INDUSTRY_GROUP                   VARCHAR2(50),  -- e.g. AGR_REL_ACT, AGR_REL_ACT_OTH, ARA_TCP, INDS_GRP_ALL_COMP, CONSTRN
    PERFORMANCE_INDICATOR            VARCHAR2(50),  -- e.g. DEPRC, EBITDA, EXPD, GROSS_PFT_EBIT, INT
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE PRF_LNGNFC_IND_QTR_RN IS 'DBIE: PRF_LNGNFC_IND_QTR_RN - Performance Indicators – Industry-wise Growth Rates (Y-o-Y per cent) Quarterly | Corporate Sector:Listed Non-Government Non-Financial Companies | Performance Indicators – Industry-wise Growth Rates (Y-o-Y per cent) Quarterly';
COMMENT ON COLUMN PRF_LNGNFC_IND_QTR_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN PRF_LNGNFC_IND_QTR_RN.INDUSTRY_GROUP IS 'DBIE dimension: Industry Group';
COMMENT ON COLUMN PRF_LNGNFC_IND_QTR_RN.PERFORMANCE_INDICATOR IS 'DBIE dimension: Performance Indicators';
COMMENT ON COLUMN PRF_LNGNFC_IND_QTR_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN PRF_LNGNFC_IND_QTR_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN PRF_LNGNFC_IND_QTR_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN PRF_LNGNFC_IND_QTR_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: PUB_BOR_RN
-- DBIE Dataset: Public Sector Borrowings
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 68
-- ================================================================

CREATE TABLE PUB_BOR_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    PUBLIC_BORROWING_TYPE            VARCHAR2(50),  -- e.g. TTL_RESOURCES, PBOR1, PBOR3, PBOR7, PBOR2
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE PUB_BOR_RN IS 'DBIE: PUB_BOR_RN - Public Sector Borrowings | Public Finance:Central Govt Finance | Public Sector Borrowings';
COMMENT ON COLUMN PUB_BOR_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN PUB_BOR_RN.PUBLIC_BORROWING_TYPE IS 'DBIE dimension: Public Borrowing';
COMMENT ON COLUMN PUB_BOR_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN PUB_BOR_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN PUB_BOR_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN PUB_BOR_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: QTR_GDP_FACT_CST_RN
-- DBIE Dataset: Quarterly Gross Domestic Product at Factor cost / Gross value added at basic price
-- Sector: Real Sector:National Income
-- Frequency: Quarterly - Financial Year
-- Handbook Tables: Table 155, Table 157
-- ================================================================

CREATE TABLE QTR_GDP_FACT_CST_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1999_2000, BY_2004_05, BY_2011_12
    ECONOMY_CLASSIFICATION           VARCHAR2(50),  -- e.g. CECN_GDP_FACT_CST, CECN_AGR_ALL_ACV, CECN_COMM_SOL_PERS_SER, CECN_CONST, CECN_ELCTY_GAS_WTR
    CALCULATION_METHOD               VARCHAR2(50),  -- e.g. FACT_CST
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CNST_PRC, CURR_PRC
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE QTR_GDP_FACT_CST_RN IS 'DBIE: QTR_GDP_FACT_CST_RN - Quarterly Gross Domestic Product at Factor cost / Gross value added at basic price | Real Sector:National Income | Quarterly Gross Domestic Product at Factor cost / Gross value added at basic price';
COMMENT ON COLUMN QTR_GDP_FACT_CST_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN QTR_GDP_FACT_CST_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN QTR_GDP_FACT_CST_RN.ECONOMY_CLASSIFICATION IS 'DBIE dimension: Classification based on economy';
COMMENT ON COLUMN QTR_GDP_FACT_CST_RN.CALCULATION_METHOD IS 'DBIE dimension: Method of Calculation';
COMMENT ON COLUMN QTR_GDP_FACT_CST_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN QTR_GDP_FACT_CST_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN QTR_GDP_FACT_CST_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN QTR_GDP_FACT_CST_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN QTR_GDP_FACT_CST_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: SEC_MKT_RN
-- DBIE Dataset: Secondary market transactions
-- Sector: Financial Markets:Government Securities Market
-- Frequency: Monthly
-- Handbook Tables: Table 175, Table 215, Table 221
-- ================================================================

CREATE TABLE SEC_MKT_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MARKET_TRANSACTION_TYPE          VARCHAR2(50),  -- e.g. DAT_SECRS, CEN_GOV_SEC, ST_GOV_SEC, TR_BILLS, TR_182DAY
    TRANSACTION_TYPE                 VARCHAR2(50),  -- e.g. OUTR_TRANSC, REPO_TRANSC
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE SEC_MKT_RN IS 'DBIE: SEC_MKT_RN - Secondary market transactions | Financial Markets:Government Securities Market | Secondary market transactions';
COMMENT ON COLUMN SEC_MKT_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN SEC_MKT_RN.MARKET_TRANSACTION_TYPE IS 'DBIE dimension: Market Transactions';
COMMENT ON COLUMN SEC_MKT_RN.TRANSACTION_TYPE IS 'DBIE dimension: Transaction Type';
COMMENT ON COLUMN SEC_MKT_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN SEC_MKT_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN SEC_MKT_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN SEC_MKT_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: SEC_WIS_CAP_FOM_RN
-- DBIE Dataset: Sector-wise Gross Capital Formation
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 13
-- ================================================================

CREATE TABLE SEC_WIS_CAP_FOM_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_2004_05, BY_2011_12
    GCF_SECTOR                       VARCHAR2(50),  -- e.g. CSG_GEN_GOV, CSG_GROSS_CAP_FRM, CSG_HOUS_SEC, CSG_HOUS_SEC_NPISH, CSG_NET_CAP_FRM
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CNST_PRC, CURR_PRC
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE SEC_WIS_CAP_FOM_RN IS 'DBIE: SEC_WIS_CAP_FOM_RN - Sector-wise Gross Capital Formation | Real Sector:National Income | Sector-wise Gross Capital Formation';
COMMENT ON COLUMN SEC_WIS_CAP_FOM_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN SEC_WIS_CAP_FOM_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN SEC_WIS_CAP_FOM_RN.GCF_SECTOR IS 'DBIE dimension: Classification of sector wise GCF';
COMMENT ON COLUMN SEC_WIS_CAP_FOM_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN SEC_WIS_CAP_FOM_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN SEC_WIS_CAP_FOM_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN SEC_WIS_CAP_FOM_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN SEC_WIS_CAP_FOM_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: SEC_WIS_DOM_SAV_RN
-- DBIE Dataset: Sector-wise Domestic Savings
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 11
-- ================================================================

CREATE TABLE SEC_WIS_DOM_SAV_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_2004_05, BY_2011_12
    GDP_SECTOR                       VARCHAR2(50),  -- e.g. N_A
    GDP_SECTOR                       VARCHAR2(50),  -- e.g. DSG_GROSS_DOM_SAV, DSG_GROSS_SAV, DSG_FIN_CRP, DSG_PRV_FIN_CRP, DSG_PUB_FIN_CRP
    PRICE_TYPE                       VARCHAR2(50),  -- e.g. CURR_PRC
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE SEC_WIS_DOM_SAV_RN IS 'DBIE: SEC_WIS_DOM_SAV_RN - Sector-wise Domestic Savings | Real Sector:National Income | Sector-wise Domestic Savings';
COMMENT ON COLUMN SEC_WIS_DOM_SAV_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN SEC_WIS_DOM_SAV_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN SEC_WIS_DOM_SAV_RN.GDP_SECTOR IS 'DBIE dimension: Classification of sectors for GDP';
COMMENT ON COLUMN SEC_WIS_DOM_SAV_RN.GDP_SECTOR IS 'DBIE dimension: Different sectors for GDP';
COMMENT ON COLUMN SEC_WIS_DOM_SAV_RN.PRICE_TYPE IS 'DBIE dimension: Price Type';
COMMENT ON COLUMN SEC_WIS_DOM_SAV_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN SEC_WIS_DOM_SAV_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN SEC_WIS_DOM_SAV_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN SEC_WIS_DOM_SAV_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: SEC_WIS_EMP_RN
-- DBIE Dataset: Sector-wise Employment
-- Sector: Real Sector:National Income
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 14
-- ================================================================

CREATE TABLE SEC_WIS_EMP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    SECTOR_AND_NUMBER_OF_PERSONS_O   VARCHAR2(50),  -- e.g. NBR_PRS_LIV_REG, SEC_PRV, SEC_PUB
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE SEC_WIS_EMP_RN IS 'DBIE: SEC_WIS_EMP_RN - Sector-wise Employment | Real Sector:National Income | Sector-wise Employment';
COMMENT ON COLUMN SEC_WIS_EMP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN SEC_WIS_EMP_RN.SECTOR_AND_NUMBER_OF_PERSONS_O IS 'DBIE dimension: Sector &  Number of Persons on the Live Register';
COMMENT ON COLUMN SEC_WIS_EMP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN SEC_WIS_EMP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN SEC_WIS_EMP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN SEC_WIS_EMP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: SG_BOR_RN
-- DBIE Dataset: State Government Gross Fiscal Deficit Financing
-- Sector: Public Finance:State Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 94, Table 100
-- ================================================================

CREATE TABLE SG_BOR_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    FINANCING_TYPE                   VARCHAR2(50),  -- e.g. SGB, SGB1, SGB2, SGB4, SGB3
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE SG_BOR_RN IS 'DBIE: SG_BOR_RN - State Government Gross Fiscal Deficit Financing | Public Finance:State Govt Finance | State Government Gross Fiscal Deficit Financing';
COMMENT ON COLUMN SG_BOR_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN SG_BOR_RN.FINANCING_TYPE IS 'DBIE dimension: Type of Financing';
COMMENT ON COLUMN SG_BOR_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN SG_BOR_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN SG_BOR_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN SG_BOR_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: SG_EXP_RN
-- DBIE Dataset: Expenditure Pattern of the State Governments
-- Sector: Public Finance:State Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 99, Table 113
-- ================================================================

CREATE TABLE SG_EXP_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    EXPENDITURE_TYPE                 VARCHAR2(50),  -- e.g. SE2, SE21, SE22, SE3, SE32
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE SG_EXP_RN IS 'DBIE: SG_EXP_RN - Expenditure Pattern of the State Governments | Public Finance:State Govt Finance | Expenditure Pattern of the State Governments';
COMMENT ON COLUMN SG_EXP_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN SG_EXP_RN.EXPENDITURE_TYPE IS 'DBIE dimension: Type of State Governments Expenditures';
COMMENT ON COLUMN SG_EXP_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN SG_EXP_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN SG_EXP_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN SG_EXP_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: SG_RECPT_RN
-- DBIE Dataset: Pattern of Receipts of the State Governments
-- Sector: Public Finance:State Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 97, Table 98
-- ================================================================

CREATE TABLE SG_RECPT_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    RECEIPT_TYPE                     VARCHAR2(50),  -- e.g. SGR1, SGR12, SGR1201, SGR1203, OTHER
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE SG_RECPT_RN IS 'DBIE: SG_RECPT_RN - Pattern of Receipts of the State Governments | Public Finance:State Govt Finance | Pattern of Receipts of the State Governments';
COMMENT ON COLUMN SG_RECPT_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN SG_RECPT_RN.RECEIPT_TYPE IS 'DBIE dimension: Type of State Government''s Receipts';
COMMENT ON COLUMN SG_RECPT_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN SG_RECPT_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN SG_RECPT_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN SG_RECPT_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: SMAL_SAV_RN
-- DBIE Dataset: Small Savings
-- Sector: Public Finance:Central Govt Finance
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 111, Table 112
-- ================================================================

CREATE TABLE SMAL_SAV_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    AMOUNT_TYPE                      VARCHAR2(50),  -- e.g. OUTSTNDING, RECEIPTS
    SMALL_SAVINGS_TYPE               VARCHAR2(50),  -- e.g. SSV2, SSV1, SSV3, TTL_OUTSTNDINGS, TTL_RECEIPTS
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE SMAL_SAV_RN IS 'DBIE: SMAL_SAV_RN - Small Savings | Public Finance:Central Govt Finance | Small Savings';
COMMENT ON COLUMN SMAL_SAV_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN SMAL_SAV_RN.AMOUNT_TYPE IS 'DBIE dimension: Amount Type';
COMMENT ON COLUMN SMAL_SAV_RN.SMALL_SAVINGS_TYPE IS 'DBIE dimension: Small Savings';
COMMENT ON COLUMN SMAL_SAV_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN SMAL_SAV_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN SMAL_SAV_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN SMAL_SAV_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: TAX_REV_RN
-- DBIE Dataset: Direct and Indirect Tax Revenues
-- Sector: Public Finance:Cental & State Govt Finance(Combined)
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 103
-- ================================================================

CREATE TABLE TAX_REV_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    TAX_TYPE                         VARCHAR2(50),  -- e.g. GR3, GR31, GR3101, GR3102, GR32
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE TAX_REV_RN IS 'DBIE: TAX_REV_RN - Direct and Indirect Tax Revenues | Public Finance:Cental & State Govt Finance(Combined) | Direct and Indirect Tax Revenues';
COMMENT ON COLUMN TAX_REV_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN TAX_REV_RN.TAX_TYPE IS 'DBIE dimension: Type of Taxes';
COMMENT ON COLUMN TAX_REV_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN TAX_REV_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN TAX_REV_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN TAX_REV_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: TRN_OVR_BSE_RN
-- DBIE Dataset: Turnover BSE
-- Sector: Financial Markets:Equity and Corporate Debt Market
-- Frequency: Monthly
-- Handbook Tables: Table 183
-- ================================================================

CREATE TABLE TRN_OVR_BSE_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. TOTAL_TO
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE TRN_OVR_BSE_RN IS 'DBIE: TRN_OVR_BSE_RN - Turnover BSE | Financial Markets:Equity and Corporate Debt Market | Turnover BSE';
COMMENT ON COLUMN TRN_OVR_BSE_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN TRN_OVR_BSE_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN TRN_OVR_BSE_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN TRN_OVR_BSE_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN TRN_OVR_BSE_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN TRN_OVR_BSE_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: TURNO_NSE_RN
-- DBIE Dataset: Turnover at NSE
-- Sector: Financial Markets:Equity and Corporate Debt Market
-- Frequency: Monthly
-- Handbook Tables: Table 184
-- ================================================================

CREATE TABLE TURNO_NSE_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE TURNO_NSE_RN IS 'DBIE: TURNO_NSE_RN - Turnover at NSE | Financial Markets:Equity and Corporate Debt Market | Turnover at NSE';
COMMENT ON COLUMN TURNO_NSE_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN TURNO_NSE_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN TURNO_NSE_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN TURNO_NSE_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN TURNO_NSE_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: WAGE_RATES_RN
-- DBIE Dataset: Wage Rates
-- Sector: Real Sector:Prices & Wages
-- Frequency: Monthly
-- Handbook Tables: Table 43
-- ================================================================

CREATE TABLE WAGE_RATES_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    GENDER                           VARCHAR2(50),  -- e.g. MALE
    STATE                            VARCHAR2(50),  -- e.g. ALL_INDIA, ALLS, CR, MP, UP
    AGRI_ACTIVITY_TYPE               VARCHAR2(50),  -- e.g. WR01, WR03, WR04, WR05, WR06
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE WAGE_RATES_RN IS 'DBIE: WAGE_RATES_RN - Wage Rates | Real Sector:Prices & Wages | Wage Rates';
COMMENT ON COLUMN WAGE_RATES_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN WAGE_RATES_RN.GENDER IS 'DBIE dimension: Gender';
COMMENT ON COLUMN WAGE_RATES_RN.STATE IS 'DBIE dimension: State';
COMMENT ON COLUMN WAGE_RATES_RN.AGRI_ACTIVITY_TYPE IS 'DBIE dimension: Type of Agri & Allied Activity';
COMMENT ON COLUMN WAGE_RATES_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN WAGE_RATES_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN WAGE_RATES_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN WAGE_RATES_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: WAR_CALL_MONEY_RN
-- DBIE Dataset: Weighted Average Call Money Rates
-- Sector: Financial Markets:Money Market
-- Frequency: Monthly
-- Handbook Tables: Table 173, Table 224
-- ================================================================

CREATE TABLE WAR_CALL_MONEY_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    RATE_TYPE                        VARCHAR2(50),  -- e.g. AVERAGE_RATE, HIGH_RATE, LOW_RATE
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE WAR_CALL_MONEY_RN IS 'DBIE: WAR_CALL_MONEY_RN - Weighted Average Call Money Rates | Financial Markets:Money Market | Weighted Average Call Money Rates';
COMMENT ON COLUMN WAR_CALL_MONEY_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN WAR_CALL_MONEY_RN.RATE_TYPE IS 'DBIE dimension: High low Average Rates';
COMMENT ON COLUMN WAR_CALL_MONEY_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN WAR_CALL_MONEY_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN WAR_CALL_MONEY_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN WAR_CALL_MONEY_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: WHOLE_PRICE_INDEX_AVG_VAR_RN
-- DBIE Dataset: Wholesale Price Index - Annual Average/Variation
-- Sector: Real Sector:Prices & Wages
-- Frequency: Annual - Financial Year
-- Handbook Tables: Table 36, Table 234, Table 241
-- ================================================================

CREATE TABLE WHOLE_PRICE_INDEX_AVG_VAR_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1952_53, BY_1961_62, BY_1970_71, BY_1981_82, BY_1993_94
    MEASURE_TYPE                     VARCHAR2(50),  -- e.g. ANNUAL_AVE, ANL_VAR
    WPI_COMMODITY                    VARCHAR2(50),  -- e.g. WPI01, WPI010101, WPI0102, WPI0103, WPI010102
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE WHOLE_PRICE_INDEX_AVG_VAR_RN IS 'DBIE: WHOLE_PRICE_INDEX_AVG_VAR_RN - Wholesale Price Index - Annual Average/Variation | Real Sector:Prices & Wages | Wholesale Price Index - Annual Average/Variation';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_AVG_VAR_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_AVG_VAR_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_AVG_VAR_RN.MEASURE_TYPE IS 'DBIE dimension: Measure';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_AVG_VAR_RN.WPI_COMMODITY IS 'DBIE dimension: WPI_Commodity Classification';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_AVG_VAR_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_AVG_VAR_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_AVG_VAR_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_AVG_VAR_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: WHOLE_PRICE_INDEX_RN
-- DBIE Dataset: Wholesale Price Index
-- Sector: Real Sector:Prices & Wages
-- Frequency: Monthly
-- Handbook Tables: Table 161
-- ================================================================

CREATE TABLE WHOLE_PRICE_INDEX_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    BASE_PERIOD                      VARCHAR2(50),  -- e.g. BY_1981_82, BY_1993_94, BY_2004_05, BY_2011_12
    WPI_COMMODITY                    VARCHAR2(50),  -- e.g. WPI0103240206, WPI0103260109, WPI0103260103, WPI0103290105, WPI0103160201
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE WHOLE_PRICE_INDEX_RN IS 'DBIE: WHOLE_PRICE_INDEX_RN - Wholesale Price Index | Real Sector:Prices & Wages | Wholesale Price Index';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_RN.BASE_PERIOD IS 'DBIE dimension: Base Period';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_RN.WPI_COMMODITY IS 'DBIE dimension: WPI_Commodity Classification';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN WHOLE_PRICE_INDEX_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: YIELD_GOV_SEC_RN
-- DBIE Dataset: YIELD OF SGL TRANSACTIONS IN GOVERNMENT DATED SECURITIES
-- Sector: Financial Markets:Government Securities Market
-- Frequency: Monthly
-- Handbook Tables: Table 21, Table 22, Table 177
-- ================================================================

CREATE TABLE YIELD_GOV_SEC_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MATURITY_PERIOD                  VARCHAR2(50),  -- e.g. TERM_MAT
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE YIELD_GOV_SEC_RN IS 'DBIE: YIELD_GOV_SEC_RN - YIELD OF SGL TRANSACTIONS IN GOVERNMENT DATED SECURITIES | Financial Markets:Government Securities Market | YIELD OF SGL TRANSACTIONS IN GOVERNMENT DATED SECURITIES';
COMMENT ON COLUMN YIELD_GOV_SEC_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN YIELD_GOV_SEC_RN.MATURITY_PERIOD IS 'DBIE dimension: Maturity Period';
COMMENT ON COLUMN YIELD_GOV_SEC_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN YIELD_GOV_SEC_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN YIELD_GOV_SEC_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN YIELD_GOV_SEC_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
-- ================================================================
-- TABLE: YIELD_TB_RN
-- DBIE Dataset: YIELD OF SGL TRANSACTIONS IN TREASURY BILLS
-- Sector: Financial Markets:Government Securities Market
-- Frequency: Monthly
-- Handbook Tables: Table 176
-- ================================================================

CREATE TABLE YIELD_TB_RN (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TIME_PERIOD     VARCHAR2(20)   NOT NULL,
    MATURITY_DAYS                    VARCHAR2(50),  -- e.g. 15TO91, 183TO364, 92TO182, UPTOTO14
    INDICATOR_NAME  VARCHAR2(200)  NOT NULL,
    VALUE           NUMBER(20,2),
    UNIT            VARCHAR2(50),
    HANDBOOK_TABLE  VARCHAR2(20),  -- Source Handbook table number
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE YIELD_TB_RN IS 'DBIE: YIELD_TB_RN - YIELD OF SGL TRANSACTIONS IN TREASURY BILLS | Financial Markets:Government Securities Market | YIELD OF SGL TRANSACTIONS IN TREASURY BILLS';
COMMENT ON COLUMN YIELD_TB_RN.TIME_PERIOD IS 'Time period of observation (Year/Quarter/Month/Date)';
COMMENT ON COLUMN YIELD_TB_RN.MATURITY_DAYS IS 'DBIE dimension: Term To Maturity In days';
COMMENT ON COLUMN YIELD_TB_RN.INDICATOR_NAME IS 'Name of the data series/indicator';
COMMENT ON COLUMN YIELD_TB_RN.VALUE IS 'Observed value in specified unit';
COMMENT ON COLUMN YIELD_TB_RN.UNIT IS 'Unit of measurement (₹ Crore, US$ Million, %, Index, etc.)';
COMMENT ON COLUMN YIELD_TB_RN.HANDBOOK_TABLE IS 'Reference to the RBI Handbook table(s) that source this data';
PROMPT
PROMPT ============================================================
PROMPT Schema creation complete.
PROMPT Total tables created: 114
PROMPT ============================================================

EXIT;
