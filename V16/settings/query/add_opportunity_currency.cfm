<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_max" datasource="#dsn3#">
			SELECT MAX(OPP_CURRENCY_ID) AS MAX_ID FROM OPPORTUNITY_CURRENCY
		</cfquery>
		<cfif len(get_max.max_id)>
			<cfset temp_max = get_max.max_id + 1>
		<cfelse>
			<cfset temp_max = 1>
		</cfif>
        <cfquery name="INS_OPP_CURRENCY" datasource="#dsn3#">
			INSERT INTO 
				OPPORTUNITY_CURRENCY
				(
				OPP_CURRENCY_ID,
                OPP_CURRENCY,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
				) 
			VALUES 
				(
				#temp_max#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#OPPORTUNITY_CURRENCY#">,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
				)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_opportunity_currency" addtoken="no">
