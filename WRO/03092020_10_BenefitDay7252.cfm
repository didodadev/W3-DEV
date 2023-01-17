<!-- Description : Ücret kartına 7252 kanunundan yararlanacağı gün sayısı eklendi
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_IN_OUT' AND COLUMN_NAME = 'BENEFIT_DAY_7252')
    BEGIN
        ALTER TABLE EMPLOYEES_IN_OUT ADD BENEFIT_DAY_7252 int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'SSK_ISVEREN_HISSESI_7252')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        SSK_ISVEREN_HISSESI_7252 float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'SSK_ISCI_HISSESI_7252')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        SSK_ISCI_HISSESI_7252 float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'ISSIZLIK_ISCI_HISSESI_7252')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        ISSIZLIK_ISCI_HISSESI_7252 float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'ISSIZLIK_ISVEREN_HISSESI_7252')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        ISSIZLIK_ISVEREN_HISSESI_7252 float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'LAW_NUMBER_7252')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        LAW_NUMBER_7252 int NULL
    END;  
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'SSK_DAYS_7252')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        SSK_DAYS_7252 float NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'IS_7252_CONTROL')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD
        IS_7252_CONTROL bit NULL
    END;
</querytag>