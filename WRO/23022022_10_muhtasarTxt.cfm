
<!-- Description : Muhtasar tablosuna Vergi bildirimi alanı eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_MUHTASAR_EXPORTS' AND COLUMN_NAME = 'TOTAL_FILE_NAME')
    BEGIN
        ALTER TABLE EMPLOYEES_MUHTASAR_EXPORTS ADD TOTAL_FILE_NAME nvarchar(200) NULL
    END;
</querytag>