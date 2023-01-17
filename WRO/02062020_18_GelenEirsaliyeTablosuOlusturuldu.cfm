<!-- Description : Gelen E-İrsaliye tablosu oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ESHIPMENT_RECEIVING_DETAIL' AND TABLE_SCHEMA = '@_dsn_period_@')
    BEGIN
        CREATE TABLE [ESHIPMENT_RECEIVING_DETAIL](
            [RECEIVING_DETAIL_ID] [int] IDENTITY(1,1) NOT NULL,
            [SERVICE_RESULT] [nvarchar](50) NULL,
            [SERVICE_RESULT_DESCRIPTION] [nvarchar](250) NULL,
            [UUID] [nvarchar](50) NULL,
            [ESHIPMENT_ID] [nvarchar](50) NULL,
            [STATUS_DESCRIPTION] [nvarchar](250) NULL,
            [STATUS_CODE] [int] NULL,
            [ERROR_CODE] [int] NULL,
            [DESPATCH_ADVICE_TYPE_CODE] [nvarchar](50) NULL,
            [SENDER_TAX_ID] [nvarchar](50) NULL,
            [RECEIVER_TAX_ID] [nvarchar](50) NULL,
            [PROFILE_ID] [nvarchar](50) NULL,
            [TOTAL_AMOUNT] [float] NULL,
            [ISSUE_DATE] [datetime] NULL,
            [ISSUE_TIME] [datetime] NULL,
            [PARTY_NAME] [nvarchar](250) NULL,
            [PATH] [nvarchar](250) NULL,
            [STATUS] [bit] NULL,
            [LAST_DATE] [datetime] NULL,
            [IS_APPROVE] [bit] NULL,
            [PRINT_COUNT] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [RECEIVER_POSTBOX_NAME] [nvarchar](250) NULL,
            [SENDER_POSTBOX_NAME] [nvarchar](250) NULL,
            [DIRECTION] [nvarchar](50) NULL,
            [CREATE_DATE] [datetime] NULL,
            [PROCESS_STAGE] [int] NULL,
            [IS_PROCESS] [bit] NULL,
            [SHIP_ID] [int] NULL,
        CONSTRAINT [PK_ESHIPMENT_RECEIVING_DETAIL] PRIMARY KEY CLUSTERED 
        (
            [RECEIVING_DETAIL_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>