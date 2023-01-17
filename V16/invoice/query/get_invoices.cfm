<cfquery name="get_payments" datasource="#DSN2#">
	SELECT
		*
	FROM
		INVOICE
	WHERE
		PAY_METHOD IS NOT NULL
	AND
		IS_CASH=0
		<cfif isdefined('attributes.type') and LEN(attributes.type) >
	AND
		PURCHASE_SALES =#attributes.type#
		</cfif>
		<cfif isdefined("attributes.keyword") and LEN(attributes.keyword)>
	AND
		INVOICE_NUMBER LIKE '%#attributes.keyword#%'
		</cfif>
</cfquery>

