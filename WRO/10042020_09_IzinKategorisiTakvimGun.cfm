<!-- Description : İzin ve Mazeret Kategorisi için takvim gününden hesapla kolonu eklendi
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'CALC_CALENDAR_DAY')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        CALC_CALENDAR_DAY bit NOT NULL DEFAULT 0;
    END;
</querytag>