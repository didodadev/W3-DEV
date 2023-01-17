<cfquery name="UPD_BRAND" datasource="#DSN#">
	UPDATE 
		SETUP_BRAND
	SET 
		BRAND_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.brand_name#">,
		<cfif isdefined("it_asset")>IT_ASSET = 1,<cfelse>IT_ASSET = 0,</cfif>
		<cfif isdefined("motorized_vehicle")>MOTORIZED_VEHICLE = 1,<cfelse>MOTORIZED_VEHICLE = 0,</cfif>
		<cfif isdefined("physical_asset")>PHYSICAL_ASSET = 1,<cfelse>PHYSICAL_ASSET = 0,</cfif>		
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE 
		BRAND_ID = #attributes.brand_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.upd_brand&brand_id=#attributes.brand_id#" addtoken="no">
