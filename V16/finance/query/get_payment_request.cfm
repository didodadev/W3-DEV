<cfquery name="get_payment_request" datasource="#DSN#">
	SELECT 
		*
	FROM 
		CORRESPONDENCE_PAYMENT
		<cfif isdefined('attributes.id')>
	WHERE
		ID = #URL.ID#
		<cfelse>
	WHERE
		ID NOT IN
		(	
			SELECT 
				PAY_REQUEST_ID
			FROM
				PAYMENT_ORDERS
			WHERE
				PAY_REQUEST_ID IS NOT NULL
		) 
		</cfif>	
</cfquery>
