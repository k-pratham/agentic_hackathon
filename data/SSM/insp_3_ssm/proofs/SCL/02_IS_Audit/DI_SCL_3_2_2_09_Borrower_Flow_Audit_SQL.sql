-- ===================================================
-- Bank: Saptarishi Capital Limited
-- Observation: 3.2.2
-- Purpose: SQL audit queries for borrower flow control verification
-- Author: IT Audit & Compliance Team
-- Date: 18-06-2026
-- ===================================================

USE [SCL_Audit_DB];
GO

PRINT '========================================';
PRINT '  Saptarishi Capital Limited - Audit Query';
PRINT '  Observation: 3.2.2';
PRINT '  Date: 18-06-2026';
PRINT '========================================';

SELECT GETDATE() AS AuditRunDate, DB_NAME() AS DatabaseName, @@SERVERNAME AS ServerName;

IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name LIKE '%Audit%')
    PRINT '[PASS] Audit control procedures exist.'
ELSE
    PRINT '[FAIL] Audit control procedures missing - 3.2.2';

SELECT 'ComplianceCheck' AS CheckType, COUNT(*) AS TotalRecords, GETDATE() AS CheckDate
FROM sys.objects WHERE type IN ('U', 'V', 'P');

SELECT DP.name AS PrincipalName, DP.type_desc AS PrincipalType, DP.is_disabled AS IsDisabled
FROM sys.database_principals DP WHERE DP.type IN ('S', 'U', 'G') ORDER BY DP.name;

PRINT '========================================';
PRINT '  Audit query execution completed';
PRINT '========================================';
GO
