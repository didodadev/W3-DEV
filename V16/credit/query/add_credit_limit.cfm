<cfif isdefined("attributes.credit_limit_id")>
	<cfquery name="upd_credit_limit" datasource="#DSN3#">
		UPDATE
			CREDIT_LIMIT
		SET
			CREDIT_TYPE = #attributes.credit_type#,
			ACCOUNT_ID = <cfif len(attributes.account_id)>#attributes.account_id#<cfelse>NULL</cfif>,
			COMPANY_ID = <cfif len(attributes.company_id) and len(attributes.company)>#attributes.company_id#<cfelse>NULL</cfif>,
			CREDIT_LIMIT = #attributes.action_value#,
			MONEY_TYPE = '#attributes.action_currency_id#',
			LIMIT_HEAD = '#attributes.limit_head#',
			ACTION_DETAIL = <cfif len(attributes.action_detail)>'#attributes.action_detail#'<cfelse>NULL</cfif>,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#'	
		WHERE
			CREDIT_LIMIT_ID = #attributes.credit_limit_id#		
	</cfquery>
<cfelse>
	<cfquery name="add_credit_limit" datasource="#DSN3#">
		INSERT INTO
			CREDIT_LIMIT
		(
			CREDIT_TYPE,
			ACCOUNT_ID,
			COMPANY_ID,
			CREDIT_LIMIT,
			MONEY_TYPE,
			ACTION_DETAIL,
			LIMIT_HEAD,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
		VALUES
		(
			#attributes.credit_type#,
			<cfif len(attributes.account_id)>#attributes.account_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.company_id) and len(attributes.company)>#attributes.company_id#<cfelse>NULL</cfif>,
			#attributes.action_value#,
			'#attributes.action_currency_id#',
			<cfif len(attributes.action_detail)>'#attributes.action_detail#'<cfelse>NULL</cfif>,
			'#attributes.limit_head#',
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#'			
		)					
	</cfquery>
</cfif>
<script>
	window.location='<cfoutput>#request.self#?fuseaction=credit.list_credit_limit</cfoutput>';
</script>
