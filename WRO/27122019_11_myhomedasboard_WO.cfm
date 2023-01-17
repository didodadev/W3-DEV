<!-- Description : Hesabım,İzinler,Sağlık Harcamaları ve Çalışma Programına Dashboard üzerinden erişim sağlandı.
Developer: Berkay Erken
Company : Workcube
Destination: Main-->
<querytag>

IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'myhome.dashboard')
BEGIN
    INSERT [WRK_OBJECTS] (
        [IS_ACTIVE]
        ,[MODULE_NO]
        ,[HEAD]
        ,[DICTIONARY_ID]
        ,[FRIENDLY_URL]
        ,[FULL_FUSEACTION]
        ,[FULL_FUSEACTION_VARIABLES]
        ,[FILE_PATH]
        ,[CONTROLLER_FILE_PATH]
        ,[STANDART_ADDON]
        ,[LICENCE]
        ,[EVENT_TYPE]
        ,[STATUS]
        ,[IS_DEFAULT]
        ,[IS_MENU]
        ,[WINDOW]
        ,[VERSION]
        ,[IS_CATALYST_MOD]
        ,[MENU_SORT_NO]
        ,[USE_PROCESS_CAT]
        ,[USE_SYSTEM_NO]
        ,[USE_WORKFLOW]
        ,[DETAIL]
        ,[AUTHOR]
        ,[OBJECTS_COUNT]
        ,[DESTINATION_MODUL]
        ,[RECORD_IP]
        ,[RECORD_EMP]
        ,[RECORD_DATE]
        ,[UPDATE_IP]
        ,[UPDATE_EMP]
        ,[UPDATE_DATE]
        ,[SECURITY]
        ,[STAGE]
        ,[MODUL]
        ,[BASE]
        ,[MODUL_SHORT_NAME]
        ,[FUSEACTION]
        ,[FUSEACTION2]
        ,[FOLDER]
        ,[FILE_NAME]
        ,[IS_ADD]
        ,[IS_UPDATE]
        ,[IS_DELETE]
        ,[LEFT_MENU_NAME]
        ,[IS_WBO_DENIED]
        ,[IS_WBO_FORM_LOCK]
        ,[IS_WBO_LOCK]
        ,[IS_WBO_LOG]
        ,[IS_SPECIAL]
        ,[IS_TEMP]
        ,[EVENT_ADD]
        ,[EVENT_DASHBOARD]
        ,[EVENT_DEFAULT]
        ,[EVENT_DETAIL]
        ,[EVENT_LIST]
        ,[EVENT_UPD]
        ,[TYPE]
        ,[POPUP_TYPE]
        ,[RANK_NUMBER]
        ,[EXTERNAL_FUSEACTION]
        ,[IS_LEGACY]
        ,[ADDOPTIONS_CONTROLLER_FILE_PATH]
        ,[THEME_PATH]
        )
    VALUES (
	1
	,80
	,N'Dashboard Welcome'
	,51637
	,N'myhome.dashboard'
	,N'myhome.dashboard'
	,NULL
	,N'myhome/display/myhome_dashboard.cfm'
	,NULL
	,NULL
	,1
	,NULL
	,N'Analys'
	,NULL
	,0
	,NULL
	,N'v16'
	,NULL
	,NULL
	,0
	,0
	,0
	,NULL
	,NULL
	,NULL
	,NULL
	,N'127.0.0.1'
	,7
	,CAST(N'2019-12-26T16:34:09.000' AS DATETIME)
	,N'127.0.0.1'
	,7
	,CAST(N'2019-12-26T16:35:39.853' AS DATETIME)
	,N'HTTP'
	,2176
	,NULL
	,NULL
	,N'myhome'
	,N'dashboard'
	,NULL
	,N'W3WorkDev'
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,0
	,1
	,NULL
	,0
	,0
	,0
	,0
	,NULL
	,NULL
	,NULL
	,0
	,NULL
	,NULL
    )
    END
    
</querytag>