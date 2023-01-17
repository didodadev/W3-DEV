<!-- Description : WoDiBa Tablolar
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WODIBA_BANK_ACCOUNTS' )
    BEGIN
        CREATE TABLE [WODIBA_BANK_ACCOUNTS](
            [WDB_ACCOUNT_ID] [int] IDENTITY(1,1) NOT NULL,
            [STATUS] [bit] NULL,
            [OUR_COMPANY_ID] [int] NOT NULL,
            [ACCOUNT_ID] [int] NOT NULL,
            [API_USER] [nvarchar](50) NULL,
            [API_PASSWORD] [nvarchar](500) NULL,
            [UID] [nvarchar](50) NULL,
            [BANKAKODU] [int] NULL,
            [HESAPTURU] [nvarchar](20) NULL,
            [HESAPNO] [nvarchar](20) NULL,
            [MUSTERINO] [nvarchar](20) NULL,
            [SUBEKODU] [int] NULL,
            [SUBEADI] [nvarchar](50) NULL,
            [DOVIZTURU] [nvarchar](3) NULL,
            [HESAPACILISTARIHI] [datetime] NULL,
            [SONHAREKETTARIHI] [datetime] NULL,
            [BAKIYE] [float] NULL,
            [REC_USER] [int] NULL,
            [REC_DATE] [datetime] NULL,
            [REC_IP] [nvarchar](50) NULL,
            [UPD_USER] [int] NULL,
            [UPD_DATE] [datetime] NULL,
            [UPD_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_WODIBA_BANK_ACCOUNTS] PRIMARY KEY CLUSTERED 
        (
            [WDB_ACCOUNT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WODIBA_BANK_ACTIONS' )
    BEGIN
        CREATE TABLE [WODIBA_BANK_ACTIONS](
            [WDB_ACTION_ID] [int] IDENTITY(1,1) NOT NULL,
            [WDB_ACCOUNT_ID] [int] NOT NULL,
            [PERIOD_ID] [int] NULL,
            [BANK_ACTION_ID] [int] NULL,
            [UID] [nvarchar](50) NULL,
            [BANKAKODU] [int] NULL,
            [HESAPNO] [nvarchar](20) NULL,
            [MUSTERINO] [nvarchar](20) NULL,
            [SUBEKODU] [int] NULL,
            [TARIH] [datetime] NULL,
            [ISL_ID] [nvarchar](50) NULL,
            [DEKONTNO] [nvarchar](50) NULL,
            [KAYNAK] [nvarchar](100) NULL,
            [MIKTAR] [float] NULL,
            [BAKIYE] [float] NULL,
            [DOVIZTURU] [nvarchar](3) NULL,
            [ACIKLAMA] [nvarchar](250) NULL,
            [KARSIVKN] [nvarchar](15) NULL,
            [KARSIIBAN] [nvarchar](35) NULL,
            [ISLEMKODU] [nvarchar](50) NULL,
            [GUNCELLEMETARIHI] [datetime] NULL,
            [ORDER] [int] NULL,
            [WDB_REC_DATE] [datetime] NULL,
        CONSTRAINT [PK_WODIBA_BANK_ACTIONS] PRIMARY KEY CLUSTERED 
        (
            [WDB_ACTION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>