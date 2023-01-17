<cfquery datasource="#DSN#" name="get_healty_report">
	SELECT 
		* 
	FROM 
		EMPLOYEE_HEALTY_REPORT 
	WHERE 
		HEALTY_REPORT_ID= #attributes.HEALTY_REPORT_ID#
</cfquery>
