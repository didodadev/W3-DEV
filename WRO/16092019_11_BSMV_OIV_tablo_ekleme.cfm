 <!-- Description : Setup_BSMV ve Setup_OIV Tabloları oluşturuldu TAX_CODE_NAME alanı eklendi.
Developer: Ahmet Yolcu
Company : Workcube
Destination: Company-->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SETUP_BSMV')
    BEGIN
    CREATE TABLE [SETUP_BSMV](
        [BSMV_ID] [int] IDENTITY(1,1) NOT NULL,
        [TAX] [float] NULL,
        [DETAIL] [nvarchar](50) NULL,
        [ACCOUNT_CODE] [nvarchar](50) NULL,
        [PURCHASE_CODE] [nvarchar](50) NULL,
        [ACCOUNT_CODE_IADE] [nvarchar](50) NULL,
        [PURCHASE_CODE_IADE] [nvarchar](50) NULL,
        [PERIOD_ID] [int] NULL,
        [TAX_CODE] [nvarchar](50) NULL,
        [RECORD_DATE] [datetime] NULL,
        [RECORD_EMP] [int] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [UPDATE_DATE] [datetime] NULL,
        [UPDATE_EMP] [int] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
    CONSTRAINT [PK_SETUP_BSMV] PRIMARY KEY CLUSTERED 
    (
        [BSMV_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END;

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_SCHEMA = '@_dsn_company_@' and  TABLE_NAME='SETUP_OIV')
    BEGIN
    CREATE TABLE [SETUP_OIV](
        [OIV_ID] [int] IDENTITY(1,1) NOT NULL,
        [TAX] [float] NULL,
        [DETAIL] [nvarchar](50) NULL,
        [ACCOUNT_CODE] [nvarchar](50) NULL,
        [PURCHASE_CODE] [nvarchar](50) NULL,
        [ACCOUNT_CODE_IADE] [nvarchar](50) NULL,
        [PURCHASE_CODE_IADE] [nvarchar](50) NULL,
        [PERIOD_ID] [int] NULL,
        [TAX_CODE] [nvarchar](50) NULL,
        [RECORD_DATE] [datetime] NULL,   
        [RECORD_EMP] [int] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [UPDATE_DATE] [datetime] NULL,
        [UPDATE_EMP] [int] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
    CONSTRAINT [PK_SETUP_OIV] PRIMARY KEY CLUSTERED 
    (
        [OIV_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SETUP_BSMV' AND COLUMN_NAME='TAX_CODE_NAME' )
    BEGIN   
        ALTER TABLE SETUP_BSMV ADD TAX_CODE_NAME NVARCHAR(250) NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SETUP_OIV' AND COLUMN_NAME='TAX_CODE_NAME' )
    BEGIN   
        ALTER TABLE SETUP_OIV ADD TAX_CODE_NAME NVARCHAR(250) NULL 
    END

</querytag>