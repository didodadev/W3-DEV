
<!-- Description : Add new columns to company schema
Developer: Uğur Hamurpet
Company : Workcube
Destination: company-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SMS_SEND_RECEIVE' AND COLUMN_NAME = 'SMS_RETURN')
    BEGIN
        ALTER TABLE SMS_SEND_RECEIVE ADD
        SMS_RETURN nvarchar(50) NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SMS_SEND_RECEIVE' AND COLUMN_NAME = 'ACTION_COLUMN')
    BEGIN
        ALTER TABLE SMS_SEND_RECEIVE ADD
        ACTION_COLUMN nvarchar(50) NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SMS_SEND_RECEIVE' AND COLUMN_NAME = 'ACTION_TABLE')
    BEGIN
        ALTER TABLE SMS_SEND_RECEIVE ADD
        ACTION_TABLE nvarchar(50) NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SMS_SEND_RECEIVE' AND COLUMN_NAME = 'RETURN_ID')
    BEGIN
        ALTER TABLE SMS_SEND_RECEIVE ADD
        RETURN_ID nvarchar(50) NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SMS_SEND_RECEIVE' AND COLUMN_NAME = 'SMS_DURUM_CEVAP')
    BEGIN
        ALTER TABLE SMS_SEND_RECEIVE ADD
        SMS_DURUM_CEVAP nvarchar(100) NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SMS_SEND_RECEIVE' AND COLUMN_NAME = 'SMS_DURUM_CEVAP_HATA')
    BEGIN
        ALTER TABLE SMS_SEND_RECEIVE ADD
        SMS_DURUM_CEVAP_HATA nvarchar(100) NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SMS_SEND_RECEIVE' AND COLUMN_NAME = 'PHONE_NUMBER_LIST')
    BEGIN
        ALTER TABLE SMS_SEND_RECEIVE ADD
        PHONE_NUMBER_LIST nvarchar(250) NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SMS_SEND_RECEIVE' AND COLUMN_NAME = 'ACTION_ID')
    BEGIN
        ALTER TABLE SMS_SEND_RECEIVE ADD
        ACTION_ID int NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'STOCKBONDS_VALUE_CHANGES' AND COLUMN_NAME = 'IS_DAD_ACCOUNT')
    BEGIN
        ALTER TABLE STOCKBONDS_VALUE_CHANGES ADD
        IS_DAD_ACCOUNT int NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'STOCKBONDS_VALUE_CHANGES' AND COLUMN_NAME = 'IS_DAD_ACTION_ID')
    BEGIN
        ALTER TABLE STOCKBONDS_VALUE_CHANGES ADD
        IS_DAD_ACTION_ID int NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'STOCKBONDS_VALUE_CHANGES' AND COLUMN_NAME = 'IS_DAD_ACCOUNT_DATE')
    BEGIN
        ALTER TABLE STOCKBONDS_VALUE_CHANGES ADD
        IS_DAD_ACCOUNT_DATE datetime NULL
    END;
</querytag>