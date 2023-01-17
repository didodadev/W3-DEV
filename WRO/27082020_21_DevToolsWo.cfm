<!-- Description : Dev Tools sayfası oluşturuldu.
Developer: Emine Yilmaz
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (
    SELECT WRK_OBJECTS_ID
    FROM WRK_OBJECTS
    WHERE FULL_FUSEACTION = 'dev.tools'
    )
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
        ,'Tools'
        ,60879
        ,NULL
        ,'dev.tools'
        ,'WDO/catalogs/designers/dtdesigner/layout.cfm'
        ,NULL
        ,1
        ,'Development'
        ,0
        ,NULL
        ,'v19'
        ,0
        ,0
        ,0
        ,'Workcube Core'
        ,NULL
        ,'127.0.0.1'
        ,124
        ,'2020-08-27 16:56:10.0'
        ,'127.0.0.1'
        ,124
        ,'2020-08-27 17:02:53.31'
        ,'Dark'
        ,160
        ,NULL
        ,'dev'
        ,'tools'
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
        ,1
        ,0
        ,0
        ,0 
        ,NULL 
        ,NULL 
        ,0
        ,NULL
        )
    END

</querytag>