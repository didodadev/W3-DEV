<!-- Description : Yakıt İmport WO
Developer: Cemil Durgan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'settings.add_fuel_import'
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
                ,40
                ,'Yakıt Import'
                ,61346
                ,NULL
                ,'settings.add_fuel_import'
                ,'settings/form/add_fuel_import.cfm'
                ,NULL
                ,1
                ,'Deployment'
                ,0
                ,NULL
                ,'V16'
                ,0
                ,0
                ,0
                ,'Workcube Team'
                ,NULL
                ,'127.0.0.1'
                ,140
                ,'2020-10-28 19:15:45.0'
                ,'127.0.0.1'
                ,140
                ,'2020-10-28 19:19:34.937'
                ,'Standart'
                ,70
                ,NULL
                ,'settings'
                ,'add_fuel_import'
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
                ,3 
                ,NULL 
                ,NULL 
                ,0
                ,NULL
                )
        END
    
</querytag>