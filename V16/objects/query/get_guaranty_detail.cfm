<cfquery name="GET_GUARANTY_DETAIL" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_GUARANTY_NEW
	WHERE
		GUARANTY_ID=#URL.ID#
</cfquery>
