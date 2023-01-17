<cfquery name="GET_PRICE_CAT_ID" datasource="#DSN3#">
	SELECT
		PRICE_CATID,
		PRICE_CAT
	FROM
		PRICE_CAT
	WHERE
		BRANCH LIKE '%,#attributes.branch_id#,%'
</cfquery>

