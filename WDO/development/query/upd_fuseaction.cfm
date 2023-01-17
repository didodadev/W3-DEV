<cfparam name="delete_unchecked_events" default="1">
<cfset error = 0>
<cfif attributes.old_fuseaction neq attributes.fuseaction_name>
	<cfset fuseaction_name_ = replacelist(lcase(attributes.fuseaction_name),"/,*, ,',ğ,ü,ş,ö,ç,ı,İ,:,;","-,x,-,_,g,u,s,o,c,i,I,,")>
	<!---<cfquery name="GET_FUSEACTION_NAME" datasource="#DSN#">
		SELECT 
			FUSEACTION 
		FROM 
			WRK_OBJECTS 
		WHERE 
			FUSEACTION = '#fuseaction_name_#' AND
			MODUL = '#listlast(attributes.module,';')#' AND
			WRK_OBJECTS_ID <> #attributes.woid#
	</cfquery>
	<cfif get_fuseaction_name.recordcount>
		<script type="text/javascript">
			alert('Sayfa İçin Tanımladığınız Fuseaction Kullanılmaktadır!\n Lütfen Düzenleyiniz !');
			history.back();
		</script>
		<cfabort>
	</cfif>--->
<cfelse>
	<cfset fuseaction_name_ = attributes.fuseaction_name>
</cfif>
<!---
<cfif isdefined("attributes.friendly_url") and len(attributes.friendly_url)>
	<cf_workcube_user_friendly user_friendly_url='#attributes.friendly_url#' action_type='woid' action_id='#attributes.woid#' action_page='#listlast(attributes.module,';')##attributes.fuseaction_name#'>
</cfif>--->

<cfquery name="INSERT_WRK_HISTORY" datasource="#DSN#">
	INSERT INTO
		WRK_OBJECTS_HISTORY
	(
		IS_ACTIVE,
		IS_WBO_LOG,
		WRK_OBJECTS_ID,
		BASE,
		MODUL,
		MODUL_SHORT_NAME,
		FUSEACTION,
		HEAD,
		FRIENDLY_URL,
		FOLDER,
		FILE_NAME,
		STAGE,
		TYPE,
		WINDOW,
		SECURITY,
		STATUS,
		VERSION,
		DETAIL,
		DESTINATION_MODUL,  
		USE_PROCESS_CAT,
		USE_WORKFLOW,
		USE_SYSTEM_NO,             
		RECORD_IP,
		RECORD_EMP,
		RECORD_DATE
	)
	SELECT
		IS_ACTIVE,
		IS_WBO_LOG,
		WRK_OBJECTS_ID,
		BASE,
		MODUL,
		MODUL_SHORT_NAME,
		FUSEACTION,
		HEAD,
		FRIENDLY_URL,
		FOLDER,
		FILE_NAME,
		STAGE,
		TYPE,
		WINDOW,
		SECURITY,
		STATUS,
		VERSION,
		DETAIL,
		DESTINATION_MODUL,
		USE_PROCESS_CAT,
		USE_WORKFLOW,
		USE_SYSTEM_NO, 
		'#cgi.remote_addr#',
		#session.ep.userid#,
		#now()#
	FROM
		WRK_OBJECTS
	WHERE
		WRK_OBJECTS_ID = #attributes.woid#
</cfquery>

