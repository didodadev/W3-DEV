<cfquery name="STORES" datasource="#dsn#">
	SELECT
		*
	FROM
		DEPARTMENT
	WHERE 
		IS_STORE <> 2
		AND DEPARTMENT_STATUS = 1
</cfquery>	

