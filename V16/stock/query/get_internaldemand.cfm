<cfquery name="get_internaldemand" datasource="#dsn3#">
	SELECT
		PROJECT_ID,
		REF_NO,
		DEPARTMENT_IN,
		LOCATION_IN,
		DEPARTMENT_OUT,
		LOCATION_OUT,
		SHIP_METHOD,
		NOTES
		
	FROM
		INTERNALDEMAND
	WHERE
		INTERNAL_ID = #attributes.ship_id#

</cfquery>
