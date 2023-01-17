<!-- Description : Magic Budgeter için Kullanılacak olan tablolar
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BUDGET_WIZARD' AND TABLE_SCHEMA = '@_dsn_main_@')
        BEGIN
            CREATE TABLE [BUDGET_WIZARD](
            [WIZARD_ID] [int] IDENTITY(1,1) NOT NULL,
            [WIZARD_NAME] [nvarchar](50) NULL,
            [WIZARD_DESIGNER] [int] NULL,
            [WIZARD_STAGE] [int] NULL,
            [WIZARD_DATE] [date] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_BUDGET_WIZARD] PRIMARY KEY CLUSTERED 
        (
            [WIZARD_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BUDGET_WIZARD_BLOCK' AND TABLE_SCHEMA = '@_dsn_main_@')
        BEGIN
            CREATE TABLE [BUDGET_WIZARD_BLOCK](
            [WIZARD_BLOCK_ID] [int] IDENTITY(1,1) NOT NULL,
            [WIZARD_ID] [nchar](10) NULL,
            [BLOCK_NAME] [nvarchar](50) NULL,
            [BLOCK_INCOME] [int] NULL,
        CONSTRAINT [PK_BUDGET_WIZARD_BLOCK] PRIMARY KEY CLUSTERED 
        (
            [WIZARD_BLOCK_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BUDGET_WIZARD_BLOCK_ROW' AND TABLE_SCHEMA = '@_dsn_main_@')
        BEGIN
            CREATE TABLE [BUDGET_WIZARD_BLOCK_ROW](
                [WIZARD_BLOCK_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
                [WIZARD_BLOCK_ID] [int] NULL,
                [BLOCK_COLUMN] [int] NULL,
                [EXP_CENTER] [int] NULL,
                [EXP_ITEM] [int] NULL,
                [ACTIVITY_TYPE] [int] NULL,
                [RATE] [float] NULL,
                [DESCRIPTION] [nvarchar](50) NULL,
            CONSTRAINT [PK_BUDGET_WIZARD_BLOCK_ROW] PRIMARY KEY CLUSTERED 
            (
                [WIZARD_BLOCK_ROW_ID] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY]
        END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BUDGET_WIZARD_RELATION' AND TABLE_SCHEMA = '@_dsn_main_@')
        BEGIN
            CREATE TABLE [BUDGET_WIZARD_RELATION](
                [WIZARD_RELATION_ID] [int] IDENTITY(1,1) NOT NULL,
                [WIZARD_ID] [int] NULL,
                [EXP_ITEM_ROWS_ID] [int] NULL,
                [PERIOD_ID] [int] NULL,
                [IS_MANUAL] [int] NULL,
                [RECORD_DATE] [datetime] NULL,
                [IS_INCOME] [int] NULL,
            CONSTRAINT [PK_BUDGET_WIZARD_RELATION] PRIMARY KEY CLUSTERED 
            (
                [WIZARD_RELATION_ID] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY]
        END;
</querytag>