<!-- Description : User Groups History Table
Developer: Gülbahar İnan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='USER_GROUP_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' )
    BEGIN
        CREATE TABLE [USER_GROUP_HISTORY](
            [USER_GROUP_HIST_ID] [int] IDENTITY(1,1) NOT NULL,
            [USER_GROUP_ID] [int] NOT NULL,
            [USER_GROUP_NAME] [nvarchar](50) NOT NULL,
            [USER_GROUP_PERMISSIONS] [nvarchar](500) NOT NULL,
            [USER_GROUP_PERMISSIONS_EXTRA] [nvarchar](500) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [IS_DEFAULT] [bit] NULL,
            [IS_BRANCH_AUTHORIZATION] [bit] NULL,
            [POWERUSER] [nvarchar](500) NULL,
            [REPORT_USER_LEVEL] [nvarchar](500) NULL,
            [SENSITIVE_USER_LEVEL] [nvarchar](500) NULL,
            [DATA_LEVEL] [nvarchar](500) NULL,
            [WRK_MENU] [nvarchar](500) NULL,
         CONSTRAINT [PK_USER_GROUP_HISTORY] PRIMARY KEY CLUSTERED 
        (
            [USER_GROUP_HIST_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='USER_GROUP_EMPLOYEE_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' )
    BEGIN
        CREATE TABLE [USER_GROUP_EMPLOYEE_HISTORY](
            [USER_GROUP_EMP_HIST_ID] [int] IDENTITY(1,1) NOT NULL,
            [USER_GROUP_EMP_IDENTITY] [int] NOT NULL,
            [EMPLOYEE_ID] [int] NOT NULL,
            [POSITION_ID] [int] NOT NULL,
            [USER_GROUP_ID] [int] NOT NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
         CONSTRAINT [PK_USER_GROUP_EMPLOYEE_HISTORY] PRIMARY KEY CLUSTERED 
        (
            [USER_GROUP_EMP_HIST_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='USER_GROUP_OBJECT_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' )
    BEGIN
        CREATE TABLE [USER_GROUP_OBJECT_HISTORY](
            [USER_GROUP_OBJECT_HIST_ID] [int] IDENTITY(1,1) NOT NULL,
            [USER_GROUP_OBJECT_ID] [int] NOT NULL,
            [USER_GROUP_ID] [int] NOT NULL,
            [OBJECT_NAME] [nvarchar](50) NULL,
            [MODULE_NO] [int] NULL,
            [LIST_OBJECT] [bit] NULL,
            [ADD_OBJECT] [bit] NULL,
            [UPDATE_OBJECT] [bit] NULL,
            [DELETE_OBJECT] [bit] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [BRANCH_OBJECT] [bit] NULL,
         CONSTRAINT [PK_USER_GROUP_OBJECT_HISTORY] PRIMARY KEY CLUSTERED 
        (
            [USER_GROUP_OBJECT_HIST_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
</querytag>