CREATE TABLE [@_dsn_company_@].[TEXTILE_CUTPLAN_SIZE](	  [CUTPLAN_SIZEID] int NOT NULL IDENTITY(1,1)	, [CUTPLAN_ID] int NOT NULL	, [CUTPLAN_ROWID] int NULL	, [SIZE] nvarchar(20) NOT NULL	, [WEIGHT] nvarchar(20) NOT NULL	, [CUT_AMOUNT] int NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, CONSTRAINT [PK_TEXTILE_CUTPLAN_SIZE] PRIMARY KEY ([CUTPLAN_SIZEID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_CUTSTRETCH_HEAD](	  [CUTSTRETCH_ID] int NOT NULL IDENTITY(1,1)	, [CUTACTUAL_ID] int NULL	, [PROJECT_ID] int NULL	, [MARKER_NAME] nvarchar(50) NULL	, [MARKER_HEIGHT] decimal(8,2) NULL	, [STRETCHING_TEST_ID] int NULL	, [RECORD_DATE] datetime NOT NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(20) NULL	, CONSTRAINT [PK_TEXTILE_CUTSTRETCH] PRIMARY KEY ([CUTSTRETCH_ID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_CUTACTUAL_ROW](	  [CUTACTUAL_ROWID] int NOT NULL IDENTITY(1,1)	, [CUTACTUAL_ID] int NOT NULL	, [MARKER_NAME] nvarchar(50) NULL	, [MARKER_OUTPUT] nvarchar(50) NULL	, [CUTACTUAL_NAME] nvarchar(50) NULL	, [MARKER_HEIGHT] decimal(8,2) NULL	, [LAYER_AMOUNT] int NULL	, [ASSORTMENT_SIZE_AMOUNT] int NULL	, [NET_MARKER_METER] decimal(8,2) NULL	, [GROSS_MARKER_HEIGHT] decimal(8,2) NULL	, [GROSS_MARKER_METER] decimal(8,2) NULL	, [MARKER_UNIT_METER] decimal(8,2) NULL	, [PRODUCTIVITY] decimal(8,2) NULL	, [AFTER_CUT_METER] decimal(8,2) NULL	, [MARKER_WIDTH] decimal(8,2) NULL	, [DRAFT_COLOR] nvarchar(50) NULL	, [DRAFT_WIDTH] decimal(8,2) NULL	, [DRAFT_HEIGHT] decimal(8,2) NULL	, [METO_COLOR] nvarchar(50) NULL	, [CUT_AMOUNT] int NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, CONSTRAINT [PK_TEXTILE_CUTACTUAL_ROW] PRIMARY KEY ([CUTACTUAL_ROWID] ASC));
CREATE TABLE [@_dsn_company_@].[PRODUCTION_ORDER_RESULTS_MAIN](	  [PARTY_RESULT_ID] int NOT NULL IDENTITY(1,1)	, [PARTY_RESULT_NO] nvarchar(50) NULL	, [PARTY_ID] int NULL	, [PARTY_NO] nvarchar(50) NULL);
CREATE TABLE [@_dsn_company_@].[MONEY_HISTORY](	  [MONEY_HISTORY_ID] int NOT NULL IDENTITY(1,1)	, [MONEY] nvarchar(43) NULL	, [RATE1] float NULL	, [RATE2] float NULL	, [RATE3] float NULL	, [VALIDATE_DATE] datetime NULL	, [VALIDATE_HOUR] nvarchar(43) NULL	, [VALIDATE_S_HOUR] nvarchar(43) NULL	, [COMPANY_ID] int NULL	, [PERIOD_ID] int NULL	, [RATEPP2] float NULL	, [RATEPP3] float NULL	, [RATEWW2] float NULL	, [RATEWW3] float NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [EFFECTIVE_SALE] float NULL	, [EFFECTIVE_PUR] float NULL	, CONSTRAINT [PK_MONEY_HISTORY_MONEY_HISTORY_ID] PRIMARY KEY ([MONEY_HISTORY_ID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_CUTPLAN_ROW](	  [CUTPLAN_ROWID] int NOT NULL IDENTITY(1,1)	, [CUTPLAN_ID] int NOT NULL	, [MARKER_NAME] nvarchar(50) NULL	, [MARKER_OUTPUT] nvarchar(50) NULL	, [CUTPLAN_NAME] nvarchar(50) NULL	, [MARKER_HEIGHT] decimal(8,2) NULL	, [LAYER_AMOUNT] int NULL	, [ASSORTMENT_SIZE_AMOUNT] int NULL	, [NET_MARKER_METER] decimal(8,2) NULL	, [GROSS_MARKER_HEIGHT] decimal(8,2) NULL	, [GROSS_MARKER_METER] decimal(8,2) NULL	, [MARKER_UNIT_METER] decimal(8,2) NULL	, [PRODUCTIVITY] decimal(8,2) NULL	, [AFTER_CUT_METER] decimal(8,2) NULL	, [MARKER_WIDTH] decimal(8,2) NULL	, [DRAFT_COLOR] nvarchar(50) NULL	, [DRAFT_WIDTH] decimal(8,2) NULL	, [DRAFT_HEIGHT] decimal(8,2) NULL	, [METO_COLOR] nvarchar(50) NULL	, [CUT_AMOUNT] int NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, CONSTRAINT [PK_TEXTILE_CUTPLAN_ROW] PRIMARY KEY ([CUTPLAN_ROWID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_CUSTOMER_VALUES](	  [VALUE_ID] int NOT NULL IDENTITY(1,1)	, [CUSTOMER_VALUE] nvarchar(25) NOT NULL	, [GYG_RATE] float NOT NULL	, [DATETIME] datetime NOT NULL DEFAULT(getdate())	, [IS_ACTIVE] bit NOT NULL DEFAULT((1))	, CONSTRAINT [PK_TEXTILE_CUSTOMER_VALUES] PRIMARY KEY ([VALUE_ID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_STRETCHING_TEST_GROUP](	  [STRETCHING_TEST_GROUPID] int NOT NULL IDENTITY(1,1)	, [STRETCHING_TEST_ID] int NOT NULL	, [GROUP_NAME] nvarchar(50) NOT NULL	, [WIDTH] decimal(8,2) NULL	, [HEIGHT] decimal(8,2) NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, CONSTRAINT [PK_STRETCHING_TEST_GROUP] PRIMARY KEY ([STRETCHING_TEST_GROUPID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_CUTSTRETCH_ROW](	  [CUTSTRETCH_ROWID] int NOT NULL IDENTITY(1,1)	, [CUTSTRETCH_ID] int NOT NULL	, [ROLL_NO] nvarchar(25) NULL	, [COLOR] nvarchar(25) NULL	, [MARKER] nvarchar(25) NULL	, [STRETCH_AMOUNT1] int NULL	, [STRETCH_AMOUNT2] int NULL	, [UNDEMAND_SPILL_METER] decimal(8,2) NULL	, [FLAW_METER] decimal(8,2) NULL	, [ADDITIONAL_METER] decimal(8,2) NULL	, [CLASSIFICATION_METER] decimal(8,2) NULL	, [MISSING_ROLL] int NULL	, [WAYBILL_METER] decimal(8,2) NULL	, [STRETCH_METER] decimal(8,2) NULL	, [RECORD_DATE] datetime NOT NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, CONSTRAINT [PK_CUTSTRETCH_ROW] PRIMARY KEY ([CUTSTRETCH_ROWID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_WASHING_RECEPIE_HEAD](	  [WASHING_RECEPIE_ID] int NOT NULL IDENTITY(1,1)	, [ORDER_ID] nvarchar(150) NULL	, [PROJECT_ID] int NULL	, [STATION_ID] int NULL	, [EMPLOYEE_ID] int NULL	, [RESULT_ID] int NULL	, [APPROVED] int NULL	, [STATUS] int NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(20) NULL	, CONSTRAINT [PK_TEXTILE_WASHING_RECEPIE_HEAD] PRIMARY KEY ([WASHING_RECEPIE_ID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_STRETCHING_TEST_HEAD](	  [STRETCHING_TEST_ID] int NOT NULL IDENTITY(1,1)	, [STAGE_ID] int NULL	, [TEST_DATE] datetime NOT NULL	, [FABRIC_ARRIVAL_DATE] datetime NULL	, [PROJECT_ID] int NULL	, [REQ_ID] int NULL	, [ORDER_ID] int NULL	, [WAYBILL] nvarchar(15) NULL	, [EMP_ID] int NULL	, [WASHING_ID] int NULL	, [PRODUCTION_ORDERID] int NULL	, [REQUIRED_FABRIC_METER] decimal(18,2) NULL	, [NOTES] nvarchar(MAX) NULL	, [START_DATE] datetime NULL	, [FINISH_DATE] datetime NULL	, [DOCU_FILE] nvarchar(150) NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(20) NULL	, CONSTRAINT [PK_TEXTILE_STRECHING_TEST_HEAD] PRIMARY KEY ([STRETCHING_TEST_ID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_STRETCHING_TEST_ROWS](	  [STRETCHING_TEST_ROWID] int NOT NULL IDENTITY(1,1)	, [STRETCHING_TEST_ID] int NOT NULL	, [PRODUCT_ID] int NULL	, [ROLL_ID] nvarchar(50) NULL	, [ROLL_METER] decimal(8,2) NULL	, [ROLL_TEST_METER] decimal(8,2) NULL	, [FABRIC_WIDTH] decimal(8,2) NULL	, [HEIGHT_SHRINKAGE] decimal(8,2) NULL	, [WIDTH_SHRINKAGE] decimal(8,2) NULL	, [SMOOTH] decimal(8,2) NULL	, [COLOR_LOT] nvarchar(20) NULL	, [COLOR_NAME] nvarchar(30) NULL	, [DESC_ONE] nvarchar(500) NULL	, [DESC_TWO] nvarchar(500) NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, CONSTRAINT [PK_STRETCHING_TEST_ROWS] PRIMARY KEY ([STRETCHING_TEST_ROWID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_CUTACTUAL_HEAD](	  [CUTACTUAL_ID] int NOT NULL IDENTITY(1,1)	, [SOURCEPLAN_ID] int NULL	, [COMPANY_ID] int NULL	, [ORDER_ID] int NULL	, [STAGE_ID] int NULL	, [FABRIC_NAME] nvarchar(150) NULL	, [PLAN_UNIT_METER] decimal(8,2) NULL	, [PLAN_ARRIVAL_METER] decimal(8,2) NULL	, [PLAN_METER] decimal(8,2) NULL	, [MARKER_METER] decimal(8,2) NULL	, [ROLL_AMOUNT] int NULL	, [PIECE_COUNT] int NULL	, [TOTAL_PIECE_COUNT] int NULL	, [MARKER_SIZE] decimal(8,2) NULL	, [MARGIN] decimal(8,2) NULL	, [STRETCHING_TEST_ID] int NULL	, [PLAN_DATE] datetime NULL	, [EMP_ID] int NULL	, [START_DATE] datetime NULL	, [FINISH_DATE] datetime NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(20) NULL	, CONSTRAINT [PK_TEXTILE_CUTACTUAL_HEAD] PRIMARY KEY ([CUTACTUAL_ID] ASC));
CREATE TABLE [@_dsn_company_@].[PRODUCTION_ORDERS_MAIN](	  [PARTY_ID] int NOT NULL IDENTITY(1,1)	, [PARTY_NO] nvarchar(50) NULL	, [PARTY_STARTDATE] datetime NULL	, [PARTY_FINISHDATE] datetime NULL	, [STAGE] int NULL	, [PRODUCT_ID] int NULL	, [COLOR_ID] int NULL	, [OPERATION_TYPE_ID] int NULL	, [PARTY_RESULT_ID] int NULL	, [AMOUNT] float NULL	, [RESULT_AMOUNT] float NULL	, [RELATED_PARTY_ID] int NULL	, [ORDER_ID] int NULL	, [PROJECT_ID] int NULL	, CONSTRAINT [PK_PRODUCTION_ORDERS_MAIN] PRIMARY KEY ([PARTY_ID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_SR_PLUS](	  [REQ_ID] int NULL	, [PLUS_ID] int NOT NULL IDENTITY(1,1)	, [PLUS_DATE] datetime NULL	, [COMMETHOD_ID] int NULL	, [PARTNER_ID] int NULL	, [EMPLOYEE_ID] int NULL	, [PLUS_CONTENT] nvarchar(MAX) NULL	, [OPP_ZONE] int NULL	, [MAIL_SENDER] nvarchar(250) NULL	, [PLUS_SUBJECT] nvarchar(100) NULL	, [MAIL_CC] nvarchar(250) NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [RECORD_PAR] int NULL	, [UPDATE_PAR] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(50) NULL	, [IS_EMAIL] bit NULL	, CONSTRAINT [PK_REQ_PLUS_PLUS_ID] PRIMARY KEY ([PLUS_ID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_CUTPLAN_HEAD](	  [CUTPLAN_ID] int NOT NULL IDENTITY(1,1)	, [COMPANY_ID] int NULL	, [ORDER_ID] int NULL	, [STAGE_ID] int NULL	, [FABRIC_NAME] nvarchar(150) NULL	, [PLAN_UNIT_METER] decimal(8,2) NULL	, [PLAN_ARRIVAL_METER] decimal(8,2) NULL	, [PLAN_METER] decimal(8,2) NULL	, [MARKER_METER] decimal(8,2) NULL	, [ROLL_AMOUNT] int NULL	, [PIECE_COUNT] int NULL	, [TOTAL_PIECE_COUNT] int NULL	, [MARKER_SIZE] decimal(8,2) NULL	, [MARGIN] decimal(8,2) NULL	, [STRETCHING_TEST_ID] int NULL	, [PLAN_DATE] datetime NULL	, [EMP_ID] int NULL	, [START_DATE] datetime NULL	, [FINISH_DATE] datetime NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(20) NULL	, CONSTRAINT [PK_TEXTILE_CUTPLAN_HEAD] PRIMARY KEY ([CUTPLAN_ID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_WASHING_RECEPIE_ROW](	  [WASHING_RECEPIE_ROWID] int NOT NULL IDENTITY(1,1)	, [WASHING_RECEPIE_ID] int NULL	, [STOCK_ID] int NULL	, [AMOUNT] decimal(8,2) NULL	, [PRODUCT_NAME] nvarchar(100) NULL	, CONSTRAINT [PK_WASHING_RECEPIE_ROW] PRIMARY KEY ([WASHING_RECEPIE_ROWID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_CUTACTUAL_SIZE](	  [CUTACTUAL_SIZEID] int NOT NULL IDENTITY(1,1)	, [CUTACTUAL_ID] int NOT NULL	, [CUTACTUAL_ROWID] int NULL	, [SIZE] nvarchar(20) NOT NULL	, [WEIGHT] nvarchar(20) NOT NULL	, [CUT_AMOUNT] int NULL	, [RECORD_DATE] datetime NOT NULL DEFAULT(getdate())	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(20) NULL	, CONSTRAINT [PK_TEXTILE_CUTACTUAL_SIZE] PRIMARY KEY ([CUTACTUAL_SIZEID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_STATION_PROCESS](	  [STATION_PROCESS_ID] int NOT NULL IDENTITY(1,1)	, [STATION_ID] int NOT NULL	, [PROCESS_CAT] nvarchar(50) NOT NULL	, [PROCESS_NAME] nvarchar(50) NOT NULL	, [ACTIVE] bit NOT NULL DEFAULT((0))	, CONSTRAINT [PK_TEXTILE_STATION_PROCESS] PRIMARY KEY ([STATION_PROCESS_ID] ASC));
CREATE TABLE [@_dsn_company_@].[PRODUCTION_OPERATION_RESULT_MAIN](	  [MAIN_RESULT_ID] int NOT NULL IDENTITY(1,1)	, [PARTY_ID] int NULL	, [OPERATION_ID] int NULL	, [STATION_ID] int NULL	, [REAL_AMOUNT] float NULL	, [LOSS_AMOUNT] float NULL	, [REAL_TIME] float NULL	, [WAIT_TIME] float NULL	, [RECORD_EMP] int NULL	, [RECORD_DATE] datetime NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_EMP] int NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_IP] nvarchar(50) NULL	, [ACTION_EMPLOYEE_ID] int NULL	, CONSTRAINT [PK_PRODUCTION_OPERATION_RESULT_MAIN] PRIMARY KEY ([MAIN_RESULT_ID] ASC));
CREATE TABLE [@_dsn_company_@].[TEXTILE_PRODUCT_TREE](	  [TREE_ID] int NOT NULL IDENTITY(1,1)	, [REQUEST_ID] int NOT NULL	, [PRODUCT_ID] int NOT NULL	, [PROCESS_STAGE] int NOT NULL	, CONSTRAINT [PK_TEXTILE_PRODUCT_TREE] PRIMARY KEY ([TREE_ID] ASC));