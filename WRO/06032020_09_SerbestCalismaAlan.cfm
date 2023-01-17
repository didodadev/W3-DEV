<!-- Description : Çalışan Tablosuna serbest zaman kolonları eklendi.
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'EXT_OFFTIME_MINUTES')
    BEGIN
        ALTER TABLE EMPLOYEES ADD
        EXT_OFFTIME_MINUTES int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'EXT_OFFTIME_DATE')
    BEGIN
        ALTER TABLE EMPLOYEES ADD
        EXT_OFFTIME_DATE datetime NULL;
    END;
</querytag>