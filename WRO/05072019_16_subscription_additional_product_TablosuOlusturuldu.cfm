<!-- Description : subscription_additional_product Tablosu Oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SUBSCRIPTION_ADDITIONAL_PRODUCT')
    BEGIN
        CREATE TABLE [SUBSCRIPTION_ADDITIONAL_PRODUCT](
            [ADDITIONAL_ID] [int] IDENTITY(1,1) NOT NULL,
            [TARIFF_ID] [int] NULL,
            [STOCK_ID] [int] NULL,
            [PRODUCT_ID] [int] NULL,
            [CAL_METHOD] [int] NULL,
            [NUMBER] [float] NULL,
            [PRICE_LIST] [int] NULL,
            [SPECIAL_PRICE] [float] NULL,
            [MONEY_TYPE] [nvarchar](25) NULL,
        CONSTRAINT [PK_SUBSCRIPTION_ADDITIONAL_PRODUCT] PRIMARY KEY CLUSTERED 
        (
            [ADDITIONAL_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>