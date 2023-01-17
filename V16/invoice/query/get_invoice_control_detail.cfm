<cfquery name="GET_INVOICE_CONTROL" datasource="#DSN2#">
	SELECT
		*
	FROM
		INVOICE_CONTROL
	WHERE
		<cfif isdefined("attributes.invoice_id")>
			INVOICE_ID = #attributes.invoice_id#
		<cfelse>
			INVOICE_CONTROL_ID IN (#attributes.INVOICE_CONTROL_ID#)
		</cfif>
</cfquery>
