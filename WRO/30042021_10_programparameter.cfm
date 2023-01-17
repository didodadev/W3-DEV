<!-- Description : Bordro akış parametrelerine 5746 Damga vergisi çalışana eklensin mi  eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PROGRAM_PARAMETERS' AND COLUMN_NAME = 'IS_5746_STAMPDUTY')
    BEGIN
        ALTER TABLE SETUP_PROGRAM_PARAMETERS ADD IS_5746_STAMPDUTY bit NULL
    END
</querytag>