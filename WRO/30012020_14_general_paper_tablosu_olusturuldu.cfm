<!-- Description : Create GENERAL_PAPER sql
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GENERAL_PAPER' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [GENERAL_PAPER](
            [GENERAL_PAPER_ID] [int] IDENTITY(1,1) NOT NULL,
            [GENERAL_PAPER_NO] [nvarchar](25) NULL,
            [GENERAL_PAPER_DATE] [datetime] NULL,
            [FUSEACTION] [nvarchar](100) NULL,
            [ACTION_LIST_ID] [nvarchar](MAX) NULL,
            [STAGE_ID] [int] NULL,
            [GENERAL_PAPER_NOTICE] [nvarchar](1000) NULL,
            [TOTAL_VALUES] [nvarchar](MAX) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](43) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](43) NULL,
            [RESPONSIBLE_EMP] [int] NULL,
            [RESPONSIBLE_EMP_POS] [int] NULL,
        CONSTRAINT [PK__GENERAL___A46DA77B19C1D87F] PRIMARY KEY CLUSTERED 
        (
            [GENERAL_PAPER_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'GENERAL_PAPER_ID')
    BEGIN
        ALTER TABLE PAGE_WARNINGS ADD 
        GENERAL_PAPER_ID int NULL
    END;
</querytag>
