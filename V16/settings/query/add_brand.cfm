<cfquery name="ADD_BRAND" datasource="#dsn#" result="MAX_ID"> 
	INSERT INTO 
	SETUP_BRAND
	(
		BRAND_NAME,
		<cfif isdefined("it_asset")>IT_ASSET,</cfif>
		<cfif isdefined("motorized_vehicle")>MOTORIZED_VEHICLE,</cfif>
		<cfif isdefined("physical_asset")>PHYSICAL_ASSET,</cfif>
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.brand_name#">,
		<cfif isdefined("it_asset")>1,</cfif>
		<cfif isdefined("motorized_vehicle")>1,</cfif>
		<cfif isdefined("physical_asset")>1,</cfif>
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.upd_brand&brand_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
