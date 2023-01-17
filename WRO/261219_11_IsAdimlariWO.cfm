
 <!-- Description : İş sayfası WO'lar ve yeni diller hazırlandı 
Developer: Melek Kocabey
Company : Workcube
Destination: Main-->
<querytag>
 IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'project.emptypopup_work_steps')
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
            ,1
            ,'İş Adımları(Ekle)'
            ,50968
            ,'project.emptypopup_work_steps'
            ,'project.emptypopup_work_steps'
            ,'project/query/WorkSteps.cfm'
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
            ,'192.168.69.14'
            ,87
            ,'2019-09-12 07:42:34.0'
            ,'192.168.69.14'
            ,87
            ,'2019-09-12 09:22:02.527'
            ,'HTTP'
            ,2176
            ,NULL
            ,'project'
            ,'emptypopup_work_steps'
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
            ,1
            ,NULL
            )
    END;
</querytag>