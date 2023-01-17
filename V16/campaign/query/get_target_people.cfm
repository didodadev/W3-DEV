<cfquery name="GET_TARGET_PEOPLE" datasource="#dsn3#">
	SELECT
		*
	FROM
		CAMPAIGN_TARGET_PEOPLE
	WHERE
		CAMPAIGN_TARGET_PEOPLE.CAMP_ID = #attributes.CAMP_ID#
	<cfif isDefined("attributes.TMARKET_ID")>
	AND (
		CAMPAIGN_TARGET_PEOPLE.TMARKET_ID = #attributes.TMARKET_ID#
		<cfif attributes.TMARKET_ID eq 0>
		OR CAMPAIGN_TARGET_PEOPLE.TMARKET_ID IS NULL
		</cfif>
		)
	</cfif>
</cfquery>
