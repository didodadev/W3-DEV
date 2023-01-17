<!-- Description : WoDiBa Log Tablosu Eklendi.
Developer: Emre Kaplan
Company : Gramoni
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WODIBA_LOGS' )
    BEGIN
        CREATE TABLE [WODIBA_LOGS]
        (
        LOG_ID int NOT NULL IDENTITY (1, 1),
        LOG_STATUS bit NULL,
        LOG_TYPE nvarchar(50) NULL,
        IS_BUGLOG bit NULL,
        WDB_ACTION_ID int NULL,
        MESSAGE nvarchar(MAX) NULL,
        DETAILS nvarchar(MAX) NULL,
        REC_DATE datetime NULL,
        REC_IP nvarchar(50) NULL,
        REC_USER int NULL
        )  ON [PRIMARY]

        ALTER TABLE [WODIBA_LOGS] ADD CONSTRAINT
            DF_WODIBA_LOGS_LOG_STATUS DEFAULT 1 FOR LOG_STATUS

        ALTER TABLE [WODIBA_LOGS] ADD CONSTRAINT
            PK_WODIBA_LOGS PRIMARY KEY CLUSTERED 
            (
            LOG_ID
            ) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    END;
</querytag>