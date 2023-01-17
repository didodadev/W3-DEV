
<!-- Description : Harcırah Kuralları Tablosu
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EXPENSE_HR_RULES')
    BEGIN
        CREATE TABLE [EXPENSE_HR_RULES](
            [EXPENSE_HR_RULES_ID] [int] IDENTITY(1,1) NOT NULL,
            [EXPENSE_HR_RULES_TYPE] [int] NULL,
            [EXPENSE_HR_RULES_DESCRIPTION] [nvarchar](250) NULL,
            [EXPENSE_HR_RULES_DETAIL] [nvarchar](250) NULL,
            [DAILY_PAY_MAX] [float] NULL,
            [MONEY_TYPE] [nvarchar](43) NULL,
            [FIRST_LEVEL_DAY_MAX] [int] NULL,
            [FIRST_LEVEL_PAY_RATE] [float] NULL,
            [SECOND_LEVEL_DAY_MAX] [int] NULL,
            [SECOND_LEVEL_PAY_RATE] [float] NULL,
            [RULE_START_DATE] [datetime] NULL,
            [TAX_EXCEPTION_AMOUNT] [float] NULL,
            [TAX_EXCEPTION_MONEY_TYPE] [nvarchar](43) NULL,
            [IS_INCOME_TAX_INCLUDE] [bit] NULL,
            [IS_STAMP_TAX] [bit] NULL,
            [TAX_RANK_FACTOR] [float] NULL,
            [EXPENSE_CENTER] [int] NULL,
            [EXPENSE_ITEM_ID] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](43) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](43) NULL,
            [IS_COUNTRY_OUT] [bit] NULL,
            [IS_ACTIVE] [bit] NULL,
            [ADDITIONAL_ALLOWANCE_ID] [int] NULL,
        CONSTRAINT [PK__EXPENSE___2CD1554FE9E559AD] PRIMARY KEY CLUSTERED 
        (
            [EXPENSE_HR_RULES_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
</querytag>


