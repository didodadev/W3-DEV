<cfquery name="ADD_PROCESS" datasource="#DSN#">
	INSERT INTO
		PROCESS_TYPE
	(
		IS_ACTIVE,
		PROCESS_NAME,
		DETAIL,
		FACTION,
		IS_STAGE_BACK,
		IS_STAGE_MANUEL_CHANGE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		DEPARTMENT_ID,
		UPPER_DEP_ID,
		RESP_EMP_ID,
		FRIENDLY_URL,
		PAGE_NAME
	)
	VALUES
	(
		<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_name#">,
		<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		<cfif len(attributes.module_field_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_field_name#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_stage_back")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_stage_manuel_change")>1<cfelse>0</cfif>,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.up_department_id") and len(attributes.up_department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.up_department_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"><cfelse>NULL</cfif>,
		<cfif len(attributes.widget_friendly_url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.widget_friendly_url#"><cfelse>NULL</cfif>,
		<cfif len(attributes.module_page_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_page_name#"><cfelse>NULL</cfif>
	)
    SELECT @@IDENTITY AS MAX_PROCESS_TYPE_ID
</cfquery>

<cfquery name="record_main_rows" datasource="#dsn#">
	INSERT INTO
		PROCESS_MAIN_ROWS
		(	
			PROCESS_MAIN_ID,
			PROCESS_ID,
			DISPLAY_HEADER,
			ACTION_HEADER,
			DESIGN_OBJECT_TYPE,
			DESIGN_TITLE,
			DESIGN_XY_COORD,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
	VALUES
		(
			<cfif isdefined('attributes.item_process_main_id') and len(attributes.item_process_main_id)>#attributes.item_process_main_id#<cfelse>Null</cfif>,
			#add_process.max_process_type_id#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Display File">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Action File">,
			0,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_name#">,
			'0,0;;',
			#now()#,
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">	
		)
</cfquery>
<cfquery name="ADD_PROCESS_TYPE_HISTORY" datasource="#dsn#">
    INSERT INTO
        PROCESS_TYPE_HISTORY
    (
        PROCESS_ID,
        IS_ACTIVE,
        PROCESS_NAME,
        FACTION,
        IS_STAGE_BACK,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
		FRIENDLY_URL,
		PAGE_NAME
    )
    VALUES
    (
        #add_process.max_process_type_id#,
        <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_name#">,
        <cfif len(attributes.module_field_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_field_name#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.is_stage_back")>1<cfelse>0</cfif>,
        #now()#,
        #session.ep.userid#,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfif len(attributes.widget_friendly_url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.widget_friendly_url#"><cfelse>NULL</cfif>,
		<cfif len(attributes.module_page_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_page_name#"><cfelse>NULL</cfif>
    )
</cfquery>
<cfquery name="GET_MAXID" datasource="#DSN#">
	SELECT MAX(PROCESS_ID) AS MAX_ID FROM PROCESS_TYPE
</cfquery>
<cfif isDefined("attributes.process_our_company_id") and Len(attributes.process_our_company_id)>
	<!--- Iliskili Sirketler --->
	<cfloop list="#attributes.process_our_company_id#" index="poc">
		<cfquery name="Add_Process_Type_Our_Company" datasource="#dsn#">
			INSERT INTO
				PROCESS_TYPE_OUR_COMPANY
			(
				PROCESS_ID,
				OUR_COMPANY_ID
			)
			VALUES
			(
				#get_maxid.max_id#,
				#poc#
			)
		</cfquery>
	</cfloop>
</cfif>
<script type="text/javascript">
	window.location.href ="<cfoutput>#request.self#?fuseaction=process.list_process&event=upd&process_id=#get_maxid.max_id#</cfoutput>";
</script>
