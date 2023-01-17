<!-- Description : subscription_tax_funds Tablosu Oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SUBSCRIPTION_TAX_FUNDS')
    BEGIN
        CREATE TABLE [SUBSCRIPTION_TAX_FUNDS](
            [TAX_FUNDS_ID] [int] IDENTITY(1,1) NOT NULL,
            [TARIFF_ID] [int] NULL,
            [ACCOUNT_CODE] [nvarchar](50) NULL,
            [CAL_METHOD] [int] NULL,
            [NUMBER] [float] NULL,
            [PRICE] [float] NULL,
            [MONEY_TYPE] [nvarchar](25) NULL,
        CONSTRAINT [PK_SUBSCRIPTION_TAX_FUNDS] PRIMARY KEY CLUSTERED 
        (
            [TAX_FUNDS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>