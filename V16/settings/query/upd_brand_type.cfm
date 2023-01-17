<cfquery name="UPD_BRAND_TYPE" datasource="#DSN#">
	UPDATE 
		SETUP_BRAND_TYPE
	SET
		BRAND_TYPE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.brand_type_name#">,
		BRAND_ID = #attributes.brand_id#,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE  
		BRAND_TYPE_ID = #attributes.brand_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.upd_brand_type&brand_type_id=#attributes.brand_type_id#" addtoken="no">
