<!-- Description : Garanti Süresinin ondalıklı olarak girilebilmesi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_GUARANTYCAT_TIME' AND COLUMN_NAME='GUARANTYCAT_TIME')
    BEGIN
        ALTER TABLE SETUP_GUARANTYCAT_TIME ALTER COLUMN GUARANTYCAT_TIME FLOAT
    END;
</querytag>