<cfquery name="GET_WEEK_EVENTS" datasource="#dsn#">
	SELECT DISTINCT
			EVENT_ID,
			STARTDATE,
			FINISHDATE,
			EVENTCAT,
			VALID,
			RECORD_PAR,
			UPDATE_PAR,
			EVENT_HEAD
	FROM 
			EVENT,
			EVENT_CAT
	WHERE
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND
		(
			( STARTDATE >= #attributes.TO_DAY# AND STARTDATE < #DATEADD('ww',1,attributes.TO_DAY)# )
		OR
			( FINISHDATE >= #attributes.TO_DAY# AND FINISHDATE < #DATEADD('ww',1,attributes.TO_DAY)# )
		) 
<!--- 		OR
		EVENT.VIEW_TO_ALL = 1 --->
</cfquery>
