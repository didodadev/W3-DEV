<!-- Description : subscription_tariff Tablosu Oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SUBSCRIPTION_TARIFF')
    BEGIN
        CREATE TABLE [SUBSCRIPTION_TARIFF](
            [TARIFF_ID] [int] IDENTITY(1,1) NOT NULL,
            [TARIFF_NAME] [nvarchar](255) NULL,
            [STOCK_ID] [int] NULL,
            [PRODUCT_ID] [int] NULL,
            [PRODUCT_UNIT_ID] [int] NULL,
            [PRODUCT_UNIT] [nvarchar](25) NULL,
            [PRICE_LIST] [int] NULL,
            [TARIFF_PRICE] [float] NULL,
            [MONEY_TYPE] [nvarchar](25) NULL,
            [IS_ACTIVE] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_SUBSCRIPTION_TARIFF] PRIMARY KEY CLUSTERED 
        (
            [TARIFF_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>