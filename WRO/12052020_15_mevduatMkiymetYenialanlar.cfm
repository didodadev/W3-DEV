<!-- Description : Menkul kıymet getiri tarafı için obje
Developer: İlker Altındal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'credit.emptypopup_stockbond_recurring_yield'
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
        ,36
        ,'Menkul Kıymet Getirileri'
        ,59786
        ,NULL
        ,'credit.emptypopup_stockbond_recurring_yield'
        ,'credit/query/stockbond_recurring_yield.cfm'
        ,NULL
        ,1
        ,'Analys'
        ,0
        ,NULL
        ,'v16'
        ,0
        ,0
        ,0
        ,NULL
        ,NULL
        ,'127.0.0.1'
        ,67
        ,'2020-05-13 18:32:38.0'
        ,NULL
        ,NULL
        ,NULL
        ,'HTTP'
        ,2176
        ,NULL
        ,'credit'
        ,'emptypopup_stockbond_recurring_yield'
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
END;

IF NOT EXISTS (
    SELECT WRK_OBJECTS_ID
    FROM WRK_OBJECTS
    WHERE FULL_FUSEACTION = 'credit.stockbond_recurring_yield'
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
    ,36
    ,'Menkul Kıymet Getirileri'
    ,59786
    ,NULL
    ,'credit.stockbond_recurring_yield'
    ,'credit/display/stockbond_recurring_yield.cfm'
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
    ,'2020-05-13 13:28:25.0'
    ,NULL
    ,NULL
    ,NULL
    ,'HTTP'
    ,2176
    ,NULL
    ,'credit'
    ,'stockbond_recurring_yield'
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