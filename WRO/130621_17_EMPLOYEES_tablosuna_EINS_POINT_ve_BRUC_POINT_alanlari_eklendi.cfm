<!-- Description : EMPLOYEES tablosuna EINS_POINT ve BRUC_POINT alanları eklendi.
Developer: Berkay Topçu
Company : Workcube
Destination: main -->

<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES' AND COLUMN_NAME = 'EINS_POINT' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        ALTER TABLE EMPLOYEES
        ADD EINS_POINT float;
    END;   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES' AND COLUMN_NAME = 'BRUC_POINT' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        ALTER TABLE EMPLOYEES
        ADD BRUC_POINT float;
    END;     
</querytag>