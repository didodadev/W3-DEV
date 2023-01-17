<cfquery name="ADD_ASSET_CARE_CAT" datasource="#DSN#">
	INSERT INTO 
		ASSET_CARE_CAT 
	(
		ASSET_CARE,
		ASSETP_CAT,
		IS_YASAL,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_care#">,		
		#attributes.assetp_cat#,
		<cfif isDefined("attributes.is_yasal")>1<cfelse>0</cfif>,
		<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_asset_care_cat" addtoken="no">
