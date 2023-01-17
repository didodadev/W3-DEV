<!-- Description : Plevne rule tablosu eklendi
Developer: Halit Yurttaş
Company : Workcube
Destination: Main-->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_PLEVNE_RULE')
    BEGIN
        CREATE TABLE [WRK_PLEVNE_RULE](
            [RULE_ID] [int] IDENTITY(1,1) NOT NULL,
            [PATTERN] [nvarchar](max) NOT NULL,
            [ACTIVE] [bit] NOT NULL,
            [SECURITY_LEVEL] [nvarchar](50) NOT NULL,
            [RECORD_DATE] [datetime] NOT NULL,
            [RECORD_EMP] [int] NOT NULL,
            [RECORD_IP] [nvarchar](25) NOT NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](25) NULL
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
    END;

    
</querytag>