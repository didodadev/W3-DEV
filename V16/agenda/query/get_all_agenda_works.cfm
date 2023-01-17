<cfquery name="get_all_agenda_works" datasource="#dsn#">
	SELECT 
		WORK_ID,
		TARGET_START,
		TARGET_FINISH,
		WORK_HEAD,
		PROJECT_ID
	FROM 
		PRO_WORKS
	WHERE
		WORK_CURRENCY_ID <> 3 AND
		WORK_STATUS = 1 AND
		PROJECT_EMP_ID = <cfif isDefined("session.agenda_userid")>#session.agenda_userid#<cfelse>#session.ep.userid#</cfif> AND
		(
			(TARGET_START >= #attributes.to_day# AND TARGET_START < #DATEADD("#add_format_#",1,attributes.to_day)#) OR
			(TARGET_FINISH >= #attributes.to_day# AND TARGET_FINISH < #DATEADD("#add_format_#",1,attributes.to_day)#)
		)
</cfquery>
