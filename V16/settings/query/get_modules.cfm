<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT 
		SOLUTION,
        FAMILY,
        MODULE,
        MODUL_NO,
        MODULE_TYPE
	FROM 
		MODULES
	ORDER BY
		SOLUTION,
        FAMILY,
        MODULE
</cfquery>
