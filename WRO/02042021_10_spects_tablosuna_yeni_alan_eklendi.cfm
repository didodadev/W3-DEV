<!-- Description : SPECTS tablosuna yeni kolon eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Company -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SPECTS' AND COLUMN_NAME='IS_MIX_PRODUCT')
    BEGIN
        ALTER TABLE SPECTS ADD
        IS_MIX_PRODUCT bit NULL CONSTRAINT DF_SPECTS_IS_MIX_PRODUCT DEFAULT ((0))
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SPECTS' AND COLUMN_NAME='STAGE')
    BEGIN
        ALTER TABLE SPECTS ADD
        STAGE int NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SPECTS' AND COLUMN_NAME='EMPLOYEE_ID')
    BEGIN
        ALTER TABLE SPECTS ADD
        EMPLOYEE_ID int NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SPECTS' AND COLUMN_NAME='SAVE_DATE')
    BEGIN
        ALTER TABLE SPECTS ADD
        SAVE_DATE datetime NULL
    END;

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SPECT_MAIN' AND COLUMN_NAME='IS_MIX_PRODUCT')
    BEGIN
        ALTER TABLE SPECT_MAIN ADD
        IS_MIX_PRODUCT bit NULL CONSTRAINT DF_SPECT_MAIN_IS_MIX_PRODUCT DEFAULT ((0))
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SPECT_MAIN' AND COLUMN_NAME='STAGE')
    BEGIN
        ALTER TABLE SPECT_MAIN ADD
        STAGE int NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SPECT_MAIN' AND COLUMN_NAME='EMPLOYEE_ID')
    BEGIN
        ALTER TABLE SPECT_MAIN ADD
        EMPLOYEE_ID int NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME='SPECT_MAIN' AND COLUMN_NAME='SAVE_DATE')
    BEGIN
        ALTER TABLE SPECT_MAIN ADD
        SAVE_DATE datetime NULL
    END;
   
</querytag>