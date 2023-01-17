<!--- get_zone.cfm --->
<cfquery name="GET_ZONE" datasource="#dsn#">
	SELECT 
		ZONE_ID, 
		ZONE_NAME 
	FROM 
		ZONE
</cfquery>
