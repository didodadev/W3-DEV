<cfquery name="get_insurance_payment" datasource="#dsn#">
	SELECT
		*
	FROM
		INSURANCE_PAYMENT
	WHERE
		INS_PAY_ID = #attributes.INS_PAY_ID#
</cfquery>
