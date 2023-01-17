<cfquery name="get_rivals" datasource="#dsn#">
	SELECT
		R_ID,
		RIVAL_NAME
	FROM
		SETUP_RIVALS
	ORDER BY
		RIVAL_NAME
</cfquery>
