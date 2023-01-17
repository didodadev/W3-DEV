<!-- Description : Department Tablosuna DEPT_STAGE alanı eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'DEPARTMENT' AND COLUMN_NAME = 'DEPT_STAGE')
    BEGIN
        ALTER TABLE DEPARTMENT ADD
        DEPT_STAGE int NULL
    END;
</querytag>