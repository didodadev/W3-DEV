<cfparam name="is_internet" default=0>
<cfparam name="is_extranet" default=0>
<cfif not isDefined("COMMETHODS")>
	<cfset COMMETHODS = "">
<cfelse>
	<cfset COMMETHODS = ",#COMMETHODS#,">
</cfif>
<cf_date tarih="attributes.CAMP_STARTDATE">
<cf_date tarih="attributes.CAMP_FINISHDATE">

<cfset attributes.camp_startdate = date_add('h',attributes.camp_start_hour-session.ep.time_zone,attributes.camp_startdate)>
<cfset attributes.camp_startdate = date_add('n',attributes.camp_start_min,attributes.camp_startdate)>
<cfset attributes.camp_finishdate = date_add('h',attributes.camp_finish_hour-session.ep.time_zone,attributes.camp_finishdate)>
<cfset attributes.camp_finishdate = date_add('n',attributes.camp_finish_min,attributes.camp_finishdate)>
<cfquery name="UPD_CAMPAIGN" datasource="#dsn3#">
	UPDATE
		CAMPAIGNS
	SET
		USER_FRIENDLY_URL = <cfif isdefined("attributes.USER_FRIENDLY_URL") and len(attributes.USER_FRIENDLY_URL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_url#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" null="yes" value=""></cfif>,
		<cfif len(LEADER_EMPLOYEE_ID)>LEADER_EMPLOYEE_ID = #LEADER_EMPLOYEE_ID#,</cfif>
		<cfif isDefined("CAMP_STATUS")>CAMP_STATUS = 1<cfelse>CAMP_STATUS = 0</cfif>,
		CAMP_CAT_ID = #CAMP_CAT_ID#,
		<cfif isdefined('attributes.is_internet')>IS_INTERNET=1<cfelse>IS_INTERNET=0</cfif>,
		<cfif isdefined('attributes.is_extranet')>IS_EXTRANET=1<cfelse>IS_EXTRANET=0</cfif>,
		<cfif isdefined('attributes.comp_cat')>COMPANY_CAT = ',#attributes.comp_cat#,'<cfelse>COMPANY_CAT = NULL</cfif>,
		<cfif isdefined('attributes.cons_cat')>CONSUMER_CAT = ',#attributes.cons_cat#,'<cfelse>CONSUMER_CAT = NULL</cfif>,
		<cfif len(attributes.PROCESS_STAGE)>PROCESS_STAGE = #attributes.PROCESS_STAGE#<cfelse>PROCESS_STAGE = NULL</cfif>,
		<cfif Len(project_head) AND Len(project_id)>PROJECT_ID = #project_id#<cfelse>PROJECT_ID = NULL</cfif>,
		CAMP_NO = '#CAMP_NO#', 
		CAMP_STARTDATE = #attributes.CAMP_STARTDATE#,
		CAMP_FINISHDATE = #attributes.CAMP_FINISHDATE#,
		CAMP_HEAD = '#CAMP_HEAD#',
		CAMP_OBJECTIVE = '#CAMP_OBJECTIVE#',
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		CAMP_TYPE = #attributes.camp_type#,
		PART_TIME =<cfif isdefined("attributes.participation_time") and len(attributes.participation_time)>'#attributes.participation_time#'<cfelse>NULL</cfif> 
	WHERE
		CAMP_ID = #attributes.CAMP_ID#
</cfquery>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn3#' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='CAMPAIGNS'
	action_column='CAMP_ID'
	action_id='#attributes.camp_id#'
	action_page='#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#attributes.camp_id#' 
	warning_description='Kampanya : #attributes.camp_id#'>
    
<cfset attributes.actionId=attributes.camp_id/>    
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#attributes.camp_id#</cfoutput>';
</script>
