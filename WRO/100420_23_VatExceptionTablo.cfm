<!-- Description : VAT_EXCEPTION Tablosu oluşturuldu.
Developer: Emine Yılmaz
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'VAT_EXCEPTION' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [VAT_EXCEPTION](
        [VAT_EXCEPTION_ID] [int] IDENTITY(1,1) NOT NULL,
        [VAT_EXCEPTION_CODE] [nvarchar](50) NULL,
        [VAT_EXCEPTION_ARTICLE] [nvarchar](50) NULL,
        [VAT_EXCEPTION_DETAIL] [nvarchar](500) NULL,
        [RECORD_DATE] [datetime] NULL,
        [RECORD_EMP] [int] NULL,
        [RECORD_IP] [nvarchar](43) NULL,
        [EXCEPTION_GROUP_CODE] [int] NULL,
    CONSTRAINT [PK__VAT_EXCE__E73F42D991226B7B] PRIMARY KEY CLUSTERED 
    (
        [VAT_EXCEPTION_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]


    END



</querytag>