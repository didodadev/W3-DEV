<!-- Description : Belge Numaralarına M. Kıymet DAD Ekranı İçin Yeni Alan Eklendi
Developer: İlker Altındal
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'MKDAD_NO')
        BEGIN
            ALTER TABLE GENERAL_PAPERS ADD 
            MKDAD_NO nvarchar(40) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'MKDAD_NUMBER')
        BEGIN
            ALTER TABLE GENERAL_PAPERS ADD 
            MKDAD_NUMBER int NULL
    END;
</querytag>