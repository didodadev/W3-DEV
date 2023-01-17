<!-- Description : Şirket Akış Parametrelerine Watalogy Member Code alanı eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>  
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='OUR_COMPANY_INFO' AND COLUMN_NAME='WATALOGY_MEMBER_CODE')
    BEGIN   
        ALTER TABLE OUR_COMPANY_INFO
        ADD WATALOGY_MEMBER_CODE NVARCHAR(50) NULL
    END;
</querytag>