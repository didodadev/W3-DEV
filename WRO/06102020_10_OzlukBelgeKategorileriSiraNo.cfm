<!-- Description : Özlük Belge Kategorileri tablosuna sıra no alanı eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SETUP_EMPLOYMENT_ASSET_CAT' AND COLUMN_NAME = 'SEQUENCE_NO')
    BEGIN
        ALTER TABLE SETUP_EMPLOYMENT_ASSET_CAT
        ADD SEQUENCE_NO INT NULL
    END;
</querytag>