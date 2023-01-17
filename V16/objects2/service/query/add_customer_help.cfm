<cfif len(attributes.subject) and len(attributes.applicant_name)>
	<cfquery name="get_system" datasource="#dsn3#">
		SELECT
			SUBSCRIPTION_ID
		FROM
			SUBSCRIPTION_CONTRACT
		WHERE
			SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#WORKCUBE_ID#">
	</cfquery>
	<cfquery name="add_help" datasource="#dsn#">
		INSERT INTO
			CUSTOMER_HELP
			(
				WORKCUBE_ID,
				COMPANY,
				<cfif isdefined('attributes.app_cat') and len(attributes.app_cat)>#attributes.app_cat#<cfelse>APP_CAT</cfif>,
				SUBJECT,
				PROCESS_STAGE,
				<!--- DETAIL, --->
				HELP_PAGE,
				APPLICANT_NAME,
				APPLICANT_MAIL,
				RECORD_DATE,
				RECORD_IP
			<cfif get_system.recordcount>
				,SUBSCRIPTION_ID
			</cfif>
			)
			VALUES
			(
				'#attributes.workcube_id#',
				'#attributes.company#',
				<cfif isdefined('attributes.app_cat') and len(attributes.app_cat)>#attributes.app_cat#<cfelse>2</cfif>,
				'#attributes.subject#',
				'#attributes.process_stage#',
				<!--- '#attributes.detail#', --->
				'#attributes.help_page#',
				'#attributes.applicant_name#',
				'#attributes.applicant_mail#',
				#now()#,
				'#CGI.REMOTE_ADDR#'
			<cfif get_system.recordcount>
				,#get_system.SUBSCRIPTION_ID#
			</cfif>
			)
	</cfquery>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1501.Bilgilerinizi Kontrol Ediniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
	window.close();
</script>
<cfabort>

