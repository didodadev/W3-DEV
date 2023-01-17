<!-- Description : Tedavi Fiyatları tablosu oluşturuldu
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'COMPLAINT_PRICE' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [COMPLAINT_PRICE](
            [COMPLAINT_PRICE_ID] [int] IDENTITY(1,1) NOT NULL,
            [COMPLAINT_ID] [int] NULL,
            [HEALTH_PRICE_PROTOCOL_ID] [int] NULL,
            [COMPLAINT_PRICE] [float] NULL,
            [COMPLAINT_PRICE_MONEY] [nvarchar](10) NULL,
            [PRICE_START_DATE] [datetime] NULL,
            [DISCOUNT_RATE] [float] NULL,
            [UPDATE_DATE] [nvarchar](43) NULL,
            [UPDATE_IP] [int] NULL,
            [UPDATE_EMP] [bigint] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](43) NULL,
            [COMPLAINT_TAX_RATE] [float] NULL,
            [PRODUCT_ID] [int] NULL,
            [COMPANY_ID] [int] NULL,
        CONSTRAINT [PK__COMPLAIN__75E836010BBFCDDE] PRIMARY KEY CLUSTERED 
        (
            [COMPLAINT_PRICE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>
