<cfquery name="GET_PAYMENT_REQUEST" datasource="#DSN#">
	SELECT 
		*
	FROM 
		CORRESPONDENCE_PAYMENT
	<cfif isdefined('attributes.id') >
		WHERE
			ID=#url.id#
	</cfif>	
</cfquery>
