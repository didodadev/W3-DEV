<!-- Description : Tablolara yeni alanlar eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'WORKTIME_FLEXIBLE' AND COLUMN_NAME = 'APPROVE_EMP_ID_2')
    BEGIN
        ALTER TABLE WORKTIME_FLEXIBLE ADD APPROVE_EMP_ID_2 int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'WORKTIME_FLEXIBLE' AND COLUMN_NAME = 'APPROVE_EMP_ID_1')
    BEGIN
        ALTER TABLE WORKTIME_FLEXIBLE ADD APPROVE_EMP_ID_1 int NULL
    END;
   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'WORKTIME_FLEXIBLE' AND COLUMN_NAME = 'IS_APPROVE')
    BEGIN
        ALTER TABLE WORKTIME_FLEXIBLE ADD IS_APPROVE bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'EXPENSE_CENTER' AND COLUMN_NAME = 'ACTIVITY_ID')
    BEGIN
       ALTER TABLE EXPENSE_CENTER ADD ACTIVITY_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'SALARYPARAM_PAY' AND COLUMN_NAME = 'IS_RD_GELIR')
    BEGIN
        ALTER TABLE SALARYPARAM_PAY ALTER COLUMN IS_RD_GELIR bit 
    END;

     IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'SALARYPARAM_PAY' AND COLUMN_NAME = 'IS_RD_SSK')
    BEGIN
        ALTER TABLE SALARYPARAM_PAY ALTER COLUMN IS_RD_SSK bit 
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS' AND COLUMN_NAME = 'PAYMENT_RATE')
    BEGIN
        ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS ADD PAYMENT_RATE float NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'DAMGA_VERGISI_INDIRIMI_5746')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ALTER COLUMN DAMGA_VERGISI_INDIRIMI_5746 float 
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'LAW_NUMBER_7103')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ALTER COLUMN LAW_NUMBER_7103 int 
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'SETUP_PROGRAM_PARAMETERS' AND COLUMN_NAME = 'SETUP_PROGRAM_PARAMETERS')
    BEGIN
        ALTER TABLE SETUP_PROGRAM_PARAMETERS ALTER COLUMN IS_5746_SALARYPARAM_PAY bit 
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'ASSET_HISTORY' AND COLUMN_NAME = 'TV_CAT_ID')
    BEGIN
        ALTER TABLE ASSET_HISTORY ADD TV_CAT_ID nvarchar(500) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'ASSET_HISTORY' AND COLUMN_NAME = 'IS_TV_PUBLISH')
    BEGIN
        ALTER TABLE ASSET_HISTORY ADD IS_TV_PUBLISH int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'TRAINING_CLASS' AND COLUMN_NAME = 'HOUR_NO')
    BEGIN
        ALTER TABLE TRAINING_CLASS ALTER COLUMN HOUR_NO float
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'WRK_MESSAGE' AND COLUMN_NAME = 'ACTION_PAGE')
    BEGIN
        ALTER TABLE WRK_MESSAGE ALTER COLUMN ACTION_PAGE nvarchar(500) 
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'WRK_MESSAGE' AND COLUMN_NAME = 'WARNING_HEAD')
    BEGIN
        ALTER TABLE WRK_MESSAGE ALTER COLUMN WARNING_HEAD nvarchar(500) 

    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'WRK_MESSAGE' AND COLUMN_NAME = 'ACTION_COLUMN')
    BEGIN
        ALTER TABLE WRK_MESSAGE ALTER COLUMN ACTION_COLUMN nvarchar(50)
    END;

     IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'WRK_MESSAGE' AND COLUMN_NAME = 'STAGE_ID')
    BEGIN
         ALTER TABLE WRK_MESSAGE ADD STAGE_ID int NULL
    END;

     IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'WRK_SESSION' AND COLUMN_NAME = 'FUSEACTION')
    BEGIN
        ALTER TABLE WRK_SESSION ALTER COLUMN FUSEACTION nvarchar(250) 
    END;

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'UTILITIES' AND COLUMN_NAME = 'DETAIL')
    BEGIN
        ALTER TABLE UTILITIES ALTER COLUMN DETAIL nvarchar(max)        
    END;
</querytag>


 


 

