<!-- Description : İzin ve Mazeret Kategorisi için serbest zamanda kullanılsın kolonu eklendi
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'IS_FREE_TIME')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        IS_FREE_TIME bit NULL
    END;
</querytag>