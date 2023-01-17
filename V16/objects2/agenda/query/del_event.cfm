<!--- OLAY REZERVASYONLARý SIL --->
<cfquery name="DEL_EVENT_RESERVATIONS" datasource="#DSN#">
	DELETE FROM
		ASSET_P_RESERVE
	WHERE
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<!--- OLAY SIL --->
<cfquery name="DEL_EVENT_RESERVATIONS" datasource="#DSN#">
	DELETE FROM
		EVENT
	WHERE
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.view_daily" addtoken="no">




