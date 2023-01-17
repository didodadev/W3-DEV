<cfquery name="ADD_USAGE_PURPOSE" datasource="#DSN#">
	INSERT 
	INTO 
		SETUP_USAGE_PURPOSE 
	(
		USAGE_PURPOSE,
		DETAIL,
		ASSETP_RESERVE,
		IT_ASSET,
		MOTORIZED_VEHICLE,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usage_purpose#">,
		<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.assetp_reserve")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.it_asset")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.motorized_vehicle")>1<cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_usage_purpose" addtoken="no">
