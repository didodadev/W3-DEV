<cfquery name="get_day_daily_offtimes" datasource="#DSN#">
	SELECT 
		*
	FROM 
		SETUP_GENERAL_OFFTIMES
	WHERE
		START_DATE <= #attributes.to_day# AND
		FINISH_DATE >= #DATEADD('D',1,attributes.TO_DAY)#	
</cfquery>
