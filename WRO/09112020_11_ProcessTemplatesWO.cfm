<!-- Description : Process Template için Wo lar ve WRK_PROCESS_TEMPLATES tablosu oluşturuldu.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID  FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'dev.process_templates')
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
            ,'Process Templates'
            ,61421
            ,NULL
            ,'dev.process_templates'
            ,'WDO/modalProcessTemplates.cfm'
            ,'WBO/controller/ProcessTemplatesController.cfm'
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
            ,'195.214.135.5'
            ,10
            ,'2020-11-09 11:34:51.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,832
            ,NULL
            ,'dev'
            ,'process_templates'
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
            ,0 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END;
    IF NOT EXISTS (  SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'dev.emptypopup_add_process_templates')
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
            ,'Add Process Templates'
            ,NULL
            ,NULL
            ,'dev.emptypopup_add_process_templates'
            ,'WDO/development/query/add_process_templates.cfm'
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
            ,'195.214.135.5'
            ,10
            ,'2020-11-09 11:41:06.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,832
            ,NULL
            ,'dev'
            ,'emptypopup_add_process_templates'
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
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'dev.emptypopup_upd_process_templates')
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
            ,'Update Process Templates'
            ,61423
            ,NULL
            ,'dev.emptypopup_upd_process_templates'
            ,'WDO/development/query/upd_process_templates.cfm'
            ,NULL
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
            ,'195.214.135.5'
            ,10
            ,'2020-11-09 11:44:43.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,832
            ,NULL
            ,'dev'
            ,'emptypopup_upd_process_templates'
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
            ,0 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END;         
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='WRK_PROCESS_TEMPLATES')
    BEGIN
    CREATE TABLE [WRK_PROCESS_TEMPLATES](
        [WRK_PROCESS_TEMPLATE_ID] [int] IDENTITY(1,1) NOT NULL,
        [WRK_PROCESS_TEMPLATE_NAME] [nvarchar](250) NULL,
        [IS_ACTIVE] [bit] NULL,
        [IS_ACTION] [bit] NULL,
        [IS_DISPLAY] [bit] NULL,
        [IS_STAGE] [bit] NULL,
        [IS_MAIN] [bit] NULL,
        [BEST_PRACTISE_CODE] [nvarchar](25) NULL,
        [PROCESS_TEMPLATE_DETAIL] [nvarchar](500) NULL,
        [WORKCUBE_PRODUCT_ID] [int] NULL,
        [LICENCE_TYPE] [int] NULL,
        [RELATED_WO] [nvarchar](200) NULL,
        [AUTHOR_PARTNER_ID] [int] NULL,
        [AUTHOR_NAME] [nvarchar](100) NULL,
        [PROCESS_TEMPLATE_ICON_PATH] [nvarchar](200) NULL,
        [PROCESS_TEMPLATE_PATH] [nvarchar](500) NULL,
        [PROCESS_TEMPLATE_SECTORS] [nvarchar](500) NULL,
        [WRK_PROCESS_STAGE] [int] NULL,
        [MODULE_ID] [int] NULL,
        [PROCESS_TEMPLATE_VERSION] [nvarchar](25) NULL,
        [RECORD_DATE] [datetime] NULL,
        [RECORD_EMP] [int] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [UPDATE_DATE] [datetime] NULL,
        [UPDATE_EMP] [int] NULL,
        [UPDATE_IP] [nvarchar](50) NULL
    ) ON [PRIMARY]
    END;          
                    
</querytag>