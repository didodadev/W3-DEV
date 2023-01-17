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
				alert("Etkinlik Başlangıç ve Bitiş Tarihleri Proje Tarihleri Dışında Kalıyor !");
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
			alert("Etkinlik Başlangıç ve Bitiş Tarihleri Kampanya Tarihleri Dışında Kalıyor !");
			history.back();
		</script>
        <cfabort>
	</cfif>
</cfif>	
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_CLASS" datasource="#DSN#">
			UPDATE
				ORGANIZATION
			SET
            	IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				ORGANIZATION_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_head#">,
				ORGANIZATION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_cat_id#">,
				ORGANIZER_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#" null="#not len(attributes.emp_id)#">,
				ORGANIZER_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.con_id#" null="#not len(attributes.con_id)#">,
				ORGANIZER_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#" null="#not len(attributes.par_id)#">,
				START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#" null="#not len(attributes.start_date)#">,
				FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#" null="#not len(attributes.finish_date)#">,			
				MAX_PARTICIPANT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.max_participant#" null="#not len(attributes.max_participant)#">,
				ADDITIONAL_PARTICIPANT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.additional_participant#" null="#not len(attributes.additional_participant)#">,
				ORGANIZATION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_detail#" null="#not len(attributes.organization_detail)#">,
				ORGANIZATION_PLACE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#organization_place#" null="#not len(attributes.organization_place)#">,
				ORGANIZATION_PLACE_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#organization_place_address#" null="#not len(attributes.organization_place_address)#">,
				ORGANIZATION_PLACE_TEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#organization_place_tel#" null="#not len(attributes.organization_place_tel)#">,
				ORGANIZATION_PLACE_MANAGER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_place_manager#" null="#not len(attributes.organization_place_manager)#">,
				ORGANIZATION_ANNOUNCEMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_announcement#" null="#not len(attributes.organization_announcement)#">,
				ORGANIZATION_TARGET = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_target#" null="#not len(attributes.organization_target)#">,
				ORGANIZATION_TOOLS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.organization_tools#" null="#not len(attributes.organization_tools)#">,
				CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#" null="#not len(attributes.camp_name)#">,
				PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" null="#not len(attributes.project_head)#">,
				IS_INTERNET = <cfif isdefined("attributes.is_net_display")>1<cfelse>0</cfif>,
				INT_OR_EXT = <cfif isdefined("attributes.int_or_ext")>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.view_to_all")>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_VIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_VIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				<cfelseif isDefined("attributes.is_view_branch")>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_VIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_view_branch#">,
					IS_VIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				<cfelseif isDefined("attributes.is_view_department")>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_VIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_view_branch_#">,
					IS_VIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_view_department#">,
				<cfelse>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_VIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_VIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				</cfif>
				TOTAL_DATE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.total_date#" null="#not len(attributes.total_date)#">,
				TOTAL_HOUR = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.total_hour#" null="#not len(attributes.total_hour)#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				ORG_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
				ONLINE = <cfif isdefined("attributes.online") and len(attributes.online)>1<cfelse>0</cfif>,
				<cfif len(attributes.url_organization) and len(attributes.url_organization)>	
					ORGANIZATION_LINK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.url_organization#">
				<cfelse>
					ORGANIZATION_LINK = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes" value="">
				</cfif>
			WHERE
				ORGANIZATION_ID = #attributes.org_id#
		</cfquery>
        <cfquery name="del_site_domain" datasource="#dsn#">
            DELETE FROM ORGANIZATION_SITE_DOMAIN WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.org_id#">
        </cfquery>
        <cfif isdefined("attributes.is_net_display") and attributes.is_net_display eq 1>
            <cfquery name="get_company" datasource="#dsn#">
                SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS 
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
                                    #attributes.org_id#,
                                    #attributes['menu_#menu_id#']#
                                )	
                        </cfquery>
                    </cfif>
            </cfoutput>
        </cfif>

		<cf_workcube_process 
			is_upd='1'
			data_source='#dsn#'
			old_process_line='#attributes.old_process_line#'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='ORGANIZATION'
			action_column='ORGANIZATION_ID'
			action_id='#attributes.org_id#'
			action_page='#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#attributes.org_id#'
			warning_description = 'Etkinlik : #attributes.organization_head#'>
	</cftransaction>
</cflock>

<cfif isdefined("attributes.caller_campaign_id")>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=campaign.list_organization&event=upd&camp_id=#attributes.caller_campaign_id#</cfoutput>";
	</script>
<cfelseif isdefined("attributes.caller_project_id")>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=project.projects&event=det&id=#attributes.caller_project_id#</cfoutput>";
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#attributes.org_id#</cfoutput>";
	</script>
</cfif>