<!-- Description : Üye Muhasebe Kodları Rapor
Developer: Pınar Yıldız
Company : Workcube
Destination: Main -->
<querytag>
        IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.member_account_code' )
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
            ,'Üye Muhasebe Kodu'
            ,61002
            ,NULL
            ,'report.member_account_code'
            ,'report/standart/member_account_code.cfm'
            ,NULL
            ,1
            ,'Analys'
            ,0
            ,NULL
            ,'holistic'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,'127.0.0.1'
            ,69
            ,'2020-06-16 22:18:21.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,2176
            ,NULL
            ,'report'
            ,'member_account_code'
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
            ,8 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
   
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.emptypopup_member_account_code')
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
            ,'Üye Muhasebe Kodu Excel'
            ,61002
            ,NULL
            ,'report.emptypopup_member_account_code'
            ,'report/standart/member_account_code.cfm'
            ,NULL
            ,1
            ,'Analys'
            ,0
            ,NULL
            ,'Holistic'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,'127.0.0.1'
            ,69
            ,'2020-06-16 23:48:45.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Standart'
            ,2176
            ,NULL
            ,'report'
            ,'emptypopup_member_account_code'
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