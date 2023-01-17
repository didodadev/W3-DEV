<cfif len(attributes.notice_id)>
	<cfquery name="get_emp_notice" datasource="#dsn#">
		SELECT 
			APP_POS_ID
		FROM
			EMPLOYEES_APP_POS
		WHERE
			EMPAPP_ID=#attributes.empapp_id# AND
			APP_POS_ID<>#attributes.app_pos_id#
			<cfif len(attributes.notice_id)>AND NOTICE_ID=#attributes.notice_id#</cfif>
	</cfquery>
	<cfif get_emp_notice.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1723.Bu ilana daha önce başvuru yapılmış'>");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>
	<cfif len(attributes.app_date)>
		<CF_DATE tarih="attributes.app_date">
	 <cfelse>
		<cfset attributes.app_date = "NULL">
	</cfif>
	<cfif len(attributes.startdate_if_accepted)>
		<CF_DATE tarih="attributes.startdate_if_accepted">
	<cfelse>
		<cfset attributes.startdate_if_accepted = "NULL">
	</cfif>
<cflock timeout="60">
	<cftransaction>		
		<cfquery name="add_app_pos" datasource="#dsn#">
			UPDATE 
			EMPLOYEES_APP_POS
			SET
				<cfif len(attributes.notice_id)>NOTICE_ID=#attributes.notice_id#<cfelse>NOTICE_ID=NULL</cfif>,
				<cfif len(attributes.position_id)>POSITION_ID=#attributes.position_id#<cfelse>POSITION_ID=NULL</cfif>,
				<cfif len(attributes.position_cat_id)>POSITION_CAT_ID=#attributes.position_cat_id#<cfelse>POSITION_CAT_ID=NULL</cfif>,
				APP_DATE=#attributes.app_date#,
			<cfif len(attributes.company) and len(attributes.company_id)>
				COMPANY_ID=#attributes.company_id#,
			</cfif>
			<cfif len(attributes.our_company_id)>
				OUR_COMPANY_ID=#attributes.our_company_id#,
			</cfif>
			<cfif len(attributes.department_id) and len(attributes.department)>
				DEPARTMENT_ID=#attributes.department_id#,
			</cfif>
			<cfif len(attributes.branch) and len(attributes.branch_id)>
				BRANCH_ID=#attributes.branch_id#,
			</cfif>
				COMMETHOD_ID=#attributes.commethod_id#,
				APP_POS_STATUS=<cfif IsDefined('attributes.app_pos_status')>1<cfelse>0</cfif>,
				<cfif len(attributes.salary_wanted)>SALARY_WANTED=#attributes.salary_wanted#<cfelse>SALARY_WANTED=NULL</cfif>,
				SALARY_WANTED_MONEY='#attributes.salary_wanted_money#',
				<!--- <cfif len(validator_position_code)>VALIDATOR_POSITION_CODE=#validator_position_code#<cfelse>VALIDATOR_POSITION_CODE=NULL</cfif>, --->
				STARTDATE_IF_ACCEPTED=#attributes.startdate_if_accepted#,
				DETAIL='#attributes.detail_app#',
				UPDATE_DATE=#now()#,
				UPDATE_IP='#cgi.REMOTE_ADDR#',
				UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				APP_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
			WHERE 
				APP_POS_ID=#attributes.app_pos_id#
		</cfquery>
		<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
			<cf_workcube_process
				is_upd='1' 
				data_source='#dsn#'
				old_process_line='#attributes.old_process_line#'
				process_stage='#attributes.process_stage#'
				record_member='#session.ep.userid#'
				record_date='#now()#'
				action_table='EMPLOYEES_APP_POS'
				action_column='APP_POS_ID'
				action_id='#attributes.app_pos_id#'
				action_page='#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#attributes.empapp_id#&app_pos_id=#attributes.app_pos_id#'
				warning_description='IK Başvuru Detay : #attributes.app_pos_id#'>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#attributes.empapp_id#&app_pos_id=#attributes.app_pos_id#</cfoutput>";
</script>

