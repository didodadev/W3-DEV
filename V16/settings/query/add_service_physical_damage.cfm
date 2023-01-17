<cfquery name="INS_PHYSICAL_DAMAGE" datasource="#DSN3#">
	INSERT INTO 
		SERVICE_PHYSICAL_DAMAGE
		(
			PHYSICAL_DAMAGE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
	VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.physical_damage_name#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
	SELECT @@IDENTITY AS MAX_PHYSICAL_DAMAGE
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_service_physical_damage&phy_id=#ins_physical_damage.max_physical_damage#" addtoken="no">
