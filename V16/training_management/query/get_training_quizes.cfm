<!--- <cfinclude template="../query/get_class.cfm"> --->
<cfquery name="get_trainers" datasource="#dsn#">
	SELECT EMP_ID FROM TRAINING_CLASS_TRAINERS
</cfquery>
<cfquery name="GET_QUIZ" datasource="#DSN#">
	SELECT
		DISTINCT
		EQU.QUIZ_ID,
		EQU.QUIZ_HEAD
		<cfif not isdefined("attributes.class_ids")>
		,TCQ.TRAINING_QUIZ_ID
		</cfif>
	FROM
		TRAINING_CLASS_QUIZES TCQ,
		EMPLOYEE_QUIZ EQU 
	WHERE
		EQU.QUIZ_ID=TCQ.QUIZ_ID
	<cfif isdefined("attributes.class_ids")>
		AND TCQ.CLASS_ID IN (#attributes.class_ids#)
	<cfelse>
		AND TCQ.CLASS_ID=#attributes.class_id#
	</cfif>
	 <!--- <cfif get_class.recordcount><!--- Eğer sisteme giren eğitimci ise eğitimci için oluşturulmuş formları göremez.. --->
		<cfif (get_class.TRAINER_EMP eq session.ep.userid)>
			AND  EQU.IS_EDUCATION=1
		</cfif>
	</cfif>	  --->
</cfquery>
