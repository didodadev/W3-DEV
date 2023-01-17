<cfif isdefined("attributes.del") and attributes.del eq 1> 
	<cfquery name="DEL_PHYSICAL_DAMAGE" datasource="#DSN3#">
		DELETE FROM	SERVICE_PHYSICAL_DAMAGE	WHERE PHYSICAL_DAMAGE_ID = #attributes.phy_id#
	</cfquery>
	<cflocation url="#request.self#?fuseaction=settings.form_add_service_physical_damage" addtoken="no">
<cfelse>
	<cfquery name="INS_PHYSICAL_DAMAGE" datasource="#DSN3#">
		UPDATE  
			SERVICE_PHYSICAL_DAMAGE
		SET
			PHYSICAL_DAMAGE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.physical_damage_name#">,
			UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE 
			PHYSICAL_DAMAGE_ID = #attributes.phy_id#
	</cfquery>
	<cflocation url="#request.self#?fuseaction=settings.form_upd_service_physical_damage&phy_id=#attributes.phy_id#" addtoken="no">
</cfif>
