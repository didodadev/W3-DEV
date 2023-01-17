<!-- Description :Detaylı Anket Raporu Excel Child WOdur.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'report.emptypopup_list_employee_survey_detail'
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
        ,66
        ,'Detaylı Anket Raporu (Excel)'
        ,60964
        ,NULL
        ,'report.emptypopup_list_employee_survey_detail'
        ,'report/standart/list_survey_detail_report.cfm'
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
        ,'127.0.0.1'
        ,124
        ,'2020-06-11 20:18:13.0'
        ,'127.0.0.1'
        ,124
        ,'2020-06-11 20:24:50.157'
        ,'Standart'
        ,NULL
        ,NULL
        ,'report'
        ,'emptypopup_list_employee_survey_detail'
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