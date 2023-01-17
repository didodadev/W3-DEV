<cfset xfa.upd = "campaign.popup_upd_campaign">
<cfset xfa.del = "campaign.popup_del_campaign">
<cfif not isdefined("commethods")>
	<cfset commethods = ",,">
<cfelse>
	<cfset commethods = ",#commethods#,">
</cfif>
<cfif not isdefined("camp_status")>
	<cfset camp_status = 0>
</cfif>
<cf_date tarih="attributes.camp_startdate">
<cf_date tarih="attributes.camp_finishdate">
<cfset attributes.camp_startdate = date_add('h',attributes.camp_start_hour-session.ep.time_zone,attributes.camp_startdate)>
<cfset attributes.camp_startdate = date_add('n',attributes.camp_start_min,attributes.camp_startdate)>
<cfset attributes.camp_finishdate = date_add('h',attributes.camp_finish_hour-session.ep.time_zone,attributes.camp_finishdate)>
<cfset attributes.camp_finishdate = date_add('n',attributes.camp_finish_min,attributes.camp_finishdate)>
<cf_papers paper_type="CAMPAIGN">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_CAMPAIGN" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO
				CAMPAIGNS
			(
				USER_FRIENDLY_URL,
				CAMP_STATUS, 
				CAMP_CAT_ID,
				OUR_COMPANY_ID,
				IS_EXTRANET,
				IS_INTERNET,
				<cfif isdefined('attributes.comp_cat')and len(attributes.comp_cat)>COMPANY_CAT,</cfif>
				<cfif isdefined('attributes.cons_cat')and len(attributes.cons_cat)>CONSUMER_CAT,</cfif>
				PROCESS_STAGE,
				CAMP_NO,
				CAMP_STARTDATE, 
				CAMP_FINISHDATE, 
				CAMP_HEAD, 
				<cfif len(leader_employee_id)>LEADER_EMPLOYEE_ID,</cfif>
				<cfif len(CAMP_OBJECTIVE)>CAMP_OBJECTIVE,</cfif>
				PROJECT_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				CAMP_TYPE,
				PART_TIME
			)
			VALUES
			(
				<cfif isdefined("attributes.USER_FRIENDLY_URL") and len(attributes.USER_FRIENDLY_URL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_url#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" null="yes" value=""></cfif>,
				#camp_status#, 
				#camp_cat_id#, 
				#session.ep.company_id#,
				<cfif isdefined('attributes.is_extranet')and len(attributes.is_extranet)>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.is_internet')and len(attributes.is_internet)>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.comp_cat') and len(attributes.comp_cat)>',#attributes.comp_cat#,',</cfif>
				<cfif isdefined('attributes.cons_cat') and len(attributes.cons_cat)>',#attributes.cons_cat#,',</cfif>
				#attributes.process_stage#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#system_paper_no#">,
				#attributes.camp_startdate#, 
				#attributes.camp_finishdate#, 
				'#camp_head#', 
				<cfif len(leader_employee_id)>#leader_employee_id#,</cfif>
				<cfif len(camp_objective)>'#camp_objective#',</cfif>
				<cfif len(project_head) and len(project_id)>#project_id#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#attributes.camp_type#,
				<cfif isdefined('participation_time') and len(participation_time)>#participation_time#<cfelse>NULL</cfif>
			)
		</cfquery>
		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn3#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='CAMPAIGNS'
			action_column='CAMP_ID'
			action_id='#MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#MAX_ID.IDENTITYCOL#' 
			warning_description='Kampanya : #MAX_ID.IDENTITYCOL#'>
	</cftransaction>
</cflock>
<cfif len(system_paper_no_add)>
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS
		SET
			CAMPAIGN_NUMBER = #system_paper_no_add#
		WHERE
			CAMPAIGN_NUMBER IS NOT NULL
	</cfquery>
</cfif>
<cfset attributes.actionId=MAX_ID.IDENTITYCOL />
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
