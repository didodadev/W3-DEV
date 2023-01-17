<cfquery name="GET_PRO_CODE" datasource="#dsn3#">
	SELECT
		*
	FROM
		STOCKS
	WHERE
		PRODUCT_ID=#PRO_ID#
	AND
		PRODUCT_CODE = '#SERIAL_NO#'
</cfquery>
