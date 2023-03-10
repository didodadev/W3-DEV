<cfquery name="upd" datasource="#dsn#">
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_SYSTEM_PARAMS')
    BEGIN
        CREATE TABLE [WRK_SYSTEM_PARAMS](
            [WSP_ID] [int] IDENTITY(1,1) NOT NULL,
            [WSP_DOMAIN] [nvarchar](250) NOT NULL,
            [WSP_DOMAIN_WHOPS] [nvarchar](250) NULL,
            [RELEASE_NO] [nvarchar](250) NULL,
            [WSP_PARAM] [nvarchar](max) NOT NULL,
        CONSTRAINT [PK_WRK_SYSTEM_PARAMS] PRIMARY KEY CLUSTERED 
        (
            [WSP_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_SYSTEM_PARAMS' AND COLUMN_NAME = 'RELEASE_NO')
        BEGIN
            ALTER TABLE WRK_SYSTEM_PARAMS ADD 
            RELEASE_NO nvarchar(250) NULL
        END
    END
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_OBJECTS_RELATION')
    BEGIN
        CREATE TABLE [WRK_OBJECTS_RELATION](
            [FRIENDLY_URL] [nvarchar](250) NULL,
            [PARENT_FUSEACTION] [nvarchar](250) NULL,
            [PARENT_FUSEACTION_VARAIBLE] [nvarchar](250) NULL,
            [RELATED_HEAD] [nvarchar](250) NULL,
            [FULL_FUSEACTION] [nvarchar](250) NULL,
            [FULL_FUSEACTION_VARAIBLE] [nvarchar](250) NULL,
            [RELATED_TYPE] [nvarchar](250) NULL,
            [WINDOW] [nvarchar](250) NULL,
            [FULL_FUSEACTION_EVENT] [nvarchar](10) NULL
        ) ON [PRIMARY]
    END
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS_RELATION' AND COLUMN_NAME = 'FULL_FUSEACTION_EVENT')
        BEGIN
            ALTER TABLE WRK_OBJECTS_RELATION ADD FULL_FUSEACTION_EVENT [nvarchar](10) NULL
        END
    END

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='EMPLOYEE_MANDATE')
    BEGIN
        CREATE TABLE [EMPLOYEE_MANDATE](
            [MANDATE_MASTER_ID] [int] IDENTITY(1,1) NOT NULL,
            [MANDATE_EMPLOYEE_ID] [int] NULL,
            [WRK_PROCESS_ID] [int] NULL,
            [MASTER_EMPLOYEE_ID] [int] NULL,
            [MANDATE_DETAIL] [nvarchar](250) NULL,
            [MANDATE_STARTDATE] [datetime] NULL,
            [MANDATE_FINISHDATE] [datetime] NULL,
            [IS_ACTIVE] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [IS_APPROVE] [bit] NULL,
        CONSTRAINT [PK_EMPLOYEE_MANDATE] PRIMARY KEY CLUSTERED 
        (
            [MANDATE_MASTER_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'IS_CHECKER_UPDATE_AUTHORITY')
    BEGIN
        ALTER TABLE PAGE_WARNINGS ADD 
        IS_CHECKER_UPDATE_AUTHORITY bit NULL
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'WARNING_PASSWORD')
    BEGIN
        ALTER TABLE PAGE_WARNINGS ADD 
        WARNING_PASSWORD bit NULL
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'DATA_CFC')
    BEGIN
        ALTER TABLE WRK_OBJECTS ADD 
        DATA_CFC nvarchar(MAX) NULL
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_SESSION' AND COLUMN_NAME = 'ACTION_PAGE_Q_STRING')
    BEGIN
        ALTER TABLE WRK_SESSION ADD 
        ACTION_PAGE_Q_STRING nvarchar(MAX) NULL
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_SESSION' AND COLUMN_NAME = 'WEEK_START')
    BEGIN
        ALTER TABLE WRK_SESSION ADD 
        WEEK_START bit NULL
    END

    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES' AND COLUMN_NAME = 'EMPLOYEE_PASSWORD')
    BEGIN
        ALTER TABLE EMPLOYEES ALTER COLUMN EMPLOYEE_PASSWORD nvarchar(300);
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES' AND COLUMN_NAME = 'TEL_TYPE')
    BEGIN
        ALTER TABLE EMPLOYEES ADD 
        TEL_TYPE int NULL
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'WATOMIC_SOLUTION_ID')
    BEGIN
        ALTER TABLE WRK_OBJECTS ADD 
        WATOMIC_SOLUTION_ID int NULL
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'WATOMIC_FAMILY_ID')
    BEGIN
        ALTER TABLE WRK_OBJECTS ADD 
        WATOMIC_FAMILY_ID int NULL
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MY_SETTINGS' AND COLUMN_NAME = 'WEEK_START')
    BEGIN
        ALTER TABLE MY_SETTINGS ADD 
        WEEK_START bit NULL
    END
	
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'IS_APPROVE')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD 
        IS_APPROVE bit NULL
    END
	
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'APPROVED_DATE')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD 
        APPROVED_DATE datetime NULL
    END
	
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'APPROVED_NAME_SURNAME')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD 
        APPROVED_NAME_SURNAME nvarchar(MAX) NULL
    END
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='GDPR_DECLERATION')
    BEGIN
        CREATE TABLE [GDPR_DECLERATION](
            [GDPR_DECLERATION_ID] [int] IDENTITY(1,1) NOT NULL,
            [GDPR_DECLERATION_TEXT] [nvarchar](max) NULL,
            [GDPR_DECLERATION_VERSION] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](100) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](100) NULL,
            [AUTHOR] [nvarchar](200) NULL,
            [DECLERATION_DATE] [datetime] NULL,
        PRIMARY KEY CLUSTERED 
        (
            [GDPR_DECLERATION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GDPR_DECLERATION' AND COLUMN_NAME = 'DECLERATION_DATE')
        BEGIN
            ALTER TABLE GDPR_DECLERATION ADD 
            DECLERATION_DATE datetime NULL
        END
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_SYSTEM_PARAMS' AND COLUMN_NAME = 'WSP_DOMAIN_WHOPS')
    BEGIN
        ALTER TABLE WRK_SYSTEM_PARAMS ADD 
        WSP_DOMAIN_WHOPS nvarchar(250) NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_LANGUAGE_TR' AND COLUMN_NAME = 'ITEM_IT')
    BEGIN
        ALTER TABLE SETUP_LANGUAGE_TR ADD 
        ITEM_IT nvarchar(500) NULL
    END
</cfquery>