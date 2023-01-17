<cfquery name="GET_MOBILE_CAT" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MOBILCAT
	WHERE
		MOBILCAT_ID = #MOBILE_CAT_ID#
</cfquery>
