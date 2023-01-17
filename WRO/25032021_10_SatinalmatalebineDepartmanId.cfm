<!-- Description : Satınalma Taleplerine Departman alanı PROCESS_CAT alanı açıldı
Developer: Gülbahar İnan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INTERNALDEMAND' AND COLUMN_NAME = 'DEPARTMENT_ID' )
    BEGIN
        ALTER TABLE INTERNALDEMAND ADD DEPARTMENT_ID INT NULL 
    END
</querytag>