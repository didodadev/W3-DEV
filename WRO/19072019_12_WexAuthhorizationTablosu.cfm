<!-- Description : Wex authorization tablosu oluştur
Developer: Botan Kayğan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_WEX_AUTHORIZATION' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
    CREATE TABLE [WRK_WEX_AUTHORIZATION](
        [AUTH_ID] [int] IDENTITY(1,1) NOT NULL,
        [WEX_ID] [int] NULL,
        [SUBSCRIPTION_ID] [int] NULL,
        [COUNTER_ID] [int] NULL,
        [COMPANY_ID] [int] NULL,
        [DOMAIN] [nvarchar](50) NULL,
        [IP] [nvarchar](50) NULL,
        [PASSWORD] [nvarchar](50) NULL,
        [IS_SMS] [int] NULL,
        [RECORD_EMP] [int] NULL,
        [RECORD_DATE] [datetime] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [UPDATE_EMP] [nvarchar](50) NULL,
        [UPDATE_DATE] [datetime] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
    CONSTRAINT [PK_WRK_WEX_AUTHORIZATION] PRIMARY KEY CLUSTERED 
    (
        [AUTH_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END
</querytag>