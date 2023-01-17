<cfquery name="GET_RELATIVES_HEALTY" datasource="#DSN#">
  SELECT
  	*
  FROM
 	EMPLOYEES_RELATIVE_HEALTY
  WHERE
	EMP_ID = #attributes.employee_id#
</cfquery>	

