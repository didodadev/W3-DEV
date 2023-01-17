<cfquery name="GET_SPECT" datasource="#dsn3#">
	SELECT
		*
	FROM
		SPECTS
	WHERE
		SPECT_VAR_ID = #attributes.spect_var_id#
</cfquery>
