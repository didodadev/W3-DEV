<cfquery name="COMPANY_DISCOUNT" datasource="#dsn#">
	SELECT
		DISCOUNT
	FROM
		COMPANY
	WHERE
		COMPANY_ID = #COMPANY_ID#
</cfquery>
