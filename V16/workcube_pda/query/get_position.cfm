<cfquery name="GET_POSITION" datasource="#dsn#">
	SELECT
		POSITION_CODE,
		POSITION_NAME,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_EMAIL
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_STATUS = 1
	<cfif isDefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
		AND
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	</cfif>
	<cfif isDefined("attributes.POSITION_CODE") and len(attributes.POSITION_CODE)>
		AND
		POSITION_CODE = #attributes.POSITION_CODE#
	</cfif>
</cfquery>
