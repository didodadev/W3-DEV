
<cflock name="#createUUID()#" timeout="60">		
	<cftransaction>
		<cfquery name="UPD_STOPPAGE_RATE" datasource="#dsn2#">
			UPDATE 
				SETUP_STOPPAGE_RATES
			SET 
				STOPPAGE_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.stoppage_rate#">,
				STOPPAGE_ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_id#">,
                TAX_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.tax_code)#">,
                TAX_CODE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.tax_code)#">,
				DETAIL =<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.stoppage_rate_detail#" null="#not len(attributes.stoppage_rate_detail)#">,
				SETUP_BANK_TYPE_ID = <cfif len(attributes.setup_bank_type_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.setup_bank_type_id#"><cfelse>NULL</cfif>,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
			WHERE 
				STOPPAGE_RATE_ID = #attributes.STOPPAGE_RATE_ID#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_upd_stoppage_rate&stoppage_rate_id=#attributes.STOPPAGE_RATE_ID#" addtoken="no">
