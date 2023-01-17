<!-- Description : Diğer işlemler altına değerlendirme Formları Onay sayfası Eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'myhome.list_detail_survey_approve'
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
        ,65
        ,'Değerlendirme Formu Onay'
        ,61031
        ,NULL
        ,'myhome.list_detail_survey_approve'
        ,'myhome/display/list_detail_survey_approve.cfm'
        ,NULL
        ,1
        ,'Deployment'
        ,0
        ,NULL
        ,'V19'
        ,0
        ,0
        ,0
        ,'Workcube Team'
        ,NULL
        ,'127.0.0.1'
        ,124
        ,'2020-06-25 12:12:15.0'
        ,'127.0.0.1'
        ,13
        ,'2020-07-06 16:57:11.403'
        ,'Standart'
        ,NULL
        ,NULL
        ,'hr'
        ,'list_detail_survey_approve'
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
END
    
</querytag>