<cfif len(attributes.empo_id)>
	<cfquery name="GET_DELIVERED_EMP" datasource="#dsn#">
		SELECT 
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			POSITION_ID,
			POSITION_STATUS
		FROM 
			EMPLOYEE_POSITIONS
		WHERE 
			POSITION_STATUS=1
		AND 
			EMPLOYEE_ID = #attributes.empo_id#
	</cfquery>
</cfif>

