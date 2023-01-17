<!-- Description : WORKNET_RELATION_COMPANY Tablosu oluşturuldu.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WORKNET_RELATION_COMPANY' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [WORKNET_RELATION_COMPANY](
            [ID] [int] IDENTITY(1,1) NOT NULL,
            [WORKNET_ID] [int] NULL,
            [COMPANY_ID] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_WORKNET_RELATION_COMPANY] PRIMARY KEY CLUSTERED 
        (
            [ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>