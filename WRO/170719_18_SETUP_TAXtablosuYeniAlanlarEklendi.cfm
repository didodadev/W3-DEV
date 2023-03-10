<!-- Description :SETUP_TAX tablosuna yeni alanlar eklendi
Developer: Ahmet Yolcu
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'SETUP_TAX' AND COLUMN_NAME = 'EXP_SALES_CODE')
    BEGIN
    ALTER TABLE SETUP_TAX ADD 
    EXP_SALES_CODE nvarchar(50) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'SETUP_TAX' AND COLUMN_NAME = 'EXP_PURCHASE_CODE')
    BEGIN
    ALTER TABLE SETUP_TAX ADD 
    EXP_PURCHASE_CODE nvarchar(50) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'SETUP_TAX' AND COLUMN_NAME = 'INWARD_PROCESS_CODE')
    BEGIN
    ALTER TABLE SETUP_TAX ADD 
    INWARD_PROCESS_CODE nvarchar(50) NULL
    END;  
</querytag>