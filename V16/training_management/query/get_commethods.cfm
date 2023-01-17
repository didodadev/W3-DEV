<cfquery name="GET_COMMETHODS" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_COMMETHOD
		<cfif isdefined("attributes.COMMETHOD_ID")>
	WHERE
		COMMETHOD_ID=#attributes.COMMETHOD_ID#
		</cfif>
	ORDER BY
		COMMETHOD
</cfquery>
