<!-- Description : General paper yazar kasa için belge numarası eklendi
Developer: ilker altındal
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'CASHREGISTER_NO')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD
        CASHREGISTER_NO nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'CASHREGISTER_NUMBER')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD
        CASHREGISTER_NUMBER int NULL
    END;

</querytag>