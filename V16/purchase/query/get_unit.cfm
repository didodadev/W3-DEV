<!--- get_unit.cfm --->
<cfquery name="GET_UNIT" datasource="#dsn#">
	SELECT 
		UNIT,
		UNIT_ID 
	FROM 
		SETUP_UNIT
</cfquery>
