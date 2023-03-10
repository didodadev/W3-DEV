CREATE TABLE [@_dsn_main_@].[WRK_COOKIE](	  
    [WRK_COOKIE_ID] int NOT NULL, 
    [WRK_COOKIE] nvarchar(50) NULL, 
    [DOMAIN] nvarchar(250)  NULL, 
    [COKIE_DATE] datetime NULL, 
    [IS_APPROVE_ALL] bit NULL, 
    [IS_APPROVE_CUSTOM] bit NULL, 
    [IS_ANALYTIC] bit NULL, 
    [IS_MARKETING] bit NULL, 
    [IS_PERSONAL] bit NULL, 
    [TIME_STAMP] datetime NULL,
    [CGI_STRUCT] text NULL,
CONSTRAINT [PK__WRK_COOK__E6059E94F66EA278] PRIMARY KEY ([WRK_COOKIE_ID] ASC));

CREATE TABLE [@_dsn_main_@].[SUBSCRIPTION_CONTRACT_APPROVE](	 
    [APP_ID] int NOT NULL IDENTITY(1,1), 
    [SUBSCRIPTION_ID] int NULL, 
    [APP_DOMAIN] nvarchar(250) NULL, 
    [APP_APPROVED_DATE] datetime NULL, 
    [APP_APPROVED_NAME_SURNAME] nvarchar(250) NULL, 
    [RELEASE_NO] nvarchar(100) NULL, 
    [PATCH_NO] nvarchar(100) NULL, 
CONSTRAINT [PK__SUBSCRIP__F00E58045F84BA10] PRIMARY KEY ([APP_ID] ASC));