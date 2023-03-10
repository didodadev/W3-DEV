<!-- Description : Mail Sunucu Ayarları Tablosu,  ve WRO'su
Developer: Ahmet Yolcu
Company : Workcube
Destination: Main-->
<querytag>

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MAIL_SERVER_SETTINGS' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        CREATE TABLE [MAIL_SERVER_SETTINGS](
            [SERVER_NAME_ID] [int] IDENTITY(1,1) NOT NULL,
            [SERVER_NAME] [nvarchar](50) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
        CONSTRAINT [PK_NAMES_OF_MAIL_SERVERS] PRIMARY KEY CLUSTERED 
        (
            [SERVER_NAME_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END

    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.list_mail_server_settings' )
    BEGIN
    INSERT [WRK_OBJECTS] 
    (
        [IS_ACTIVE], 
        [MODULE_NO], 
        [HEAD], 
        [DICTIONARY_ID], 
        [FRIENDLY_URL], 
        [FULL_FUSEACTION], 
        [FULL_FUSEACTION_VARIABLES], 
        [FILE_PATH], 
        [CONTROLLER_FILE_PATH], 
        [STANDART_ADDON], 
        [LICENCE], 
        [EVENT_TYPE], 
        [STATUS], 
        [IS_DEFAULT], 
        [IS_MENU], 
        [WINDOW], 
        [VERSION], 
        [IS_CATALYST_MOD], 
        [MENU_SORT_NO], 
        [USE_PROCESS_CAT], 
        [USE_SYSTEM_NO], 
        [USE_WORKFLOW], 
        [DETAIL], 
        [AUTHOR], 
        [OBJECTS_COUNT], 
        [DESTINATION_MODUL], 
        [SECURITY], 
        [STAGE], 
        [MODUL], 
        [BASE], 
        [MODUL_SHORT_NAME], 
        [FUSEACTION], 
        [FUSEACTION2], 
        [FOLDER], 
        [FILE_NAME], 
        [IS_ADD], 
        [IS_UPDATE], 
        [IS_DELETE], 
        [LEFT_MENU_NAME], 
        [IS_WBO_DENIED], 
        [IS_WBO_FORM_LOCK], 
        [IS_WBO_LOCK], 
        [IS_WBO_LOG], 
        [IS_SPECIAL], 
        [IS_TEMP], 
        [EVENT_ADD], 
        [EVENT_DASHBOARD], 
        [EVENT_DEFAULT], 
        [EVENT_DETAIL], 
        [EVENT_LIST], 
        [EVENT_UPD], 
        [TYPE], 
        [POPUP_TYPE], 
        [RANK_NUMBER], 
        [EXTERNAL_FUSEACTION], 
        [IS_LEGACY], 
        [ADDOPTIONS_CONTROLLER_FILE_PATH], 
        [THEME_PATH]
    )
    VALUES 
    (
        1, 
        7, 
        N'Mail Sunucu Ayarları', 
        44098, 
        N'settings.list_mail_server_settings', 
        N'settings.list_mail_server_settings', 
        NULL, 
        N'settings/display/mail_server_settings.cfm', 
        N'WBO/controller/addMailServerController.cfm', 
        NULL, 
        1, 
        NULL, 
        N'Analys', 
        NULL, 
        0, 
        NULL, 
        N'V16', 
        NULL, 
        NULL, 
        0, 
        0, 
        0, 
        NULL, 
        N'Workcube Team', 
        NULL, 
        NULL, 
        N'HTTP', 
        2176, 
        NULL, 
        NULL, 
        N'W3WorkDev', 
        N'list_mail_server_settings', 
        NULL, 
        N'W3WorkDev', 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        1, 
        0, 
        NULL, 
        0, 
        1, 
        1, 
        2, 
        NULL, 
        NULL, 
        NULL, 
        0, 
        NULL,
        NULL
    )
    END
</querytag>