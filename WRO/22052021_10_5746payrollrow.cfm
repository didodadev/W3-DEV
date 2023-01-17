<!-- Description : Puantaja 5746 Damga vergisi çalışana eklensin mi  eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'STAMPDUTY_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD STAMPDUTY_5746 float NULL
    END
</querytag>