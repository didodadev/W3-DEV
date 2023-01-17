<cfquery name="ADD_CUSTOMER_TYPE" datasource="#DSN#">
	INSERT INTO
		SETUP_CUSTOMER_TYPE
	(
		CUSTOMER_TYPE,
		DETAIL,
		IS_CONTROL,
		CONTROL_RATE,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.customer_type#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
	<cfif isdefined("attributes.is_control")>
		1,
		#attributes.control_rate#,
	<cfelse>
		0,
		NULL,
	</cfif>		
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_customer_type" addtoken="no">
