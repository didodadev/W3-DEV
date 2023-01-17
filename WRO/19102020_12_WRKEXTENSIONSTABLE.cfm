<!-- Description : WRK_EXTENSIONS Tablosu oluşturuldu.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='WRK_EXTENSIONS')
    BEGIN
        CREATE TABLE [WRK_EXTENSIONS](
            [WRK_EXTENSION_ID] [int] IDENTITY(1,1) NOT NULL,
            [WRK_EXTENSION_NAME] [nvarchar](250) NULL,
            [IS_ACTIVE] [bit] NULL,
            [BEST_PRACTISE_CODE] [nvarchar](25) NULL,
            [EXTENSION_DETAIL] [nvarchar](500) NULL,
            [WORKCUBE_PRODUCT_ID] [int] NULL,
            [LICENCE_TYPE] [int] NULL,
            [RELATED_WO] [nvarchar](200) NULL,
            [AUTHOR_PARTNER_ID] [int] NULL,
            [AUTHOR_NAME] [nvarchar](100) NULL,
            [EXTENSION_ICON_IMAGE_PATH] [nvarchar](200) NULL,
            [EXTENSION_SECTORS] [nvarchar](500) NULL,
            [WRK_PROCESS_STAGE] [int] NULL,
            [EXTENSION_VERSION] [nvarchar](25) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK__WRK_EXTE__4CCFB490590FD432] PRIMARY KEY CLUSTERED 
        (
            [WRK_EXTENSION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;

    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='WRK_COMPONENTS')
    BEGIN
        CREATE TABLE [WRK_COMPONENTS](
            [WRK_COMPONENT_ID] [int] IDENTITY(1,1) NOT NULL,
            [WRK_EXTENSION_ID] [int] NULL,
            [WORKING_NUMBER] [int] NULL,
            [WRK_COMPONENT_NAME] [nvarchar](200) NULL,
            [COMPONENT_FILE_PATH] [nvarchar](250) NULL,
            [WORKING_PLACE] [int] NULL,
            [WORKING_ACTION] [int] NULL,
            [IS_ACTIVE] [bit] NULL,
            [IS_ADD_WORK] [bit] NULL,
            [IS_UPD_WORK] [bit] NULL,
            [IS_DET_WORK] [bit] NULL,
            [IS_LIST_WORK] [bit] NULL,
            [IS_DASHBOARD_WORK] [bit] NULL,
            [IS_INFO_WORK] [bit] NULL,
            [WRK_COMPONENT_DETAIL] [nvarchar](500) NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [IS_DEL_WORK] [bit] NULL,
        PRIMARY KEY CLUSTERED 
        (
            [WRK_COMPONENT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
    IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'dev.emptypopup_add_extensions')
    BEGIN
        INSERT [WRK_OBJECTS] (
            [IS_ACTIVE]
            ,[MODULE_NO]
            ,[HEAD]
            ,[DICTIONARY_ID]
            ,[FRIENDLY_URL]
            ,[FULL_FUSEACTION]
            ,[FILE_PATH]
            ,[CONTROLLER_FILE_PATH]
            ,[LICENCE]
            ,[STATUS]
            ,[IS_MENU]
            ,[WINDOW]
            ,[VERSION]
            ,[USE_PROCESS_CAT]
            ,[USE_SYSTEM_NO]
            ,[USE_WORKFLOW]
            ,[AUTHOR]
            ,[OBJECTS_COUNT]
            ,[RECORD_IP]
            ,[RECORD_EMP]
            ,[RECORD_DATE]
            ,[UPDATE_IP]
            ,[UPDATE_EMP]
            ,[UPDATE_DATE]
            ,[SECURITY]
            ,[STAGE]
            ,[MODUL]
            ,[MODUL_SHORT_NAME]
            ,[FUSEACTION]
            ,[FILE_NAME]
            ,[IS_ADD]
            ,[IS_UPDATE]
            ,[IS_DELETE]
            ,[IS_WBO_DENIED]
            ,[IS_WBO_LOCK]
            ,[IS_WBO_LOG]
            ,[IS_SPECIAL]
            ,[EVENT_ADD]
            ,[EVENT_DASHBOARD]
            ,[EVENT_DETAIL]
            ,[EVENT_LIST]
            ,[EVENT_UPD]
            ,[TYPE]
            ,[POPUP_TYPE]
            ,[EXTERNAL_FUSEACTION]
            ,[IS_LEGACY]
            ,[ADDOPTIONS_CONTROLLER_FILE_PATH]
            )
        VALUES (
            0
            ,42
            ,'Add Extensions'
            ,61333
            ,NULL
            ,'dev.emptypopup_add_extensions'
            ,'WDO/development/query/add_extensions.cfm'
            ,NULL
            ,1
            ,'Analys'
            ,0
            ,NULL
            ,'v19'
            ,0
            ,0
            ,0
            ,'Workcube Core'
            ,NULL
            ,'81.214.54.35'
            ,10
            ,'2020-10-20 13:33:36.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,832
            ,NULL
            ,'dev'
            ,'emptypopup_add_extensions'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,0
            ,0
            ,0
            ,0
            ,0
            ,11 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END;
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'dev.extensions')
    BEGIN
        INSERT [WRK_OBJECTS] (
            [IS_ACTIVE]
            ,[MODULE_NO]
            ,[HEAD]
            ,[DICTIONARY_ID]
            ,[FRIENDLY_URL]
            ,[FULL_FUSEACTION]
            ,[FILE_PATH]
            ,[CONTROLLER_FILE_PATH]
            ,[LICENCE]
            ,[STATUS]
            ,[IS_MENU]
            ,[WINDOW]
            ,[VERSION]
            ,[USE_PROCESS_CAT]
            ,[USE_SYSTEM_NO]
            ,[USE_WORKFLOW]
            ,[AUTHOR]
            ,[OBJECTS_COUNT]
            ,[RECORD_IP]
            ,[RECORD_EMP]
            ,[RECORD_DATE]
            ,[UPDATE_IP]
            ,[UPDATE_EMP]
            ,[UPDATE_DATE]
            ,[SECURITY]
            ,[STAGE]
            ,[MODUL]
            ,[MODUL_SHORT_NAME]
            ,[FUSEACTION]
            ,[FILE_NAME]
            ,[IS_ADD]
            ,[IS_UPDATE]
            ,[IS_DELETE]
            ,[IS_WBO_DENIED]
            ,[IS_WBO_LOCK]
            ,[IS_WBO_LOG]
            ,[IS_SPECIAL]
            ,[EVENT_ADD]
            ,[EVENT_DASHBOARD]
            ,[EVENT_DETAIL]
            ,[EVENT_LIST]
            ,[EVENT_UPD]
            ,[TYPE]
            ,[POPUP_TYPE]
            ,[EXTERNAL_FUSEACTION]
            ,[IS_LEGACY]
            ,[ADDOPTIONS_CONTROLLER_FILE_PATH]
            )
        VALUES (
            1
            ,42
            ,'Extension'
            ,61331
            ,NULL
            ,'dev.extensions'
            ,'WDO/modalExtensions.cfm'
            ,'WBO/controller/ExtensionsController.cfm'
            ,1
            ,'Analys'
            ,0
            ,NULL
            ,'v19'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,'88.236.69.154'
            ,10
            ,'2020-10-20 09:26:57.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,832
            ,NULL
            ,'dev'
            ,'extensions'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,1
            ,0
            ,0
            ,1
            ,1
            ,7 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END;
    
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'dev.emptypopup_upd_extensions')
    BEGIN
        INSERT [WRK_OBJECTS] (
            [IS_ACTIVE]
            ,[MODULE_NO]
            ,[HEAD]
            ,[DICTIONARY_ID]
            ,[FRIENDLY_URL]
            ,[FULL_FUSEACTION]
            ,[FILE_PATH]
            ,[CONTROLLER_FILE_PATH]
            ,[LICENCE]
            ,[STATUS]
            ,[IS_MENU]
            ,[WINDOW]
            ,[VERSION]
            ,[USE_PROCESS_CAT]
            ,[USE_SYSTEM_NO]
            ,[USE_WORKFLOW]
            ,[AUTHOR]
            ,[OBJECTS_COUNT]
            ,[RECORD_IP]
            ,[RECORD_EMP]
            ,[RECORD_DATE]
            ,[UPDATE_IP]
            ,[UPDATE_EMP]
            ,[UPDATE_DATE]
            ,[SECURITY]
            ,[STAGE]
            ,[MODUL]
            ,[MODUL_SHORT_NAME]
            ,[FUSEACTION]
            ,[FILE_NAME]
            ,[IS_ADD]
            ,[IS_UPDATE]
            ,[IS_DELETE]
            ,[IS_WBO_DENIED]
            ,[IS_WBO_LOCK]
            ,[IS_WBO_LOG]
            ,[IS_SPECIAL]
            ,[EVENT_ADD]
            ,[EVENT_DASHBOARD]
            ,[EVENT_DETAIL]
            ,[EVENT_LIST]
            ,[EVENT_UPD]
            ,[TYPE]
            ,[POPUP_TYPE]
            ,[EXTERNAL_FUSEACTION]
            ,[IS_LEGACY]
            ,[ADDOPTIONS_CONTROLLER_FILE_PATH]
            )
        VALUES (
            0
            ,42
            ,'Update Extensions'
            ,61334
            ,NULL
            ,'dev.emptypopup_upd_extensions'
            ,'WDO/development/query/upd_extensions.cfm'
            ,NULL
            ,1
            ,'Analys'
            ,0
            ,NULL
            ,'v19'
            ,0
            ,0
            ,0
            ,'Workcube Core'
            ,NULL
            ,'81.214.54.35'
            ,10
            ,'2020-10-20 13:38:43.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,832
            ,NULL
            ,'dev'
            ,'emptypopup_upd_extensions'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,0
            ,0
            ,0
            ,0
            ,0
            ,11 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END;
</querytag>