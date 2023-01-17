<!-- Description : Teminatlar ve history tablosuna cari account_type_id eklendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>  
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='COMPANY_SECUREFUND' AND COLUMN_NAME='ACCOUNT_TYPE_ID')
    BEGIN   
        ALTER TABLE COMPANY_SECUREFUND
        ADD ACCOUNT_TYPE_ID INT NULL
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='COMPANY_SECUREFUND' AND COLUMN_NAME='DEPARTMENT_ID')
    BEGIN   
        ALTER TABLE COMPANY_SECUREFUND
        ADD DEPARTMENT_ID INT NULL
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='COMPANY_SECUREFUND' AND COLUMN_NAME='RETURN_DETAIL')
    BEGIN   
        ALTER TABLE COMPANY_SECUREFUND
        ADD RETURN_DETAIL NVARCHAR(250) NULL
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='COMPANY_SECUREFUND_HISTORY' AND COLUMN_NAME='ACCOUNT_TYPE_ID')
    BEGIN   
        ALTER TABLE COMPANY_SECUREFUND_HISTORY
        ADD ACCOUNT_TYPE_ID INT NULL
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='COMPANY_SECUREFUND_HISTORY' AND COLUMN_NAME='DEPARTMENT_ID')
    BEGIN   
        ALTER TABLE COMPANY_SECUREFUND_HISTORY
        ADD DEPARTMENT_ID INT NULL
    END;
</querytag>