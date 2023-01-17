<cfquery name="UPD_BRAND_TYPE" datasource="#DSN#">
	UPDATE 
		SETUP_IT_WORKGROUP_TYPE
	SET
		WORKGROUP_TYPE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.workgroup_type_name_#">,
		INTERNAL_GROUP = <cfif isDefined('attributes.internal_group')>1<cfelse>0</cfif>,
		EXTERNAL_GROUP = <cfif isDefined('attributes.external_group')>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE  
		WORKGROUP_TYPE_ID = #attributes.workgroup_type_id_#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_it_workgroup_type" addtoken="no">
