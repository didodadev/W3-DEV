<!-- Description : Mekan Tanımları WO.
Developer: Emine Yılmaz
Company : Workcube
Destination: main -->

<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'assetcare.assetcare_space'
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
            ,'Mekan Tanımları'
            ,60367
            ,NULL
            ,'assetcare.assetcare_space'
            ,'assetcare/form/assetcare_space.cfm'
            ,NULL
            ,1
            ,'Testing'
            ,0
            ,NULL
            ,'0.1'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,'192.168.69.85'
            ,263
            ,'2020-02-27 06:54:09.0'
            ,'192.168.69.85'
            ,263
            ,'2020-03-06 14:21:40.56'
            ,'HTTP'
            ,2176
            ,NULL
            ,'assetcare'
            ,'assetcare_space'
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
            ,1 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
</querytag>