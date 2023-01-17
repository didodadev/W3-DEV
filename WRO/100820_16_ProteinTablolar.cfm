<!-- Description : Protein Site,Page,Widget,Template,Menu Tablolarini Olusturur.
Developer: Semih AKARTUNA
Company : Yazılımsa
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='PROTEIN_SITES')
    BEGIN
        CREATE TABLE [PROTEIN_SITES](
            [SITE_ID] [int] IDENTITY(1,1) NOT NULL,
            [DOMAIN] [nvarchar](250) NOT NULL,
            [STATUS] [int] NOT NULL,
            [MAINTENANCE_MODE] [int] NOT NULL,
            [PRIMARY_DATA] [text] NULL,
            [ZONE_DATA] [text] NULL,
            [ACCESS_DATA] [text] NULL,
            [THEME_DATA] [text] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [COMPANY] [int] NULL,
        CONSTRAINT [PK_PROTEIN_SITES] PRIMARY KEY CLUSTERED 
        (
            [SITE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

        ALTER TABLE [PROTEIN_SITES] ADD  CONSTRAINT [DF_PROTEIN_SITES_STATUS]  DEFAULT ((0)) FOR [STATUS]

        ALTER TABLE [PROTEIN_SITES] ADD  CONSTRAINT [DF_PROTEIN_SITES_MAINTENANCE]  DEFAULT ((0)) FOR [MAINTENANCE_MODE]

    END

    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='PROTEIN_PAGES')
    BEGIN
        CREATE TABLE [PROTEIN_PAGES](
            [PAGE_ID] [int] IDENTITY(1,1) NOT NULL,
            [SITE] [int] NOT NULL,
            [TITLE] [nvarchar](140) NULL,
            [FRIENDLY_URL] [nvarchar](140) NULL,
            [TEMPLATE_BODY] [int] NULL,
            [TEMPLATE_INSIDE] [int] NULL,
            [STATUS] [int] NULL,
            [PAGE_DATA] [text] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            CONSTRAINT [PK_PROTEIN_PAGES] PRIMARY KEY CLUSTERED 
        (
            [PAGE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='PROTEIN_TEMPLATES')
    BEGIN
        CREATE TABLE [PROTEIN_TEMPLATES](
            [TEMPLATE_ID] [int] IDENTITY(1,1) NOT NULL,
            [SITE] [int] NOT NULL,
            [TITLE] [nvarchar](140) NULL,
            [STATUS] [int] NULL,
            [TYPE] [int] NULL,
            [DESIGN_DATA] [text] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_PROTEIN_TEMPLATES] PRIMARY KEY CLUSTERED 
        (
            [TEMPLATE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='PROTEIN_WIDGETS')
    BEGIN
        CREATE TABLE [PROTEIN_WIDGETS](
            [WIDGET_ID] [int] IDENTITY(1,1) NOT NULL,
            [SITE] [int] NOT NULL,
            [TITLE] [nvarchar](140) NULL,
            [STATUS] [int] NULL,
            [WIDGET_NAME] [nvarchar](140) NULL,
            [WIDGET_DATA] [text] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_PROTEIN_WIDGETS] PRIMARY KEY CLUSTERED 
        (
            [WIDGET_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END

     IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='PROTEIN_MENUS')
	BEGIN
        CREATE TABLE [PROTEIN_MENUS](
            [MENU_ID] [int] IDENTITY(1,1) NOT NULL,
            [SITE] [int] NOT NULL,
            [MENU_NAME] [nvarchar](250) NULL,
            [MENU_STATUS] [int] NULL,
            [IS_DEFAULT] [int] NULL,
            [MENU_DATA] [text] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_PROTEIN_MENUS] PRIMARY KEY CLUSTERED 
        (
            [MENU_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
    
</querytag>