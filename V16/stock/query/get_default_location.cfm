<cfquery name="get_loc" datasource="#DSN#">
	SELECT  LOCATION_ID,COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID=#search_dep_id# AND PRIORITY = 1
</cfquery>

