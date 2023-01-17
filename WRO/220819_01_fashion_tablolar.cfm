 <!-- Description : Fashion Tablolar
Developer: Metin Çakar
Company : N1-Soft
Destination: Company-->
<querytag>
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_ASSORTMENT')
    BEGIN
		CREATE TABLE [TEXTILE_ASSORTMENT](
			[ASSORTMENT_ID] [int] IDENTITY(1,1) NOT NULL,
			[REQUEST_ID] [int] NULL,
			[COMPANY_ID] [int] NULL,
			[PRODUCT_ID] [int] NULL,
			[STOCK_ID] [int] NULL,
			[COLOR_ID] [int] NULL,
			[SIZE_ID] [int] NULL,
			[LEN_ID] [int] NULL,
			[STOCK_AMOUNT] [float] NULL,
			[ASSORTMENT_AMOUNT] [float] NULL,
			[ORDER_ID] [int] NULL,
			[ORDER_ROW_ID] [int] NULL,
			[WRK_ROW_ID] [nvarchar](50) NULL,
			[ORDER_AMOUNT] [float] NULL,
		 CONSTRAINT [PK_TEXTILE_ASSORTMENT] PRIMARY KEY CLUSTERED 
		(
			[ASSORTMENT_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_CAT_SUPLIERS')
    BEGIN
		CREATE TABLE [TEXTILE_CAT_SUPLIERS](
			[TEXTILE_CAT_SUPLIERS_ID] [int] IDENTITY(1,1) NOT NULL,
			[PRODUCT_CATID] [int] NOT NULL,
			[SUPLIERS_ID] [int] NOT NULL,
		 CONSTRAINT [PK_TEXTILE_CAT_SUPLIERS] PRIMARY KEY CLUSTERED 
		(
			[TEXTILE_CAT_SUPLIERS_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_FABRIC')
    BEGIN
		CREATE TABLE [TEXTILE_FABRIC](
			[FABRIC_ID] [int] IDENTITY(1,1) NOT NULL,
			[STRETCHING_TEST_ID] [int] NULL,
			[PROJECT_ID] [int] NULL,
			[OPPORTUNITY_ID] [int] NULL,
			[PURCHASING_ID] [int] NULL,
			[ROLL_NR] [nvarchar](15) NULL,
			[METERING] [float] NULL,
			[HEIGHT_SHRINKAGE] [float] NOT NULL,
			[WIDTH_SHRINKAGE] [float] NOT NULL,
			[SMOOTH] [nvarchar](15) NOT NULL,
			[COLOR] [nvarchar](15) NOT NULL,
			[HEIGHT_COLOR] [float] NOT NULL,
			[WIDTH_COLOR] [float] NOT NULL,
			[IS_SHRINKAGE_REQUEST] [smallint] NOT NULL,
			[RECORD_DATE] [datetime] NOT NULL,
			[RECORD_EMP] [int] NULL,
			[RECORD_IP] [int] NULL,
			[UPDATE_DATE] [datetime] NULL,
			[UPDATE_EMP] [int] NULL,
			[UPDATE_IP] [int] NULL,
			[FABRIC_WIDTH] [float] NULL,
		 CONSTRAINT [PK_TEXTILE_FABRIC] PRIMARY KEY CLUSTERED 
		(
			[FABRIC_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_MEASUREMENT_HEADER')
    BEGIN
		CREATE TABLE [TEXTILE_MEASUREMENT_HEADER](
		[HEADER_ID] [int] IDENTITY(1,1) NOT NULL,
		[REQUEST_ID] [int] NOT NULL,
		[ERATE] [decimal](8, 2) NULL,
		[BRATE] [decimal](8, 2) NULL,
		[PROCDATE] [datetime] NULL,
		 CONSTRAINT [PK_TEXTILE_MEASUREMENT_HEADER] PRIMARY KEY CLUSTERED 
		(
			[HEADER_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_MEASUREMENT_ITEMS')
    BEGIN
		CREATE TABLE [TEXTILE_MEASUREMENT_ITEMS](
			[ITEM_ID] [int] IDENTITY(1,1) NOT NULL,
			[HEADER_ID] [int] NOT NULL,
			[REQUEST_ID] [int] NULL,
			[BOY_ID] [nvarchar](50) NULL,
			[STOCK_ID] [nvarchar](50) NULL,
			[ROW_INDEX] [int] NULL,
			[EBTYPE] [nvarchar](25) NULL,
			[MEASURE_POINT] [nvarchar](150) NULL,
			[SERIAL_INC] [decimal](8, 2) NULL,
			[DESCRIPTION] [nvarchar](400) NULL,
			[TARGET] [decimal](8, 2) NULL,
			[YOI] [decimal](8, 2) NULL,
			[YOG] [decimal](8, 2) NULL,
			[YOF] [decimal](8, 2) NULL,
			[UOG] [decimal](8, 2) NULL,
			[USG] [decimal](8, 2) NULL,
			[USF] [decimal](8, 2) NULL,
		 CONSTRAINT [PK_TEXTILE_MEASUREMENT_ITEMS] PRIMARY KEY CLUSTERED 
		(
			[ITEM_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_MEASUREMENT_ROWS')
    BEGIN
			CREATE TABLE [TEXTILE_MEASUREMENT_ROWS](
					[MeasureID] [int] IDENTITY(1,1) NOT NULL,
					[REQUEST_ID] [int] NOT NULL,
					[STOCK_ID] [int] NULL,
					[Detail] [nvarchar](250) NOT NULL,
					[DetailEN] [nvarchar](250) NULL,
					[Target] [decimal](18, 4) NOT NULL,
					[YOH] [decimal](18, 4) NOT NULL,
					[YOG] [decimal](18, 4) NOT NULL,
					[YOD] [decimal](18, 4) NOT NULL,
					[UOH] [decimal](18, 4) NOT NULL,
					[UOG] [decimal](18, 4) NOT NULL,
					[UOD] [decimal](18, 4) NOT NULL,
					[USH] [decimal](18, 4) NOT NULL,
					[USG] [decimal](18, 4) NOT NULL,
					[USD] [decimal](18, 4) NOT NULL,
				 CONSTRAINT [PK_TEXTILE_MEASUREMENT_ROWS] PRIMARY KEY CLUSTERED 
				(
					[MeasureID] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_PREDEFINED_PROC')
    BEGIN
		CREATE TABLE [TEXTILE_PREDEFINED_PROC](
			[PREDEFINED_ID] [int] IDENTITY(1,1) NOT NULL,
			[PREDEFINED_TITLE] [nvarchar](100) NOT NULL,
			[PREDEFINED_STATUS] [int] NOT NULL,
			[REQUEST_ID] [int] NULL,
		 CONSTRAINT [PK_TEXTILE_PREDEFINED_PROC] PRIMARY KEY CLUSTERED 
		(
			[PREDEFINED_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_PREDEFINED_PROC_ROW')
    BEGIN
		CREATE TABLE [TEXTILE_PREDEFINED_PROC_ROW](
			[PREDEFINED_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
			[PREDEFINED_ID] [int] NOT NULL,
			[STATION_ID] [int] NOT NULL,
		 CONSTRAINT [PK_TEXTILE_PREDEFINED_PROC_ROW] PRIMARY KEY CLUSTERED 
		(
			[PREDEFINED_ROW_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_PRODUCT_PLAN')
    BEGIN
		CREATE TABLE [TEXTILE_PRODUCT_PLAN](
				[PLAN_ID] [int] IDENTITY(1,1) NOT NULL,
				[REQUEST_ID] [int] NULL,
				[PLAN_DATE] [datetime] NULL,
				[START_DATE] [datetime] NULL,
				[FINISH_DATE] [datetime] NULL,
				[ACTIVE] [bit] NULL,
				[PLAN_TYPE_ID] [int] NULL,
				[PLAN_TYPE] [nvarchar](50) NULL,
				[STAGE_ID] [int] NULL,
				[RECORD_DATE] [datetime] NULL,
				[RECORD_EMP] [int] NULL,
				[UPDATE_DATE] [datetime] NULL,
				[UPDATE_EMP] [int] NULL,
				[TASK_EMP] [int] NULL,
				[IS_APPROV] [bit] NULL,
				[WORK_ID] [int] NULL,
				[IS_REVISION] [bit] NULL
			) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_PRODUCTION_OPERATION')
    BEGIN
			CREATE TABLE [TEXTILE_PRODUCTION_OPERATION](
				[P_OPERATION_ID] [int] IDENTITY(1,1) NOT NULL,
				[REQUEST_ID] [int] NULL,
				[P_ORDER_ID] [int] NULL,
				[AMOUNT] [float] NULL,
				[STATION_ID] [int] NULL,
				[OPERATION_TYPE_ID] [int] NULL,
				[STAGE] [int] NULL,
				[O_MINUTE] [float] NULL,
				[RECORD_EMP] [int] NULL,
				[RECORD_DATE] [datetime] NULL,
				[RECORD_IP] [nvarchar](50) NULL,
				[UPDATE_EMP] [int] NULL,
				[UPDATE_DATE] [datetime] NULL,
				[UPDATE_IP] [nvarchar](50) NULL,
				[RELATED_OP_ID] [int] NULL,
				[MAIN_OPERATION_ID] [int] NULL,
				[LINE] [int] NULL,
				[MARJ] [float] NULL,
				[IS_FINISH_LINE] [bit] NULL,
			 CONSTRAINT [PK_TEXTILE_PRODUCTION_OPERATION_P_OPERATION_ID] PRIMARY KEY CLUSTERED 
			(
				[P_OPERATION_ID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_PRODUCTION_OPERATION_MAIN')
    BEGIN
			CREATE TABLE [TEXTILE_PRODUCTION_OPERATION_MAIN](
					[MAIN_OPERATION_ID] [int] IDENTITY(1,1) NOT NULL,
					[PARTY_ID] [int] NULL,
					[AMOUNT] [float] NULL,
					[STATION_ID] [int] NULL,
					[RECORD_EMP] [int] NULL,
					[RECORD_DATE] [datetime] NULL,
					[RECORD_IP] [nvarchar](50) NULL,
					[UPDATE_EMP] [int] NULL,
					[UPDATE_DATE] [datetime] NULL,
					[UPDATE_IP] [nvarchar](50) NULL,
					[REQUEST_ID] [int] NULL,
					[ORDER_ID] [int] NULL,
					[PROJECT_ID] [int] NULL,
					[STATUS] [bit] NULL,
					[LOT_NO] [nvarchar](50) NULL,
					[DETAIL] [nvarchar](1500) NULL,
					[PROD_ORDER_STAGE] [int] NULL,
					[LINE] [int] NULL,
					[IS_SEND] [bit] NULL,
					[P_OPERATION_ID] [int] NULL,
					[MARJ] [float] NULL,
				 CONSTRAINT [PK_TEXTILE_PRODUCTION_OPERATION_MAIN] PRIMARY KEY CLUSTERED 
				(
					[MAIN_OPERATION_ID] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_PRODUCTION_ORDER_RESULTS_MAIN')
    BEGIN
		CREATE TABLE [TEXTILE_PRODUCTION_ORDER_RESULTS_MAIN](
			[PARTY_RESULT_ID] [int] IDENTITY(1,1) NOT NULL,
			[PARTY_RESULT_NO] [nvarchar](50) NULL,
			[PARTY_ID] [int] NULL,
			[PARTY_NO] [nvarchar](50) NULL,
			[RESULT_AMOUNT] [float] NULL
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_PRODUCTION_ORDERS_MAIN')
    BEGIN
		CREATE TABLE [TEXTILE_PRODUCTION_ORDERS_MAIN](
			[PARTY_ID] [int] IDENTITY(1,1) NOT NULL,
			[PARTY_NO] [nvarchar](50) NULL,
			[PARTY_STARTDATE] [datetime] NULL,
			[PARTY_FINISHDATE] [datetime] NULL,
			[STAGE] [int] NULL,
			[PRODUCT_ID] [int] NULL,
			[COLOR_ID] [int] NULL,
			[OPERATION_TYPE_ID] [int] NULL,
			[PARTY_RESULT_ID] [int] NULL,
			[AMOUNT] [float] NULL,
			[RESULT_AMOUNT] [float] NULL,
			[RELATED_PARTY_ID] [int] NULL,
			[ORDER_ID] [int] NULL,
			[PROJECT_ID] [int] NULL,
			[MAIN_OPERATION_ID] [int] NULL,
			[UPDATE_DATE] [datetime] NULL,
			[UPDATE_EMP] [int] NULL,
			[UPDATE_IP] [nvarchar](50) NULL,
			[DETAIL] [nvarchar](1500) NULL,
			[LOT_NO] [nvarchar](50) NULL,
			[STATUS] [bit] NULL,
			[EXIT_DEP_ID] [int] NULL,
			[EXIT_LOC_ID] [int] NULL,
			[PRODUCTION_DEP_ID] [int] NULL,
			[PRODUCTION_LOC_ID] [int] NULL,
			[REQ_ID] [int] NULL,
			[P_OPERATION_ID] [int] NULL,
			[STATION_ID] [int] NULL,
		 CONSTRAINT [PK_TEXTILE_PRODUCTION_ORDERS_MAIN] PRIMARY KEY CLUSTERED 
		(
			[PARTY_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_SAMPLE_REQUEST')
    BEGIN
				CREATE TABLE [TEXTILE_SAMPLE_REQUEST](
					[REQ_ID] [int] IDENTITY(1,1) NOT NULL,
					[REQ_STATUS] [bit] NULL,
					[REQ_CURRENCY_ID] [int] NULL,
					[REQ_STAGE] [int] NULL,
					[COMPANY_ID] [int] NULL,
					[PARTNER_ID] [int] NULL,
					[CONSUMER_ID] [int] NULL,
					[REQ_HEAD] [nvarchar](255) NULL,
					[REQ_DETAIL] [nvarchar](max) NULL,
					[COMMETHOD_ID] [int] NULL,
					[STOCK_ID] [int] NULL,
					[PRODUCT_CAT_ID] [int] NULL,
					[ACTIVITY_TIME] [int] NULL,
					[INCOME] [float] NULL,
					[MONEY] [nvarchar](50) NULL,
					[PROBABILITY] [int] NULL,
					[REQ_DATE] [datetime] NULL,
					[ACTION_DATE] [datetime] NULL,
					[INVOICE_DATE] [datetime] NULL,
					[APPLICATION_LEVEL] [nvarchar](50) NULL,
					[SALES_PARTNER_ID] [int] NULL,
					[SALES_CONSUMER_ID] [int] NULL,
					[CC_POSITIONS] [nvarchar](500) NULL,
					[CC_PAR_IDS] [nvarchar](500) NULL,
					[CC_CON_IDS] [nvarchar](500) NULL,
					[CC_GRP_IDS] [nvarchar](500) NULL,
					[CC_WRKGRP_IDS] [nvarchar](500) NULL,
					[REQ_ZONE] [int] NULL,
					[IS_VIEWED_PAR] [nvarchar](max) NULL,
					[PROJECT_ID] [int] NULL,
					[IS_PROCESSED] [bit] NULL,
					[REQ_NO] [nvarchar](50) NULL,
					[REQ_TYPE_ID] [int] NULL,
					[REF_COMPANY_ID] [int] NULL,
					[REF_PARTNER_ID] [int] NULL,
					[REF_CONSUMER_ID] [int] NULL,
					[REF_EMPLOYEE_ID] [int] NULL,
					[COST] [float] NULL,
					[MONEY2] [nvarchar](50) NULL,
					[SALE_ADD_OPTION_ID] [int] NULL,
					[SERVICE_ID] [int] NULL,
					[SALES_EMP_ID] [int] NULL,
					[SALES_TEAM_ID] [int] NULL,
					[PREFERENCE_REASON_ID] [nvarchar](50) NULL,
					[RIVAL_COMPANY_ID] [int] NULL,
					[RIVAL_PARTNER_ID] [int] NULL,
					[CUS_HELP_ID] [int] NULL,
					[CAMPAIGN_ID] [int] NULL,
					[ADD_RSS] [bit] NULL,
					[RECORD_EMP] [int] NULL,
					[RECORD_PAR] [int] NULL,
					[RECORD_DATE] [datetime] NULL,
					[RECORD_IP] [nvarchar](50) NULL,
					[UPDATE_EMP] [int] NULL,
					[UPDATE_PAR] [int] NULL,
					[UPDATE_DATE] [datetime] NULL,
					[UPDATE_IP] [nvarchar](50) NULL,
					[COUNTRY_ID] [int] NULL,
					[SZ_ID] [int] NULL,
					[EVENT_PLAN_ROW_ID] [int] NULL,
					[PRODUCT_ID] [int] NULL,
					[SHORT_CODE_ID] [int] NULL,
					[SHORT_CODE] [nvarchar](50) NULL,
					[COMPANY_MODEL_NO] [nvarchar](50) NULL,
					[IS_FABRIC_PLAN] [bit] NULL,
					[IS_ACCESSORY_PLAN] [bit] NULL,
					[MEASURE_FILENAME] [nvarchar](50) NULL,
					[COMMISSION] [float] NULL,
					[GYG_FIRE] [float] NULL,
					[CONFIG_PRICE_OTHER] [float] NULL,
					[CONFIG_PRICE_MONEY] [nvarchar](50) NULL,
					[CONFIG_STATUS] [int] NULL,
					[COMPANY_ORDER_NO] [nvarchar](50) NULL,
					[INVOICE_COMPANY_ID] [int] NULL,
					[DESING_EMP_ID] [int] NULL,
				 CONSTRAINT [PK_REQ_ID] PRIMARY KEY CLUSTERED 
				(
					[REQ_ID] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	END;
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TEXTILE_SAMPLE_REQUEST' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'COMMISSION')
    BEGIN
		ALTER TABLE [TEXTILE_SAMPLE_REQUEST] ADD  CONSTRAINT [DF_TEXTILE_SAMPLE_REQUEST_COMMISSION]  DEFAULT ((0)) FOR [COMMISSION]
	END;
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TEXTILE_SAMPLE_REQUEST' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'CONFIG_PRICE_OTHER')
    BEGIN		
		ALTER TABLE [TEXTILE_SAMPLE_REQUEST] ADD  CONSTRAINT [DF_TEXTILE_SAMPLE_REQUEST_CONFIG_PRICE_OTHER]  DEFAULT ((0)) FOR [CONFIG_PRICE_OTHER]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_SAMPLE_REQUEST_IMAGE')
    BEGIN			
		CREATE TABLE [TEXTILE_SAMPLE_REQUEST_IMAGE](
				[IMAGE_ID] [int] IDENTITY(1,1) NOT NULL,
				[REQ_ID] [int] NULL,
				[MEASURE_FILENAME] [nvarchar](250) NULL,
			 CONSTRAINT [PK_TEXTILE_SAMPLE_REQUEST_IMAGE] PRIMARY KEY CLUSTERED 
			(
				[IMAGE_ID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_SAMPLE_REQUEST_MONEY')
    BEGIN	
		CREATE TABLE [TEXTILE_SAMPLE_REQUEST_MONEY](
			[MONEY_TYPE] [nvarchar](43) NULL,
			[ACTION_ID] [int] NULL,
			[RATE2] [float] NULL,
			[RATE1] [float] NULL,
			[IS_SELECTED] [bit] NULL,
			[ACTION_MONEY_ID] [int] IDENTITY(1,1) NOT NULL,
		 CONSTRAINT [PK_SAMPLE_REQUEST_MONEY] PRIMARY KEY CLUSTERED 
		(
			[ACTION_MONEY_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_SR_PROCESS')
    BEGIN
		CREATE TABLE [TEXTILE_SR_PROCESS](
				[ID] [int] IDENTITY(1,1) NOT NULL,
				[REQUEST_ID] [int] NULL,
				[PROCESS] [nvarchar](50) NULL,
				[PROCESS_ID] [int] NULL,
				[DETAIL] [nvarchar](750) NULL,
				[IMAGE_PATH] [nvarchar](250) NULL,
				[PRICE] [float] NULL,
				[MONEY] [nvarchar](50) NULL,
				[PRODUCT_ID] [int] NULL,
				[STOCK_ID] [int] NULL,
				[PRODUCT_CATID] [int] NULL,
				[IS_ORJINAL] [bit] NULL,
				[REVIZE_PRICE] [float] NULL,
				[IS_STATUS] [bit] NULL,
				[IS_REVISION] [bit] NULL,
				[PLAN_ID] [int] NULL,
				[OPERATION_ID] [int] NULL
			) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_SR_PROCESS_TYPE')
    BEGIN
			CREATE TABLE [TEXTILE_SR_PROCESS_TYPE](
				[PROCESS_ID] [int] IDENTITY(1,1) NOT NULL,
				[PROCESS] [nvarchar](50) NULL,
				[DETAIL] [nvarchar](750) NULL,
				[IMAGE_PATH] [nvarchar](250) NULL,
				[PRICE] [float] NULL,
				[PRICE_A] [float] NULL,
				[PRICE_B] [float] NULL,
				[PRICE_C] [float] NULL,
				[MONEY_A] [nvarchar](50) NULL,
				[MONEY_B] [nvarchar](50) NULL,
				[MONEY_C] [nvarchar](50) NULL,
				[WORK_GROUP] [int] NULL
			) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_SR_SUPLIERS')
    BEGIN
			CREATE TABLE [TEXTILE_SR_SUPLIERS](
				[ID] [int] IDENTITY(1,1) NOT NULL,
				[REQ_ID] [int] NULL,
				[COMPANY_ID] [int] NULL,
				[BRAND_ID] [int] NULL,
				[PRODUCT_CATID] [int] NULL,
				[PRODUCT_ID] [int] NULL,
				[STOCK_ID] [int] NULL,
				[PRODUCT_NAME] [nvarchar](500) NULL,
				[UNIT_ID] [int] NULL,
				[UNIT] [nvarchar](50) NULL,
				[ESTIMATED_INCOME] [float] NULL,
				[ESTIMATED_COST] [float] NULL,
				[ESTIMATED_PROFIT] [float] NULL,
				[MONEY_TYPE] [nvarchar](50) NULL,
				[OPERATION_ID] [int] NULL,
				[REQUEST_COMPANY_STOCK] [nvarchar](750) NULL,
				[REQUEST_TYPE] [int] NULL,
				[QUANTITY] [float] NULL,
				[PRICE] [float] NULL,
				[WRK_ROW_ID] [nvarchar](50) NULL,
				[WORK_ID] [int] NULL,
				[IMAGE_PATH] [nvarchar](250) NULL,
				[ROW_DETAIL] [nvarchar](750) NULL,
				[EN] [float] NULL,
				[REVIZE_QUANTITY] [float] NULL,
				[REVIZE_PRICE] [float] NULL,
				[IS_REVISION] [bit] NULL,
				[IS_STATUS] [bit] NULL,
				[PLAN_ID] [int] NULL,
			 CONSTRAINT [PK_SUPPLIERS_ID] PRIMARY KEY CLUSTERED 
			(
				[ID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_STRETCHING_TEST')
    BEGIN
		CREATE TABLE [TEXTILE_STRETCHING_TEST](
			[STRETCHING_TEST_ID] [int] IDENTITY(1,1) NOT NULL,
			[TEST_DATE] [datetime] NOT NULL,
			[AUTHOR_ID] [int] NOT NULL,
			[PROJECT_ID] [int] NULL,
			[OPPORTUNITY_ID] [int] NULL,
			[ORDER_ID] [int] NULL,
			[EMPLOYEE_ID] [int] NOT NULL,
			[PURCHASING_ID] [int] NULL,
			[FABRIC_ARRIVAL_DATE] [datetime] NULL,
			[RECORD_DATE] [datetime] NOT NULL,
			[RECORD_EMP] [int] NULL,
			[RECORD_IP] [int] NULL,
			[UPDATE_DATE] [datetime] NULL,
			[UPDATE_EMP] [int] NULL,
			[UPDATE_IP] [int] NULL,
		 CONSTRAINT [PK_HY_STRETCHING_TESTS] PRIMARY KEY CLUSTERED 
		(
			[STRETCHING_TEST_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_WASH_DEMAND')
    BEGIN
		CREATE TABLE [TEXTILE_WASH_DEMAND](
				[ROW_ID] [int] IDENTITY(1,1) NOT NULL,
				[WASH_TYPE] [int] NULL,
				[WASH_VALUE] [int] NULL,
				[PLAN_ID] [int] NULL,
				[REQUEST_ID] [int] NULL,
				[PRICE] [float] NULL,
				[RECORD_DATE] [datetime] NULL,
				[RECORD_EMP] [int] NULL,
				[UPDATE_DATE] [datetime] NULL,
				[UPDATE_EMP] [int] NULL
			) ON [PRIMARY]
	END;
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='TEXTILE_WASH_TYPE')
    BEGIN
			CREATE TABLE [TEXTILE_WASH_TYPE](
				[WASH_ID] [int] IDENTITY(1,1) NOT NULL,
				[WASH_DETAIL] [nvarchar](500) NULL,
				[WASH_TYPE_ID] [int] NULL,
				[WASH_TYPE] [nvarchar](50) NULL,
				[A_PRICE] [float] NULL,
				[B_PRICE] [float] NULL,
				[C_PRICE] [float] NULL,
			 CONSTRAINT [PK_TEXTILE_WASH_TYPE] PRIMARY KEY CLUSTERED 
			(
				[WASH_ID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
	END;
</querytag>	