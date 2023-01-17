<!-- Description : WRK_BESTPRACTICE_DATA_LIBRARY tablosu oluşturuldu
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='WRK_BESTPRACTICE_DATA_LIBRARY')
    BEGIN
        CREATE TABLE [WRK_BESTPRACTICE_DATA_LIBRARY](
            [BPDL_ID] [int] IDENTITY(1,1) NOT NULL,
            [WBP_CODE] [nvarchar](50) NULL,
            [BPDL_NAME] [nvarchar](250) NULL,
            [BPDL_SCHEMA] [nvarchar](50) NULL,
            [BPDL_TYPE] [nvarchar](250) NULL,
            [BPDL_FILE] [nvarchar](250) NULL,
            [BPDL_STATUS] [bit] NULL,
            [COMPANY_ID] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_WRK_BESTPRACTICE_DATA_LIBRARY] PRIMARY KEY CLUSTERED 
        (
            [BPDL_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
</querytag>