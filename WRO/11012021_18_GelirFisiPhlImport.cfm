<!-- Description : Gelir fişi phl import işleminde satıralara etki etme eklendi.
Developer : Utku Gürler
Company : Mifa Bilgi Sistemleri
Destination : Main -->
<querytag>
 IF NOT EXISTS (
    SELECT WRK_OBJECTS_ID
    FROM WRK_OBJECTS
    WHERE FULL_FUSEACTION = 'objects.emptypopup_get_income_row_from_file'
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
            ,47
            ,'Dosyadan Gelir Fişi Ekle'
            ,61614
            ,NULL
            ,'objects.emptypopup_get_income_row_from_file'
            ,'objects/query/get_income_row_from_file.cfm'
            ,NULL
            ,1
            ,'Deployment'
            ,0
            ,NULL
            ,'v 12'
            ,0
            ,0
            ,0
            ,'Utku Gürler'
            ,0
            ,'127.0.0.1'
            ,18479
            ,'2021-01-08 08:14:57.0'
            ,NULL
            ,NULL
            ,NULL
            ,'HTTP'
            ,71
            ,NULL
            ,'objects'
            ,'emptypopup_get_income_row_from_file'
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