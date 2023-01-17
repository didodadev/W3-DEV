<!-- Description : Saglik Faturaları Kontrol Raporu sayfası wo oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.health_expenses_report')
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
            ,'Sağlık Faturaları Kontrol Raporu'
            ,60814
            ,NULL
            ,'report.health_expenses_report'
            ,'report/standart/health_expenses_report.cfm'
            ,NULL
            ,1
            ,'Deployment'
            ,0
            ,NULL
            ,'v16'
            ,0
            ,0
            ,0
            ,'Workcube Core'
            ,NULL
            ,'127.0.0.1'
            ,119
            ,'2020-04-28 13:18:56.0'
            ,'127.0.0.1'
            ,119
            ,'2020-04-28 13:29:03.493'
            ,'HTTP'
            ,2176
            ,NULL
            ,'report'
            ,'health_expenses_report'
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
            ,1
            ,NULL
        )
    END;
</querytag>