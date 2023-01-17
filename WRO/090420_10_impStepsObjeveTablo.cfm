<!-- Description : İmplementasyon Adımları WO ve Tablo
Developer: İlker Altındal
Company : Workcube
Destination: Main -->

<querytag>
    IF NOT EXISTS ( SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.stepbystep_imp' )
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
            ,30
            ,'Adım Adım İmplementasyon'
            ,44149
            ,'StepByStep_Imp'
            ,'settings.stepbystep_imp'
            ,'settings/display/stepbystep_imp.cfm'
            ,NULL
            ,1
            ,'Deployment'
            ,0
            ,NULL
            ,'V19'
            ,0
            ,0
            ,0
            ,'Workcube Core'
            ,NULL
            ,'127.0.0.1'
            ,67
            ,'2019-05-29 12:08:59.0'
            ,'127.0.0.1'
            ,222
            ,'2020-02-18 14:21:09.78'
            ,'HTTP'
            ,2176
            ,NULL
            ,'Business Process'
            ,'stepbystep_imp'
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
    END;


     IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_IMPLEMENTATION_STEP')
     BEGIN

        CREATE TABLE [WRK_IMPLEMENTATION_STEP](
            [WRK_IMPLEMENTATION_STEP_ID] [int] IDENTITY(1,1) NOT NULL,
            [WRK_MODUL_ID] [int] NULL,
            [WRK_IMPLEMENTATION_TASK] [nvarchar](500) NULL,
            [WRK_IMPLEMENTATION_TYPE] [int] NULL,
            [WRK_OBJECTS] [nvarchar](250) NULL,
            [WRK_RELATED_OBJECTS] [nvarchar](500) NULL,
            [WRK_RELATED_TABLE_NAME] [nvarchar](250) NULL,
            [WRK_RELATED_SCHEMA_NAME] [nvarchar](250) NULL,
            [WRK_IMPLEMENTATION_TASK_COMPLETE] [int] NULL,
            [RANK_NUMBER] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_WRK_IMPLEMENTATION_STEP] PRIMARY KEY CLUSTERED 
        (
            [WRK_IMPLEMENTATION_STEP_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]


     END;

        

</querytag>