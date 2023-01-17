<cfquery name="GET_LOCATION" datasource="#DSN#">
	SELECT
		SL.*,
		D.DEPARTMENT_HEAD
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D
	WHERE
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID
	<cfif isDefined('attributes.department') and len(attributes.department)>
		AND SL.DEPARTMENT_ID = #attributes.department#
	</cfif>
	ORDER BY
		D.DEPARTMENT_HEAD
</cfquery>
