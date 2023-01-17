<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="ADD_SALE_OPTIONS" datasource="#DSN3#">
			INSERT INTO 
				SETUP_SALES_ADD_OPTIONS
			(
				SALES_ADD_OPTION_NAME,
				DETAIL,
				IS_INTERNET,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP
			) 
			VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.add_option_name#">,
				<cfif len(attributes.add_option_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.add_option_detail#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_internet') and attributes.is_internet eq 1>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#now()#,
				#session.ep.userid#
			)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_sales_add_option" addtoken="no">
