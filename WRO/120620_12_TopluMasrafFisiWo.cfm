<!-- Description : Toplu masraf fişine dönüştürülme için wo eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS (
		SELECT WRK_OBJECTS_ID
		FROM WRK_OBJECTS
		WHERE FULL_FUSEACTION = 'cost.emptypopup_add_request_from_expense'
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
		,49
		,'Masraf Fişine Dönüştür(QUERY)'
		,33492
		,NULL
		,'cost.emptypopup_add_request_from_expense'
		,'cost/query/add_expense_requests.cfm'
		,NULL
		,1
		,'Development'
		,0
		,NULL
		,'v12'
		,0
		,0
		,0
		,'Workcube Core'
		,NULL
		,'127.0.0.1'
		,15
		,'2020-06-10 19:37:01.0'
		,'127.0.0.1'
		,15
		,'2020-06-11 11:32:19.653'
		,'Dark'
		,70
		,NULL
		,'cost'
		,'emptypopup_add_request_from_expense'
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
		,0
		,NULL
		)
END
</querytag>
