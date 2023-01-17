<!-- Description : Olay Tutanağında tanıkların ifadesi için objeler.
Developer: Gülbahar İnan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'ehesap.popup_add_witness_statement'
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
        ,72
        ,'Tanık İfadesi Ekle'
        ,61152
        ,NULL
        ,'ehesap.popup_add_witness_statement'
        ,'hr/ehesap/form/add_witness_statement.cfm'
        ,NULL
        ,1
        ,'Analys'
        ,0
        ,NULL
        ,'v19'
        ,0
        ,0
        ,0
        ,'Workcube Core'
        ,NULL
        ,'127.0.0.1'
        ,124
        ,'2020-08-14 17:11:18.0'
        ,'127.0.0.1'
        ,124
        ,'2020-08-14 23:44:41.797'
        ,'Dark'
        ,NULL
        ,NULL
        ,'ehesap'
        ,'popup_add_witness_statement'
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
    WHERE FULL_FUSEACTION = 'ehesap.popup_upd_witness_statement'
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
    ,72
    ,'Tanık İfadesi Güncelle'
    ,61153
    ,NULL
    ,'ehesap.popup_upd_witness_statement'
    ,'hr/ehesap/form/upd_witness_statement.cfm'
    ,NULL
    ,1
    ,'Deployment'
    ,0
    ,NULL
    ,'v19'
    ,0
    ,0
    ,0
    ,'Workcube Core'
    ,NULL
    ,'127.0.0.1'
    ,124
    ,'2020-08-16 19:20:56.0'
    ,NULL
    ,NULL
    ,NULL
    ,'Standart'
    ,NULL
    ,NULL
    ,'ehesap'
    ,'popup_upd_witness_statement'
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
