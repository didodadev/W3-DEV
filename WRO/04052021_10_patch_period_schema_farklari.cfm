<!-- Description : 19.12.5.1 patch period şema farkları giderildi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Period -->

<querytag>

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='ACCOUNT_CARD_ROWSCOPY1')
    BEGIN
        CREATE TABLE [ACCOUNT_CARD_ROWSCOPY1]
        (
            [CARD_ID] int NOT NULL
            , [CARD_ROW_ID] int NOT NULL IDENTITY(1,1)
            , [ACCOUNT_ID] nvarchar(100) NOT NULL
            , [BA] bit NOT NULL
            , [AMOUNT] float NOT NULL
            , [AMOUNT_CURRENCY] nvarchar(43) NULL
            , [DETAIL] nvarchar(500) NULL
            , [AMOUNT_2] float NULL
            , [ROW_ACTION_ID] int NULL
            , [ROW_ACTION_TYPE_ID] int NULL
            , [ROW_PAPER_NO] nvarchar(50) NULL
            , [AMOUNT_CURRENCY_2] nvarchar(43) NULL
            , [OTHER_AMOUNT] float NULL
            , [OTHER_CURRENCY] nvarchar(43) NULL
            , [QUANTITY] float NULL
            , [PRICE] float NULL
            , [BILL_CONTROL_NO] float NULL
            , [IFRS_CODE] nvarchar(100) NULL
            , [ACCOUNT_CODE2] nvarchar(100) NULL
            , [IS_RATE_DIFF_ROW] bit NULL
            , [COST_PROFIT_CENTER] int NULL
            , [ACC_DEPARTMENT_ID] int NULL
            , [ACC_BRANCH_ID] int NULL
            , [ACC_PROJECT_ID] int NULL
            , [CARD_ROW_NO] int NULL
            , [RECORD_EMP] int NULL
            , [RECORD_IP] nvarchar(50) NULL
            , [RECORD_DATE] datetime NULL
            , [UPDATE_EMP] int NULL
            , [UPDATE_IP] nvarchar(50) NULL
            , [UPDATE_DATE] datetime NULL
        );
    END;
    
</querytag>