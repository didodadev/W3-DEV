<cfquery name="get_rival" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_RIVALS
	WHERE
		R_ID = #attributes.R_ID#
</cfquery>
