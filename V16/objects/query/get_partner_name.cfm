<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		PARTNER_ID 
	FROM 
		COMPANY_PARTNER 
	WHERE 
		<!---COMPBRANCH_ID = #attributes.PARTNER_ID#--->
		<cfif isdefined("attributes.PARTNER_ID")>
		   PARTNER_ID = #attributes.PARTNER_ID#
		<cfelseif isdefined("attributes.branch_id")>
		   COMPBRANCH_ID = #attributes.branch_id#
		</cfif>
</cfquery>
