<!-- Description : Anlasmalar Tablosunun Tarihce tablosu WRO'sudur.
Developer: Gulbahar Inan
Company : Workcube
Destination: Company-->
<querytag>   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'RELATED_CONTRACT_HISTORY')
    BEGIN
    CREATE TABLE [RELATED_CONTRACT_HISTORY](
        [CONTRACT_HISTORY_ID] [int] IDENTITY(1,1) NOT NULL,
        [CONTRACT_ID] [int] NOT NULL,
        [TERM] [int] NULL,
        [FOLDER] [nvarchar](150) NULL,
        [CONTRACT_CAT_ID] [nvarchar](50) NULL,
        [STARTDATE] [datetime] NULL,
        [FINISHDATE] [datetime] NULL,
        [CONTRACT_HEAD] [nvarchar](100) NULL,
        [CONTRACT_BODY] [nvarchar](max) NULL,
        [COMPANY] [nvarchar](max) NULL,
        [COMPANY_PARTNER_VALID_NO] [nvarchar](max) NULL,
        [COMPANY_PARTNER_VALID] [nvarchar](max) NULL,
        [COMPANY_PARTNER] [nvarchar](max) NULL,
        [EMPLOYEE] [nvarchar](max) NULL,
        [EMPLOYEE_VALID_NO] [nvarchar](max) NULL,
        [EMPLOYEE_VALID] [nvarchar](max) NULL,
        [CONSUMERS] [nvarchar](max) NULL,
        [CONSUMERS_VALID_NO] [nvarchar](max) NULL,
        [CONSUMERS_VALID] [nvarchar](max) NULL,
        [STATUS] [bit] NULL,
        [EMPLOYEE_VALID_EMP_ID] [nvarchar](max) NULL,
        [COUNTER] [int] NULL,
        [STAGE_ID] [int] NULL,
        [OUR_COMPANY_ID] [int] NULL,
        [COMPANY_ID] [int] NULL,
        [CONSUMER_ID] [int] NULL,
        [CONTRACT_NO] [nvarchar](50) NULL,
        [PAYMENT_TYPE_ID] [int] NULL,
        [CONTRACT_AMOUNT] [float] NULL,
        [CONTRACT_TAX] [float] NULL,
        [CONTRACT_TAX_AMOUNT] [float] NULL,
        [CONTRACT_UNIT_PRICE] [float] NULL,
        [CONTRACT_MONEY] [nvarchar](40) NULL,
        [GUARANTEE_AMOUNT] [float] NULL,
        [GUARANTEE_RATE] [float] NULL,
        [ADVANCE_AMOUNT] [float] NULL,
        [TEVKIFAT_RATE_ID] [int] NULL,
        [TEVKIFAT_RATE] [float] NULL,
        [STOPPAGE_RATE_ID] [int] NULL,
        [STOPPAGE_RATE] [float] NULL,
        [ADVANCE_RATE] [float] NULL,
        [CONTRACT_TYPE] [int] NULL,
        [CONTRACT_CALCULATION] [int] NULL,
        [RECORD_DATE] [datetime] NULL,
        [RECORD_EMP] [int] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [UPDATE_DATE] [datetime] NULL,
        [UPDATE_EMP] [int] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
        [PROJECT_ID] [int] NULL,
        [DISCOUNT_RATE] [float] NULL,
        [CARD_PAYMETHOD_ID] [int] NULL,
        [PAYMETHOD_ID] [int] NULL,
        [DELIVER_DEPT_ID] [int] NULL,
        [LOCATION_ID] [int] NULL,
        [SHIP_METHOD_ID] [int] NULL,
        [ORDER_ID] [nvarchar](max) NULL,
        [STAMP_TAX] [float] NULL,
        [COPY_NUMBER] [int] NULL,
        [STAMP_TAX_RATE] [float] NULL,
        [PROCESS_CAT] [int] NULL,
     CONSTRAINT [PK_RELATED_CONTRACT_HISTORY_CONTRACT_HISTORY_ID] PRIMARY KEY CLUSTERED 
    (
        [CONTRACT_HISTORY_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
</querytag>