<cfquery name="DAILY_WORKS" datasource="#dsn#">
	SELECT 
		WORK_ID,
		TARGET_START,
		TARGET_FINISH,
		WORK_HEAD,
		PROJECT_ID
	FROM 
		PRO_WORKS
	WHERE
		WORK_CURRENCY_ID <> 3
		AND
		WORK_STATUS = 1
		AND
		(
	<cfif isDefined("SESSION.AGENDA_POSITION_CODE")>
		PROJECT_EMP_ID = #SESSION.AGENDA_POSITION_CODE#
	<cfelse>
		PROJECT_EMP_ID = #SESSION.pda.userid#
	</cfif>
		OR
	<cfif isDefined("SESSION.AGENDA_USERID")>
		RECORD_AUTHOR = #SESSION.AGENDA_USERID#
		OR
		UPDATE_AUTHOR = #SESSION.AGENDA_USERID#
	<cfelse>
		RECORD_AUTHOR = #SESSION.pda.USERID#
		OR
		RECORD_AUTHOR = #SESSION.pda.USERID#
	</cfif>
		)
		AND
		(
		 <!--- (
		 	REAL_START >= #attributes.to_day#
		  	AND
		 	REAL_START < #DATEADD("D",1,attributes.to_day)#
		 ) 
		 OR
		 (
		 	REAL_FINISH >= #attributes.to_day#
		  	AND
			REAL_FINISH < #DATEADD("D",1,attributes.to_day)#
		 )
		 OR --->
		 (
		 	TARGET_START >= #attributes.to_day#
		  	AND
		 	TARGET_START < #DATEADD("D",1,attributes.to_day)#
		 ) 
		 OR
		 (
		 	TARGET_FINISH >= #attributes.to_day#
		  	AND
			TARGET_FINISH < #DATEADD("D",1,attributes.to_day)#
		 )
		)
</cfquery>
