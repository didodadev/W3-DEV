<cfset fuseaction_name_ = replacelist(lcase(attributes.fuseaction_name),"/,*, ,',ğ,ü,ş,ö,ç,ı,İ,:,;","-,x,-,_,g,u,s,o,c,i,I,,")>
<cfquery name="GET_FUSEACTION_NAME" datasource="#DSN#">
	SELECT 
		FUSEACTION 
	FROM 
		WRK_OBJECTS 
	WHERE 
		FULL_FUSEACTION = '#fuseaction_name_#'
</cfquery>  
<cfif get_fuseaction_name.recordcount>
	<script type="text/javascript">
		alert('Sayfa İçin Tanımladığınız Fuseaction Kullanılmaktadır!\Lütfen Düzenleyiniz');
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name= "ADD_WRK_OBJECTS" datasource="#DSN#" result="MAX_ID">
    INSERT INTO
        WRK_OBJECTS
    (
        DICTIONARY_ID,
        MODULE_NO,
        FILE_PATH,
        FUSEACTION,
        FULL_FUSEACTION,
        HEAD,
        SECURITY,
        RECORD_IP,
        RECORD_EMP,
        RECORD_DATE,
        IS_ACTIVE,
        IS_MENU,
        WINDOW,
        POPUP_TYPE,
        USE_PROCESS_CAT,
        USE_WORKFLOW,
        USE_SYSTEM_NO,
        EVENT_ADD,
        EVENT_UPD,
        EVENT_LIST,
        EVENT_DETAIL,
        EVENT_DASHBOARD,
        EVENT_OUTPUT,
        LICENCE,
        TYPE,
        AUTHOR,
        VERSION,
        DETAIL,
        FRIENDLY_URL,
        STATUS,
        EXTERNAL_FUSEACTION,
        STAGE,
        IS_LEGACY,
        CONTROLLER_FILE_PATH,
        MAIN_VERSION,
        ADDOPTIONS_CONTROLLER_FILE_PATH,
        FOLDER,
        MODUL_SHORT_NAME,
        DISPLAY_BEFORE_PATH,
        DISPLAY_AFTER_PATH,
        ACTION_BEFORE_PATH,
        ACTION_AFTER_PATH,
        XML_PATH,
        IS_PUBLIC,
        IS_EMPLOYEE,
        IS_CONSUMER,
        IS_COMPANY,
        IS_EMPLOYEE_APP,
        IS_LIVESTOCK,
        IS_MACHINES
    )
    VALUES
    (
        <cfif IsDefined("attributes.dictionary_id") and len(attributes.dictionary_id)>#attributes.dictionary_id#<cfelse>NULL</cfif>,
        <cfif IsDefined("attributes.module") and len(attributes.module)>#attributes.module#<cfelse>NULL</cfif>,
        <cfif IsDefined("attributes.file_path") and len(attributes.file_path)>'#attributes.file_path#'<cfelse>NULL</cfif>,
        '#listlast(fuseaction_name_,".")#',
        '#fuseaction_name_#',
        '#attributes.head#',
        '#attributes.security#',
        '#cgi.remote_addr#',
        #session.ep.userid#,
        #now()#,
        <cfif Isdefined("attributes.is_active")>1<cfelse>0</cfif>,
        <cfif Isdefined("attributes.is_menu")>1<cfelse>0</cfif>,
        <cfif Isdefined("attributes.window_type")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.window_type#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.popupInfoType") and len(attributes.popupInfoType)>'#attributes.popupInfoType#'<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.use_process_cat")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.use_workflow")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.use_system_no")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.eventAdd")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.eventUpd")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.eventList")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.eventDetail")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.eventDashboard")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.eventOutput")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.licence") and len(attributes.licence)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.licence#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.type") and len(attributes.type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type#"><cfelse>NULL</cfif>,
        <cfif len(attributes.author_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.author_name#"><cfelse>NULL</cfif>,
        <cfif len(attributes.version)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.version#"><cfelse>NULL</cfif>,
        <cfif len(attributes.wo_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.wo_detail#"><cfelse>NULL</cfif>,
        <cfif len(attributes.friendly_url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.friendly_url#"><cfelse>NULL</cfif>,
        <cfif len(attributes.status)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.status#"><cfelse>NULL</cfif>,
        <cfif len(attributes.external_fuseaction)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.external_fuseaction#"><cfelse>NULL</cfif>,
        <cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.is_legacy")><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.is_legacy#'><cfelse>0</cfif>,
        <cfif len(attributes.controllerFilePath) and attributes.licence neq 3><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.controllerFilePath#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.main_version") and len(attributes.main_version)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_version#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.addOpitonsControllerFilePath") and len(attributes.addOpitonsControllerFilePath) and attributes.licence neq 1><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.addOpitonsControllerFilePath#"><cfelse>NULL</cfif>,
        'W3WorkDev',
        '#listfirst(fuseaction_name_,'.')#',
        <cfif len(attributes.display_before_path)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.display_before_path#'><cfelse>NULL</cfif>,
        <cfif len(attributes.display_after_path)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.display_after_path#'><cfelse>NULL</cfif>,
        <cfif len(attributes.action_before_path)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.action_before_path#'><cfelse>NULL</cfif>,
        <cfif len(attributes.action_after_path)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.action_after_path#'><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.xml_path") and len(attributes.xml_path)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.xml_path#'><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.is_public") and len(attributes.is_public)>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_employee") and len(attributes.is_employee)>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_consumer") and len(attributes.is_consumer)>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_company") and len(attributes.is_company)>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_employee_app") and len(attributes.is_employee_app)>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_livestock") and len(attributes.is_livestock)>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_machines") and len(attributes.is_machines)>1<cfelse>0</cfif>
    )
</cfquery>

<cfquery name="familyTable" datasource="#dsn#">
    SELECT WRK_FAMILY_ID , FAMILY 
    FROM WRK_FAMILY where WRK_FAMILY_ID = #attributes.family#
</cfquery>

<cfquery name="moduleTable" datasource="#dsn#">
    SELECT MODULE , MODULE_ID FROM WRK_MODULE where MODULE_ID =  #module#
</cfquery>
<cfquery name="solutionTable" datasource="#dsn#">
select WRK_SOLUTION_ID , SOLUTION FROM WRK_SOLUTION where WRK_SOLUTION_ID=#solution#
</cfquery>

<cfif attributes.is_legacy eq "2">
    <cfscript>
        eventArray=[];
        if(isdefined("attributes.eventAdd"))
        ArrayAppend(eventArray, "add"); 
        if(isdefined("attributes.eventUpd"))
        ArrayAppend(eventArray, "upd"); 
        if( isdefined("attributes.eventList"))
        ArrayAppend(eventArray, "list");
        if( isdefined("attributes.eventDetail"))
        ArrayAppend(eventArray, "info"); 
        if (isdefined("attributes.eventDashboard"))
        ArrayAppend(eventArray, "dashboard"); 
        attributes.events=(arrayToList( eventArray ));
        
         widgetComponent = createObject("component", "WDO.development.cfc.widgetQuery");
		 savetowidget = widgetComponent.savetowidget(
                    fuseaction  : fuseaction_name_,
                    title       : attributes.head,
                    version     : attributes.version,
                    status      : attributes.status,
                    stage       : attributes.process_stage,
                    tool        : "nocode",
                    file_path   : attributes.file_path,
                    solutionid  : attributes.solution,
                    solution    : solutionTable.solution,
                    familyid    : attributes.family,
                    family      : familyTable.family,
                    moduleid    : attributes.module,
                    module      : moduleTable.module,
                    license     : attributes.licence,
                    author      : attributes.author_name,
                    description : attributes.wo_detail,
                    events      : attributes.events    ); 

        eventComponent= createObject("component", "WDO.development.cfc.eventQuery");
        savetoevent = eventComponent.savetoevent(
                    fuseaction  : fuseaction_name_,
                    title       : attributes.head,
                    version     : attributes.version,
                    status      : attributes.status,
                    stage       : attributes.process_stage,
                    tool        : "nocode",
                    file_path   : attributes.file_path,
                    solutionid  : attributes.solution,
                    solution    : solutionTable.solution,
                    familyid    : attributes.family,
                    family      : familyTable.family,
                    moduleid    : attributes.module,
                    module      : moduleTable.module,
                    license     : attributes.licence,
                    author      : attributes.author_name,
                    description : attributes.wo_detail,
                    events      : attributes.events
        );
    


</cfscript>
      
</cfif>

<cfif isDefined("attributes.bestpractice") and len(attributes.bestpractice)>
    <cfquery name="query_obj_bp" datasource="#dsn#">
        INSERT INTO WRK_OBJECTS_BESTPRACTICE ( OBJECT_ID, BESTPRACTICE_ID ) VALUES( #MAX_ID.IDENTITYCOL#, <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.bestpractice#'> )
    </cfquery>
</cfif>

<!---iliskili islem tipi --->
<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
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
					<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
					'#i#'
				)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>

<cfset attributes.actionId = MAX_ID.IDENTITYCOL>

<cfdirectory directory="#upload_folder#personal_settings#dir_seperator#" name="files" filter="userGroup*" action="list"><!--- Workcube kurulumu icindeki klasorler alınıyor --->
<cfoutput query="files">
	<cffile action="delete" file="#upload_folder#personal_settings#dir_seperator##files.name#">
</cfoutput>

<script type="text/javascript">
  <cfif attributes.fuseaction_control eq 'dev.wo'>
        window.location.href="<cfoutput>#request.self#?fuseaction=dev.wo&event=upd&fuseact=#fuseaction_name_#&woid=#attributes.actionId#</cfoutput>";	
    <cfelse>
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type=a&event=upd&fuseact=#fuseaction_name_#&woid=#attributes.actionId#</cfoutput>','workDev-page-content');
    </cfif>
  	
</script>

<!--- <cffunction name="savetowidget" access="remote" returntype="any">  
    <cfargument name="fuseaction" type="string" default="">
    <cfargument name="title" type="string">
    <cfargument name="version" type="string">
    <cfargument name="structure" type="string" default="">
    <cfargument name="code" type="string" default="">
    <cfargument name="status" type="string">
    <cfargument name="stage" type="string" default="0">
    <cfargument name="tool" type="string">
    <cfargument name="file_path" type="string">
    <cfargument name="solutionid" type="integer">
    <cfargument name="solution" type="string">
    <cfargument name="familyid" type="integer">
    <cfargument name="family" type="string">
    <cfargument name="moduleid" type="integer">
    <cfargument name="module" type="string">
    <cfargument name="license" type="string">
    <cfargument name="author" type="string">
    <cfargument name="description" type="string">
    <cfargument name="events" type="string">
    <cftry>
        <cftransaction>
            <cfloop list="#arguments.events#" index="event">
                
                    <cfquery datasource="#dsn#">
                        INSERT INTO WRK_WIDGET (
                            WIDGET_FUSEACTION,
                            WIDGET_TITLE,
                            WIDGET_EVENT_TYPE,
                            WIDGET_VERSION,
                            WIDGET_STATUS,
                            WIDGET_STAGE,
                            WIDGET_TOOL,
                            <cfif isDefined("arguments.file_path")>
                            WIDGET_FILE_PATH,
                            </cfif>
                            WIDGETSOLUTIONID,
                            WIDGETSOLUTION,
                            WIDGETFAMILYID,
                            WIDGETFAMILY,
                            WIDGETMODULEID,
                            WIDGETMODULE,
                            WIDGET_LICENSE,
                            WIDGET_AUTHOR,
                            WIDGET_DESCRIPTION,
                            RECORD_IP,
                            RECORD_EMP,
                            RECORD_DATE
                        ) VALUES (
                            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#event#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.version#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.status#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.stage#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.tool#'>
                            <cfif isDefined("arguments.file_path")>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.file_path#'>
                            </cfif>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.solutionid#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.solution#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.familyid#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.family#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.moduleid#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.module#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.license#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.author#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.description#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#cgi.remote_addr#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                            ,#now()#
                        )
                    </cfquery>
                
            </cfloop>
        </cftransaction>
        <cfreturn 1>
        <cfcatch>
            <cfreturn 0>
        </cfcatch>
    </cftry>
</cffunction> --->