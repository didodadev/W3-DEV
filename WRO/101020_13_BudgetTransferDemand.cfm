<!-- Description : Bütçe Aktarım Talebi için kullanılan tablolar
Developer: Melek KOCABEY
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND' AND TABLE_SCHEMA = '@_dsn_period_@')
        BEGIN
            CREATE TABLE [BUDGET_TRANSFER_DEMAND](
                [DEMAND_ID] [int] IDENTITY(1,1) NOT NULL,
                [BUDGET_ID] [int] NULL,
                [DEMAND_EMP_ID] [int] NULL,                
                [DEMAND_DATE] [datetime] NULL,
                [DEMAND_NO] [nvarchar](100) NULL,
                [DEMAND_STAGE] [int] NULL,
                [DETAIL] [nvarchar](max) NULL,
                [RECORD_EMP] [int] NULL,
                [RECORD_IP] [nvarchar](50) NULL,
                [RECORD_DATE] [datetime] NULL,
                [UPDATE_EMP] [int] NULL,
                [UPDATE_IP] [nvarchar](50) NULL,
                [UPDATE_DATE] [datetime] NULL,	
            CONSTRAINT [PK_BUDGET_TRANSFER_DEMAND_DEMAND_ID] PRIMARY KEY CLUSTERED 
            (
                [DEMAND_ID] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BUDGET_TRANSFER_DEMAND_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@')
        BEGIN
            CREATE TABLE [BUDGET_TRANSFER_DEMAND_ROWS](
                [DEMAND_ROWS_ID] [int] IDENTITY(1,1) NOT NULL,
                [DEMAND_ID] [int] NULL,
                [DEMAND_EXP_CENTER] [int] NULL,
                [DEMAND_EXP_ITEM] [int] NULL,
                [DEMAND_ACTIVITY_TYPE] [int] NULL,
                [DEMAND_PROJECT_ID] [int] NULL,
                [AMOUNT] [float] NULL,
                [USABLE_MONEY] [float] NULL,
                [MONEY_CURRENCY] [nvarchar](43) NULL,
                [TRANSFER_EXP_CENTER] [int] NULL,
                [TRANSFER_EXP_ITEM] [int] NULL,
                [TRANSFER_ACTIVITY_TYPE] [int] NULL,
                [TRANSFER_PROJECT_ID] [int] NULL,
                [USABLE_TRANSFER_MONEY] [float] NULL,
                [RECORD_EMP] [int] NULL,
                [RECORD_IP] [nvarchar](50) NULL,
                [RECORD_DATE] [datetime] NULL,
                [UPDATE_EMP] [int] NULL,
                [UPDATE_IP] [nvarchar](50) NULL,
                [UPDATE_DATE] [datetime] NULL,	
            CONSTRAINT [PK_BUDGET_TRANSFER_DEMAND_ROWS_DEMAND_ROWS_ID] PRIMARY KEY CLUSTERED 
            (
                [DEMAND_ROWS_ID] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY]
    END;
</querytag>