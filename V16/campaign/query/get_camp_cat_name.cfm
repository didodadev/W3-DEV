<cfquery name="get_camp_cat_name" datasource="#dsn3#">
	SELECT
		CAMP_CAT_NAME
	FROM
		CAMPAIGN_CATS
	WHERE
		CAMP_CAT_ID = #attributes.CAMP_CAT_ID#
</cfquery>
