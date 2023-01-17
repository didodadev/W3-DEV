<!-- Description : WoDiBa API Tanımları Tablosu
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main-->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WODIBA_API_DEFINITIONS' )
    BEGIN
    CREATE TABLE [WODIBA_API_DEFINITIONS](
        [WDB_API_URI] [nvarchar](250) NULL,
        [WDB_API_USERNAME] [nvarchar](50) NULL,
        [WDB_API_PASSWORD] [nvarchar](50) NULL,
        [WDB_API_SERVER_IP] [nvarchar](50) NULL,
        [WDB_EMP_ID] [int] NULL,
        [WDB_START_DATE] [datetime] NULL,
        [UPD_USER] [int] NULL,
        [UPD_DATE] [datetime] NULL,
        [UPD_IP] [nvarchar](50) NULL
    ) ON [PRIMARY]
    END
</querytag>