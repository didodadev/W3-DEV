<!-- Description : WRK_PROCESS_TEMPLATES tablosu detay alanı genişletme
Developer: Botan Kayğan
Company : Workcube
Destination: Main-->
<querytag>
    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_PROCESS_TEMPLATES' AND TABLE_SCHEMA = '@_dsn_main_@' AND  COLUMN_NAME = 'PROCESS_TEMPLATE_DETAIL' )
    BEGIN
        ALTER TABLE WRK_PROCESS_TEMPLATES 
        ALTER COLUMN PROCESS_TEMPLATE_DETAIL nvarchar(MAX)
    END;
</querytag>