<!-- Description : borc alacak tutmayanlar muhasebe fişleri excel getiren scripttir.
Developer: Melek Kocabey
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'report.emptypopup_borc_alacak_tutmayanlar'
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
            ,33
            ,'Borç Alacak Tutmayan Muhasebe Fişleri'
            ,39161
            ,NULL
            ,'report.emptypopup_borc_alacak_tutmayanlar'
            ,'report/standart/borc_alacak_tutmayanlar.cfm'
            ,NULL
            ,1
            ,'Analys'
            ,0
            ,NULL
            ,'v16'
            ,0
            ,0
            ,0
            ,'Workcube Core'
            ,NULL
            ,'127.0.0.1'
            ,15
            ,'2020-07-17 15:28:53.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,70
            ,NULL
            ,'report'
            ,'emptypopup_borc_alacak_tutmayanlar'
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
            ,10 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
</querytag>