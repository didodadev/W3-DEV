<cfquery name="get_day_daily_offtimes" datasource="#dsn#">
	SELECT 
		*
	FROM 
		SETUP_GENERAL_OFFTIMES
	WHERE
		START_DATE <= #tarih# AND
		FINISH_DATE >= #tarih#		
</cfquery>
