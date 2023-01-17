<!-- Description : Görev Tanımları sayfası için departman id eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEE_AUTHORITY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'DEPARTMENT_ID')
    BEGIN        
        ALTER TABLE EMPLOYEE_AUTHORITY ADD DEPARTMENT_ID nvarchar(250) NULL
    END
</querytag>