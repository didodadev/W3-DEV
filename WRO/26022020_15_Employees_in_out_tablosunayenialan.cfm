<!-- Description : EMPLOYEES_IN_OUT tablosuna IS_STATUS_EMPLOYEE alanı açıldı.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_IN_OUT' AND COLUMN_NAME = 'IS_STATUS_EMPLOYEE')
    BEGIN
        ALTER TABLE EMPLOYEES_IN_OUT ADD IS_STATUS_EMPLOYEE bit
    END;
</querytag>