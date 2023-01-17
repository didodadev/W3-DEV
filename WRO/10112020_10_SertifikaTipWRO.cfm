<!-- Description : Sertifikalar Parametre tablosu eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SETTINGS_CERTIFICATE' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
    CREATE TABLE [SETTINGS_CERTIFICATE]
        ( 
         [CERTIFICATE_ID] int NOT NULL IDENTITY(1,1)	
        ,[CERTIFICATE_NAME] nvarchar(100) NULL	
        ,[CERTIFICATE_DETAIL] nvarchar(500) NULL
        ,[IS_ACTIVE] [bit] NULL
        ,[CERTIFICATE_PERIOD] int NULL
        ,[CERTIFICATE_PERIOD_TYPE] nvarchar(100) NULL
        ,[RECORD_DATE] datetime NULL	
        ,[RECORD_EMP] int NULL	
        ,[RECORD_IP] nvarchar(43) NULL	
        ,[UPDATE_DATE] datetime NULL	
        ,[UPDATE_EMP] int NULL	
        ,[UPDATE_IP] nvarchar(43) NULL
        ,CONSTRAINT [PK_SETTINGS_CERTIFICATE_CERTIFICATE_ID] PRIMARY KEY ([CERTIFICATE_ID] ASC)
        );
    END

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TRAINING_CERTIFICATE' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
    CREATE TABLE [TRAINING_CERTIFICATE]
        ( 
         [TRAINING_CERTIFICATE_ID] int NOT NULL IDENTITY(1,1)	
        ,[CERTIFICATE_ID] int NOT NULL
        ,[PARTNER_ID] int NULL	
        ,[CONSUMER_ID] int NULL
        ,[EMPLOYEE_ID] int NULL
        ,[EMPLOYEE_APP_ID] int NULL
        ,[GET_DATE] datetime NULL
        ,[DATE_OF_VALIDITY] datetime NULL
        ,[DETAIL] nvarchar(max) NULL
        ,[RECORD_EMP] int NULL	
        ,[RECORD_IP] nvarchar(43) NULL	
        ,[RECORD_DATE] datetime NULL
        ,[UPDATE_DATE] datetime NULL	
        ,[UPDATE_EMP] int NULL	
        ,[UPDATE_IP] nvarchar(43) NULL
        ,CONSTRAINT [PK_TRAINING_CERTIFICATE_TRAINING_CERTIFICATE_ID] PRIMARY KEY ([TRAINING_CERTIFICATE_ID] ASC)
        );
    END

    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'training_management.certificates'
        )
        BEGIN
            INSERT [WRK_OBJECTS] 
            (
                [IS_ACTIVE],[MODULE_NO],[HEAD],[DICTIONARY_ID],[FRIENDLY_URL],[FULL_FUSEACTION],[FILE_PATH],[CONTROLLER_FILE_PATH],[LICENCE],[STATUS],[IS_MENU],[WINDOW],[VERSION],[USE_PROCESS_CAT],[USE_SYSTEM_NO],[USE_WORKFLOW],[AUTHOR],[OBJECTS_COUNT],[RECORD_IP],[RECORD_EMP],[RECORD_DATE],[UPDATE_IP],[UPDATE_EMP],[UPDATE_DATE],[SECURITY],[STAGE],[MODUL],[MODUL_SHORT_NAME],[FUSEACTION],[FILE_NAME],[IS_ADD],[IS_UPDATE],[IS_DELETE],[IS_WBO_DENIED],[IS_WBO_LOCK],[IS_WBO_LOG],[IS_SPECIAL],[EVENT_ADD],[EVENT_DASHBOARD],[EVENT_DETAIL],[EVENT_LIST],[EVENT_UPD],[TYPE],[POPUP_TYPE],[EXTERNAL_FUSEACTION],[IS_LEGACY],[ADDOPTIONS_CONTROLLER_FILE_PATH]
            )
            VALUES 
            (
                1,34,'Sertifikalar',29693,NULL,'training_management.certificates','training_management/display/list_certificates.cfm','WBO/controller/Certificatecontroller.cfm',1,'Deployment',0,NULL,'V19',0,0,0,NULL,NULL,'127.0.0.1',124,'2020-11-10 10:46:41.0','127.0.0.1',124,'2020-11-10 21:44:30.093','Standart',NULL,NULL,'training_management','certificates',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0 ,NULL ,NULL ,0,NULL
            )
        END
    
</querytag>