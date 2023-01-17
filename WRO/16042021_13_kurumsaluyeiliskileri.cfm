<!-- Description : Kurumsal Üye İlişkileri sayfası
Developer: Emine Yavaş
Company : Mifa Bilgi Sistemleri
Destination: Main -->
<querytag>
    IF NOT EXISTS (
    SELECT WRK_OBJECTS_ID
    FROM WRK_OBJECTS
    WHERE FULL_FUSEACTION = 'settings.form_add_company_relation'
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
            ,4
            ,'Kurumsal Üye İlişkileri'
            ,42667
            ,NULL
            ,'settings.form_add_company_relation'
            ,'settings/form/add_partner_relation.cfm'
            ,NULL
            ,1
            ,'Development'
            ,1
            ,NULL
            ,'V16'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,'78.183.98.245'
            ,59
            ,'2021-04-16 10:33:56.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Dark'
            ,NULL
            ,NULL
            ,'settings'
            ,'form_add_company_relation'
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
            ,1 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
</querytag>                   