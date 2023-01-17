<!-- Description : EMPLOYEES_IN_OUT_HISTORY tablosuna Hizmet Sınıfları ve Hizmet Unvanları alanları eklendi.
Developer: Dilek ÖZdemir
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_IN_OUT_HISTORY' AND COLUMN_NAME='SERVICE_CLASS')
    BEGIN
        ALTER TABLE EMPLOYEES_IN_OUT_HISTORY 
        ADD SERVICE_CLASS [int] NULL
    END;

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_IN_OUT_HISTORY' AND COLUMN_NAME='SERVICE_TITLE')
    BEGIN
        ALTER TABLE EMPLOYEES_IN_OUT_HISTORY 
        ADD SERVICE_TITLE [int] NULL
    END;
</querytag>