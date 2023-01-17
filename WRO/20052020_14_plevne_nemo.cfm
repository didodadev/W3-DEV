<!-- Description : Plevne V2 Nemo yapılandırma eklendi
Developer: Halit Yurttaş
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'settings.security_rule'
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
            ,7
            ,'Güvenlik Şablonu'
            ,271
            ,'settings_security_rule'
            ,'settings.security_rule'
            ,'/settings/form/form_plevne_rule.cfm'
            ,NULL
            ,1
            ,'Analys'
            ,0
            ,NULL
            ,'1'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,'127.0.0.1'
            ,73
            ,'2020-05-19 01:09:47.0'
            ,'127.0.0.1'
            ,73
            ,'2020-05-19 01:14:59.347'
            ,'HTTP'
            ,2176
            ,NULL
            ,'settings_security_rule'
            ,'security_rule'
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