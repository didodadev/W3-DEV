
<!-- Description : Ölçü Tabloları Açıldı
Developer: Cemil Durgan
Company : Durgan Bilisim
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='MEASUREMENT_PARAMETERS_ROWS')
	BEGIN
        CREATE TABLE [MEASUREMENT_PARAMETERS_ROWS](
                [ROW_ID] [int] IDENTITY(1,1) NOT NULL,
                [UNIT_NAME] [nvarchar](150) NULL,
                [SHORT_UNIT_NAME] [nvarchar](50) NULL,
                [MEASUREMENT_ID] [int] NULL,
            CONSTRAINT [PK_MEASUREMENT_PARAMETERS_ROWS] PRIMARY KEY CLUSTERED 
            (
                [ROW_ID] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY]
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='MEASUREMENT_PARAMETERS')
	BEGIN
        CREATE TABLE [MEASUREMENT_PARAMETERS](
            [MEASUREMENT_ID] [int] IDENTITY(1,1) NOT NULL,
            [MEASUREMENT_NAME] [nvarchar](150) NULL,
        CONSTRAINT [PK_MEASUREMENT_PARAMETERS] PRIMARY KEY CLUSTERED 
        (
            [MEASUREMENT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='STOCK_LOCATION_MEASUREMENT')
	BEGIN
        CREATE TABLE [STOCK_LOCATION_MEASUREMENT](
            [STOCK_LOCATION_ID] [int] IDENTITY(1,1) NOT NULL,
            [DEPARTMENT_ID] [int] NULL,
            [LOCATION_ID] [int] NULL,
            [MEASUREMENT_ID] [int] NULL,
            [MEASUREMENT_ROW_ID] [int] NULL,
            [MEASUREMENT_VALUE] [float] NULL,
            [MIN_VALUE] [float] NULL,
            [MAX_VALUE] [float] NULL,
            [IT_ASSET_ID] [int] NULL,
        CONSTRAINT [PK_STOCK_LOCATION_MEASUREMENT] PRIMARY KEY CLUSTERED 
        (
            [STOCK_LOCATION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
    IF NOT EXISTS (SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'stock.measurement_parameters' )
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
            ,[DATA_PATH]
            ,[MAIN_VERSION]
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
            ,57
            ,'Ölçüm Parametreleri'
            ,62181
            ,NULL
            ,'stock.measurement_parameters'
            ,'stock/display/measurement_parameters.cfm'
            ,'WBO/controller/MeasurementParametersController.cfm'
            ,NULL
            ,'19.12.5'
            ,1
            ,'Analys'
            ,0
            ,NULL
            ,'1'
            ,0
            ,0
            ,0
            ,NULL
            ,NULL
            ,'127.0.0.1'
            ,140
            ,'2021-04-24 01:50:52.0'
            ,'127.0.0.1'
            ,140
            ,'2021-04-24 05:12:02.687'
            ,'Standart'
            ,70
            ,NULL
            ,'stock'
            ,'measurement_parameters'
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
            ,0
            ,1
            ,1 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
</querytag>                   
