<cfquery name="get_zimmet" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEES_INVENT_ZIMMET
	WHERE
		ZIMMET_ID=#attributes.ZIMMET_ID#
</cfquery>
