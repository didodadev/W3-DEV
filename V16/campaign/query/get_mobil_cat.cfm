<cfquery name="GET_MOBIL_CAT" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_MOBILCAT 
	WHERE 
		MOBILCAT_ID = #attributes.MOBILCAT_ID#
</cfquery>
