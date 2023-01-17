<cfquery name="get_active_shifts" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_SHIFTS
	WHERE
		STARTDATE <= #NOW()# AND
		FINISHDATE >= #NOW()#		
</cfquery>
