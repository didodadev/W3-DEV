<!-- Description : Hata Raporları Tablosu
Developer: Deniz Hamurpet
Company : Workcube
Destination: main-->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'BUGS')
    BEGIN
        CREATE TABLE [BUGS](
            [BUG_ID] [int] IDENTITY(1,1) NOT NULL,
            [WORKCUBE_NAME] [nvarchar] NULL,
            [BUG_DETAIL] [nvarchar](250) NULL,
            [PAGE] [nvarchar] NULL,
            [BROWSER_TYPE] [nvarchar] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_PAR] [int] NULL,
            [RECORD_CON] [int] NULL,
            [RECORD_PDA] [int] NULL
        ) ON [PRIMARY]
    END;
</querytag>