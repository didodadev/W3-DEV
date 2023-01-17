<!-- Description : Muhtasar 1.0 WO'su eklendi.
Developer: Yunus Özay
Company : Team YAzılım
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.muhtasar_beyanname' )
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
            ,22
            ,'Muhtasar Beyannamesi'
            ,47453
            ,NULL
            ,'report.muhtasar_beyanname'
            ,'report/standart/muhtasar_beyanname.cfm'
            ,NULL
            ,1
            ,'Deployment'
            ,NULL
            ,'normal'
            ,'v16'
            ,NULL
            ,NULL
            ,NULL
            ,'Workcube Core'
            ,472
            ,'127.0.0.1'
            ,10
            ,'2013-12-28 12:46:58.0'
            ,NULL
            ,NULL
            ,NULL
            ,'HTTP'
            ,52
            ,'Report'
            ,'Accounting Transactions'
            ,'muhtasar_beyanname'
            ,'muhtasar_beyanname.cfm'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,0
            ,0
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,8 
            ,NULL 
            ,NULL 
            ,1
            ,NULL
            )
    END;
</querytag>
