<cfquery datasource="#DSN3#" name="GET_PRO">
	SELECT
		STOCK_ID,PROPERTY
	FROM
		STOCKS
	WHERE
		PRODUCT_ID=#attributes.PID#
</cfquery>
