<cfquery name="GET_PARTNER_SUPPORT" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_SUPPORT,
		#dsn_alias#.SETUP_SUPPORT AS SETUP_SUPPORT
	WHERE
		SERVICE_SUPPORT.SUPPORT_CAT_ID = SETUP_SUPPORT.SUPPORT_CAT_ID
		AND		
		(
		<cfif not GET_SERVICE_DETAIL.SERVICE_PARTNER_ID is ''>
		SERVICE_SUPPORT.SALES_PARTNER_ID=#GET_SERVICE_DETAIL.SERVICE_PARTNER_ID#
		OR
		</cfif>
		SERVICE_SUPPORT.SERVICE_PARTNER_ID=#GET_SERVICE_DETAIL.SERVICE_PARTNER_ID#
		)
</cfquery>
