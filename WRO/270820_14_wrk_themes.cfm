<!-- Description : WRK_THEME sisteme eklendi
Developer: Semih Akartuna
Company : Protein Team
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_THEME' )
    BEGIN
        CREATE TABLE [WRK_THEME](
            [THEME_ID] [int] IDENTITY(1,1) NOT NULL,
            [THEME_NAME] [nvarchar](250) NOT NULL,
            [THEME_DETAIL] [nvarchar](max) NULL,
            [THEME_AUTHOR] [nvarchar](150) NOT NULL,
            [THEME_AUTHORID] [int] NOT NULL,
            [THEME_STOCK_ID] [int] NULL,
            [THEME_PRODUCT_ID] [int] NULL,
            [THEME_PRODUCT_NAME] [nvarchar](250) NULL,
            [THEME_FILE_PATH] [nvarchar](250) NULL,
            [THEME_LICENSE] [int] NOT NULL,
            [THEME_IS_ACTIVE] [bit] NULL,
            [THEME_STAGE] [int] NULL,
            [THEME_SECTORS] [nvarchar](150) NULL,
            [THEME_PUBLISH_DATE] [datetime] NULL,
            [THEME_PRODUCT_CODE] [nvarchar](50) NOT NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](25) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](25) NULL,
        CONSTRAINT [PK_WRK_THEME] PRIMARY KEY CLUSTERED 
        (
            [THEME_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END

    IF NOT EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'dev.themes'
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
            ,42
            ,'Themes'
            ,35634
            ,'DevThemes'
            ,'dev.themes'
            ,'WDO/catalogs/designers/themes/list.cfm'
            ,'WBO/controller/DevThemesController.cfm'
            ,1
            ,'Development'
            ,0
            ,NULL
            ,'1.0'
            ,0
            ,0
            ,0
            ,'Protein Team'
            ,NULL
            ,'127.0.0.1'
            ,119
            ,'2019-09-17 10:40:06.0'
            ,'176.88.142.106'
            ,57
            ,'2020-02-10 18:50:26.433'
            ,'HTTP'
            ,2176
            ,NULL
            ,'dev'
            ,'themes'
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
            ,7 
            ,NULL 
            ,NULL 
            ,0
            ,NULL
            )
    END
        
</querytag>