<!-- Description : Process Tablosuna üst departman, departman ve sorumlu alanları eklendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PROCESS_TYPE' AND COLUMN_NAME = 'RESP_EMP_ID')
    BEGIN
        ALTER TABLE PROCESS_TYPE ADD 
        RESP_EMP_ID int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PROCESS_TYPE' AND COLUMN_NAME = 'UPPER_DEP_ID')
    BEGIN
        ALTER TABLE PROCESS_TYPE ADD 
        UPPER_DEP_ID int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PROCESS_TYPE' AND COLUMN_NAME = 'DEPARTMENT_ID')
    BEGIN
        ALTER TABLE PROCESS_TYPE ADD 
        DEPARTMENT_ID int NULL
    END;
</querytag>