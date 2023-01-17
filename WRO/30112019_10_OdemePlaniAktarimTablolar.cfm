<!--Description : Ödeme Planı Aktarım Tablolar
Developer: Tolga SÜTLÜ
Company : Devonomy
Destination: Company-->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SETUP_PAYMENT_PLAN_IMPORT_TYPE')
    BEGIN
        CREATE TABLE [SETUP_PAYMENT_PLAN_IMPORT_TYPE](
        [IMPORT_TYPE_ID] [int] IDENTITY(1,1) NOT NULL,
        [IMPORT_TYPE_NAME] [nvarchar](50) NULL,
        [SUBSCRIPTION_TYPE_ID] [int] NULL,
        [IMPORT_TYPE] [int] NULL,
        [PAYMETHOD_ID] [int] NULL,
        [PRODUCT_ID] [int] NULL,
        [STOCK_ID] [int] NULL,
        [DETAIL] [nvarchar](250) NULL,
        [IS_PAYMENT_DATE] [bit] NULL,
        [USE_PRODUCT_PRICE] [bit] NULL,
        [USE_PRODUCT_REASON_CODE] [bit] NULL,
        [USE_PRODUCT_TAX] [bit] NULL,
        [USE_PRODUCT_PAYMETHOD] [bit] NULL,
        [IS_COLLECTED_INVOICE] [bit] NULL,
        [IS_GROUP_INVOICE] [bit] NULL,
        [IS_ROW_DESCRIPTION] [bit] NULL,
        [IS_ALLOW_ZERO_PRICE] [bit] NULL,
        [CFC_FILE] [nvarchar](50) NULL,
        [TYPE_DESCRIPTION] [nvarchar](max) NULL,
        [RECORD_EMP] [int] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [RECORD_DATE] [datetime] NULL,
        [UPDATE_EMP] [int] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
        [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_SETUP_PAYMENT_PLAN_IMPORT_TYPE_IMPORT_TYPE_ID] PRIMARY KEY CLUSTERED 
        (
            [IMPORT_TYPE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;


    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SUBSCRIPTION_PAYMENT_PLAN_IMPORT')
    BEGIN
        CREATE TABLE [SUBSCRIPTION_PAYMENT_PLAN_IMPORT](
            [SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ID] [int] IDENTITY(1,1) NOT NULL,
            [IMPORT_TYPE_ID] [int] NULL,
            [IMPORT_NAME] [nvarchar](100) NULL,
            [FILE_PATH] [nvarchar](500) NULL,
            [FILE_NAME] [nvarchar](50) NULL,
            [PAYMENT_DATE] [datetime] NULL,
            [START_DATE] [datetime] NULL,
            [FINISH_DATE] [datetime] NULL,
            [IMPORT_DESCRIPTION] [nvarchar](500) NULL,
            [ROW_DESCRIPTION] [nvarchar](100) NULL,
            [CONVERT_SUBSCRIPTION_PAYMENT_PLAN] [bit] NULL,
            [PAYMETHOD_ID] [int] NULL,
            [PROCESS_STAGE] [int] NULL,
            [PERIOD] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_SUBSCRIPTION_PAYMENT_PLAN_SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ID] PRIMARY KEY CLUSTERED 
        (
            [SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ROW')
    BEGIN
        CREATE TABLE [SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ROW](
            [SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
            [SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ID] [int] NULL,
            [SUBSCRIPTION_ID] [int] NULL,
            [STOCK_ID] [int] NULL,
            [PRODUCT_ID] [int] NULL,
            [PERIOD_ID] [int] NULL,
            [PAYMENT_DATE] [datetime] NULL,
            [PAYMENT_FINISH_DATE] [datetime] NULL,
            [DETAIL] [nvarchar](100) NULL,
            [UNIT] [nvarchar](50) NULL,
            [AMOUNT] [float] NULL,
            [MONEY_TYPE] [nvarchar](43) NULL,
            [ROW_TOTAL] [float] NULL,
            [DISCOUNT] [float] NULL,
            [ROW_NET_TOTAL] [float] NULL,
            [IS_COLLECTED_INVOICE] [bit] NULL,
            [IS_BILLED] [bit] NULL,
            [IS_PAID] [bit] NULL,
            [IS_COLLECTED_PROVISION] [bit] NULL,
            [UNIT_ID] [int] NULL,
            [PAYMETHOD_ID] [int] NULL,
            [CARD_PAYMETHOD_ID] [int] NULL,
            [SUBS_REFERENCE_ID] [int] NULL,
            [IS_GROUP_INVOICE] [bit] NULL,
            [IS_INVOICE_IPTAL] [bit] NULL,
            [DUE_DIFF_ID] [int] NULL,
            [SERVICE_ID] [int] NULL,
            [CALL_ID] [int] NULL,
            [ROW_DESCRIPTION] [nvarchar](200) NULL,
            [IS_ACTIVE] [bit] NULL,
            [CAMPAIGN_ID] [int] NULL,
            [CARI_ACTION_ID] [int] NULL,
            [CARI_PERIOD_ID] [int] NULL,
            [CARI_ACT_TYPE] [int] NULL,
            [CARI_ACT_TABLE] [nvarchar](50) NULL,
            [CARI_ACT_ID] [int] NULL,
            [QUANTITY] [float] NULL,
            [DISCOUNT_AMOUNT] [float] NULL,
            [CAMP_ID] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [INVOICE_DATE] [datetime] NULL,
            [DUE_DIFF_INVOICE_ID] [int] NULL,
            [DUE_DIFF_PERIOD_ID] [int] NULL,
            [RATE] [float] NULL,
            [BSMV_RATE] [float] NULL,
            [BSMV_AMOUNT] [float] NULL,
            [OIV_RATE] [float] NULL,
            [OIV_AMOUNT] [float] NULL,
            [TEVKIFAT_RATE] [float] NULL,
            [TEVKIFAT_AMOUNT] [float] NULL,
            [REASON_CODE] [nvarchar](max) NULL,
            [ROW_RESULT] [bit] NULL,
            [ROW_RESULT_MESSAGE] [nvarchar](500) NULL,
        CONSTRAINT [PK_SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ROW_SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ROW_ID] PRIMARY KEY CLUSTERED 
        (
            [SUBSCRIPTION_PAYMENT_PLAN_IMPORT_ROW_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;

</querytag>