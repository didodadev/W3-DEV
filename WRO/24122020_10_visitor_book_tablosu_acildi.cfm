<!-- Description : VISITOR BOOK tablosu açıldı
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='VISITOR_BOOK' )
    BEGIN
    CREATE TABLE [VISITOR_BOOK](
        [VISIT_ID] [int] IDENTITY(1,1) NOT NULL,
        [VISIT_NAME] [nvarchar](150) NULL,
        [VISIT_SURNAME] [nvarchar](150) NULL,
        [CARD_NO] [nvarchar](150) NULL,
        [DATE] [datetime] NOT NULL,
        [START_TIME] [int] NOT NULL,
        [END_TIME] [int] NOT NULL,
        [START_MINUTE] [int] NOT NULL,
        [FINISH_MINUTE] [int] NOT NULL,
        [REASON_VISIT] [nvarchar](150) NULL,
        [EMP_ID] [int] NOT NULL,
        [BRANCH_ID] [int] NULL,
        [DEPARTMENT_ID] [int] NULL,
        [FINISH_DATE] [datetime] NULL,
        [START_DATE] [datetime] NULL,
    CONSTRAINT [PK_VISIT_B_TEST] PRIMARY KEY CLUSTERED 
    (
        [VISIT_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END;
</querytag>