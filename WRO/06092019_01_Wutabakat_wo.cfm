<!-- Description : Mutabakat modülü
Developer: Canan Ebret
Company : Workcube
Destination: Main-->
<querytag>
    
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'finance.list_cari_letter'
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
        ,25
        ,'Mutabakat, BA, BS, Cari Hatırlatma'
        ,31568
        ,'finance.list_cari_letter'
        ,'finance.list_cari_letter'
        ,'Wutabakat/display/list_cari_letter.cfm'
        ,NULL
        ,2
        ,'Deployment'
        ,1
        ,NULL
        ,'1.0'
        ,0
        ,0
        ,0
        ,'IBS'
        ,NULL
        ,'127.0.0.1'
        ,1
        ,'2019-07-01 16:00:00.0'
        ,'127.0.0.1'
        ,73
        ,'2020-06-24 17:57:28.327'
        ,'Standart'
        ,2176
        ,NULL
        ,'Debt/Receivable Management'
        ,'list_cari_letter'
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
        ,1
        ,0
        ,0 
        ,NULL 
        ,NULL 
        ,0
        ,NULL
        )
    END

    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'finance.form_add_cari_letter'
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
        ,25
        ,'Mutabakat, BA, BS, Cari Hatırlatma Form - Ekleme'
        ,31568
        ,'finance.form_add_cari_letter'
        ,'finance.form_add_cari_letter'
        ,'AddOns/ibs/Wutabakat/form/form_add_cari_letter.cfm'
        ,NULL
        ,2
        ,'Deployment'
        ,0
        ,NULL
        ,'1.0'
        ,0
        ,0
        ,0
        ,'IBS'
        ,NULL
        ,'127.0.0.1'
        ,1
        ,'2019-07-01 16:00:00.0'
        ,'127.0.0.1'
        ,4
        ,'2019-07-03 12:36:19.25'
        ,'HTTP'
        ,2176
        ,NULL
        ,'Debt/Receivable Management'
        ,'form_add_cari_letter'
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
        ,1
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
        WHERE FULL_FUSEACTION = 'finance.add_cari_letter'
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
        ,25
        ,'Mutabakat, BA, BS, Cari Hatırlatma Query - Ekleme ve Güncelleme'
        ,31568
        ,'finance.add_cari_letter'
        ,'finance.add_cari_letter'
        ,'AddOns/ibs/Wutabakat/query/add_cari_letter.cfm'
        ,NULL
        ,2
        ,'Deployment'
        ,0
        ,NULL
        ,'1.0'
        ,0
        ,0
        ,0
        ,'IBS'
        ,NULL
        ,'127.0.0.1'
        ,1
        ,'2019-07-01 16:00:00.0'
        ,'127.0.0.1'
        ,4
        ,'2019-07-03 12:36:31.3'
        ,'HTTP'
        ,2176
        ,NULL
        ,'Debt/Receivable Management'
        ,'add_cari_letter'
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
        ,1
        ,0
        ,11 
        ,NULL 
        ,NULL 
        ,0
        ,NULL
        )
    END

    IF NOT EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'finance.form_upd_cari_letter'
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
            ,25
            ,'Mutabakat, BA, BS, Cari Hatırlatma Form - Güncelleme'
            ,31568
            ,'finance.form_upd_cari_letter'
            ,'finance.form_upd_cari_letter'
            ,'AddOns/ibs/Wutabakat/form/form_upd_cari_letter.cfm'
            ,NULL
            ,2
            ,'Deployment'
            ,0
            ,NULL
            ,'1.0'
            ,0
            ,0
            ,0
            ,'IBS'
            ,NULL
            ,'127.0.0.1'
            ,1
            ,'2019-07-01 16:00:00.0'
            ,'127.0.0.1'
            ,4
            ,'2019-07-03 12:36:44.007'
            ,'HTTP'
            ,2176
            ,NULL
            ,'Debt/Receivable Management'
            ,'form_upd_cari_letter'
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
            ,1
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
        WHERE FULL_FUSEACTION = 'finance.del_cari_letter'
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
        ,25
        ,'Mutabakat, BA, BS, Cari Hatırlatma Query - Silme'
        ,31568
        ,'finance.del_cari_letter'
        ,'finance.del_cari_letter'
        ,'AddOns/ibs/Wutabakat/query/del_cari_letter.cfm'
        ,NULL
        ,2
        ,'Deployment'
        ,0
        ,NULL
        ,'1.0'
        ,0
        ,0
        ,0
        ,'IBS'
        ,NULL
        ,'127.0.0.1'
        ,1
        ,'2019-07-01 16:00:00.0'
        ,'127.0.0.1'
        ,4
        ,'2019-07-03 12:36:59.667'
        ,'HTTP'
        ,2176
        ,NULL
        ,'Debt/Receivable Management'
        ,'del_cari_letter'
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
        ,1
        ,0
        ,11 
        ,NULL 
        ,NULL 
        ,0
        ,NULL
        )
    END
    
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'finance.popup_accept_cari_letter'
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
        ,25
        ,'Mutabakat, BA, BS, Cari Hatırlatma Form - Onay ve Red'
        ,31568
        ,'finance.popup_accept_cari_letter'
        ,'finance.popup_accept_cari_letter'
        ,'AddOns/ibs/Wutabakat/display/form_accept_cari_letter.cfm'
        ,NULL
        ,2
        ,'Deployment'
        ,0
        ,NULL
        ,'1.0'
        ,0
        ,0
        ,0
        ,'IBS'
        ,NULL
        ,'127.0.0.1'
        ,1
        ,'2019-07-01 16:00:00.0'
        ,'127.0.0.1'
        ,4
        ,'2019-07-03 12:37:16.613'
        ,'HTTP'
        ,2176
        ,NULL
        ,'Debt/Receivable Management'
        ,'popup_accept_cari_letter'
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
        ,1
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
        WHERE FULL_FUSEACTION = 'finance.send_cari_letter_mail'
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
        ,25
        ,'Mutabakat, BA, BS, Cari Hatırlatma Liste - Toplu Email Gönderme'
        ,31568
        ,'finance.send_cari_letter_mail'
        ,'finance.send_cari_letter_mail'
        ,'AddOns/ibs/Wutabakat/display/send_cari_letter_mail.cfm'
        ,NULL
        ,2
        ,'Deployment'
        ,0
        ,NULL
        ,'1.0'
        ,0
        ,0
        ,0
        ,'IBS'
        ,NULL
        ,'127.0.0.1'
        ,1
        ,'2019-07-01 16:00:00.0'
        ,'127.0.0.1'
        ,4
        ,'2019-07-03 12:37:25.257'
        ,'HTTP'
        ,2176
        ,NULL
        ,'Debt/Receivable Management'
        ,'send_cari_letter_mail'
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
        ,1
        ,0
        ,10 
        ,NULL 
        ,NULL 
        ,0
        ,NULL
        )
    END
    
</querytag>