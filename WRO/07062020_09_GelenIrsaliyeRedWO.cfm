<!-- Description : Gelen E-İrsaliye reddi için wo oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'stock.popup_reject_despatch')
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
            ,28
            ,'E-İrsaliye Red'
            ,60937
            ,NULL
            ,'stock.popup_reject_despatch'
            ,'e_government/display/reject_despatch.cfm'
            ,NULL
            ,1
            ,'Deployment'
            ,0
            ,NULL
            ,'v19'
            ,0
            ,0
            ,0
            ,'Workcube Core'
            ,NULL
            ,'127.0.0.1'
            ,119
            ,'2020-06-08 07:49:40.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,2176
            ,NULL
            ,'stock'
            ,'popup_reject_despatch'
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
</querytag>