<!-- Description : Bordro akış parametrelerine Çıkışı Yapılan Çalışanın Çalışma Günü 0 ise SGK Matrahı 0dan Hesapla alanı eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PROGRAM_PARAMETERS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'EMPLOYEES_BASE_CALC')
    BEGIN               
        ALTER TABLE SETUP_PROGRAM_PARAMETERS ADD EMPLOYEES_BASE_CALC bit;
    END
</querytag>