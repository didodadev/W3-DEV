<!-- Description :  İşlem kategoriler için e-irsaliye senaryo alanı açıldı
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_PROCESS_CAT' AND COLUMN_NAME = 'ESHIPMENT_PROFILE_ID')
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD
        ESHIPMENT_PROFILE_ID nvarchar(50) NULL
    END;
</querytag>