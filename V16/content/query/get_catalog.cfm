<cfquery name="GET_CATALOG" datasource="#dsn3#">
	SELECT
		CATALOG_HEAD
	FROM
		CATALOG
	WHERE
	<cfif isdefined("url.catalog_promotion_id")>
		CATALOG_PROMOTION_ID = #URL.CATALOG_PROMOTION_ID#
	<cfelseif isdefined("url.catalog_standard_id")>
		CATALOG_STANDARD_ID = #URL.CATALOG_STANDARD_ID#
	</cfif>
</cfquery>
