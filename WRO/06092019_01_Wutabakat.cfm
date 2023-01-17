<!-- Description : Mutabakat modülü
Developer: Canan Ebret
Company : Workcube
Destination: Period-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='CARI_LETTER' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        CREATE TABLE [CARI_LETTER](
            [CARI_LETTER_ID] [int] IDENTITY(1,1) NOT NULL,
            [OUR_COMPANY_ID] [int] NULL,
            [PERIOD_ID] [int] NULL,
            [START_DATE] [datetime] NULL,
            [FINISH_DATE] [datetime] NULL,
            [KEYWORD] [ntext] NULL,
            [SEARCH_ORDER_ID] [int] NULL,
            [SEARCH_TYPE_ID] [int] NULL,
            [IS_ZERO] [bit] NULL,
            [IS_ACTION] [bit] NULL,
            [IS_OPEN] [bit] NULL,
            [BABS_AMOUNT] [float] NULL,
            [IS_CH] [bit] NULL,
            [IS_CR] [bit] NULL,
            [IS_BA] [bit] NULL,
            [IS_BS] [bit] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](40) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](40) NULL
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='CARI_LETTER_ROW' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        CREATE TABLE [CARI_LETTER_ROW](
            [CARI_LETTER_ID] [int] NULL,
            [CARI_LETTER_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
            [UNIQUE_ID] [nvarchar](500) NULL,
            [COMPANY_ID] [int] NULL,
            [START_DATE] [datetime] NULL,
            [FINISH_DATE] [datetime] NULL,
            [IS_CH_AMOUNT] [float] NULL,
            [IS_CR_AMOUNT] [float] NULL,
            [IS_BA_TOTAL] [int] NULL,
            [IS_BA_AMOUNT] [float] NULL,
            [IS_BS_TOTAL] [int] NULL,
            [IS_BS_AMOUNT] [float] NULL,
            [CH_EMAIL] [nvarchar](500) NULL,
            [AS_EMAIL] [nvarchar](500) NULL,
            [IS_SEND] [int] NULL,
            [IS_SEND_DATE] [datetime] NULL,
            [IS_SEND_IP] [nvarchar](40) NULL,
            [ACCEPT_USER] [int] NULL,
            [ACCEPT_DATE] [datetime] NULL,
            [ACCEPT_NAME] [nvarchar](500) NULL,
            [ACCEPT_DETAIL] [ntext] NULL,
            [ACCEPT_TYPE] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](40) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](40) NULL,
            [IS_BS_ACCEPT] [int] NULL,
            [ACCEPT_TOTAL] [int] NULL,
            [ACCEPT_AMOUNT] [float] NULL,
            [ACCOUNT_CODE] [nvarchar](500) NULL,
            [ACCOUNT_AMOUNT] [float] NULL,
            [ACCEPT_STATUS] [int] NULL,
            [ACCEPT_IP] [nvarchar](40) NULL,
            [CARI_STATUS] [int] NULL
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END
</querytag>