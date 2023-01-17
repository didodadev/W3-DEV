<!-- Description : WODIBA_RULE_SET_ROW_PARAMS tablosu eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main-->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WODIBA_RULE_SET_ROW_PARAMS')
    BEGIN
        CREATE TABLE [WODIBA_RULE_SET_ROW_PARAMS](
            [PARAM_ID] [int] IDENTITY(1,1) NOT NULL,
            [RULE_SET_ROW_ID] [int] NULL,
            [PARAM_NAME] [nvarchar](50) NULL,
            [PARAM_VALUE] [nvarchar](50) NULL
        ) ON [PRIMARY]
    END;
</querytag>