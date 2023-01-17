<cfquery name="GET_POSITION" datasource="#DSN#">
	SELECT
		EMPLOYEE_ID,
		POSITION_CODE,
		POSITION_NAME,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_EMAIL
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_STATUS = 1
		<cfif isDefined("attributes.employee_id") and len(attributes.employee_id)>
            AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
        </cfif>
        <cfif isDefined("attributes.position_code") and len(attributes.position_code)>
            AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
        </cfif>
</cfquery>
