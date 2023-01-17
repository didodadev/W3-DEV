<!-- Description : SETUP_HEALTH_ASSURANCE_TYPE tablosuna CALCULATION_FORMULA alanı ve COMPANY tablosuna IS_CIVIL_COMPANY alanı eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE' AND COLUMN_NAME = 'CALCULATION_FORMULA')
    BEGIN
        ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE ADD
        CALCULATION_FORMULA nvarchar(MAX) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY' AND COLUMN_NAME = 'IS_CIVIL_COMPANY')
    BEGIN
        ALTER TABLE COMPANY ADD
        IS_CIVIL_COMPANY bit NULL
    END;
</querytag>