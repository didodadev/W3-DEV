<!-- Description : PLEVNE install
Developer: Halit Yurttaş
Company : Workcube
Destination: main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PLVN_EXPRESSION_CATEGORIES')
    BEGIN
        CREATE TABLE @_dsn_main_@.[PLVN_EXPRESSION_CATEGORIES](
            [EXPRESSION_CATEGORY_ID] [int] IDENTITY(1,1) NOT NULL,
            [EXPRESSION_KIND] [int] NOT NULL,
            [TITLE] [nvarchar](150) NOT NULL,
            [STATUS] [int] NOT NULL,
        CONSTRAINT [PK_PLVN_EXPRESSION_CATEGORIES] PRIMARY KEY CLUSTERED 
        (
            [EXPRESSION_CATEGORY_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PLVN_EXPRESSIONS')
    BEGIN
        CREATE TABLE @_dsn_main_@.[PLVN_EXPRESSIONS](
            [EXPRESSION_ID] [int] IDENTITY(1,1) NOT NULL,
            [EXPRESSION_CATEGORY] [int] NOT NULL,
            [EXPRESSION_BODY] [nvarchar](max) NULL,
            [STATUS] [int] NOT NULL,
        CONSTRAINT [PK_PLVN_EXPRESSIONS] PRIMARY KEY CLUSTERED 
        (
            [EXPRESSION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PLVN_GOPCHA')
    BEGIN
        CREATE TABLE @_dsn_main_@.[PLVN_GOPCHA](
            [GOPCHA_ID] [int] IDENTITY(1,1) NOT NULL,
            [USER_ID] [int] NOT NULL,
            [GOPCHA_TYPE] [int] NOT NULL,
            [GOPCHA_KEY] [nvarchar](150) NOT NULL,
            [GOPCHA_CODE] [nvarchar](25) NOT NULL,
            [ADDRESS] [nvarchar](250) NULL,
            [GOPCHA_UNTIL] [datetime] NULL,
            [IP] [nvarchar](40) NOT NULL,
        CONSTRAINT [PK_PLVN_GOPCHA] PRIMARY KEY CLUSTERED 
        (
            [GOPCHA_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PLVN_INTERCEPTOR_CATEGORIES')
    BEGIN
        CREATE TABLE @_dsn_main_@.[PLVN_INTERCEPTOR_CATEGORIES](
            [INTERCEPTOR_CATEGORY_ID] [int] IDENTITY(1,1) NOT NULL,
            [INTERCEPTOR_KIND] [int] NOT NULL,
            [TITLE] [nvarchar](150) NOT NULL,
            [STATUS] [int] NOT NULL,
        CONSTRAINT [PK_PLVN_INTERCEPTOR_CATEGORIES] PRIMARY KEY CLUSTERED 
        (
            [INTERCEPTOR_CATEGORY_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PLVN_INTERCEPTORS')
    BEGIN
        CREATE TABLE @_dsn_main_@.[PLVN_INTERCEPTORS](
            [INTERCEPTOR_ID] [int] IDENTITY(1,1) NOT NULL,
            [INTERCEPTOR_CATEGORY] [int] NOT NULL,
            [INTERCEPTOR_PATH] [nvarchar](max) NULL,
            [STATUS] [int] NOT NULL,
        CONSTRAINT [PK_PLVN_INTERCEPTORS] PRIMARY KEY CLUSTERED 
        (
            [INTERCEPTOR_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PLVN_LEVEL_PROCESS')
    BEGIN
        CREATE TABLE @_dsn_main_@.[PLVN_LEVEL_PROCESS](
            [LEVEL_PROCESS_ID] [int] IDENTITY(1,1) NOT NULL,
            [PROCESS_KIND] [int] NOT NULL,
            [PROCESS_TYPE] [int] NOT NULL,
            [RELATION_ID] [int] NOT NULL,
            [CONTRAST] [nvarchar](50) NULL,
        CONSTRAINT [PK_PLVN_LEVEL_PROCESS] PRIMARY KEY CLUSTERED 
        (
            [LEVEL_PROCESS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PLVN_LOGS')
    BEGIN
        CREATE TABLE @_dsn_main_@.[PLVN_LOGS](
            [LOG_ID] [int] IDENTITY(1,1) NOT NULL,
            [SOURCE] [nvarchar](150) NOT NULL,
            [SOURCE_ID] [int] NOT NULL,
            [MESSAGE] [nvarchar](1000) NOT NULL,
            [TYPE] [int] NOT NULL,
            [TRACE] [nvarchar](max) NULL,
            [LOGDATE] [datetime] NOT NULL,
        CONSTRAINT [PK_PLVN_LOGS] PRIMARY KEY CLUSTERED 
        (
            [LOG_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PLVN_RESPONSES')
    BEGIN
        CREATE TABLE @_dsn_main_@.[PLVN_RESPONSES](
            [RESPONSE_ID] [int] IDENTITY(1,1) NOT NULL,
            [TYPE] [int] NOT NULL,
            [HEADER] [nvarchar](250) NOT NULL,
            [RESPONSE_DATA] [nvarchar](max) NULL,
            [STATUS] [int] NOT NULL,
        CONSTRAINT [PK_PLVN_RESPONSE] PRIMARY KEY CLUSTERED 
        (
            [RESPONSE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'PLVN_SETTINGS')
    BEGIN
        CREATE TABLE @_dsn_main_@.[PLVN_SETTINGS](
            [SETTING_ID] [int] IDENTITY(1,1) NOT NULL,
            [SETTING_KEY] [nvarchar](150) NOT NULL,
            [SETTING_VALUE] [nvarchar](max) NULL,
            [STATUS] [int] NOT NULL,
        CONSTRAINT [PK_PLVN_SETTINGS] PRIMARY KEY CLUSTERED 
        (
            [SETTING_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

        ALTER TABLE @_dsn_main_@.[PLVN_RESPONSES] ADD  CONSTRAINT [DF_PLVN_RESPONSE_STATUS]  DEFAULT ((1)) FOR [STATUS]
    END;

    SET IDENTITY_INSERT [PLVN_SETTINGS] ON 
    INSERT [PLVN_SETTINGS] ([SETTING_ID], [SETTING_KEY], [SETTING_VALUE], [STATUS]) VALUES (1, N'ENABLED', N'0', 1)
    INSERT [PLVN_SETTINGS] ([SETTING_ID], [SETTING_KEY], [SETTING_VALUE], [STATUS]) VALUES (2, N'TRACE_TIMEUP', N'15', 1)
    INSERT [PLVN_SETTINGS] ([SETTING_ID], [SETTING_KEY], [SETTING_VALUE], [STATUS]) VALUES (3, N'MFA_ENABLED', N'0', 1)
    INSERT [PLVN_SETTINGS] ([SETTING_ID], [SETTING_KEY], [SETTING_VALUE], [STATUS]) VALUES (4, N'MFA_UNTIL', N'7', 1)
    SET IDENTITY_INSERT [PLVN_SETTINGS] OFF


</querytag>