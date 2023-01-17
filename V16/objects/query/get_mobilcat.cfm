<cfquery name="GET_MOBILCAT" datasource="#dsn#">
	SELECT 
		*
	FROM 
		SETUP_MOBILCAT 
	<cfif isdefined("attributes.MOBILCAT_ID")>
	WHERE 
		MOBILCAT_ID = #attributes.MOBILCAT_ID#
	</cfif>
</cfquery>
