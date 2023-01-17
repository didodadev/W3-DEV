<cfif len(attributes.notice_id)>
	<cfquery name="get_emp_notice" datasource="#dsn#">
		SELECT 
			APP_POS_ID
		FROM
			EMPLOYEES_APP_POS
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#"> AND
			APP_POS_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_pos_id#">
			<cfif len(attributes.notice_id)>AND NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#"></cfif>
	</cfquery>
	<cfif get_emp_notice.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='917.Bu ilana daha önce başvuru yapılmış'>");
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
	
	<cfquery name="add_app_pos" datasource="#dsn#">
	UPDATE 
		EMPLOYEES_APP_POS
		SET
			NOTICE_ID = <cfif len(attributes.notice_id)>#attributes.notice_id#<cfelse>NULL</cfif>,
			<!--- POSITION_ID = <cfif len(attributes.position_id)>#attributes.position_id#<cfelse>NULL</cfif>, --->
			APP_DATE = #attributes.app_date#,
			COMPANY_ID = #session.pp.company_id#,
			OUR_COMPANY_ID = #session.pp.our_company_id#,
			COMMETHOD_ID = 6,
			APP_POS_STATUS = <cfif IsDefined('attributes.app_pos_status')>1<cfelse>0</cfif>,
			SALARY_WANTED = <cfif len(attributes.salary_wanted)>#attributes.salary_wanted#<cfelse>NULL</cfif>,
			SALARY_WANTED_MONEY = '#attributes.salary_wanted_money#',
			VALIDATOR_PAR = <cfif len(validator_par)>#listgetat(attributes.validator_par,1,',')#<cfelse>NULL</cfif>,
			STARTDATE_IF_ACCEPTED = #attributes.startdate_if_accepted#,
			DETAIL = '#attributes.detail_app#',
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.pp.userid#
		WHERE 
			APP_POS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_pos_id#">
	</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.upd_app_pos&empapp_id=#attributes.empapp_id#&app_pos_id=#attributes.app_pos_id#" addtoken="No">

