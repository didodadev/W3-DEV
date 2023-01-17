<!-- Description : İzin ve Mazeret Kategorisi için İZİN ÖTELEME KOLONU AÇILDI
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'IS_OFFDAY_DELAY')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        IS_OFFDAY_DELAY bit NULL
    END;
</querytag>