<cfquery name="ADD_OPPORTUNITY" datasource="#dsn3#">
	INSERT INTO
		SETUP_OPPORTUNITY_TYPE
	(
		OPPORTUNITY_TYPE,
		OPPORTUNITY_TYPE_DETAIL,
		IS_INTERNET,
		IS_SALES,
		IS_PURCHASE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.opportunity_type#">,
		<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_sales")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_purchase")>1<cfelse>0</cfif>,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_opportunity_type" addtoken="no">
