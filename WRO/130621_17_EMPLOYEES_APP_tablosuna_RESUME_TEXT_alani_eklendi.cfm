<!-- Description : EMPLOYEES_APP tablosuna RESUME_TEXT alanı eklendi.
Developer: Berkay Topçu
Company : Workcube
Destination: main -->

<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_APP' AND COLUMN_NAME = 'RESUME_TEXT' AND TABLE_SCHEMA = '@_dsn_@')
    BEGIN
        ALTER TABLE EMPLOYEES_APP
        ADD RESUME_TEXT nvarchar(MAX);
    END;        
</querytag>