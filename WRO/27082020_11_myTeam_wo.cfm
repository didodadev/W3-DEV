<!-- Description : Ekibim Ve Ben Sayfası Oluşturuldu
Developer: Pınar Yıldız
Company : Workcube
Destination: Main-->
<querytag>
               IF NOT EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'myhome.myTeam'
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
            ,82
            ,'Ekibim ve Ben'
            ,61183
            ,'myhome.myTeam'
            ,'myhome.myTeam'
            ,'myhome/display/my_team.cfm'
            ,'WBO/controller/myTeamController.cfm'
            ,1
            ,'Development'
            ,1
            ,NULL
            ,'Holistic'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,'127.0.0.1'
            ,69
            ,'2020-08-27 21:08:00.0'
            ,'127.0.0.1'
            ,69
            ,'2020-08-27 22:35:52.793'
            ,'Dark'
            ,2176
            ,NULL
            ,'myhome'
            ,'myTeam'
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
            ,13 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
        
</querytag>