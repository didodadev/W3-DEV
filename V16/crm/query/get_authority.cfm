<cfquery name="GET_AUTHORITY" datasource="#dsn#">
	SELECT
		AUTHORITY_ID,
		AUTHORITY_NAME 
	FROM
		SETUP_PURCHASE_AUTHORITY
	<cfif isdefined("attributes.purchase_authority_id")>
	WHERE
		AUTHORITY_ID = #attributes.purchase_authority_id#
	</cfif>	
	ORDER BY 
		AUTHORITY_ID
</cfquery>
