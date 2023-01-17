<!--Description : Sağlık harcaması WRO yazıldı.(myhome.emptypopup_upd_health_expense_approve)
Developer: Emine Yılmaz
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'myhome.emptypopup_upd_health_expense_approve'
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
            ,70
            ,'Sağlık Harcaması'
            ,33706
            ,'HealthExpenseApproveUpdQuery'
            ,'myhome.emptypopup_upd_health_expense_approve'
            ,'myhome/query/upd_health_expense_form.cfm'
            ,NULL
            ,1
            ,'Deployment'
            ,0
            ,NULL
            ,'V16'
            ,0
            ,0
            ,0
            ,'Workcube Core'
            ,NULL
            ,127.0.0.1
            ,113
            ,'2019-11-27 15:38:13.0'
            ,192.168.69.85
            ,263
            ,'2020-01-07 13:49:10.323'
            ,'HTTP'
            ,2176
            ,NULL
            ,'myhome'
            ,'emptypopup_upd_health_expense_approve'
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
    END
</querytag>