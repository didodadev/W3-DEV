<!-- Description : İzinlerde Vardiya haftasonu kolonu silindi
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='OFFTIME' AND COLUMN_NAME='WEEK_OFFDAY')
    BEGIN
        ALTER TABLE OFFTIME
        DROP COLUMN WEEK_OFFDAY
    END
</querytag>
