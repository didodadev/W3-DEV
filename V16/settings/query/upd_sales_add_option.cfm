<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="UPD_SALE_OPTIONS" datasource="#DSN3#">
			UPDATE 
				SETUP_SALES_ADD_OPTIONS
			SET 
				SALES_ADD_OPTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.add_option_name#">,
				DETAIL = <cfif len(attributes.add_option_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.add_option_detail#"><cfelse>NULL</cfif>,
				IS_INTERNET = <cfif isdefined('attributes.is_internet') and attributes.is_internet eq 1>1<cfelse>0</cfif>,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#
			WHERE 
				SALES_ADD_OPTION_ID = #attributes.sale_option_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_sales_add_option" addtoken="no">
