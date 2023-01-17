<!-- Description : Departman Kategorileri tablosu create scripti.
Developer: Dilek ÖZdemir
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SETUP_SERVICE_CLASS' AND TABLE_SCHEMA = '@_dsn_main_@' )
    BEGIN
        CREATE TABLE [SETUP_SERVICE_CLASS](
            [SERVICE_CLASS_ID] [int] IDENTITY(1,1) NOT NULL,
            [SERVICE_CLASS] [nvarchar](100) NULL,
            [DETAIL] [nvarchar](100) NULL,
            [SPECIAL_CODE] [nvarchar](100) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_SETUP_SERVICE_CLASS] PRIMARY KEY CLUSTERED 
        (
            [SERVICE_CLASS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SETUP_SERVICE_TITLE' AND TABLE_SCHEMA = '@_dsn_main_@' )
    BEGIN
        CREATE TABLE [SETUP_SERVICE_TITLE](
            [SERVICE_TITLE_ID] [int] IDENTITY(1,1) NOT NULL,
            [SERVICE_CLASS_ID] [int] NULL,
            [SERVICE_TITLE] [nvarchar](100) NULL,
            [SERVICE_TITLE_CODE] [nvarchar](100) NULL,
            [DETAIL] [nvarchar](100) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_SETUP_SERVICE_TITLE] PRIMARY KEY CLUSTERED 
        (
            [SERVICE_TITLE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_IN_OUT' AND COLUMN_NAME='SERVICE_CLASS')
    BEGIN
        ALTER TABLE EMPLOYEES_IN_OUT 
        ADD SERVICE_CLASS [int] NULL
    END;

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_IN_OUT' AND COLUMN_NAME='SERVICE_TITLE')
    BEGIN
        ALTER TABLE EMPLOYEES_IN_OUT 
        ADD SERVICE_TITLE [int] NULL
    END;

</querytag>