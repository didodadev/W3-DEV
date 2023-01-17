<!-- Description : EMPLOYEES_RELATIVES tablosuna KINDERGARDEN_SUPPORT, IS_COMMITMENT_NOT_ASSURANCE, IS_ASSURANCE_POLICY alanları eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_RELATIVES' AND COLUMN_NAME = 'KINDERGARDEN_SUPPORT')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES ADD
        KINDERGARDEN_SUPPORT bit NULL;
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_RELATIVES' AND COLUMN_NAME = 'IS_COMMITMENT_NOT_ASSURANCE')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES ADD
        IS_COMMITMENT_NOT_ASSURANCE bit NULL;
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_RELATIVES' AND COLUMN_NAME = 'IS_ASSURANCE_POLICY')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES ADD
        IS_ASSURANCE_POLICY bit NULL;
    END
</querytag>