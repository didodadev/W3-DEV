<!-- Description : Puantaj TAX_DAYS_5746 alanı WRO.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'TAX_DAYS_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD TAX_DAYS_5746 float
    END;  
</querytag>