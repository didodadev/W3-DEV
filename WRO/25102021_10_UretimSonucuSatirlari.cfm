<!-- Description : Üretim sonucu satırlarında güncelleme
Developer: Fatih Kara
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'WIDTH')
    BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD
        WIDTH float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'HEIGHT')
    BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD
        HEIGHT float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'LENGTH')
    BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD
        LENGTH float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'WEIGHT')
    BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD
        WEIGHT float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'SPECIFIC_WEIGHT')
    BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD
        SPECIFIC_WEIGHT float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'WORK_ID')
    BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD
        WORK_ID int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'WORK_HEAD')
    BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD
        WORK_HEAD nvarchar(50) NULL
    END;
    
</querytag>