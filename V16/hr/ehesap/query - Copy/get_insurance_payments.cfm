<cfquery name="get_insurance_payments" datasource="#dsn#">
	SELECT
		*
	FROM
		INSURANCE_PAYMENT
	ORDER BY
		FINISHDATE DESC
</cfquery>
