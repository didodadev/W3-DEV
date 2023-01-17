<!-- Description : İzinler Sayfası Çalışan Vardiya Haftasonu 
Developer: Esma Uysal
Company : Workcube
Destination: main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OFFTIME' AND COLUMN_NAME = 'WEEK_OFFDAY')
    BEGIN
        ALTER TABLE OFFTIME ADD WEEK_OFFDAY int
    END 
</querytag>