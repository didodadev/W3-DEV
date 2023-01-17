<!-- Description : WoDiBa Rule Set Tablosu Tablosu Eklendi.
Developer: Emre Kaplan
Company : Gramoni
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='WODIBA_RULE_SET_DEFINITIONS' )
    BEGIN
    CREATE TABLE [WODIBA_RULE_SET_DEFINITIONS](        
        [DEFINITION_ID] [int] IDENTITY(1,1) NOT NULL,
        [RULE_SET_ID] [int] NULL,
        [BANK_ID] [int] NULL,
        [MONEY_TYPE] [nvarchar](5) NULL,
        [POS_ACCOUNT_ID] [int] NULL,
        [MAIN_ACCOUNT_ID] [int] NULL,
    CONSTRAINT [PK_WODIBA_RULE_SET_DEFINITIONS] PRIMARY KEY CLUSTERED 
    (
        [DEFINITION_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END;
</querytag>