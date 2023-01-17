<cfquery name="get_standby" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITIONS_STANDBY
	WHERE
		SB_ID = #attributes.sb_id#
</cfquery>
