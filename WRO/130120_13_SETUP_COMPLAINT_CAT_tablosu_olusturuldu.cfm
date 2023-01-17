<!-- Description : SETUP_COMPLAINT_CAT Tablosu Oluşturuldu.
Developer:Gülbahar İnan
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='SETUP_COMPLAINT_CAT')
    BEGIN
        CREATE TABLE [SETUP_COMPLAINT_CAT](
            [COMPLAINT_CAT_ID] [int] IDENTITY(1,1) NOT NULL,
            [COMPLAINT_CAT] [nvarchar](100) NULL,
            [COMPLAINT_CAT_DESCRIPTION] [nvarchar](250) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](43) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](43) NULL,
        CONSTRAINT [PK_SETUP_COMPLAINT_CAT] PRIMARY KEY CLUSTERED 
        (
            [COMPLAINT_CAT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>
