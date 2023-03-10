<!-- Description : Release Eksik Alanlar oluşturuldu.
Developer: Gülbahar İnan
Company : Workcube
Destination: main -->
<querytag>
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='USE_EFATURA')
    BEGIN
        ALTER TABLE CONSUMER_HISTORY ALTER COLUMN USE_EFATURA bit NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_PERSON')
    BEGIN
        ALTER TABLE COMPANY ALTER COLUMN IS_PERSON bit NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='USE_EFATURA')
    BEGIN
        ALTER TABLE COMPANY ALTER COLUMN USE_EFATURA bit NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_PERSON')
    BEGIN
        ALTER TABLE COMPANY_HISTORY ALTER COLUMN IS_PERSON bit NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PROTEIN_WIDGETS')
    BEGIN
        CREATE TABLE [PROTEIN_WIDGETS](	  [WIDGET_ID] int NOT NULL IDENTITY(1,1)	, [SITE] int NOT NULL	, [TITLE] nvarchar(140) NULL	, [STATUS] int NULL	, [WIDGET_NAME] nvarchar(140) NULL	, [WIDGET_DATA] nvarchar(MAX) NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(50) NULL	, CONSTRAINT [PK_PROTEIN_WIDGETS] PRIMARY KEY ([WIDGET_ID] ASC));
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_WIDGET' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='XML_PATH')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD XML_PATH nvarchar(250);
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_PUANTAJ_ROWS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_4691_CONTROL')
    BEGIN
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ALTER COLUMN IS_4691_CONTROL bit NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_SSK_EXPORTS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_4691')
    BEGIN
        ALTER TABLE EMPLOYEES_SSK_EXPORTS ALTER COLUMN IS_4691 bit NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_MENU' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='USER_GROUP')
    BEGIN
        ALTER TABLE WRK_MENU ALTER COLUMN USER_GROUP nvarchar(max) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_MENU' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='BEST_PRACTISE')
    BEGIN
        ALTER TABLE WRK_MENU ALTER COLUMN BEST_PRACTISE nvarchar(max) NULL;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_MENU' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='MENU_JSON')
    BEGIN
        ALTER TABLE WRK_MENU ALTER COLUMN MENU_JSON nvarchar(max) NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PROTEIN_SITES')
    BEGIN
        CREATE TABLE [PROTEIN_SITES](	 [SITE_ID] int NOT NULL IDENTITY(1,1)	, [DOMAIN] nvarchar(250) NOT NULL	, [STATUS] int NOT NULL	, [MAINTENANCE_MODE] int NOT NULL	, [PRIMARY_DATA] nvarchar(MAX) NULL	, [ZONE_DATA] nvarchar(MAX) NULL	, [ACCESS_DATA] nvarchar(MAX) NULL	, [THEME_DATA] nvarchar(MAX) NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(50) NULL	, [COMPANY] int NULL	, CONSTRAINT [PK_PROTEIN_SITES] PRIMARY KEY ([SITE_ID] ASC));

    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PROTEIN_TEMPLATES')
    BEGIN
        CREATE TABLE [PROTEIN_TEMPLATES](	  [TEMPLATE_ID] int NOT NULL IDENTITY(1,1)	, [SITE] int NOT NULL	, [TITLE] nvarchar(140) NULL	, [STATUS] int NULL	, [TYPE] int NULL	, [DESIGN_DATA] nvarchar(MAX) NULL	, [RECORD_DATE] datetime NULL	, [RECORD_EMP] int NULL	, [RECORD_IP] nvarchar(50) NULL	, [UPDATE_DATE] datetime NULL	, [UPDATE_EMP] int NULL	, [UPDATE_IP] nvarchar(50) NULL	, CONSTRAINT [PK_PROTEIN_TEMPLATES] PRIMARY KEY ([TEMPLATE_ID] ASC));
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PROTEIN_PAGES')
    BEGIN
        CREATE TABLE [PROTEIN_PAGES]
        (
            [PAGE_ID] int NOT NULL IDENTITY(1,1)
            , [SITE] int NOT NULL
            , [TITLE] nvarchar(140) NULL
            , [FRIENDLY_URL] nvarchar(140) NULL
            , [TEMPLATE_BODY] int NULL
            , [TEMPLATE_INSIDE] int NULL
            , [STATUS] int NULL
            , [PAGE_DATA] nvarchar(MAX) NULL
            , [RECORD_DATE] datetime NULL
            , [RECORD_EMP] int NULL
            , [RECORD_IP] nvarchar(50) NULL
            , [UPDATE_DATE] datetime NULL
            , [UPDATE_EMP] int NULL
            , [UPDATE_IP] nvarchar(50) NULL
            , CONSTRAINT [PK_PROTEIN_PAGES] PRIMARY KEY ([PAGE_ID] ASC)
        )
        ;
    END;
</querytag>



