<!-- Description : Çalışan Yakını tablosuna Çocuk yardımı eklendi.  
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES' AND COLUMN_NAME='CHILD_HELP')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES ADD CHILD_HELP bit NULL
    END;
</querytag>