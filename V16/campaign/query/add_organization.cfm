<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
	<cfset attributes.finish_date = date_add('h', FORM.EVENT_finish_CLOCK - session.ep.TIME_ZONE, attributes.finish_date)>
	<cfset attributes.finish_date = date_add('n', FORM.EVENT_finish_minute, attributes.finish_date)>
</cfif>
<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
	<cfset attributes.start_date = date_add('h', FORM.EVENT_START_CLOCK - session.ep.TIME_ZONE, attributes.start_date)>
	<cfset attributes.start_date = date_add('n', FORM.EVENT_START_minute, attributes.start_date)>
</cfif>
<cfif xml_project_date_control eq 1>
	<cfif len(attributes.project_id) and len(attributes.project_head)>
		<cfquery name="check_project_date" datasource="#DSN#">
			SELECT 
				COUNT(PROJECT_ID) AS COUNT
			FROM
				PRO_PROJECTS	
			WHERE
				PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
				TARGET_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
				TARGET_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfquery>
		<cfif check_project_date.count eq 0>
			<script type="text/javascript">
				alert("Seçilen Tarihler Proje Tarihleri Dışında Kalıyor !");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
<cfif len(attributes.camp_id) and len(attributes.camp_name)>
	<cfquery name="check_campaigns_date" datasource="#DSN3#">
		SELECT 
			COUNT(CAMP_ID) AS COUNT
		FROM
			CAMPAIGNS	
		WHERE
			CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
			CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
			CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
	</cfquery>
	<cfif check_campaigns_date.count eq 0>
		<script type="text/javascript">
			alert("Seçilen Tarihler Kampanya Tarihleri Dışında Kalıyor !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>	
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_CLASS" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				ORGANIZATION
				(
                	IS_ACTIVE,
					ORGANIZATION_HEAD,
					ORGANIZATION_CAT_ID,
				<cfif len(attributes.emp_id)>
					ORGANIZER_EMP
				<cfelseif len(attributes.cons_id)>
					ORGANIZER_CON
				<cfelseif len(attributes.par_id)>
					ORGANIZER_PAR
				</cfif>,
					START_DATE,
					FINISH_DATE,
					MAX_PARTICIPANT,
					ADDITIONAL_PARTICIPANT,
					ORGANIZATION_DETAIL,
					ORGANIZATION_PLACE,
					ORGANIZATION_PLACE_ADDRESS,
					ORGANIZATION_PLACE_TEL,
					ORGANIZATION_PLACE_MANAGER,
					ORGANIZATION_ANNOUNCEMENT,
					ORGANIZATION_TARGET,
					ORGANIZATION_TOOLS,
					CAMPAIGN_ID,
					PROJECT_ID,
					IS_INTERNET,
					INT_OR_EXT,
					VIEW_TO_ALL,
					IS_VIEW_BRANCH,
					IS_VIEW_DEPARTMENT,
					TOTAL_DATE,
					TOTAL_HOUR,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					ORG_STAGE,
					ONLINE,
					ORGANIZATION_LINK
				)
			VALUES
				(
					<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_head#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_cat_id#">,
				<cfif len(attributes.emp_id)>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
				<cfelseif len(attributes.par_id)>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#">
				<cfelseif len(attributes.cons_id)>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">
				</cfif>,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.max_participant#" null="#NOT len(attributes.max_participant)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.additional_participant#" null="#NOT len(attributes.additional_participant)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_detail#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_place#" null="#not len(attributes.organization_place)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_place_address#" null="#not len(attributes.organization_place_address)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_place_tel#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_place_manager#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_announcement#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_target#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_tools#">,
					<cfif isdefined("attributes.caller_campaign_id")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.caller_campaign_id#" null="#not len(attributes.caller_campaign_id)#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.project_id#" null="#not (len(attributes.project_head) and len(attributes.project_id))#">,
					<cfif isdefined("attributes.is_net_display")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.int_or_ext")>1<cfelse>0</cfif>,
					<cfif isDefined("FORM.VIEW_TO_ALL")>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
					<cfelseif isDefined("FORM.is_wiew_branch")>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_wiew_branch#">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
					<cfelseif isDefined("FORM.is_wiew_department")>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_wiew_branch_#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_wiew_department#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
					</cfif>
					<cfif len(attributes.total_date)>#attributes.total_date#<cfelse>NULL</cfif>,
   					<cfif len(attributes.total_hour)>#attributes.total_hour#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
					<cfif isdefined("attributes.online") and len(attributes.online)>1<cfelse>0</cfif>,
					<cfif len(attributes.url_organization) and len(attributes.url_organization)>	
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.url_organization#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" null="yes" value="">
					</cfif>
				)
		</cfquery>
		<cfif isdefined("attributes.is_net_display")>
			<cfquery name="get_company" datasource="#dsn#">
				SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL AND IS_ACTIVE = 1
			</cfquery>
			<cfoutput query="get_company">
				<cfif isdefined("attributes.menu_#menu_id#")>
					<cfquery name="training_site_domain" datasource="#dsn#">
						INSERT INTO
							ORGANIZATION_SITE_DOMAIN
						(
							ORGANIZATION_ID,		
							MENU_ID
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#max_id.identitycol#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes['menu_#menu_id#']#">
						)	
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
		<cf_workcube_process 
			is_upd='1'
			data_source='#dsn#'
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='ORGANIZATION'
			action_column='ORGANIZATION_ID'
			action_id='#max_id.identitycol#'
			action_page='#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#max_id.identitycol#'
			warning_description = 'Etkinlik : #attributes.organization_head#'>
	</cftransaction>
</cflock>


<cfif isdefined("attributes.caller_campaign_id")>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#attributes.caller_campaign_id#</cfoutput>";
</script>
<cfelseif isdefined("attributes.caller_project_id")>
	<cflocation url="#request.self#?fuseaction=project.projects&event=det&id=#attributes.caller_project_id#" addtoken="no">
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#max_id.identitycol#</cfoutput>";
	</script>
</cfif>
