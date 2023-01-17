<!-- Description : STOCKS_ROW tablosuna PROCESS_TIME kolonu eklenmesi
Developer: Melek KOCABEY
Company : Workcube
Destination: period-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'STOCKS_ROW' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'PROCESS_TIME')
    BEGIN
    ALTER TABLE STOCKS_ROW ADD PROCESS_TIME datetime
    END; 
</querytag>