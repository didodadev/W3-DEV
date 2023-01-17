<CF_DATE TARIH="QUIZ_STARTDATE">
<CF_DATE TARIH="QUIZ_FINISHDATE">
<cfparam name="attributes.quiz_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfset QUIZ_STARTDATE = date_add('h', attributes.event_start_clock - session.ep.time_zone, QUIZ_STARTDATE)>
<cfset QUIZ_STARTDATE = date_add('n', attributes.event_start_minute, QUIZ_STARTDATE)>
<cfset QUIZ_FINISHDATE = date_add('h', attributes.event_finish_clock - session.ep.time_zone, QUIZ_FINISHDATE)>
<cfset QUIZ_FINISHDATE = date_add('n', attributes.event_finish_minute, QUIZ_FINISHDATE)>
<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset upd_quiz=cfc.UPD_QUIZ_func(
	QUIZ_STARTDATE:form.QUIZ_STARTDATE,
	QUIZ_FINISHDATE:form.QUIZ_FINISHDATE,
	SCORE1:iif(len(attributes.SCORE1),"attributes.SCORE1",DE("")),
	SCORE2:iif(len(attributes.SCORE2),"attributes.SCORE2",DE("")),
	SCORE3:iif(len(attributes.SCORE3),"attributes.SCORE3",DE("")),
	SCORE4:iif(len(attributes.SCORE4),"attributes.SCORE4",DE("")),
	SCORE5:iif(len(attributes.SCORE5),"attributes.SCORE5",DE("")),
	process_stage:attributes.process_stage,
	QUIZ_ID:form.QUIZ_ID,
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
	TRAIN_ID:attributes.TRAIN_ID,
	QUIZ_TRAINING_SUBJECTS:attributes.QUIZ_TRAINING_SUBJECTS,
	TEST_TYPE:attributes.test_type_id,
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
<!--- <cfquery name="UPD_QUIZ" datasource="#dsn#">
	UPDATE
		QUIZ
	SET
 		QUIZ_STARTDATE = #QUIZ_STARTDATE#, 
 		QUIZ_FINISHDATE = #QUIZ_FINISHDATE#, 
		<!---STAGE_ID = #STAGE_ID#,--->
		PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
		COMMENT1 = '#COMMENT1#', 
		COMMENT2 = '#COMMENT2#', 
		COMMENT3 = '#COMMENT3#', 
		COMMENT4 = '#COMMENT4#', 
		COMMENT5 = '#COMMENT5#', 
	<cfif len(SCORE1)>
		SCORE1 = #SCORE1#,
	<cfelse>
		SCORE1 = NULL,
	</cfif> 
	<cfif len(SCORE2)>
		SCORE2 = #SCORE2#,
	<cfelse>
		SCORE2 = NULL,
	</cfif> 
	<cfif len(SCORE3)>
		SCORE3 = #SCORE3#,
	<cfelse>
		SCORE3 = NULL,
	</cfif> 
	<cfif len(SCORE4)>
		SCORE4 = #SCORE4#,
	<cfelse>
		SCORE4 = NULL,
	</cfif> 
	<cfif len(SCORE5)>
		SCORE5 = #SCORE5#,
	<cfelse>
		SCORE5 = NULL,
	</cfif> 
	<cfif isDefined("QUIZ_PARTNERS")>
		QUIZ_PARTNERS = ',#QUIZ_PARTNERS#,', 
	<cfelse>
		QUIZ_PARTNERS = NULL, 
	</cfif>
	<cfif isDefined("QUIZ_CONSUMERS")>
		QUIZ_CONSUMERS = ',#QUIZ_CONSUMERS#,',  
	<cfelse>
		QUIZ_CONSUMERS = NULL,  
	</cfif>
	<cfif isDefined("QUIZ_DEPARTMENTS")>
		QUIZ_DEPARTMENTS = ',#QUIZ_DEPARTMENTS#,',  
	<cfelse>
		QUIZ_DEPARTMENTS = NULL,  
	</cfif>
	<cfif isDefined("QUIZ_POSITION_CATS")>
		QUIZ_POSITION_CATS = ',#QUIZ_POSITION_CATS#,',  
	<cfelse>
		QUIZ_POSITION_CATS = NULL,  
	</cfif>
	<cfif isDefined("QUIZ_OBJECTIVE")>
		QUIZ_OBJECTIVE = '#QUIZ_OBJECTIVE#',  
	<cfelse>
		QUIZ_OBJECTIVE = NULL,  
	</cfif>
		TRAINING_SEC_ID = #TRAINING_SEC_ID#, 
		TRAINING_CAT_ID = #TRAINING_CAT_ID#, 
	<cfif isDefined("TRAINING_ID")>
		TRAINING_ID = #TRAINING_ID#,
	</cfif>
	<cfif TIMING_STYLE EQ 1>
		TOTAL_TIME = #TOTAL_TIME#, 
	</cfif>
	<cfif isDefined("TOTAL_POINTS")>
		TOTAL_POINTS = #TOTAL_POINTS#, 
	</cfif>
		QUIZ_AVERAGE = #QUIZ_AVERAGE#, 
		TAKE_LIMIT = #FORM.TAKE_LIMIT#, 
		GRADE_STYLE = #GRADE_STYLE#, 
		QUIZ_HEAD = '#QUIZ_HEAD#', 
		QUIZ_TYPE = #QUIZ_TYPE#, 
		RANDOM = #RANDOM#, 
		MAX_QUESTIONS = #MAX_QUESTIONS#, 
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #SESSION.EP.USERID#, 
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		QUIZ_ID = #QUIZ_ID#
</cfquery> --->
<cf_workcube_process 
	is_upd="1" 
	old_process_line="#attributes.old_process_line#"
	process_stage='#attributes.process_stage#' 
	record_member="#session.ep.userid#"
	record_date="#now()#" 
	action_table='QUIZ'
	action_column='QUIZ_ID'
	action_id="#QUIZ_ID#" 
	action_page="#request.self#?fuseaction=training_management.quiz&quiz_id=#QUIZ_ID#" 
	warning_description="Test : #QUIZ_HEAD#">
	<script>
		window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_quizs&event=det&quiz_id=#quiz_id#</cfoutput>";
	</script>
<!--- <cflocation addtoken="No" url="#request.self#?fuseaction=training_management.quiz&quiz_id=#QUIZ_ID#"> --->
