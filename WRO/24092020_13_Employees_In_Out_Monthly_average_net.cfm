<!-- Description : EMPLOYEES_IN_OUT tablosuna aylık ortalama net maaş alanı eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Main -->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_IN_OUT' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'MONTHLY_AVERAGE_NET')
    BEGIN               
        ALTER TABLE EMPLOYEES_IN_OUT ADD MONTHLY_AVERAGE_NET float NULL;
    END

    IF NOT EXISTS (
        SELECT WRK_OBJECTS_ID
        FROM WRK_OBJECTS
        WHERE FULL_FUSEACTION = 'ehesap.import_monthly_average_net'
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
                ,48
                ,'Aylık Ortalama Net Aktarım'
                ,61253
                ,NULL
                ,'ehesap.import_monthly_average_net'
                ,'hr/ehesap/form/import_monthly_average_net.cfm'
                ,NULL
                ,1
                ,'Analys'
                ,0
                ,NULL
                ,'V19'
                ,0
                ,0
                ,0
                ,'Workcube Team'
                ,NULL
                ,'127.0.0.1'
                ,124
                ,'2020-09-25 14:34:33.0'
                ,'127.0.0.1'
                ,124
                ,'2020-09-25 15:58:41.543'
                ,'Dark'
                ,NULL
                ,NULL
                ,'ehesap'
                ,'import_monthly_average_net'
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
                ,3 
                ,NULL 
                ,NULL 
                ,0
                ,NULL
                )
        END
    
</querytag>