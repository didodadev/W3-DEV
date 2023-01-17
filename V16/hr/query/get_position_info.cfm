<cfquery name="get_position_info" datasource="#dsn#">
	SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #attributes.pos_code#
</cfquery>

