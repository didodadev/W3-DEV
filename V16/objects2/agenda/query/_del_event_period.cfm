<!--- olay rezervasyonları sil --->
<cfquery name="DEL_EVENT_RESERVATIONS" datasource="#dsn#">
	DELETE FROM
		ASSET_P_RESERVE
	WHERE
		EVENT_ID IN 
					(
					SELECT
						EVENT_ID
					FROM
						EVENT
					WHERE
						EVENT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EVENT_ID#">
						AND
						LINK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LINK_ID#">
					)
</cfquery>	

<!--- olayları sil --->
<cfquery name="DEL_EVENTS" datasource="#dsn#">
	DELETE FROM
		EVENT
	WHERE
		EVENT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EVENT_ID#">
		AND
		LINK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LINK_ID#">
</cfquery>
