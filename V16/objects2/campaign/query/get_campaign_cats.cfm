<cfquery name="GET_CAMPAIGN_CATS" datasource="#DSN3#">
	SELECT
		CAMP_CAT_ID,
		CAMP_CAT_NAME
	FROM
		CAMPAIGN_CATS
</cfquery>
