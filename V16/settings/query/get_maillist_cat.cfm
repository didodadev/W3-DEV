<cfquery name="MAILLIST_CAT" datasource="#dsn#">
	SELECT
		*
	FROM
		MAILLIST_CAT
	WHERE
		MAILLIST_CAT_ID = #attributes.MAILLIST_CAT_ID#
</cfquery>

