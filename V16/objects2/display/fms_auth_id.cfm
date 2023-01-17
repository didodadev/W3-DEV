<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.workcube_id') and len(attributes.workcube_id) and isdefined('attributes.user_type_id') and len(attributes.user_type_id)>
	<cfquery name="getControlWorkcubeID" datasource="#dsn#">
		SELECT WORKCUBE_ID FROM WRK_SESSION WHERE WORKCUBE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.workcube_id#"> AND USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.user_type_id#">
	</cfquery>
	<cfif getControlWorkcubeID.recordcount>
		<cfoutput>[FMS_AUTH_ID=#fms_auth_id#]</cfoutput>
	</cfif>
</cfif>
