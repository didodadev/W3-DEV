<!-- Description : EMPLOYEES_IN_OUT tablosuna DEFECTION_RATE alanı açıldı.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_IN_OUT' AND COLUMN_NAME = 'DEFECTION_RATE')
    BEGIN
        ALTER TABLE EMPLOYEES_IN_OUT ADD DEFECTION_RATE int NULL
    END;
</querytag>