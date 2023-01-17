<!-- Description : Offer tablosuna revision_offer_id eklendi ve puanlama tablosu oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OFFER' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'REVISION_OFFER_ID')
    BEGIN
        ALTER TABLE OFFER ADD 
		REVISION_OFFER_ID int NULL
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OFFER' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'REVISION_NUMBER')
    BEGIN
        ALTER TABLE OFFER ADD 
		REVISION_NUMBER int NULL
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PURCHASE_TECHNICAL_POINT' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        CREATE TABLE [PURCHASE_TECHNICAL_POINT](
            [TECHNICAL_POINT_ID] [int] IDENTITY(1,1) NOT NULL,
            [OFFER_ID] [int] NULL,
            [FOR_OFFER_ID] [int] NULL,
            [PRODUCT_ID] [int] NULL,
            [COMPANY_ID] [int] NULL,
            [TECHNICAL_POINT] [int] NULL,
            [TECHNICAL_DESCRIPTION] [nvarchar](250) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_PURCHASE_TECHNICAL_POINT] PRIMARY KEY CLUSTERED 
        (
            [TECHNICAL_POINT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>