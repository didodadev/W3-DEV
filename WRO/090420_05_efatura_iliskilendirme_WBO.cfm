<!-- Description : E-fatura ilişkilendirme ekranı için WBO kaydı
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main -->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'invoice.popup_import_einvoice'
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
        ,28
        ,'E-Fatura İçe Aktar'
        ,60697
        ,'import_einvoice'
        ,'invoice.popup_import_einvoice'
        ,'e_government/form/import_einvoice.cfm'
        ,NULL
        ,1
        ,'Development'
        ,0
        ,NULL
        ,'1.0'
        ,0
        ,0
        ,0
        ,'Workcube Core'
        ,NULL
        ,'85.107.147.183'
        ,48
        ,'2020-03-30 23:55:48.0'
        ,'127.0.0.1'
        ,48
        ,'2020-03-31 02:39:16.447'
        ,'HTTPS'
        ,2176
        ,NULL
        ,'invoice'
        ,'popup_import_einvoice'
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

    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'invoice.emptypopup_import_einvoice'
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
        ,28
        ,'E-Fatura İçe Aktar'
        ,60697
        ,NULL
        ,'invoice.emptypopup_import_einvoice'
        ,'e_government/query/import_einvoice.cfm'
        ,NULL
        ,1
        ,'Development'
        ,0
        ,NULL
        ,'1.0'
        ,0
        ,0
        ,0
        ,'Workcube Core'
        ,NULL
        ,'127.0.0.1'
        ,48
        ,'2020-03-31 02:54:44.0'
        ,NULL
        ,NULL
        ,NULL
        ,'HTTPS'
        ,2176
        ,NULL
        ,'invoice'
        ,'emptypopup_import_einvoice'
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