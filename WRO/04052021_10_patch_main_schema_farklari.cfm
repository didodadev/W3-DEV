<!-- Description : 19.12.5.1 patch main şema farkları giderildi
Developer: Uğur Hamurpet
Company : Workcube
Destination: main -->
<querytag>

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_WASTE_COLLECTION_EXPEDITIONS')
    BEGIN
        CREATE TABLE [REFINERY_WASTE_COLLECTION_EXPEDITIONS](	  [WASTE_COLLECTION_EXPEDITIONS_ID] int NOT NULL IDENTITY(1,1)	, [PROCESS_STAGE] int NULL	, [ATS_NO] nvarchar(50) NULL	, [DRIVER_ID] int NULL	, [YRD_DRIVER_ID] int NULL	, [ASSETP_ID] int NULL	, [ASSETP_DORSE_ID] int NULL	, [EXPEDITION_ENTRY_TIME] datetime NULL	, [EXPEDITION_EXIT_TIME] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_WASTE_COLLECTION_EXPEDITIONS] PRIMARY KEY ([WASTE_COLLECTION_EXPEDITIONS_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_GROUPS')
    BEGIN   
        CREATE TABLE [REFINERY_GROUPS](	  [REFINERY_GROUP_ID] int NOT NULL IDENTITY(1,1)	, [GROUP_NAME] nvarchar(250) NULL	, [GROUP_STATUS] bit NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_GROUPS] PRIMARY KEY ([REFINERY_GROUP_ID] ASC));
    END;

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER_BANK' AND COLUMN_NAME = 'CONSUMER_BANK')
    BEGIN
        ALTER TABLE CONSUMER_BANK ALTER COLUMN CONSUMER_BANK nvarchar(75) NULL;
    END
    ELSE
    BEGIN
        ALTER TABLE CONSUMER_BANK ADD CONSUMER_BANK nvarchar(75) NULL;
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER_BANK' AND COLUMN_NAME = 'CONSUMER_SWIFT_CODE')
    BEGIN
        ALTER TABLE CONSUMER_BANK ALTER COLUMN CONSUMER_SWIFT_CODE nvarchar(25) NULL;
    END
    ELSE
    BEGIN
        ALTER TABLE CONSUMER_BANK ADD CONSUMER_SWIFT_CODE nvarchar(25) NULL;
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TEXTILE_SETUP_MONEY')
    BEGIN
        CREATE TABLE [TEXTILE_SETUP_MONEY](	  [MONEY_ID] int NOT NULL	, [MONEY] nvarchar(43) NULL	, [RATE1] float NULL	, [RATE2] float NULL	, [MONEY_STATUS] bit NULL DEFAULT((1))	, [PERIOD_ID] int NULL	, [COMPANY_ID] int NULL	, [ACCOUNT_950] nvarchar(50) NULL	, [PER_ACCOUNT] nvarchar(50) NULL	, [RATE3] float NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(50) NULL	, [RATEPP2] float NULL	, [RATEPP3] float NULL	, [RATEWW2] float NULL	, [RATEWW3] float NULL	, [CURRENCY_CODE] nvarchar(43) NULL	, [DSP_RATE_SALE] float NULL	, [DSP_RATE_PUR] float NULL	, [DSP_UPDATE_DATE] datetime NULL	, [EFFECTIVE_SALE] float NULL	, [EFFECTIVE_PUR] float NULL	, [MONEY_NAME] nvarchar(43) NULL	, [MONEY_SYMBOL] nvarchar(43) NULL	, [DSP_EFFECTIVE_SALE] float NULL	, [DSP_EFFECTIVE_PUR] float NULL);
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_WASTE_OIL')
    BEGIN
        CREATE TABLE [REFINERY_WASTE_OIL](	  [REFINERY_WASTE_OIL_ID] int NOT NULL IDENTITY(1,1)	, [CAR_NUMBER] nvarchar(250) NULL	, [DORSE_PLAKA] nvarchar(50) NULL	, [CONSUMER_ID] int NULL	, [COMPANY_ID] int NULL	, [MEMBER_TYPE] nvarchar(50) NULL	, [DRIVER_PARTNER_ID] int NULL	, [DRIVER_YRD_PARTNER_ID] int NULL	, [BO_NUMBER] nvarchar(50) NULL	, [PRODUCT_ID] int NULL	, [PROPERTY_ID] int NULL	, [CAR_ENTRY_TIME] datetime NULL	, [CAR_ENTRY_KG] float NULL	, [CAR_EXIT_TIME] datetime NULL	, [CAR_EXIT_KG] float NULL	, [PROCESS_STAGE] int NULL	, [GENERAL_PAPER_NO] nvarchar(50) NULL	, [BRANCH_ID] int NULL	, [DEPARTMENT_ID] int NULL	, [LOCATION_ID] int NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [SHIP_ID] int NULL	, [CARRIER_CONSUMER_ID] int NULL	, [CARRIER_COMPANY_ID] int NULL	, [CARRIER_MEMBER_TYPE] nvarchar(50) NULL	, [STOCK_ID] int NULL	, [PRODUCT_MAIN_UNIT_ID] int NULL	, [OUR_COMPANY_ID] int NULL	, [TYPE] int NULL	, CONSTRAINT [PK_REFINERY_WASTE_OIL] PRIMARY KEY ([REFINERY_WASTE_OIL_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_WASTE_OIL_ROW')
    BEGIN
        CREATE TABLE [REFINERY_WASTE_OIL_ROW](	  [REFINERY_WASTE_OIL_ROW_ID] int NOT NULL IDENTITY(1,1)	, [REFINERY_WASTE_OIL_ID] int NULL	, [REFINERY_WASTE_OIL_ROW_TYPE] int NULL	, [REFINERY_WASTE_OIL_ROW_NUMBER] int NULL	, [ASSET_ID] int NULL	, [VALIDITY_START_DATE] datetime NULL	, [VALIDITY_FINISH_DATE] datetime NULL	, [FILE_STATUS] bit NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, CONSTRAINT [PK_REFINERY_WASTE_OIL_ROW] PRIMARY KEY ([REFINERY_WASTE_OIL_ROW_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_LAB_TESTS_ROW')
    BEGIN
        CREATE TABLE [REFINERY_LAB_TESTS_ROW](	  [REFINERY_LAB_TEST_ROW_ID] int NOT NULL IDENTITY(1,1)	, [REFINERY_LAB_TEST_ID] int NULL	, [GROUP_ID] int NULL	, [PARAMETER_ID] int NULL	, [MIN_LIMIT] float NULL	, [MAX_LIMIT] float NULL	, [RESULT_LIMIT] float NULL	, [OPTIONS] nvarchar(50) NULL	, [TEST_METHOD_ID] int NULL	, [UNIT_ID] int NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, CONSTRAINT [PK_REFINERY_LAB_TESTS_ROW] PRIMARY KEY ([REFINERY_LAB_TEST_ROW_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_VISITOR_REGISTER')
    BEGIN
        CREATE TABLE [REFINERY_VISITOR_REGISTER](	  [REFINERY_VISITOR_REGISTER_ID] int NOT NULL IDENTITY(1,1)	, [VISITOR_NAME] nvarchar(250) NULL	, [TC_IDENTITY_NUMBER] nvarchar(250) NULL	, [COMPANY_ID] int NULL	, [CONSUMER_ID] int NULL	, [MEMBER_TYPE] nvarchar(50) NULL	, [CAR_NUMBER] nvarchar(50) NULL	, [SPECIAL_CODE] nvarchar(50) NULL	, [PHONE_NUMBER] nvarchar(50) NULL	, [EMAIL_ADDRESS] nvarchar(50) NULL	, [EMPLOYEE_ID] int NULL	, [VISIT_TIME] datetime NULL	, [VISIT_TIME_EXIT] datetime NULL	, [VISITOR_CART_NUMBER] nvarchar(50) NULL	, [VISITOR_PURPOSE] nvarchar(50) NULL	, [NOTE] nvarchar(50) NULL	, [ISG_ENTRY_TIME] datetime NULL	, [ISG_EXIT_TIME] datetime NULL	, [PROCESS_STAGE] int NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_VISITOR_REGISTER] PRIMARY KEY ([REFINERY_VISITOR_REGISTER_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TEXTILE_SIZE_PROFILE')
    BEGIN
        CREATE TABLE [TEXTILE_SIZE_PROFILE](	  [PROFILEID] int NOT NULL IDENTITY(1,1)	, [HEAD] nvarchar(150) NOT NULL	, [WEIGHTS] nvarchar(250) NULL	, [LENGTHS] nvarchar(250) NULL	, CONSTRAINT [PK_TEXTILE_SIZE_PROFILE] PRIMARY KEY ([PROFILEID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_LAB_TESTS')
    BEGIN
        CREATE TABLE [REFINERY_LAB_TESTS](	  [REFINERY_LAB_TEST_ID] int NOT NULL IDENTITY(1,1)	, [LAB_TEST_ID] int NULL	, [REQUESTING_PERSON] nvarchar(250) NULL	, [LAB_REPORT_NO] nvarchar(250) NULL	, [NUMUNE_DATE] datetime NULL	, [NUMUNE_PERSON] nvarchar(250) NULL	, [NUMUNE_ACCEPT_DATE] datetime NULL	, [NUMUNE_NAME] nvarchar(250) NULL	, [ANALYSE_DATE] datetime NULL	, [ANALYSE_DATE_EXIT] datetime NULL	, [NUMUNE_PLACE] nvarchar(250) NULL	, [DETAIL] nvarchar(250) NULL	, [NUMUNE_POINT] int NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [CONFIRM_EMP] int NULL	, [CONFIRM_DATE] datetime NULL	, [REQUESTING_EMPLOYE_ID] int NULL	, [SAMPLE_EMPLOYEE_ID] int NULL	, [REFINERY_WASTE_OIL_ID] int NULL	, [PROCESS_STAGE] int NULL	, [CONSUMER_ID] int NULL	, [COMPANY_ID] int NULL	, [MEMBER_TYPE] nvarchar(250) NULL	, [OUR_COMPANY_ID] int NULL	, [LOCATION_ID] int NULL	, [DEPARTMENT_ID] int NULL	, [BRANCH_ID] int NULL	, [IS_VALID] bit NULL	, CONSTRAINT [PK_REFINERY_LAB_TESTS] PRIMARY KEY ([REFINERY_LAB_TEST_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_TEST')
    BEGIN
        CREATE TABLE [REFINERY_TEST](	  [REFINERY_TEST_ID] int NOT NULL IDENTITY(1,1)	, [TEST_NAME] nvarchar(250) NULL	, [TEST_COMMENT] nvarchar(2500) NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_ANALYZE] PRIMARY KEY ([REFINERY_TEST_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_ANALYZE_CAT')
    BEGIN
        CREATE TABLE [REFINERY_ANALYZE_CAT](	  [ANALYZE_CAT_ID] int NOT NULL IDENTITY(1,1)	, [ANALYZE_CAT_NAME] nvarchar(250) NULL	, [ANALYZE_CAT_STATUS] bit NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_ANALYZE_CAT] PRIMARY KEY ([ANALYZE_CAT_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_ANALYZE_ROW')
    BEGIN
        CREATE TABLE [REFINERY_ANALYZE_ROW](	  [REFINERY_ANALYZE_ROW_ID] int NOT NULL IDENTITY(1,1)	, [REFINERY_ANALYZE_ID] int NULL	, [ANALYZE_ROW_NAME] nvarchar(250) NULL	, [ANALYZE_ROW_VALUE] nvarchar(250) NULL	, CONSTRAINT [PK_REFINERY_ANALZE_ROW] PRIMARY KEY ([REFINERY_ANALYZE_ROW_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_WASTE_COLLECTION_EXPEDITIONS_ROWS')
    BEGIN
        CREATE TABLE [REFINERY_WASTE_COLLECTION_EXPEDITIONS_ROWS](	  [EXPEDITIONS_ROW_ID] int NOT NULL IDENTITY(1,1)	, [SERVICE_ID] int NULL	, [WASTE_COLLECTION_EXPEDITIONS_ID] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_MEMBER] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_MEMBER] int NULL	, [UPDATE_IP] nvarchar(50) NULL	, CONSTRAINT [PK_REFINERY_WASTE_COLLECTION_EXPEDITIONS_ROWS] PRIMARY KEY ([EXPEDITIONS_ROW_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_TEST_PARAMETERS')
    BEGIN
        CREATE TABLE [REFINERY_TEST_PARAMETERS](	  [REFINERY_TEST_PARAMETER_ID] int NOT NULL IDENTITY(1,1)	, [GROUP_ID] int NULL	, [PARAMETER_NAME] nvarchar(500) NULL	, [PARAMETER_STATUS] bit NULL	, [MIN_LIMIT] float NULL	, [MAX_LIMIT] float NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_ANALYZE_PARAMETERS] PRIMARY KEY ([REFINERY_TEST_PARAMETER_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_TEST_METHODS')
    BEGIN
        CREATE TABLE [REFINERY_TEST_METHODS](	  [REFINERY_TEST_METHOD_ID] int NOT NULL IDENTITY(1,1)	, [REFINERY_GROUP_ID] int NULL	, [REFINERY_TEST_PARAMETER_ID] int NULL	, [TEST_METHOD_NAME] nvarchar(250) NULL	, [TEST_METHOD_STATUS] bit NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_TESTS] PRIMARY KEY ([REFINERY_TEST_METHOD_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_TRANSPORT_ORDERS')
    BEGIN
        CREATE TABLE [REFINERY_TRANSPORT_ORDERS](	  [REFINERY_TRANSPORT_ID] int NOT NULL IDENTITY(1,1)	, [PROCESS_STAGE] int NULL	, [ORDERING_EMPLOYEE_ID] int NULL	, [OPERATOR_EMPLOYEE_ID] int NULL	, [LOCATION_EXIT_ID] int NULL	, [DEPARTMENT_EXIT_ID] int NULL	, [BRANCH_EXIT_ID] int NULL	, [LOCATION_ENTRY_ID] int NULL	, [DEPARTMENT_ENTRY_ID] int NULL	, [BRANCH_ENTRY_ID] int NULL	, [PRODUCT_ID] int NULL	, [UNIT_PRODUCT_ID] int NULL	, [UNIT] nvarchar(50) NULL	, [AMOUNT] float NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [STOCK_ID] int NULL	, [STOCK_RECEIPT_ID] int NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_TRANSPORT_ORDERS] PRIMARY KEY ([REFINERY_TRANSPORT_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_AUTOMATION_MODEL')
    BEGIN
        CREATE TABLE [REFINERY_AUTOMATION_MODEL](	  [MODEL_ID] int NOT NULL IDENTITY(1,1)	, [MODEL_JSON] nvarchar(MAX) NOT NULL	, [STATUS] bit NOT NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_AUTOMATION_MODEL] PRIMARY KEY ([MODEL_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_PRODUCT_OFF')
    BEGIN
        CREATE TABLE [REFINERY_PRODUCT_OFF](	  [REFINERY_PRODUCT_OFF_ID] int NOT NULL IDENTITY(1,1)	, [CAR_NUMBER] nvarchar(250) NULL	, [DESPATCH_NUMBER] nvarchar(250) NULL	, [PRODUCT_NAME] nvarchar(250) NULL	, [BUYER_COMPANY] nvarchar(250) NULL	, [BUYER_COMPANY_ID] int NULL	, [RESPONSIBLE] nvarchar(250) NULL	, [EXIT_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(50) NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_PRODUCT_OFF] PRIMARY KEY ([REFINERY_PRODUCT_OFF_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_TEST_UNITS')
    BEGIN
        CREATE TABLE [REFINERY_TEST_UNITS](	  [REFINERY_UNIT_ID] int NOT NULL IDENTITY(1,1)	, [UNIT_NAME] nvarchar(250) NULL	, [UNIT_STATUS] bit NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_UNITS] PRIMARY KEY ([REFINERY_UNIT_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TEXTILE_MONEY_HISTORY')
    BEGIN
        CREATE TABLE [TEXTILE_MONEY_HISTORY](	  [MONEY_HISTORY_ID] int NOT NULL IDENTITY(1,1)	, [MONEY] nvarchar(43) NULL	, [RATE1] float NULL	, [RATE2] float NULL	, [RATE3] float NULL	, [VALIDATE_DATE] datetime NULL	, [VALIDATE_HOUR] nvarchar(43) NULL	, [VALIDATE_S_HOUR] nvarchar(43) NULL	, [COMPANY_ID] int NULL	, [PERIOD_ID] int NULL	, [RATEPP2] float NULL	, [RATEPP3] float NULL	, [RATEWW2] float NULL	, [RATEWW3] float NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [EFFECTIVE_SALE] float NULL	, [EFFECTIVE_PUR] float NULL);
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='OPERATIONS_STATIONS')
    BEGIN
        CREATE TABLE [OPERATIONS_STATIONS](	  [OPS_ID] int NOT NULL IDENTITY(1,1)	, [OPERATION_TYPE_ID] int NOT NULL	, [STATION_ID] int NOT NULL	, CONSTRAINT [PK_OPERATIONS_STATIONS] PRIMARY KEY ([OPS_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SAMPLING_POINTS')
    BEGIN
        CREATE TABLE [SAMPLING_POINTS](	  [SAMPLING_ID] int NOT NULL IDENTITY(1,1)	, [SAMPLING_POINTS_NAME] nvarchar(250) NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_SAMPLING_POINTS] PRIMARY KEY ([SAMPLING_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TEXTILE_PROCESS_TYPE')
    BEGIN
        CREATE TABLE [TEXTILE_PROCESS_TYPE](	  [PROCESS_CAT_ID] int NULL	, [PROCESS_CAT] nvarchar(150) NULL	, [PROCESS_STATUS] bit NULL	, [OPERATION_RELATIONS] nvarchar(50) NULL);
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_TEST_ROWS')
    BEGIN
        CREATE TABLE [REFINERY_TEST_ROWS](	  [PARAMETER_TEST_ROW_ID] int NOT NULL IDENTITY(1,1)	, [PARAMETER_TEST_ID] int NULL	, [GROUP_ID] int NULL	, [PARAMETER_ID] int NULL	, [MIN_LIMIT] float NULL	, [MAX_LIMIT] float NULL	, [OPTIONS] nvarchar(50) NULL	, [TEST_METHOD_ID] int NULL	, [UNIT_ID] int NULL	, CONSTRAINT [PK_REFINERY_TEST_ROWS] PRIMARY KEY ([PARAMETER_TEST_ROW_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_POST_CARGO')
    BEGIN
        CREATE TABLE [REFINERY_POST_CARGO](	  [REFINERY_POST_CARGO_ID] int NOT NULL IDENTITY(1,1)	, [POST_SENDER] nvarchar(250) NULL	, [POST_SENDER_ID] int NULL	, [POST_BUYER] nvarchar(250) NULL	, [POST_BUYER_ID] int NULL	, [POST_RESPONSIBLE] nvarchar(250) NULL	, [POST_RESPONSIBLE_ID] int NULL	, [POST_TYPE] nvarchar(250) NULL	, [POST_TYPE_ID] int NULL	, [POST_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_REFINERY_POST_CARGO] PRIMARY KEY ([REFINERY_POST_CARGO_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SAMPLE_POINTS')
    BEGIN
        CREATE TABLE [SAMPLE_POINTS](	  [SAMPLE_POINTS_ID] int NOT NULL IDENTITY(1,1)	, [SAMPLING_ID] int NULL	, [SAMPLE_POINTS_DATE_ENTRY] datetime NULL	, [PERIOD] nvarchar(50) NULL	, [SAMPLE_POINTS_REASON] nvarchar(50) NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [OUR_COMPANY_ID] int NULL	, CONSTRAINT [PK_SAMPLE_POINTS] PRIMARY KEY ([SAMPLE_POINTS_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_DATA_SOURCE')
    BEGIN
        CREATE TABLE [WRK_DATA_SOURCE](	  [DATA_SOURCE_ID] int NOT NULL IDENTITY(1,1)	, [DATA_SOURCE_NAME] nvarchar(150) NULL	, [TYPE] int NULL	, [DRIVER] nvarchar(50) NULL	, [IP] nvarchar(50) NULL	, [PORT] int NULL	, [USERNAME] nvarchar(250) NULL	, [PASSWORD] nvarchar(250) NULL	, [DETAILS] nvarchar(MAX) NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, CONSTRAINT [PK_WRK_DATA_SOURCE] PRIMARY KEY ([DATA_SOURCE_ID] ASC));
    END;

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='REFINERY_PRODUCT_ACCEPTENCE')
    BEGIN
        CREATE TABLE [REFINERY_PRODUCT_ACCEPTENCE](	  [REFINERY_PRODUCT_ACCEPTENCE_ID] int NOT NULL IDENTITY(1,1)	, [DESPATCH_NUMBER] nvarchar(250) NULL	, [COMPANY_NAME] nvarchar(250) NULL	, [COMPANY_ID] int NULL	, [ORDER_RESPONSIBLE] nvarchar(250) NULL	, [ORDER_RESPONSIBLE_ID] int NULL	, [RESPONSIBLE] nvarchar(250) NULL	, [RESPONSIBLE_ID] int NULL	, [ACCEPT_DATE] datetime NULL	, [EXIT_DATE] datetime NULL	, [OUR_COMPANY_ID] int NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL);
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OUR_COMPANY_INFO' AND COLUMN_NAME = 'KEP_API_KEY')
    BEGIN
        ALTER TABLE OUR_COMPANY_INFO ADD KEP_API_KEY nvarchar(100) NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OUR_COMPANY_INFO' AND COLUMN_NAME = 'COMPANY_KEP_ADRESS')
    BEGIN
        ALTER TABLE OUR_COMPANY_INFO ADD COMPANY_KEP_ADRESS nvarchar(50) NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OUR_COMPANY_INFO' AND COLUMN_NAME = 'IS_KEP_INTEGRATED')
    BEGIN
        ALTER TABLE OUR_COMPANY_INFO ADD IS_KEP_INTEGRATED int NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OUR_COMPANY' AND COLUMN_NAME = 'KEP_ADRESS')
    BEGIN
        ALTER TABLE OUR_COMPANY ADD KEP_ADRESS nvarchar(50) NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_OFFTIME_CONTRACT' AND COLUMN_NAME = 'RECORD_EMP')
    BEGIN
        ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ALTER COLUMN RECORD_EMP int NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_GUARANTYCAT_TIME' AND COLUMN_NAME = 'GUARANTYCAT_TIME')
    BEGIN
        ALTER TABLE SETUP_GUARANTYCAT_TIME ALTER COLUMN GUARANTYCAT_TIME float NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY' AND COLUMN_NAME = 'IS_PERSON')
    BEGIN
        ALTER TABLE COMPANY ALTER COLUMN IS_PERSON bit NOT NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY' AND COLUMN_NAME = 'USE_EFATURA')
    BEGIN
        ALTER TABLE COMPANY ALTER COLUMN USE_EFATURA bit NOT NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY_HISTORY' AND COLUMN_NAME = 'IS_PERSON')
    BEGIN
        ALTER TABLE COMPANY_HISTORY ALTER COLUMN IS_PERSON bit NOT NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_SSK_EXPORTS' AND COLUMN_NAME = 'IS_4691')
    BEGIN
        ALTER TABLE EMPLOYEES_SSK_EXPORTS ALTER COLUMN IS_4691 bit NOT NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES' AND COLUMN_NAME = 'EMPLOYEE_KEP_ADRESS')
    BEGIN
        ALTER TABLE EMPLOYEES ADD EMPLOYEE_KEP_ADRESS nvarchar(200);
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT' AND COLUMN_NAME = 'MIN')
    BEGIN
        ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT ADD MIN nvarchar(200);
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT' AND COLUMN_NAME = 'MAX')
    BEGIN
        ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT ADD MAX nvarchar(200);
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LIBRARY_ASSET' AND COLUMN_NAME = 'EBOOK_PATH')
    BEGIN
        ALTER TABLE LIBRARY_ASSET ADD EBOOK_PATH nvarchar(500);
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LIBRARY_ASSET' AND COLUMN_NAME = 'IMAGE_PATH')
    BEGIN
        ALTER TABLE LIBRARY_ASSET ADD IMAGE_PATH nvarchar(500);
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LIBRARY_ASSET' AND COLUMN_NAME = 'PRODUCT_ID')
    BEGIN
        ALTER TABLE LIBRARY_ASSET ADD PRODUCT_ID int;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME = 'IS_4691_CONTROL')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ALTER COLUMN IS_4691_CONTROL bit NOT NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'VISITOR_BOOK' AND COLUMN_NAME = 'VISIT_DATE')
    BEGIN
        ALTER TABLE VISITOR_BOOK ALTER COLUMN VISIT_DATE datetime NOT NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY_PARTNER' AND COLUMN_NAME = 'PARTNER_KEP_ADRESS')
    BEGIN
        ALTER TABLE COMPANY_PARTNER ADD PARTNER_KEP_ADRESS nvarchar(250);
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ADDRESSBOOK' AND COLUMN_NAME = 'AB_KEP_ADRESS')
    BEGIN
        ALTER TABLE ADDRESSBOOK ADD AB_KEP_ADRESS nvarchar(250);
    END;

</querytag>