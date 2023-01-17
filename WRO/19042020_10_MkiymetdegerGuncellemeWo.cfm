<!-- Description : menkul kıymet değer güncelleme objeleier
Developer: İlker Altındal
Company : Workcube
Destination: main -->

<querytag>

    IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'credit.ajax_stockbond_value_currently' )
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
        ,36
        ,'Menkul Kıymet Alış'
        ,49619
        ,'StockbondValueAjax'
        ,'credit.ajax_stockbond_value_currently'
        ,'credit/form/upd_actual_value.cfm'
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
        ,67
        ,'2019-11-11 12:13:03.0'
        ,'192.168.69.83'
        ,57
        ,'2019-12-14 05:40:37.33'
        ,'HTTP'
        ,2176
        ,NULL
        ,'credit'
        ,'ajax_stockbond_value_currently'
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


IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'credit.emptypopup_ajax_stockbond_value_currently' )
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
    ,36
    ,'Menkul Kıymet Alış'
    ,49619
    ,NULL
    ,'credit.emptypopup_ajax_stockbond_value_currently'
    ,'credit/query/upd_actual_value.cfm'
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
    ,67
    ,'2019-11-11 12:15:01.0'
    ,NULL
    ,NULL
    ,NULL
    ,'HTTP'
    ,2176
    ,NULL
    ,'credit'
    ,'emptypopup_ajax_stockbond_value_currently'
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