<cfif isdefined("url.pid")>
	<cfquery name="GET_PRODUCT" datasource="#dsn3#">
		SELECT
			PRODUCT_NAME
		FROM
			PRODUCT
		WHERE
			PRODUCT_ID = #URL.PID#
	</cfquery>
</cfif>
