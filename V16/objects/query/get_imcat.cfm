<cfquery name="GET_IMCAT" datasource="#DSN#">
	SELECT 
		IMCAT 
	FROM 
		SETUP_IM 
	WHERE 
		IMCAT_ID = #attributes.imcat_id#
</cfquery>
