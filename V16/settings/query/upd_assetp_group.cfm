<cfquery name="UPD_ASSETP_GROUP" datasource="#DSN#">
	UPDATE 
		SETUP_ASSETP_GROUP
	SET
		GROUP_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.assetp_group#">,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		ASSETP_RESERVE = <cfif isdefined("attributes.assetp_reserve")>1<cfelse>0</cfif>,
		IT_ASSET = <cfif isdefined("attributes.it_asset")>1<cfelse>0</cfif>,
		MOTORIZED_VEHICLE = <cfif isdefined("attributes.motorized_vehicle")>1<cfelse>0</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		GROUP_ID = #attributes.assetp_group_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_assetp_group" addtoken="no">
