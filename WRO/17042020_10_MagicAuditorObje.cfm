<!-- Description : Magic Auditor WO
Developer: İlker Altındal
Company : Workcube
Destination: main -->

<querytag>
    IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'account.magic_auditor')
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
                ,86
                ,'Magic Auditor'
                ,60305
                ,'AccountMagicAuditor'
                ,'account.magic_auditor'
                ,'account/display/magicAuditor.cfm'
                ,'WBO/controller/MagicAuditorController.cfm'
                ,1
                ,'Development'
                ,1
                ,NULL
                ,'v0.1'
                ,0
                ,0
                ,0
                ,NULL
                ,NULL
                ,'127.0.0.1'
                ,67
                ,'2020-02-21 10:50:34.0'
                ,'127.0.0.1'
                ,67
                ,'2020-04-15 12:44:41.777'
                ,'HTTP'
                ,2176
                ,NULL
                ,'account'
                ,'magic_auditor'
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