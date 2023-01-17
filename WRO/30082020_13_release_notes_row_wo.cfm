<!-- Description : Release Notes Row new object
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>

    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.release_notes_row')
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
            ,47
            ,'Release Notu'
            ,61189
            ,'release_notes_row'
            ,'objects.release_notes_row'
            ,'objects/form/release_note_row.cfm'
            ,'WBO/controller/ReleaseNotesRow.cfm'
            ,1
            ,'Deployment'
            ,0
            ,NULL
            ,'V 1.0'
            ,0
            ,0
            ,0
            ,'Workcube Team'
            ,NULL
            ,'127.0.0.1'
            ,82
            ,'2020-08-31 13:26:32.0'
            ,NULL
            ,NULL
            ,NULL
            ,'Light'
            ,2177
            ,NULL
            ,'objects'
            ,'release_notes_row'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,1
            ,0
            ,0
            ,1
            ,1
            ,9 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
        
</querytag>