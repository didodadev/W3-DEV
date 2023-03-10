<!-- Description : e-irsaliye detay tanım woları
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'stock.popup_send_detail_eshipment' )
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
            ,'E-İrsaliye Gönderim Detayları'
            ,60913
            ,NULL
            ,'stock.popup_send_detail_eshipment'
            ,'e_government/display/send_detail_eshipment.cfm'
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
            ,'127.0.0.1'
            ,67
            ,'2020-06-02 17:00:53.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,2176
            ,NULL
            ,'stock'
            ,'popup_send_detail_eshipment'
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
    END;
    
    IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.popup_ajax_list_eshipment_detail' )
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
            ,'E-İrsaliye Görsel'
            ,60920
            ,NULL
            ,'objects.popup_ajax_list_eshipment_detail'
            ,'e_government/display/dsp_eshipment_detail.cfm'
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
            ,'127.0.0.1'
            ,67
            ,'2020-06-03 15:15:00.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,2176
            ,NULL
            ,'objects'
            ,'popup_ajax_list_eshipment_detail'
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
    END;

    IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'stock.popup_return_detail_eshipment' )
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
            ,'E-İrsaliye Dönüş Değerleri'
            ,60921
            ,NULL
            ,'stock.popup_return_detail_eshipment'
            ,'e_government/display/return_detail_eshipment.cfm'
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
            ,'127.0.0.1'
            ,67
            ,'2020-06-03 17:48:21.0'
            ,'127.0.0.1'
            ,67
            ,'2020-06-03 17:53:43.187'
            ,'Dark'
            ,2176
            ,NULL
            ,'invoice'
            ,'popup_return_detail_eshipment'
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
    END;
</querytag>