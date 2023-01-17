<!-- Description : Myhome özlük belgelerine süreç eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEE_EMPLOYMENT_ROWS' AND COLUMN_NAME = 'EMPLOYMENT_STAGE')
    BEGIN
        ALTER TABLE EMPLOYEE_EMPLOYMENT_ROWS ADD
        EMPLOYMENT_STAGE int NULL
    END;
</querytag>