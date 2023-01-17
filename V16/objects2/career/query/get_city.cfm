<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
