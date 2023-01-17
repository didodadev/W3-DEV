<!-- Description : Sağlık Dashboard sayfası wo oluşturuldu.
Developer: Botan Kayğan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'hr.health_dashboard' )
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
            ,'Sağlık Dashboard'
            ,60447
            ,NULL
            ,'hr.health_dashboard'
            ,'hr/display/health_dashboard.cfm'
            ,'WBO/controller/HealthDashboardController.cfm'
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
            ,'2020-03-05 11:54:40.0'
            ,'127.0.0.1'
            ,119
            ,'2020-03-20 13:25:22.79'
            ,'HTTP'
            ,2176
            ,NULL
            ,'health'
            ,'health_dashboard'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,0
            ,1
            ,0
            ,0
            ,0
            ,13 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
        )
    END
</querytag>