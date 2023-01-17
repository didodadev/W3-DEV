<!-- Description : Şirket Akış Parametrelerine Watalogy Entegrasyon alanı eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>  
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='OUR_COMPANY_INFO' AND COLUMN_NAME='IS_WATALOGY_INTEGRATED')
    BEGIN   
        ALTER TABLE OUR_COMPANY_INFO
        ADD IS_WATALOGY_INTEGRATED BIT NULL
    END;
</querytag>