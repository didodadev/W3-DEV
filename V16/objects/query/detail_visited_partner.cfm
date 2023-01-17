<cfquery name="DETAIL_VISITED_PARTNER" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		COMPANY_PARTNER 
	WHERE 
		PARTNER_ID = #NOTE_GIVEN_ID#
</cfquery>
