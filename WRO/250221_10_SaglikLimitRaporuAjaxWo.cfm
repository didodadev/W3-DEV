<!-- Description : Sağlık limit raporu ajax wo oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.emptypopup_health_expense_limits_detail')
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
            ,[MAIN_VERSION]
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
            ,'Sağlık Limit Raporu (ajax)'
            ,61425
            ,NULL
            ,'report.emptypopup_health_expense_limits_detail'
            ,'report/standart/health_expense_limits_detail.cfm'
            ,NULL
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
            ,'176.54.179.109'
            ,8
            ,'2021-02-26 09:53:08.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,832
            ,NULL
            ,'report'
            ,'emptypopup_health_expense_limits_detail'
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