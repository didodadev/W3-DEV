<cfquery name="GET_IM" datasource="#DSN#">
	SELECT 
		IMCAT_ID, 
		IMCAT 
	FROM 
		SETUP_IM
</cfquery>
