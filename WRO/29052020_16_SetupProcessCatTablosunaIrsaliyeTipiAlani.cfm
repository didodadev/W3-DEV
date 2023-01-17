<!-- Description :  İşlem kategoriler için e-irsaliye tipi alanı açıldı
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_PROCESS_CAT' AND COLUMN_NAME = 'DESPATCH_ADVICE_TYPE')
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD
        DESPATCH_ADVICE_TYPE int NULL
    END;
</querytag>