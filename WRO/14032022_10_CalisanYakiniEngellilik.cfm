<!-- Description :  Çalışan yakını tablsouna engellilik oranı ve tarihleri eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES' AND COLUMN_NAME='DEFECTION_RATE')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES ADD DEFECTION_RATE int NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES' AND COLUMN_NAME='DEFECTION_STARTDATE')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES ADD DEFECTION_STARTDATE datetime NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES' AND COLUMN_NAME='DEFECTION_FINISHDATE')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES ADD DEFECTION_FINISHDATE datetime NULL
    END;
</querytag>