<cfquery name="GET_COMMETHOD" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_COMMETHOD
	WHERE
		COMMETHOD_ID = #ATTRIBUTES.COMMETHOD_ID#
</cfquery>
