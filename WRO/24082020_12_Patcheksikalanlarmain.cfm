<!-- Description : Patch farkları için main WRO.
Developer: Gülbahar Inan
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY21')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY21 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY22')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY22 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY23')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY23 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY24')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY24 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY25')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY25 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY26')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY26 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY27')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY27 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY28')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY28 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY29')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY29 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY30')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY30 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY31')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY31 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY32')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY32 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY33')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY33 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY34')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY34 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY35')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY35 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY36')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY36 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY37')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY37 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY38')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY38 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY39')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY39 nvarchar(500) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROJECT_INFO_PLUS_HISTORY' AND COLUMN_NAME = 'PROPERTY40')
        BEGIN
        ALTER TABLE PROJECT_INFO_PLUS_HISTORY ADD
        PROPERTY40 nvarchar(500) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DIGITAL_ASSET_GROUP' AND COLUMN_NAME = 'DETAIL')
    BEGIN
        ALTER TABLE DIGITAL_ASSET_GROUP ALTER COLUMN DETAIL nvarchar(250) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE DIGITAL_ASSET_GROUP ADD DETAIL nvarchar(250) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER_BANK' AND COLUMN_NAME = 'CONSUMER_BANK')
    BEGIN
        ALTER TABLE CONSUMER_BANK ALTER COLUMN CONSUMER_BANK nvarchar(150) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE CONSUMER_BANK ADD CONSUMER_BANK nvarchar(150) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER_BANK' AND COLUMN_NAME = 'CONSUMER_SWIFT_CODE')
    BEGIN
        ALTER TABLE CONSUMER_BANK ALTER COLUMN CONSUMER_SWIFT_CODE nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE CONSUMER_BANK ADD CONSUMER_SWIFT_CODE nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_FAMILY' AND COLUMN_NAME = 'FAMILY')
    BEGIN
        ALTER TABLE WRK_FAMILY ALTER COLUMN FAMILY nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_FAMILY ADD FAMILY nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY_BANK' AND COLUMN_NAME = 'COMPANY_BANK')
    BEGIN
        ALTER TABLE COMPANY_BANK ALTER COLUMN COMPANY_BANK nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE COMPANY_BANK ADD COMPANY_BANK nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY_BANK' AND COLUMN_NAME = 'COMPANY_SWIFT_CODE')
    BEGIN
        ALTER TABLE COMPANY_BANK ALTER COLUMN COMPANY_SWIFT_CODE nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE COMPANY_BANK ADD COMPANY_SWIFT_CODE nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCTION_ORDER_RESULTS_ROW' AND COLUMN_NAME = 'SPECT_NAME')
    BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ALTER COLUMN SPECT_NAME nvarchar(500) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE PRODUCTION_ORDER_RESULTS_ROW ADD SPECT_NAME nvarchar(500) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_DEVELOPMENT_REPORT' AND COLUMN_NAME = 'COMMANDTEXT')
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ALTER COLUMN COMMANDTEXT nvarchar(max) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ADD COMMANDTEXT nvarchar(max) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_DEVELOPMENT_REPORT' AND COLUMN_NAME = 'HOSTNAME')
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ALTER COLUMN HOSTNAME nvarchar(100) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ADD HOSTNAME nvarchar(100) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_DEVELOPMENT_REPORT' AND COLUMN_NAME = 'DATABASENAME')
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ALTER COLUMN DATABASENAME nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ADD DATABASENAME nvarchar(50) NULL
    END

     IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_DEVELOPMENT_REPORT' AND COLUMN_NAME = 'OBJECTNAME')
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ALTER COLUMN OBJECTNAME nvarchar(100) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ADD OBJECTNAME nvarchar(100) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_DEVELOPMENT_REPORT' AND COLUMN_NAME = 'OBJECTTYPE')
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ALTER COLUMN OBJECTTYPE nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ADD OBJECTTYPE nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_DEVELOPMENT_REPORT' AND COLUMN_NAME = 'USERNAME')
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ALTER COLUMN USERNAME nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ADD USERNAME nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_DEVELOPMENT_REPORT' AND COLUMN_NAME = 'TIME')
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ALTER COLUMN TIME nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ADD TIME nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_DEVELOPMENT_REPORT' AND COLUMN_NAME = 'SERVERNAME')
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ALTER COLUMN SERVERNAME nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_DEVELOPMENT_REPORT ADD SERVERNAME nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMMANDMENT' AND COLUMN_NAME = 'ACCOUNT_NAME')
    BEGIN
        ALTER TABLE COMMANDMENT ALTER COLUMN ACCOUNT_NAME nvarchar(250) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE COMMANDMENT ADD ACCOUNT_NAME nvarchar(250) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMMANDMENT' AND COLUMN_NAME = 'ACCOUNT_CODE')
    BEGIN
        ALTER TABLE COMMANDMENT ALTER COLUMN ACCOUNT_CODE nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE COMMANDMENT ADD ACCOUNT_CODE nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRO_MATERIAL_ROW' AND COLUMN_NAME = 'SPECT_VAR_NAME')
    BEGIN
        ALTER TABLE PRO_MATERIAL_ROW ALTER COLUMN SPECT_VAR_NAME nvarchar(500)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE PRO_MATERIAL_ROW ADD SPECT_VAR_NAME nvarchar(500)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMMANDMENT_HISTORY' AND COLUMN_NAME = 'ACCOUNT_NAME')
    BEGIN
        ALTER TABLE COMMANDMENT_HISTORY ALTER COLUMN ACCOUNT_NAME nvarchar(250)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE COMMANDMENT_HISTORY ADD ACCOUNT_NAME nvarchar(250)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMMANDMENT_HISTORY' AND COLUMN_NAME = 'ACCOUNT_CODE')
    BEGIN
        ALTER TABLE COMMANDMENT_HISTORY ALTER COLUMN ACCOUNT_CODE nvarchar(50)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE COMMANDMENT_HISTORY ADD ACCOUNT_CODE nvarchar(50)  NULL
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='PROTEIN_TEMPLATES')
     BEGIN

        CREATE TABLE [PROTEIN_TEMPLATES](	  
            [TEMPLATE_ID] int NOT NULL IDENTITY(1,1),	
            [SITE] int NOT NULL,	
            [TITLE] nvarchar(140) NULL,	
            [STATUS] int NULL,	
            [TYPE] int NULL,	
            [DESIGN_DATA] nvarchar(16) NULL,	
            [RECORD_DATE] datetime NULL,	
            [RECORD_EMP] int NULL,	
            [RECORD_IP] nvarchar(50) NULL,	
            [UPDATE_DATE] datetime NULL,	
            [UPDATE_EMP] int NULL,	
            [UPDATE_IP] nvarchar(50) NULL,
            CONSTRAINT [PK_PROTEIN_TEMPLATES] PRIMARY KEY ([TEMPLATE_ID] ASC));
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS' AND COLUMN_NAME = 'PUANTAJ_ACCOUNT_DEFINITION')
    BEGIN
        ALTER TABLE SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS ALTER COLUMN PUANTAJ_ACCOUNT_DEFINITION nvarchar(500)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS ADD PUANTAJ_ACCOUNT_DEFINITION nvarchar(500)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_SOLUTION' AND COLUMN_NAME = 'SOLUTION')
    BEGIN
        ALTER TABLE WRK_SOLUTION ALTER COLUMN SOLUTION nvarchar(50)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_SOLUTION ADD SOLUTION nvarchar(50)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'STOCKS_LOCATION' AND COLUMN_NAME = 'DEPARTMENT_LOCATION')
    BEGIN
        ALTER TABLE STOCKS_LOCATION ALTER COLUMN DEPARTMENT_LOCATION nvarchar(500)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE STOCKS_LOCATION ADD DEPARTMENT_LOCATION nvarchar(500)  NULL
    END

     IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONTENT' AND COLUMN_NAME = 'CONT_HEAD')
    BEGIN
        ALTER TABLE CONTENT ALTER COLUMN CONT_HEAD nvarchar(250)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE CONTENT ADD CONT_HEAD nvarchar(250)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET_HISTORY' AND COLUMN_NAME = 'ASSET_DESCRIPTION')
    BEGIN
        ALTER TABLE ASSET_HISTORY ALTER COLUMN ASSET_DESCRIPTION nvarchar(max)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE ASSET_HISTORY ADD ASSET_DESCRIPTION nvarchar(max)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER_HISTORY' AND COLUMN_NAME = 'HOMESEMT')
    BEGIN
        ALTER TABLE CONSUMER_HISTORY ALTER COLUMN HOMESEMT nvarchar(150)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE CONSUMER_HISTORY ADD HOMESEMT nvarchar(150)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER_HISTORY' AND COLUMN_NAME = 'TAX_SEMT')
    BEGIN
        ALTER TABLE CONSUMER_HISTORY ALTER COLUMN TAX_SEMT nvarchar(150)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE CONSUMER_HISTORY ADD TAX_SEMT nvarchar(150)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_MODULE' AND COLUMN_NAME = 'MODULE')
    BEGIN
        ALTER TABLE WRK_MODULE ALTER COLUMN MODULE nvarchar(250)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_MODULE ADD MODULE nvarchar(250)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_BANK_TYPES' AND COLUMN_NAME = 'BANK_NAME')
    BEGIN
        ALTER TABLE SETUP_BANK_TYPES ALTER COLUMN BANK_NAME nvarchar(150)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE SETUP_BANK_TYPES ADD BANK_NAME nvarchar(150)  NULL
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEMS_ROWS' AND COLUMN_NAME = 'REASON_CODE')
    BEGIN
        ALTER TABLE EXPENSE_ITEMS_ROWS ADD REASON_CODE nvarchar(10)  NULL
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EXPENSE_ITEMS_ROWS' AND COLUMN_NAME = 'REASON_NAME')
    BEGIN
        ALTER TABLE EXPENSE_ITEMS_ROWS ADD REASON_NAME nvarchar(250)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_OFFTIME_CONTRACT' AND COLUMN_NAME = 'SYSTEM_PAPER_NO')
    BEGIN
        ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ALTER COLUMN SYSTEM_PAPER_NO nvarchar(50)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ADD SYSTEM_PAPER_NO nvarchar(50)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET' AND COLUMN_NAME = 'ASSET_DESCRIPTION')
    BEGIN
        ALTER TABLE ASSET ALTER COLUMN ASSET_DESCRIPTION nvarchar(max)  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE ASSET ADD ASSET_DESCRIPTION nvarchar(max)  NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_GUARANTYCAT_TIME' AND COLUMN_NAME = 'GUARANTYCAT_TIME')
    BEGIN
        ALTER TABLE SETUP_GUARANTYCAT_TIME ALTER COLUMN GUARANTYCAT_TIME int  NULL
    END
    ELSE
    BEGIN
        ALTER TABLE SETUP_GUARANTYCAT_TIME ADD GUARANTYCAT_TIME int NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EINVOICE_DEFINITION' AND COLUMN_NAME = 'COMP_ID')
    BEGIN
        ALTER TABLE EINVOICE_DEFINITION ALTER COLUMN COMP_ID int NOT NULL
    END
    ELSE
    BEGIN
        ALTER TABLE EINVOICE_DEFINITION ADD COMP_ID int NOT NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PERIOD' AND COLUMN_NAME = 'PERIOD')
    BEGIN
        ALTER TABLE SETUP_PERIOD ALTER COLUMN PERIOD nvarchar(250) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE SETUP_PERIOD ADD PERIOD nvarchar(250) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS_TEMP_WBO' AND COLUMN_NAME = 'HEAD')
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ALTER COLUMN HEAD nvarchar(255) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ADD HEAD nvarchar(255) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS_TEMP_WBO' AND COLUMN_NAME = 'FULL_FUSEACTION')
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ALTER COLUMN FULL_FUSEACTION nvarchar(255) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ADD FULL_FUSEACTION nvarchar(255) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS_TEMP_WBO' AND COLUMN_NAME = 'FUSEACTION_VARIABLE')
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ALTER COLUMN FUSEACTION_VARIABLE nvarchar(255) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ADD FUSEACTION_VARIABLE nvarchar(255) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS_TEMP_WBO' AND COLUMN_NAME = 'FUSEACTION_VARIABLE')
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ALTER COLUMN FUSEACTION_VARIABLE nvarchar(255) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ADD FUSEACTION_VARIABLE nvarchar(255) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS_TEMP_WBO' AND COLUMN_NAME = 'FRIENDLY_URL')
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ALTER COLUMN FRIENDLY_URL nvarchar(255) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ADD FRIENDLY_URL nvarchar(255) NULL
    END

     IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS_TEMP_WBO' AND COLUMN_NAME = 'EVENT_TYPE')
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ALTER COLUMN EVENT_TYPE nvarchar(255) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ADD EVENT_TYPE nvarchar(255) NULL
    END

     IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS_TEMP_WBO' AND COLUMN_NAME = 'OBJECTS_TYPE')
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ALTER COLUMN OBJECTS_TYPE nvarchar(255) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ADD OBJECTS_TYPE nvarchar(255) NULL
    END

     IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS_TEMP_WBO' AND COLUMN_NAME = 'WINDOW')
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ALTER COLUMN WINDOW nvarchar(255) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE WRK_OBJECTS_TEMP_WBO ADD WINDOW nvarchar(255) NULL
    END

     IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_TYPE' AND COLUMN_NAME = 'PRODUCT_TYPE')
    BEGIN
        ALTER TABLE PRODUCT_TYPE ALTER COLUMN PRODUCT_TYPE nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE PRODUCT_TYPE ADD PRODUCT_TYPE nvarchar(50) NULL
    END

     IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_TYPE' AND COLUMN_NAME = 'MY_MONTH')
    BEGIN
        ALTER TABLE PRODUCT_TYPE ALTER COLUMN MY_MONTH nvarchar(50) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE PRODUCT_TYPE ADD MY_MONTH nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER' AND COLUMN_NAME = 'HOMESEMT')
    BEGIN
        ALTER TABLE CONSUMER ALTER COLUMN HOMESEMT nvarchar(150) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE CONSUMER ADD HOMESEMT nvarchar(150) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER' AND COLUMN_NAME = 'TAX_SEMT')
    BEGIN
        ALTER TABLE CONSUMER ALTER COLUMN TAX_SEMT nvarchar(150) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE CONSUMER ADD TAX_SEMT nvarchar(150) NULL
    END


    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_MY' AND COLUMN_NAME = 'PRODUCT_TYPE')
    BEGIN
        ALTER TABLE PRODUCT_MY ALTER COLUMN PRODUCT_TYPE nvarchar(150) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE PRODUCT_MY ADD PRODUCT_TYPE nvarchar(50) NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_MY' AND COLUMN_NAME = 'PRODUCT_NAME')
    BEGIN
        ALTER TABLE PRODUCT_MY ALTER COLUMN PRODUCT_NAME nvarchar(150) NULL
    END
    ELSE
    BEGIN
        ALTER TABLE PRODUCT_MY ADD PRODUCT_NAME nvarchar(50) NULL
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='PROTEIN_WIDGETS')
     BEGIN

      CREATE TABLE [PROTEIN_WIDGETS](	  
          [WIDGET_ID] int NOT NULL IDENTITY(1,1), 
          [SITE] int NOT NULL, 
          [TITLE] nvarchar(140) NULL, 
          [STATUS] int NULL, 
          [WIDGET_NAME] nvarchar(140) NULL, 
          [WIDGET_DATA] nvarchar(16) NULL, 
          [RECORD_DATE] datetime NULL, 
          [RECORD_EMP] int NULL, 
          [RECORD_IP] nvarchar(50) NULL, 
          [UPDATE_DATE] datetime NULL, 
          [UPDATE_EMP] int NULL, 
          [UPDATE_IP] nvarchar(50) NULL, 
          CONSTRAINT [PK_PROTEIN_WIDGETS] PRIMARY KEY ([WIDGET_ID] ASC));

    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='PROTEIN_SITES')
     BEGIN

   CREATE TABLE [PROTEIN_SITES](	  
       [SITE_ID] int NOT NULL IDENTITY(1,1)	, 
       [DOMAIN] nvarchar(250) NOT NULL, 
       [STATUS] int NOT NULL, 
       [MAINTENANCE_MODE] int NOT NULL, 
       [PRIMARY_DATA] nvarchar(16) NULL, 
       [ZONE_DATA] nvarchar(16) NULL, 
       [ACCESS_DATA] nvarchar(16) NULL, 
       [THEME_DATA] nvarchar(16) NULL, 
       [RECORD_DATE] datetime NULL, 
       [RECORD_EMP] int NULL, 
       [RECORD_IP] nvarchar(50) NULL, 
       [UPDATE_DATE] datetime NULL, 
       [UPDATE_EMP] int NULL, 
       [UPDATE_IP] nvarchar(50) NULL, 
       [COMPANY] int NULL, 
       CONSTRAINT [PK_PROTEIN_SITES] PRIMARY KEY ([SITE_ID] ASC));

    END

     IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='PROTEIN_PAGES')
     BEGIN
        CREATE TABLE [PROTEIN_PAGES]
            (
            [PAGE_ID] int NOT NULL IDENTITY(1,1),
                [SITE] int NOT NULL,
                [TITLE] nvarchar(140) NULL,
                [FRIENDLY_URL] nvarchar(140) NULL,
                [TEMPLATE_BODY] int NULL,
                [TEMPLATE_INSIDE] int NULL,
                [STATUS] int NULL,
                [PAGE_DATA] nvarchar(16) NULL,
                [RECORD_DATE] datetime NULL,
                [RECORD_EMP] int NULL,
                [RECORD_IP] nvarchar(50) NULL,
                [UPDATE_DATE] datetime NULL,
                [UPDATE_EMP] int NULL,
                [UPDATE_IP] nvarchar(50) NULL,
                CONSTRAINT [PK_PROTEIN_PAGES] PRIMARY KEY ([PAGE_ID] ASC));
    END
</querytag>