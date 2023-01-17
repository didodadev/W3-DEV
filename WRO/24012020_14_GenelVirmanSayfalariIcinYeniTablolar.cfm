 <!-- Description : .
Developer: Ahmet Yolcu
Company : Force BT
Destination: Period-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'GENEL_VIRMAN')
    BEGIN
        CREATE TABLE [GENEL_VIRMAN](
            [VIRMAN_ID] [int] IDENTITY(1,1) NOT NULL,
            [VIRMAN_NO] [nvarchar](50) NOT NULL,
            [VIRMAN_DETAIL] [nvarchar](max) NULL,
            [VIRMAN_DATE] [date] NOT NULL,
            [VIRMAN_EMP] [int] NULL,
            [OTHER_MONEY] [nvarchar](50) NULL,
            [RECORD_DATE] [date] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [PROCESS_CAT] [int] NOT NULL,
            [PROCESS_TYPE] [int] NOT NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [date] NULL,
            [UPDATE_IP] [nvarchar](50) NULL
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'VIRMAN_MONEY')
    BEGIN
        CREATE TABLE [VIRMAN_MONEY](
            [MONEY_TYPE] [nvarchar](43) NULL,
            [ACTION_ID] [int] NULL,
            [RATE2] [float] NULL,
            [RATE1] [float] NULL,
            [IS_SELECTED] [bit] NULL,
            [ACTION_MONEY_ID] [int] IDENTITY(1,1) NOT NULL
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'VIRMAN_ROWS')
    BEGIN
        CREATE TABLE [VIRMAN_ROWS](
            [VIRMAN_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
            [VIRMAN_ID] [int] NOT NULL,
            [BA] [bit] NOT NULL,
            [BANK_ID] [int] NULL,
            [CASH_ID] [int] NULL,
            [COMPANY_ID] [int] NULL,
            [EMPLOYEE_ID] [int] NULL,
            [CH_ACCOUNT_CODE] [nvarchar](50) NULL,
            [ACTION_VALUE] [float] NULL,
            [ACTION_CURRENCY_ID] [nvarchar](50) NULL,
            [ACTION_DATE] [date] NULL,
            [ACTION_DETAIL] [nvarchar](max) NULL,
            [OTHER_CASH_ACT_VALUE] [float] NULL,
            [OTHER_MONEY] [nvarchar](50) NULL,
            [PROJECT_ID] [int] NULL,
            [ACCOUNT_CODE] [nvarchar](50) NULL,
            [CENTER_ID] [int] NULL,
            [CENTER_NAME] [nvarchar](50) NULL,
            [ITEM_ID] [int] NULL,
            [ITEM_NAME] [nvarchar](50) NULL,
            [QUANTITY] [float] NULL,
            [ACC_TYPE_ID] [int] NULL
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
</querytag>