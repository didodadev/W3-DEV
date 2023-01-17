<cfquery name="CAMPAIGN" datasource="#dsn3#">
	SELECT
		*
	FROM
		CAMPAIGNS
	WHERE
		CAMP_STATUS = 1
		AND CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CAMP_ID#">
</cfquery>
