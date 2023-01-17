<!-- Description : SETUP_OTV Tablolarına Yeni Alanları Eklendi.
Developer: Dilek Özdemir
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@'  AND TABLE_NAME = 'SETUP_OTV'  AND COLUMN_NAME = 'TAX_TYPE')
        BEGIN
            ALTER TABLE SETUP_OTV ADD
            TAX_TYPE int NULL
        END
</querytag>