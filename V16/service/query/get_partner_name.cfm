<cfquery name="GET_PARTNER_name" datasource="#dsn#">
	SELECT
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME,
		C.FULLNAME
	FROM
		COMPANY_PARTNER CP,
		COMPANY C
	WHERE
		CP.PARTNER_ID = #attributes.PARTNER_ID# AND
		C.COMPANY_ID = CP.COMPANY_ID
</cfquery>
