<!-- Description : İşlem Kategorisine Ödenek ve Kesinti Kolonu eklendi.
Developer: Esma R. Uysal
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_PROCESS_CAT' AND COLUMN_NAME = 'IS_ALLOWANCE_DEDUCTION')
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD
        IS_ALLOWANCE_DEDUCTION bit NULL
    END;
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_PROCESS_CAT_HISTORY' AND COLUMN_NAME = 'IS_ALLOWANCE_DEDUCTION')
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT_HISTORY ADD
        IS_ALLOWANCE_DEDUCTION bit NULL
    END;
</querytag>