
<!-- Description : CallCenter Dashboard için yeni WO oluşturuldu.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
 	IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION ='call.dashboard')
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
		)
	VALUES (
		1
		,27
		,N'Çağrı Merkezi Dashboard'
		,49028
		,N'call.dashboard'
		,N'call.dashboard'
		,NULL
		,N'callcenter/display/callcenter_dashboard.cfm'
		,NULL
		,NULL
		,1
		,NULL
		,N'Development'
		,NULL
		,1
		,NULL
		,N'V16'
		,NULL
		,NULL
		,0
		,0
		,0
		,N'<p>Canan Ebret&nbsp; &nbsp; &nbsp; &nbsp; 27/05/2019</p>

		<p>Çağrı merkezi Dashboard ekranı olarak oluşturuldu;</p>

		<ul>
		<li>Sayfada başvuru tarih aralığına göre arama yapılacak,&nbsp; &nbsp;&nbsp;</li>
		<li>Aşamalara ve kategorilere göre en çok başvuru yapan kurumsal üyelerden&nbsp;en aza doğru listelenecek,</li>
		<li>Projeleri sayısıyla birlikte "En çok başvuru gelen Projeler" olarak&nbsp;sıralayabileceğiz,</li>
		<li>Haftalık gelen başvuruların detayına göre kaç tane iş kaydı açılmış, kaçtanesi kimin üzerinde listeleyebileceğiz.</li>
		<li>Bu listelemeye ek olarak grafiklerle de desteklenecek.</li>
		</ul>
		'
		,N'Workcube Team'
		,NULL
		,NULL
		,N'127.0.0.1'
		,113
		,CAST(N'2019-05-22 13:27:59.000' AS DATETIME)
		,N'127.0.0.1'
		,113
		,CAST(N'2019-05-27 09:25:53.293' AS DATETIME)
		,N'HTTP'
		,2176
		,NULL
		,NULL
		,N'callcenter'
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
		);
    END;
</querytag>