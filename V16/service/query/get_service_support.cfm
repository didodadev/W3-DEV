<cfquery name="GET_SERVICE_SUPPORT" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_SUPPORT,
		#dsn_alias#.SETUP_SUPPORT AS SETUP_SUPPORT
	WHERE
		SERVICE_SUPPORT.SUPPORT_CAT_ID = SETUP_SUPPORT.SUPPORT_CAT_ID
		AND
		(
		<cfif not GET_SERVICE_DETAIL.SERVICE_CONSUMER_ID is ''>
		SERVICE_SUPPORT.SALES_CONSUMER_ID=#GET_SERVICE_DETAIL.SERVICE_CONSUMER_ID#
		OR
		</cfif>
		SERVICE_SUPPORT.SERVICE_CONSUMER_ID=#GET_SERVICE_DETAIL.SERVICE_CONSUMER_ID#
		)
</cfquery>
