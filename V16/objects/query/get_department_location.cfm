<cfquery name="get_department_location" datasource="#dsn#">
	SELECT
		COMMENT
	FROM
		STOCKS_LOCATION
	WHERE
	<cfif isDefined("attributes.DEPARTMENT_LOCATION") and Len(attributes.DEPARTMENT_LOCATION)>
		DEPARTMENT_LOCATION = '#attributes.DEPARTMENT_LOCATION#'
	<cfelse>
		DEPARTMENT_ID = #attributes.department_id#
		AND LOCATION_ID = #attributes.location_id#
	</cfif>
</cfquery>
