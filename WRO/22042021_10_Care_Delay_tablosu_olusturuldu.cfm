<!-- Description : CARE_DELAY Tablosu Oluşturuldu.
Developer: Cemil Durgan
Company : Durgan Bilişim
Destination: main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='CARE_DELAY' AND TABLE_SCHEMA = '@_dsn_main_@' )
    BEGIN
        CREATE TABLE [CARE_DELAY](
            [CARE_DELAY_ID] [int] IDENTITY(1,1) NOT NULL,
            [CARE_ID] [int] NULL,
            [CARE_PERIOD_TIME_OLD] [datetime] NULL,
            [CARE_PERIOD_TIME_NEW] [datetime] NULL,
            [CARE_DELAY_CAUSE] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_CARE_DELAY] PRIMARY KEY CLUSTERED 
        (
            [CARE_DELAY_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>