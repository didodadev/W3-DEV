<cfquery name="get_shift" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_SHIFTS
	WHERE
		SHIFT_ID = #attributes.SHIFT_ID#
</cfquery>
