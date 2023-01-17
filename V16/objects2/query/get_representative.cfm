<cfquery name="GET_REPRESENTATIVE" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS.POSITION_CODE, 
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME, 
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME 
	FROM
		WORKGROUP_EMP_PAR WEP,
		EMPLOYEE_POSITIONS
	WHERE
		WEP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		EMPLOYEE_POSITIONS.POSITION_CODE = WEP.POSITION_CODE AND
		WEP.IS_MASTER = 1 AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1
</cfquery>

