<cfquery name="CATALOG_PROMOTIONS" datasource="#dsn3#">
	SELECT
		CATALOG_ID,
		CATALOG_HEAD,
		STAGE_ID
	FROM
		CATALOG_PROMOTION
	WHERE
		CAMP_ID = #CAMP_ID#
</cfquery>
