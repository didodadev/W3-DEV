<!-- Description : Süreçte aşama sayfası wo su eksik olanlar vardı bu nedenle eklendi
Developer: Tolga Sütlü
Company : Devonomy
Destination: Main -->
<querytag>
  IF NOT EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'process.form_upd_process_rows'
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
            ,30
            ,'Süreç/Aşama'
            ,41129
            ,'ProcessStage'
            ,'process.form_upd_process_rows'
            ,'process/form/form_upd_process_rows.cfm'
            ,NULL
            ,1
            ,'Deployment'
            ,0
            ,'popup'
            ,'v 12'
            ,0
            ,0
            ,0
            ,'Workcube Core'
            ,24918
            ,'192.168.18.34'
            ,1898
            ,'2010-11-25 15:53:42.823'
            ,'127.0.0.1'
            ,263
            ,'2020-03-30 12:02:56.97'
            ,'HTTP'
            ,2176
            ,'Process'
            ,'Business Process'
            ,'form_upd_process_rows'
            ,'form_upd_process_rows.cfm'
            ,0
            ,1
            ,0
            ,0
            ,0
            ,NULL
            ,0
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
    END
        
</querytag>