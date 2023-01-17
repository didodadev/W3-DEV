<CF_DATE TARIH="FORM.QUIZ_STARTDATE">
<CF_DATE TARIH="FORM.QUIZ_FINISHDATE">
<cfset FORM.QUIZ_STARTDATE = date_add('h',attributes.event_start_clock - session.ep.time_zone,FORM.QUIZ_STARTDATE)>
<cfset FORM.QUIZ_STARTDATE = date_add('n',attributes.event_start_minute,FORM.QUIZ_STARTDATE)>
<cfset FORM.QUIZ_FINISHDATE = date_add('h',attributes.event_finish_clock - session.ep.time_zone,FORM.QUIZ_FINISHDATE)>
<cfset FORM.QUIZ_FINISHDATE = date_add('n',attributes.event_finish_minute,FORM.QUIZ_FINISHDATE)>
<cfparam name="attributes.class_id" default="">
<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset add_quiz=cfc.ADD_QUIZ_FUNC(	
	QUIZ_STARTDATE:form.QUIZ_STARTDATE,
	QUIZ_FINISHDATE:form.QUIZ_FINISHDATE,
	process_stage:iif(len(process_stage),"attributes.process_stage",DE("")),
	SCORE1:iif(len(attributes.SCORE1),"attributes.SCORE1",DE("")),
	SCORE2:iif(len(attributes.SCORE2),"attributes.SCORE2",DE("")),
	SCORE3:iif(len(attributes.SCORE3),"attributes.SCORE3",DE("")),
	SCORE4:iif(len(attributes.SCORE4),"attributes.SCORE4",DE("")),
	SCORE5:iif(len(attributes.SCORE5),"attributes.SCORE5",DE("")),
	class_id:iif(isdefined(attributes.class_id & len(attributes.class_id)),"attributes.class_id",DE("")),
	COMMENT1:iif(len(attributes.COMMENT1),"attributes.COMMENT1",DE("")),
	COMMENT2:iif(len(attributes.COMMENT2),"attributes.COMMENT2",DE("")),
	COMMENT3:iif(len(attributes.COMMENT3),"attributes.COMMENT3",DE("")),
	COMMENT4:iif(len(attributes.COMMENT4),"attributes.COMMENT4",DE("")),
	COMMENT5:iif(len(attributes.COMMENT5),"attributes.COMMENT5",DE("")),
	QUIZ_PARTNERS:iif(isdefined("form.QUIZ_PARTNERS"),"form.QUIZ_PARTNERS",DE("")),
	QUIZ_CONSUMERS:iif(isdefined("form.QUIZ_CONSUMERS"),"form.QUIZ_CONSUMERS",DE("")),
	QUIZ_DEPARTMENTS:iif(isdefined("form.QUIZ_DEPARTMENTS"),"form.QUIZ_DEPARTMENTS",DE("")),
	QUIZ_POSITION_CATS:iif(isdefined("form.QUIZ_POSITION_CATS"),"form.QUIZ_POSITION_CATS",DE("")),
	QUIZ_OBJECTIVE:iif(isdefined("attributes.QUIZ_OBJECTIVE"),"attributes.QUIZ_OBJECTIVE",DE("")),
	TRAINING_SEC_ID:attributes.TRAINING_SEC_ID,
	TRAINING_CAT_ID:attributes.TRAINING_CAT_ID,
	TRAINING_ID:attributes.TRAINING_ID,
	QUIZ_AVERAGE:iif(isdefined("attributes.QUIZ_AVERAGE"),"attributes.QUIZ_AVERAGE",DE("")),
	TAKE_LIMIT:iif(isdefined("attributes.TAKE_LIMIT"),"attributes.TAKE_LIMIT",DE("")),
	TOTAL_TIME:iif((TIMING_STYLE EQ 1),"attributes.TOTAL_TIME",DE("")),
	TOTAL_POINTS:iif((GRADE_STYLE EQ 1),"attributes.TOTAL_POINTS",DE("")),
	TIMING_STYLE:iif(isdefined("attributes.TIMING_STYLE"),"attributes.TIMING_STYLE",DE("")),
	GRADE_STYLE:iif(isdefined("attributes.GRADE_STYLE"),"attributes.GRADE_STYLE",DE("")),
	QUIZ_HEAD:iif(isdefined("attributes.QUIZ_HEAD"),"attributes.QUIZ_HEAD",DE("")),
	QUIZ_TYPE:iif(isdefined("attributes.QUIZ_TYPE"),"attributes.QUIZ_TYPE",DE("")),
	random:iif(isdefined("attributes.random"),"attributes.random",DE("")),
	max_questions:attributes.max_questions
)>
<cfset get_max_quiz=cfc.get_max_quiz()>
<!--- <cfquery name="ADD_QUIZ" datasource="#dsn#">
	INSERT INTO
		QUIZ
	(
		QUIZ_STARTDATE, 
		QUIZ_FINISHDATE, 
		PROCESS_STAGE,
		<cfif len(SCORE1)>SCORE1,</cfif>
		<cfif len(SCORE2)>SCORE2,</cfif>
		<cfif len(SCORE3)>SCORE3,</cfif>
		<cfif len(SCORE4)>SCORE4,</cfif>
		<cfif len(SCORE5)>SCORE5,</cfif>
		<cfif len(COMMENT1)>COMMENT1,</cfif>
		<cfif len(COMMENT2)>COMMENT2,</cfif>
		<cfif len(COMMENT3)>COMMENT3,</cfif>
		<cfif len(COMMENT4)>COMMENT4,</cfif>
		<cfif len(COMMENT5)>COMMENT5,</cfif>
		<cfif isDefined("QUIZ_PARTNERS") and len(QUIZ_PARTNERS)>QUIZ_PARTNERS,</cfif>
		<cfif isDefined("QUIZ_CONSUMERS") and len(QUIZ_CONSUMERS)>QUIZ_CONSUMERS,</cfif>
		<cfif isDefined("QUIZ_DEPARTMENTS") and len(QUIZ_DEPARTMENTS)>QUIZ_DEPARTMENTS,</cfif>
		<cfif isDefined("QUIZ_POSITION_CATS") and len(QUIZ_POSITION_CATS)>QUIZ_POSITION_CATS,</cfif>
		<cfif len(QUIZ_OBJECTIVE)>QUIZ_OBJECTIVE,</cfif>
		TRAINING_SEC_ID, 
		TRAINING_CAT_ID, 
		TRAINING_ID,
		<cfif isdefined("attributes.class_id") and (attributes.class_id neq 0)>CLASS_ID,</cfif>
		QUIZ_AVERAGE,
		TAKE_LIMIT,
		<cfif TIMING_STYLE EQ 1>TOTAL_TIME,</cfif>
		<cfif GRADE_STYLE EQ 1>TOTAL_POINTS,</cfif>
		TIMING_STYLE, 
		GRADE_STYLE, 
		QUIZ_HEAD, 
		QUIZ_TYPE, 
		RANDOM, 
		MAX_QUESTIONS, 
		RECORD_EMP, 
		RECORD_IP
	)
	VALUES
	(
		#FORM.QUIZ_STARTDATE#, 
		#FORM.QUIZ_FINISHDATE#, 
		#attributes.process_stage#,
		<cfif len(SCORE1)>#SCORE1#,</cfif>
		<cfif len(SCORE2)>#SCORE2#,</cfif>
		<cfif len(SCORE3)>#SCORE3#,</cfif>
		<cfif len(SCORE4)>#SCORE4#,</cfif>
		<cfif len(SCORE5)>#SCORE5#,</cfif>
		<cfif len(COMMENT1)>'#COMMENT1#',</cfif>
		<cfif len(COMMENT2)>'#COMMENT2#',</cfif>
		<cfif len(COMMENT3)>'#COMMENT3#',</cfif>
		<cfif len(COMMENT4)>'#COMMENT4#',</cfif>
		<cfif len(COMMENT5 )>'#COMMENT5#', </cfif>
		<cfif isDefined("QUIZ_PARTNERS") and len(QUIZ_PARTNERS)>',#QUIZ_PARTNERS#,',</cfif>
		<cfif isDefined("QUIZ_CONSUMERS") and len(QUIZ_CONSUMERS)>',#QUIZ_CONSUMERS#,',</cfif>
		<cfif isDefined("QUIZ_DEPARTMENTS") and len(QUIZ_DEPARTMENTS)>',#QUIZ_DEPARTMENTS#,', </cfif>
		<cfif isDefined("QUIZ_POSITION_CATS") and len(QUIZ_POSITION_CATS)>',#QUIZ_POSITION_CATS#,',</cfif>
		<cfif len(QUIZ_OBJECTIVE)>'#QUIZ_OBJECTIVE#',</cfif>
		<cfif len(attributes.TRAINING_SEC_ID) and attributes.TRAINING_SEC_ID NEQ 0>#attributes.TRAINING_SEC_ID#,<cfelse>NULL,</cfif>
		<cfif len(attributes.TRAINING_CAT_ID) and attributes.TRAINING_CAT_ID NEQ 0>#attributes.TRAINING_CAT_ID#,<cfelse>NULL,</cfif>
		<cfif len(TRAINING_ID) and TRAINING_ID NEQ 0>#TRAINING_ID#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.class_id") and (attributes.class_id neq 0)>#class_id#,</cfif>
		#FORM.QUIZ_AVERAGE#, 
		#TAKE_LIMIT#, 
		<cfif TIMING_STYLE EQ 1>#FORM.TOTAL_TIME#,</cfif>
		<cfif GRADE_STYLE EQ 1>#TOTAL_POINTS#,</cfif>
		#TIMING_STYLE#, 
		#GRADE_STYLE#, 
		'#QUIZ_HEAD#', 
		#QUIZ_TYPE#, 
		#RANDOM#, 
		#MAX_QUESTIONS#, 
		#SESSION.EP.USERID#, 
		'#CGI.REMOTE_ADDR#'
	)
