<!--Description : W3 Çıktı Merkezi WO EKLENDI
Developer: Semih AKARTUNA
Company : Yazılımsa
Destination: Main-->
<querytag>
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.popup_output_center')
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
	)
VALUES (
	1
	,47
	,N'Çıktılar'
	,36476
	,N'OutputCenter'
	,N'objects.popup_output_center'
	,NULL
	,N'objects/display/output_center.cfm'
	,NULL
	,NULL
	,1
	,NULL
	,N'Deployment'
	,NULL
	,1
	,NULL
	,N'1.0'
	,NULL
	,NULL
	,0
	,1
	,1
	,N'<p>TR:W3 Çıktı Merkezi &nbsp;toplu çıktı faliyetlerini tanzim etmek amacıyla kullanılır.</p> '
	,N'YazılımSA'
	,NULL
	,NULL
	,N'127.0.0.1'
	,90
	,'2019-12-25'
	,N'127.0.0.1'
	,90
	,'2019-12-25'
	,N'HTTP'
	,2176
	,NULL
	,NULL
	,N'objects'
	,N'popup_output_center'
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
	,1
	,0
	,NULL
	,0
	,1
	,1
	,0
	,NULL
	,NULL
	,NULL
	,0
	,NULL
	)
 END
</querytag>