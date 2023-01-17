<cfif len(attributes.notice_id)>
	<cfquery name="get_emp_notice" datasource="#dsn#">
		SELECT 
			APP_POS_ID
		FROM
			EMPLOYEES_APP_POS
		WHERE
			EMPAPP_ID=#attributes.empapp_id#
			AND NOTICE_ID=#attributes.notice_id#
	</cfquery>
	<cfif get_emp_notice.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1723.Bu ilana daha önce başvuru yapılmış'>");
			window.close();
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
		<cfquery name="add_app_pos" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			EMPLOYEES_APP_POS
			(
				EMPAPP_ID,
				NOTICE_ID,
				POSITION_ID,
				POSITION_CAT_ID,
				APP_DATE,
			<cfif len(attributes.company) and len(attributes.company_id)>
				COMPANY_ID,
			</cfif>
			<cfif len(attributes.our_company_id)>
				OUR_COMPANY_ID,
			</cfif>
			<cfif len(attributes.department_id) and len(attributes.department)>
				DEPARTMENT_ID,
			</cfif>
			<cfif len(attributes.branch) and len(attributes.branch_id)>
				BRANCH_ID,
			</cfif>
				COMMETHOD_ID,
				APP_POS_STATUS,
				SALARY_WANTED,
				SALARY_WANTED_MONEY,
				<!--- VALIDATOR_POSITION_CODE, --->
				DETAIL,
				STARTDATE_IF_ACCEPTED,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				APP_STAGE
			)
			VALUES
			(
				#attributes.empapp_id#,
				<cfif len(attributes.notice_id)>#attributes.notice_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.position_id)>#attributes.position_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.position_cat_id)>#attributes.position_cat_id#<cfelse>NULL</cfif>,
				#attributes.app_date#,
			<cfif len(attributes.company) and len(attributes.company_id)>
				#attributes.company_id#,
			</cfif>
			<cfif len(attributes.our_company_id)>
				#attributes.our_company_id#,
			</cfif>
			<cfif len(attributes.department_id) and len(attributes.department)>
				#attributes.department_id#,
			</cfif>
			<cfif len(attributes.branch) and len(attributes.branch_id)>
				#attributes.branch_id#,
			</cfif>
				#attributes.commethod_id#,
				<cfif IsDefined('attributes.app_pos_status')>1<cfelse>0</cfif>,
				<cfif len(attributes.salary_wanted)>#attributes.salary_wanted#<cfelse>NULL</cfif>,
				'#attributes.salary_wanted_money#',
				<!--- <cfif len(validator_position_code)>#validator_position_code#<cfelse>NULL</cfif>, --->
				<cfif len(attributes.detail_app)>'#attributes.detail_app#'<cfelse>NULL</cfif>,
				#attributes.startdate_if_accepted#,
				#now()#,
				'#cgi.REMOTE_ADDR#',
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
			)
		</cfquery>
		<cfif isdefined('process_stage') and len(process_stage)>
			<cf_workcube_process
				is_upd='1' 
				data_source='#dsn#'
				old_process_line='0'
				process_stage='#attributes.process_stage#'
				record_member='#session.ep.userid#'
				record_date='#now()#'
				action_table='EMPLOYEES_APP_POS'
				action_column='APP_POS_ID'
				action_id='#MAX_ID.IDENTITYCOL#'
				action_page='#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#attributes.empapp_id#&app_pos_id=#MAX_ID.IDENTITYCOL#'
				warning_description='IK Başvuru Detay : #MAX_ID.IDENTITYCOL#'>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#attributes.empapp_id#&app_pos_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
