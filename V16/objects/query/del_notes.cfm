<cfquery name="DEL_NOTES" datasource="#DSN#">
	DELETE FROM
		NOTES
	WHERE
		ACTION_SECTION = '#UCASE(attributes.ACTION_SECTION)#' AND
		ACTION_ID = #attributes.ACTION_ID#
</cfquery>
