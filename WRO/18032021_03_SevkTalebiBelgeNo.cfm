<!-- Description : Belge Numaraları tablosunda sevk talebi belge no eklendi.
Developer: Gülbahar İnan
Company : Workcube
Destination: Company -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'SHIP_INTERNAL_NO')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD
        SHIP_INTERNAL_NO nvarchar(50) NULL DEFAULT 'SVKT'
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'SHIP_INTERNAL_NUMBER')
    BEGIN
        ALTER TABLE GENERAL_PAPERS ADD
        SHIP_INTERNAL_NUMBER int NULL DEFAULT 0
    END;
</querytag>