<cfquery name="add_wrk_objects" datasource="#DSN#" result="xxx">
	UPDATE
		WRK_OBJECTS
	SET 
		FILE_PATH = <cfif IsDefined("attributes.file_path") and len(attributes.file_path)>'#attributes.file_path#'<cfelse>NULL</cfif>,
		XML_PATH = <cfif isdefined("attributes.xml_path") and len(attributes.xml_path)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.xml_path#"><cfelse>NULL</cfif>,
        DICTIONARY_ID = <cfif IsDefined("attributes.dictionary_id") and len(attributes.dictionary_id)>#attributes.dictionary_id#<cfelse>NULL</cfif>,
		MODULE_NO = <cfif IsDefined("attributes.module") and len(attributes.module)>#attributes.module#<cfelse>NULL</cfif>,
		FUSEACTION = <cfif attributes.old_fuseaction neq attributes.fuseaction_name><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(fuseaction_name_,'.')#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.fuseaction_name,'.')#"></cfif>,
        FULL_FUSEACTION = <cfif attributes.old_fuseaction neq attributes.fuseaction_name and len(fuseaction_name_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#fuseaction_name_#"><cfelseif len(attributes.fuseaction_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fuseaction_name#"><cfelse>NULL</cfif>,
		HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.head#">,
		<cfif isdefined("attributes.file_name") and len(attributes.file_name)>FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.file_name,"\")#">,</cfif>
		SECURITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.security#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		IS_MENU = <cfif isdefined("attributes.is_menu")>1<cfelse>0</cfif>,
		WINDOW = <cfif Isdefined("attributes.window_type")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.window_type#"><cfelse>NULL</cfif>,
		POPUP_TYPE = <cfif isdefined("attributes.popupInfoType") and len(attributes.popupInfoType)>'#attributes.popupInfoType#'<cfelse>NULL</cfif>,
		USE_PROCESS_CAT = <cfif isdefined("attributes.use_process_cat")>1<cfelse>0</cfif>,
		USE_WORKFLOW = <cfif isdefined("attributes.use_workflow")>1<cfelse>0</cfif>,
		USE_SYSTEM_NO = <cfif isdefined("attributes.use_system_no")>1<cfelse>0</cfif>,
		EVENT_ADD = <cfif isdefined("attributes.eventAdd")>1<cfelse>0</cfif>,
		EVENT_UPD = <cfif isdefined("attributes.eventUpd")>1<cfelse>0</cfif>,
		EVENT_LIST = <cfif isdefined("attributes.eventList")>1<cfelse>0</cfif>,
		EVENT_DETAIL = <cfif isdefined("attributes.eventDetail")>1<cfelse>0</cfif>,
		EVENT_DASHBOARD = <cfif isdefined("attributes.eventDashboard")>1<cfelse>0</cfif>,
		EVENT_OUTPUT =	<cfif isdefined("attributes.eventOutput")>1<cfelse>0</cfif>,
		LICENCE = <cfif isdefined("attributes.licence") and len(attributes.licence)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.licence#"><cfelse>NULL</cfif>,
        TYPE = <cfif isdefined("attributes.type") and len(attributes.type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type#"><cfelse>NULL</cfif>,
        AUTHOR = <cfif len(attributes.author_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.author_name#"><cfelse>NULL</cfif>,
        VERSION = <cfif len(attributes.version)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.version#"><cfelse>NULL</cfif>,
        DETAIL = <cfif len(attributes.wo_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.wo_detail#"><cfelse>NULL</cfif>,
        FRIENDLY_URL = <cfif len(attributes.friendly_url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.friendly_url#"><cfelse>NULL</cfif>,
        EXTERNAL_FUSEACTION = <cfif len(attributes.external_fuseaction)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.external_fuseaction#"><cfelse>NULL</cfif>,
        STATUS = <cfif len(attributes.STATUS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.STATUS#"><cfelse>NULL</cfif>,
        STAGE = <cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
		IS_LEGACY=<cfif isdefined("attributes.is_legacy")><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.is_legacy#'><cfelse>0</cfif>,
		ADDOPTIONS_CONTROLLER_FILE_PATH = <cfif isDefined("attributes.addOpitonsControllerFilePath") and len(attributes.addOpitonsControllerFilePath) and attributes.licence eq 3><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.addOpitonsControllerFilePath#"><cfelse>NULL</cfif>,
		CONTROLLER_FILE_PATH = <cfif len(attributes.controllerFilePath) and attributes.licence neq 3><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.controllerfilepath#"><cfelse>NULL</cfif>,
        MAIN_VERSION = <cfif isdefined("attributes.main_version") and len(attributes.main_version)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_version#"><cfelse>NULL</cfif>,
		IS_PUBLIC = <cfif isDefined("attributes.is_public") and Len(attributes.is_public)>1<cfelse>0</cfif>,
		IS_EMPLOYEE = <cfif isDefined("attributes.is_employee") and Len(attributes.is_employee)>1<cfelse>0</cfif>,
		IS_CONSUMER = <cfif isDefined("attributes.is_consumer") and Len(attributes.is_consumer)>1<cfelse>0</cfif>,
		IS_COMPANY = <cfif isDefined("attributes.is_company") and Len(attributes.is_company)>1<cfelse>0</cfif>,
		IS_LIVESTOCK = <cfif isDefined("attributes.is_livestock") and Len(attributes.is_livestock)>1<cfelse>0</cfif>,
		IS_MACHINES = <cfif isDefined("attributes.is_machines") and Len(attributes.is_machines)>1<cfelse>0</cfif>,
		IS_EMPLOYEE_APP = <cfif isDefined("attributes.is_employee_app") and Len(attributes.is_employee_app)>1<cfelse>0</cfif>,
		<cfif isDefined('attributes.display_before_path') and len(attributes.display_before_path)>
			DISPLAY_BEFORE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAr' value='#attributes.display_before_path#'>
		<cfelse>
			DISPLAY_BEFORE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAr' null='true'>
		</cfif>,
		<cfif isDefined('attributes.display_after_path') and len(attributes.display_after_path)>
			DISPLAY_AFTER_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.display_after_path#'>
		<cfelse>
			DISPLAY_AFTER_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null='true'>
		</cfif>,
		<cfif isDefined('attributes.action_before_path') and len(attributes.action_before_path)>
			ACTION_BEFORE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.action_before_path#'>
		<cfelse>
			ACTION_BEFORE_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null='true'>
		</cfif>,
		<cfif isDefined('attributes.action_after_path') and len(attributes.action_after_path)>
			ACTION_AFTER_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.action_after_path#'>
		<cfelse>
			ACTION_AFTER_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null='true'>
		</cfif>,
		<cfif isDefined('attributes.data_cfc') and len(attributes.data_cfc)>
			DATA_CFC = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.data_cfc#'>
		<cfelse>
			DATA_CFC = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null='true'>
		</cfif>,
		<cfif isDefined('attributes.wat_solution') and len(attributes.wat_solution)>
			WATOMIC_SOLUTION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.wat_solution#'>
		<cfelse>
			WATOMIC_SOLUTION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
		</cfif>,
		<cfif isDefined('attributes.wat_family') and len(attributes.wat_family)>
			WATOMIC_FAMILY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.wat_family#'>
		<cfelse>
			WATOMIC_FAMILY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
		</cfif>,
		<cfif isDefined('attributes.icon') and len(attributes.icon)>
			ICON = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.icon#'>
		<cfelse>
			ICON = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null='true'>
		</cfif>
	WHERE
		WRK_OBJECTS_ID = #attributes.woid#			
</cfquery>

<!--- HOLISTIC CODES --->

<cfquery name="query_family" datasource="#dsn#">
    SELECT WRK_FAMILY_ID , FAMILY 
    FROM WRK_FAMILY where WRK_FAMILY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.family#'>
</cfquery>

<cfquery name="query_module" datasource="#dsn#">
    SELECT MODULE , MODULE_ID FROM WRK_MODULE WHERE MODULE_ID = #module#
</cfquery>

<cfquery name="query_solution" datasource="#dsn#">
	SELECT WRK_SOLUTION_ID , SOLUTION FROM WRK_SOLUTION WHERE WRK_SOLUTION_ID = #solution#
</cfquery>

<cfquery name="query_current_widgets" datasource="#dsn#">
	SELECT WIDGET_EVENT_TYPE FROM WRK_WIDGET WHERE WIDGET_FUSEACTION = '#attributes.old_fuseaction#'
</cfquery>

<cfquery name="query_current_eventsList" datasource="#dsn#">
	SELECT EVENT_TYPE FROM WRK_EVENTS WHERE EVENT_FUSEACTION='#attributes.old_fuseaction#'
</cfquery>


<cfset insertEvents = arrayNew(1)>
<cfset updateEvents = arrayNew(1)>
<cfset deleteEvents = arrayNew(1)>

<cfset insertWidgets = arrayNew(1)>
<cfset updateWidgets = arrayNew(1)>
<cfset deleteWidgets = arrayNew(1)>

<cfscript>
	currentEvents = [ { name: "eventAdd", event: "add" }, { name: "eventUpd", event: "upd" }, { name: "eventList", event: "list" }, { name: "eventDetail", event: "info" }, { name: "eventDashboard", event: "dashboard" } ];
</cfscript>


<cfloop array="#currentEvents#" index="ievent">
	
	<cfquery name="query_current_eventType" dbtype="query">
		SELECT COUNT(*) AS CNT FROM query_current_eventsList WHERE EVENT_TYPE = '#ievent.event#'
	</cfquery>
	<cfif isDefined( "attributes." & ievent.name )>
		<cfif query_current_eventType.CNT gt 0>
			<cfset arrayAppend( updateEvents, ievent.event )>
		<cfelse>
			<cfset arrayAppend( insertEvents, ievent.event )>
		</cfif>
	<cfelseif query_current_eventType.CNT gt 0>
		<cfset arrayAppend( deleteEvents, ievent.event )>
	</cfif>

</cfloop>


<cfloop array="#currentEvents#" index="ievent">
	
	<cfquery name="query_current_event" dbtype="query">
		SELECT COUNT(*) AS CNT FROM query_current_widgets WHERE WIDGET_EVENT_TYPE = '#ievent.event#'
	</cfquery>
	<cfif isDefined( "attributes." & ievent.name )>
		<cfif query_current_event.CNT gt 0>
			<cfset arrayAppend( updateWidgets, ievent.event )>
		<cfelse>
			<cfset arrayAppend( insertWidgets, ievent.event )>
		</cfif>
	<cfelseif query_current_event.CNT gt 0>
		<cfset arrayAppend( deleteWidgets, ievent.event )>
	</cfif>

</cfloop>


<cfset event_manager = createObject("component", "WDO.development.cfc.eventQuery")>
<cfset widget_manager = createObject("component", "WDO.development.cfc.widgetQuery")>

	<cfif arrayLen( insertEvents )>
		<cfset savetoevent=event_manager.savetoevent(
			fuseaction  : fuseaction_name_,
			title       : attributes.head,
			version     : attributes.version,
			status      : attributes.status,
			stage       : attributes.process_stage,
			tool        : "nocode",
			file_path   : attributes.file_path,
			solutionid  : attributes.solution,
			solution    : query_solution.solution,
			familyid    : attributes.family,
			family      : query_family.family,
			moduleid    : attributes.module,
			module      : query_module.module,
			license     : attributes.licence,
			author      : attributes.author_name,
			description : attributes.wo_detail,
			events      : arrayToList( insertEvents ) )>
	</cfif>

	<cfif arrayLen( updateEvents )>
		<cfset upttoevent = event_manager.upttoevent(
		fuseaction  : fuseaction_name_,
		title       : attributes.head,
		version     : attributes.version,
		status      : attributes.status,
		stage       : attributes.process_stage,
		tool        : "nocode",
		file_path   : attributes.file_path,
		solutionid  : attributes.solution,
		solution    : query_solution.solution,
		familyid    : attributes.family,
		family      : query_family.family,
		moduleid    : attributes.module,
		module      : query_module.module,
		license     : attributes.licence,
		author      : attributes.author_name,
		description : attributes.wo_detail,
		events      : arrayToList( updateEvents ),
		original_fuseaction : attributes.old_fuseaction
		)>
	</cfif>

	<cfif arrayLen( deleteEvents ) and delete_unchecked_events eq 1>
		<cfset deleteEvents = event_manager.deletetoevent(
	
		events      : arrayToList( deleteEvents ),
		original_fuseaction : attributes.old_fuseaction
		)>
	</cfif>
	<cfif arrayLen( insertWidgets )>
		<cfset savetowidget = widget_manager.savetowidget(
			fuseaction  : fuseaction_name_,
			title       : attributes.head,
			version     : attributes.version,
			status      : attributes.status,
			stage       : attributes.process_stage,
			tool        : "nocode",
			file_path   : attributes.file_path,
			solutionid  : attributes.solution,
			solution    : query_solution.solution,
			familyid    : attributes.family,
			family      : query_family.family,
			moduleid    : attributes.module,
			module      : query_module.module,
			license     : attributes.licence,
			author      : attributes.author_name,
			description : attributes.wo_detail,
			events      : arrayToList( insertWidgets )
				)>
	</cfif>

	<cfif arrayLen( updateWidgets )>
		<cfset upttowidget = widget_manager.upttowidget(
		fuseaction  : fuseaction_name_,
		title       : attributes.head,
		version     : attributes.version,
		status      : attributes.status,
		stage       : attributes.process_stage,
		tool        : "nocode",
		file_path   : attributes.file_path,
		solutionid  : attributes.solution,
		solution    : query_solution.solution,
		familyid    : attributes.family,
		family      : query_family.family,
		moduleid    : attributes.module,
		module      : query_module.module,
		license     : attributes.licence,
		author      : attributes.author_name,
		description : attributes.wo_detail,
		events      : arrayToList( updateWidgets ),
		original_fuseaction : attributes.old_fuseaction
		)>
	</cfif>
	<cfif arrayLen( deleteWidgets ) and delete_unchecked_events eq 1>
		<cfset deleteWidgets = widget_manager.deletetowidget(
	
		events      : arrayToList( deleteWidgets ),
		original_fuseaction : attributes.old_fuseaction
		)>
	</cfif>
<!--- END OF HOLISTIC CODES --->

<cfif isDefined("attributes.bestpractice") and len(attributes.bestpractice)>
	<cfquery name="query_obj_bp" datasource="#dsn#">
		DELETE FROM WRK_OBJECTS_BESTPRACTICE WHERE OBJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.woid#'>
	</cfquery>
	<cfquery name="query_obj_bp" datasource="#dsn#">
        INSERT INTO WRK_OBJECTS_BESTPRACTICE ( OBJECT_ID, BESTPRACTICE_ID ) VALUES( <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.woid#'>, <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.bestpractice#'> )
    </cfquery>
</cfif>
<!---iliskili islem tipi --->
<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
	<cfquery name="del_related_process_cat" datasource="#dsn#">
		DELETE FROM WRK_OBJ_PROCESS_CAT WHERE WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.woid#">
	</cfquery>
	<cfif isdefined("attributes.use_process_cat") and len(attributes.use_process_cat)>
		<cfloop list="#attributes.process_cat#" index="i">
			<cfquery name="add_related_process_cat" datasource="#dsn#">
				INSERT INTO
					WRK_OBJ_PROCESS_CAT
				(
					WRK_OBJECTS_ID,
					PROCESS_CAT
				) 
				VALUES 
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.woid#">,
					'#i#'
				)
			</cfquery>
		</cfloop>
	</cfif>
 </cfif>
<!---iliskili islem tipi --->
<cfif isdefined("attributes.user_url_id")>
	<cfif attributes.new_file_type neq 2>
		<cfquery name="UPD_USER_FRIENDLY_URL" datasource="#DSN#">
			UPDATE 
				USER_FRIENDLY_URLS
			SET
				USER_FRIENDLY_URL=<cfif isdefined("attributes.friendly_url") and len(attributes.friendly_url)>'#user_friendly_#'<cfelse>NULL</cfif>,
				FUSEACTION = '#listlast(attributes.module,';')##attributes.fuseaction_name#'
			WHERE
				USER_URL_ID = '#attributes.user_url_id#'
		</cfquery>
	</cfif>
</cfif>

<cfif isdefined("attributes.old_is_active") AND attributes.old_is_active eq 0 and isdefined("attributes.is_active")>
	<cfquery name="GET_FILE" datasource="#DSN#">
		SELECT MODUL_SHORT_NAME,FOLDER,FILE_NAME FROM WRK_OBJECTS WHERE WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.woid#">
	</cfquery>
	<cfoutput query="GET_FILE">
		<cfif modul_short_name eq 'call'>
			<cfset get_file.modul_short_name = 'callcenter'>
		<cfelseif modul_short_name eq 'dev'>
			<cfset get_file.modul_short_name = 'development'>
		<cfelseif modul_short_name eq 'prod'>
			<cfset get_file.modul_short_name = 'production_plan'>
		<cfelseif modul_short_name eq 'ehesap'>
			<cfset get_file.modul_short_name = 'hr/ehesap'>
		<cfelseif modul_short_name eq 'rule'>
			<cfset get_file.modul_short_name = 'rules'>
		<cfelseif modul_short_name eq 'pda'>
			<cfset get_file.modul_short_name = 'workcube_pda'>
		</cfif>
	</cfoutput>
	<cfif left(get_file.file_name,1) eq "_">
		<cfquery name="UPD_FILE_NAME" datasource="#DSN#">
			UPDATE WRK_OBJECTS SET FILE_NAME = '#replace(get_file.file_name,"_","")#' WHERE WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.woid#">
		</cfquery>
		<cftry>
			<cffile action="rename" source="#index_folder##get_file.modul_short_name#\#get_file.folder#\#get_file.file_name#" destination="#index_folder##get_file.modul_short_name#\#get_file.folder#\#replace(get_file.file_name,"_","")#"> 
		<cfcatch>
			<cfset error =1>
	</cfcatch>
	</cftry>
	</cfif>
<cfelseif isdefined("attributes.old_is_active") and attributes.old_is_active eq 1 and not isdefined("attributes.is_active")>
	<cfquery name="GET_FILE" datasource="#DSN#">
		SELECT MODUL_SHORT_NAME,FOLDER,FILE_NAME FROM WRK_OBJECTS WHERE WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.woid#">
	</cfquery>
	<cfquery name="GET_FILE_COUNT" datasource="#DSN#">
		SELECT 
			MODUL_SHORT_NAME,
			FOLDER,
			FILE_NAME,
			WRK_OBJECTS_ID,
			FRIENDLY_URL 
		FROM 
			WRK_OBJECTS 
		WHERE 
			FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_file.file_name#"> AND
			MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.module,';')#"> AND
			FOLDER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FOLDER#"> AND
			IS_ACTIVE = 1
	</cfquery>
	<cfoutput query="GET_FILE">
		<cfif modul_short_name eq 'call'>
			<cfset get_file.modul_short_name = 'callcenter'>
		<cfelseif modul_short_name eq 'dev'>
			<cfset get_file.modul_short_name = 'development'>
		<cfelseif modul_short_name eq 'prod'>
			<cfset get_file.modul_short_name = 'production_plan'>
		<cfelseif modul_short_name eq 'ehesap'>
			<cfset get_file.modul_short_name = 'hr\ehesap'>
		<cfelseif modul_short_name eq 'rule'>
			<cfset get_file.modul_short_name = 'rules'>
		<cfelseif modul_short_name eq 'pda'>
			<cfset get_file.modul_short_name = 'workcube_pda'>
		</cfif>
	</cfoutput>
	<cfif get_file_count.recordcount eq 0>
		<cfquery name="UPD_FILE_NAME" datasource="#DSN#">
			UPDATE 
				WRK_OBJECTS 
			SET 
				FILE_NAME='_#get_file.file_name#' 
			WHERE
				FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_file.file_name#"> AND
				MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.module,';')#"> AND
				FOLDER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FOLDER#">
		</cfquery>
		<cftry>
			<cffile action="rename" source="#index_folder##get_file.modul_short_name#\#get_file.folder#\#get_file.file_name#" destination="#index_folder##get_file.modul_short_name#\#get_file.folder#\_#get_file.file_name#">
		<cfcatch>
			<cfset error =1>
		</cfcatch>
		</cftry>
	</cfif>
</cfif>
<cfset attributes.actionId = attributes.woid>

<cfdirectory directory="#upload_folder#personal_settings#dir_seperator#" name="files" filter="userGroup*" action="list"><!--- Workcube kurulumu icindeki klasorler alınıyor --->
<cfoutput query="files">
	<cffile action="delete" file="#upload_folder#personal_settings#dir_seperator##files.name#">
</cfoutput>
<script type="text/javascript">
	<cfif attributes.old_fuseaction neq attributes.fuseaction_name>
		<cfoutput>
		document.location ="http://devcatalyst/index.cfm?fuseaction=dev.workdev&fuseact=#fuseaction_name_#";
	</cfoutput>
	<cfelse>
		<cfif attributes.fuseaction_control eq 'dev.wo'>
			window.location.href="<cfoutput>#request.self#?fuseaction=dev.wo&event=upd&fuseact=#attributes.fuseact#&woid=#attributes.woid#</cfoutput>";	
		<cfelse>
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type=a&event=upd&fuseact=#attributes.fuseact#&controllerName=#pageControllerName#&woid=#attributes.woid#</cfoutput>','workDev-page-content');
		</cfif>
	</cfif>
</script>
