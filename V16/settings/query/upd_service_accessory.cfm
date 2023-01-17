<cfif isdefined("attributes.del") and attributes.del eq 1>
	<cfquery name="DEL_ACCESSORY" datasource="#DSN3#">
		DELETE FROM SERVICE_ACCESSORY WHERE ACCESSORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_id#">  
	</cfquery>
	<cflocation url="#request.self#?fuseaction=settings.form_add_service_accessory" addtoken="no">
<cfelse>
	<cfquery name="UPD_ACCESSORY" datasource="#DSN3#">
		UPDATE 
			SERVICE_ACCESSORY
		SET	
			ACCESSORY= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.accessory_name#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			ACCESSORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_id#"> 
	</cfquery>
	<cflocation url="#request.self#?fuseaction=settings.form_upd_service_accessory&acc_id=#attributes.acc_id#" addtoken="no">
</cfif>
