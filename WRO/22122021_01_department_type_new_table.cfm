<!-- Description : Departman Tipleri tablosu create scripti.
Developer: Dilek ÖZdemir
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SETUP_DEPARTMENT_TYPE' AND TABLE_SCHEMA = '@_dsn_main_@' )
    BEGIN
        CREATE TABLE [SETUP_DEPARTMENT_TYPE](
            [DEPARTMENT_TYPE_ID] [int] IDENTITY(1,1) NOT NULL,
            [DEPARTMENT_TYPE] [nvarchar](100) NULL,
            [DETAIL] [nvarchar](100) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_SETUP_DEPARTMENT_TYPE] PRIMARY KEY CLUSTERED 
        (
            [DEPARTMENT_TYPE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DEPARTMENT' AND COLUMN_NAME='DEPARTMENT_TYPE')
    BEGIN
        ALTER TABLE DEPARTMENT 
        ADD DEPARTMENT_TYPE [int] NULL
    END;

</querytag>