</cfquery> 
<cfquery name="get_max_quiz" datasource="#dsn#">
	SELECT
		MAX(QUIZ_ID) AS QUIZ_ID
	FROM
		QUIZ
</cfquery>--->
<!--- ilişkili test olarak ekle--->
<cfif isdefined("attributes.class_id") and len(attributes.class_id)>
	<cfset add_relation=cfc.add_relation(class_id:attributes.class_id, get_max_quiz_id:get_max_quiz.quiz_id,QUIZ_HEAD:QUIZ_HEAD)>
	<!--- <cfquery name="add_relation" datasource="#dsn#">
		INSERT INTO
			QUIZ_RELATION
		(
			QUIZ_ID,
			QUIZ_HEAD,
			CLASS_ID
		)
		VALUES
		(
			#GET_MAX_QUIZ.QUIZ_ID#,
			'#QUIZ_HEAD#',
			#attributes.class_id#
		)
	</cfquery> --->
</cfif>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='QUIZ'
	action_column='QUIZ_ID'
	action_id='#get_max_quiz.quiz_id#'
	action_page='#request.self#?fuseaction=training_management.quiz&quiz_id=#get_max_quiz.quiz_id#' 
	warning_description='Test : #attributes.QUIZ_HEAD#'>
<cfif isdefined("attributes.copy_quiz_id")>
	<cfset ADD_QUIZ_QUESTIONS=cfc.ADD_QUIZ_QUESTIONS(copy_quiz_id:attributes.copy_quiz_id, get_quiz_id:get_max_quiz.quiz_id)>
    <!--- <cfquery name="ADD_QUIZ_QUESTIONS" datasource="#DSN#">
        INSERT INTO
            QUIZ_QUESTIONS
		(
			QUIZ_ID,
			QUESTION_ID
		)
		SELECT
			#GET_MAX_QUIZ.QUIZ_ID#,
			QUESTION_ID
		FROM
			QUIZ_QUESTIONS
		WHERE
			QUIZ_ID = #attributes.copy_quiz_id#
    </cfquery> --->
</cfif>
 <!--- <cflocation url="#request.self#?fuseaction=training_management.quiz&quiz_id=#get_max_quiz.quiz_id#" addtoken="no"> --->
<script>
	window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_quizs&event=det&quiz_id=#get_max_quiz.quiz_id#</cfoutput>";
</script>

