<cfquery name="GET_DAILY_CLASSES" datasource="#dsn#">
	SELECT 
		TRAINING_CLASS.TRAINING_SEC_ID,
		TRAINING_CLASS.TRAINING_ID,
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.CLASS_OBJECTIVE,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS.ONLINE,
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.EMP_ID,
		TRAINING_CLASS_ATTENDER.PAR_ID,
		TRAINING_CLASS_ATTENDER.CON_ID,
		TRAINING_CLASS_ATTENDER.GRP_ID
	FROM 
		TRAINING_CLASS ,
		TRAINING_CLASS_ATTENDER 
	WHERE
		 TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_ATTENDER.CLASS_ID
		 <!---<cfif isDefined("SESSION.AGENDA_USER_ID")>--->
		<cfif isDefined("session.agenda_userid")>
			<!--- baskasinda --->
			<cfif session.agenda_user_type is "e">
				<!--- emp --->
				AND TRAINING_CLASS_ATTENDER.EMP_ID = #session.agenda_userid#
			<cfelseif session.agenda_user_type is "p">
				AND TRAINING_CLASS_ATTENDER.PAR_ID = #session.agenda_userid#
			<cfelseif session.agenda_user_type is "c">
				AND TRAINING_CLASS_ATTENDER.CON_ID = #session.agenda_userid#
			</cfif>
		<cfelse>
			<!--- kendinde --->
				AND TRAINING_CLASS_ATTENDER.EMP_ID = #session.pda.userid#
		</cfif>
		 AND
		(
			(
			TRAINING_CLASS.START_DATE >= #attributes.to_day# AND
			TRAINING_CLASS.START_DATE < #DATEADD("D",1,attributes.to_day)#
			)
			OR
			(
			TRAINING_CLASS.FINISH_DATE >= #attributes.to_day# AND
			TRAINING_CLASS.FINISH_DATE < #DATEADD("D",1,attributes.to_day)#
			) 
		)
</cfquery> 
