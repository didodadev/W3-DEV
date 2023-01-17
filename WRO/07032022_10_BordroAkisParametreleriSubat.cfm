<!-- Description : Bordro akış parametrelerine Şubat Ayı Saatlik Çalışanın SGK Matrahı 30 Gün eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PROGRAM_PARAMETERS' AND COLUMN_NAME = 'HOURLY_EMPLOYEE_WORK_DAYS_30')
    BEGIN
        ALTER TABLE SETUP_PROGRAM_PARAMETERS ADD HOURLY_EMPLOYEE_WORK_DAYS_30 bit NULL
    END
</querytag>