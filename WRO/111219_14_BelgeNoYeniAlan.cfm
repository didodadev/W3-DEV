<!-- Description : Belge Numaraları tablosunda sistem -evrak kayıt no eklendi.
Developer: Omer Turhan
Company : Workcube
Destination: Company -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'SYSTEM_PAPER_NO')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD
        SYSTEM_PAPER_NO nvarchar(50) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'SYSTEM_PAPER_NUMBER')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD
        SYSTEM_PAPER_NUMBER int NULL
    END;
</querytag>