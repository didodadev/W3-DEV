<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="ADD_STOPPAGE_RATE" datasource="#dsn2#">
			INSERT INTO 
				SETUP_STOPPAGE_RATES
				(
					STOPPAGE_RATE,
                    TAX_CODE,
                    TAX_CODE_NAME,
					STOPPAGE_ACCOUNT_CODE,
					DETAIL,
					SETUP_BANK_TYPE_ID,
					RECORD_IP,
					RECORD_DATE,
					RECORD_EMP
				) 
			VALUES 
				(
					<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.stoppage_rate#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.tax_code)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.tax_code)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.stoppage_rate_detail#" null="#not len(attributes.stoppage_rate_detail)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.setup_bank_type_id#" null="#not len(attributes.setup_bank_type_id)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
				)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_stoppage_rate" addtoken="no" />