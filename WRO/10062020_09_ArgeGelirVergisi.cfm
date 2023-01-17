<!-- Description : Puantaja Arge Gelir vergisi sütunu eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'GVM_MATRAH_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD GVM_MATRAH_5746 float
    END 
</querytag>