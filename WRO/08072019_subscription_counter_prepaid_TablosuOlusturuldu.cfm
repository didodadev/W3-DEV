<!-- Description : subscription_counter_prepaid Tablosu Oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SUBSCRIPTION_COUNTER_PREPAID')
    BEGIN
        CREATE TABLE [SUBSCRIPTION_COUNTER_PREPAID](
            [SCP_ID] [int] IDENTITY(1,1) NOT NULL,
            [COMPANY_ID] [int] NOT NULL,
            [PROCESS_ROW_ID] [int] NOT NULL,
            [SUBSCRIPTION_ID] [int] NOT NULL,
            [COUNTER_ID] [int] NOT NULL,
            [STOCK_ID] [int] NOT NULL,
            [PRODUCT_ID] [int] NOT NULL,
            [PRODUCT_AMOUNT] [float] NOT NULL,
            [PRODUCT_UNIT_ID] [int] NOT NULL,
            [PRODUCT_UNIT_PRICE] [float] NOT NULL,
            [UNIT_CURRENCY_ID] [nvarchar](50) NOT NULL,
            [COUNTER_LOADING_PRICE] [float] NOT NULL,
            [COUNTER_TOTAL_PRICE] [float] NOT NULL,
            [COUNTER_LOADING_DATE] [datetime] NOT NULL,
            [LOADING_EMPLOYEE_ID] [int] NOT NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_SUBSCRIPTION_COUNTER_PREPAID] PRIMARY KEY CLUSTERED 
        (
            [SCP_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>