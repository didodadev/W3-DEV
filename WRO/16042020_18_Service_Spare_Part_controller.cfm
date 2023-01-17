<!-- Description : Ürün servis işlemleri wo.
Developer: Deniz Hamurpet
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'settings.list_service_spare'
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
        ,14
        ,'Ürün Servis İşlemleri'
        ,41680
        ,NULL
        ,'settings.list_service_spare'
        ,'settings/display/list_service_spare_part.cfm'
        ,'WBO/controller/ServiceSparePartController.cfm'
        ,1
        ,'Deployment'
        ,0
        ,NULL
        ,'v 11.1'
        ,0
        ,0
        ,0
        ,'Workcube Core'
        ,NULL
        ,'127.0.0.1'
        ,1209
        ,'2020-04-16 14:50:46.0'
        ,'127.0.0.1'
        ,1209
        ,'2020-04-16 16:44:29.747'
        ,'HTTP'
        ,NULL
        ,NULL
        ,'settings'
        ,'list_service_spare'
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
        ,1 
        ,NULL 
        ,NULL 
        ,0
        ,NULL
        )
    END
</querytag>