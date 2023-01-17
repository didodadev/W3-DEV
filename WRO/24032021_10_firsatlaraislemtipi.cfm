<!-- Description : Fırsatlara PROCESS_CAT alanı açıldı
Developer: Gülbahar İnan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OPPORTUNITIES' AND COLUMN_NAME = 'PROCESS_CAT' )
    BEGIN
        ALTER TABLE OPPORTUNITIES ADD PROCESS_CAT INT NULL 
    END
</querytag>