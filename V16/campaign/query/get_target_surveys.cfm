<cfquery name="TARGET_SURVEYS" datasource="#dsn3#">
	SELECT
		*
	FROM
		TARGET_SURVEYS
	WHERE
		TMARKET_ID = #attributes.tmarket_id#
</cfquery>
