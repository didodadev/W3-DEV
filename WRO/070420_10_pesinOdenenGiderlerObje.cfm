<!-- Description : Peşin Ödenen Giderler Raporu Wo.
Developer: İlker Altındal
Company : Workcube
Destination: Main -->

<querytag>

IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.report_prepaid_expenses')
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
            ,86
            ,'Peşin Ödenen Giderler Denetim Raporu'
            ,45607
            ,NULL
            ,'report.report_prepaid_expenses'
            ,'report/standart/report_prepaid_expenses.cfm'
            ,NULL
            ,1
            ,'Analys'
            ,0
            ,NULL
            ,'v19'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,'78.180.51.7'
            ,6
            ,'2020-04-07 01:24:59.0'
            ,'78.180.51.7'
            ,6
            ,'2020-04-07 02:15:23.163'
            ,'HTTP'
            ,NULL
            ,NULL
            ,'report'
            ,'report_prepaid_expenses'
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
            ,8 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
</querytag>