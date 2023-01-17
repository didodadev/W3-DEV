<!-- Description : EMPLOYEES_RELATIVES tablosuna enegelli vergi istisnası alanları
Developer: Tolga Sütlü
Company : Workcube
Destination: MAIN -->

<querytag>

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES' AND COLUMN_NAME='DEFECTION_LEVEL')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES 
        ADD DEFECTION_LEVEL [int] NULL
    END;

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES' AND COLUMN_NAME='USE_TAX')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES 
        ADD USE_TAX [int] NULL
    END;

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES_HISTORY' AND COLUMN_NAME='DEFECTION_LEVEL')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES_HISTORY 
        ADD DEFECTION_LEVEL [int] NULL
    END;

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_RELATIVES_HISTORY' AND COLUMN_NAME='USE_TAX')
    BEGIN
        ALTER TABLE EMPLOYEES_RELATIVES_HISTORY 
        ADD USE_TAX [int] NULL
    END;
</querytag>