<!-- Description : WRK_OBJECTS Tablosuna Yeni Satır Eklendi.
Developer: Emin Yaşartürk
Company : Startech BT
Destination: Main -->
<querytag>
	IF NOT EXISTS (
		SELECT WRK_OBJECTS_ID
		FROM WRK_OBJECTS
		WHERE FULL_FUSEACTION = 'correspondence.message_permission'
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
				,29
				,'Mesaj İzinleri'
				,62837
				,NULL
				,'correspondence.message_permission'
				,'correspondence/display/message_permission.cfm'
				,NULL
				,NULL
				,1
				,'Development'
				,1
				,'popup'
				,'v 16'
				,0
				,0
				,0
				,'Startech BT'
				,2172
				,'192.168.18.34'
				,1898
				,'2021-05-11 15:53:42.823'
				,'176.234.128.104'
				,3
				,'2021-05-11 23:45:36.18'
				,'Dark'
				,832
				,'Correspondence'
				,'Communication'
				,'message_permission'
				,'message_permission.cfm'
				,0
				,0
				,0
				,0
				,0
				,NULL
				,0
				,1
				,0
				,0
				,1
				,0
				,0 
				,NULL 
				,NULL 
				,0
				,NULL
				)
		END;
</querytag>