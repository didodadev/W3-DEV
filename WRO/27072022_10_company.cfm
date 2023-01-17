<!-- Description : Holistic 22.2 sürümü tablolar ve kolon değişiklikleri
Developer: Fatih Kara
Company : Workcube
Destination: Company -->
<querytag>  
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SUBSCRIPTION_UPGRADES')
    BEGIN
       
        CREATE TABLE [SUBSCRIPTION_UPGRADES]
        (	  
            [SUBSCRIPTION_UPGRADES_ID] int NOT NULL IDENTITY(1,1), 
            [SUBSCRIPTION_NO] nvarchar(100) NULL, 
            [DOMAIN] nvarchar(250) NULL, 
            [RELEASE] nvarchar(50) NULL, 
            [BRANCH] nvarchar(100) NULL, 
            [UPGRADE_DATE] datetime NULL, 
            [UPGRADE_TYPE] nvarchar(50) NULL, 
            [UPGRADE_EMP_ID] int NULL, 
            [UPGRADE_USER_NAME_SURNAME] nvarchar(100) NULL, 
            [UPGRADE_USER_EMAIL] nvarchar(100) NULL
        );

    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'ORDER_PRE')
    BEGIN
       
        CREATE TABLE [ORDER_PRE]
        (	  
            [ORDER_PRE_ID] int NOT NULL IDENTITY(1,1), 
            [STATUS] int NOT NULL, 
            [COOKIE_NAME] nvarchar(250) NULL, 
            [IBAN_NO] nvarchar(150) NULL, 
            [DOMAIN_NAME] nvarchar(150) NULL, 
            [ASSET_ID] int NULL, 
            [RECORD_PAR] int NULL, 
            [RECORD_EMP] int NULL, 
            [RECORD_GUEST] bit NULL, 
            [RECORD_CONS] int NULL, 
            [RECORD_DATE] datetime NULL, 
            [RECORD_IP] nvarchar(50) NULL,
            CONSTRAINT [PK_ORDER_PRE] PRIMARY KEY ([ORDER_PRE_ID] ASC)
        ); 

    END;

</querytag>