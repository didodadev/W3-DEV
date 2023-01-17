<!-- Description : subscription_counter_meter Tablosu Oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SUBSCRIPTION_COUNTER_METER')
    BEGIN
        CREATE TABLE [SUBSCRIPTION_COUNTER_METER](
            [SCM_ID] [int] IDENTITY(1,1) NOT NULL,
            [SUBSCRIPTION_ID] [int] NOT NULL,
            [COUNTER_ID] [int] NOT NULL,
            [PREVIOUS_VALUE] [float] NOT NULL,
            [LAST_VALUE] [float] NOT NULL,
            [DIFFERENCE] [float] NOT NULL,
            [LOADING_EMPLOYEE_ID] [int] NOT NULL,
            [LOADING_DATE] [datetime] NOT NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_SUBSCRIPTION_COUNTER_METER] PRIMARY KEY CLUSTERED 
        (
            [SCM_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>