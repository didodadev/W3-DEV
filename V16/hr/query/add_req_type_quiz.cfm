<cfquery name="GET_EMP" datasource="#dsn#">
	SELECT
		EP.EMPLOYEE_ID, 
		EP.POSITION_CODE,
		D.DEPARTMENT_ID,
		B.BRANCH_NAME,
		B.BRANCH_ID,
		OC.COMP_ID,
		EP.FUNC_ID,
		EP.ORGANIZATION_STEP_ID,
		EP.POSITION_CAT_ID,
        EP.TITLE_ID
	FROM
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC
	WHERE 
		POSITION_CODE=#attributes.position_code# AND
		EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND
		B.BRANCH_ID=D.BRANCH_ID AND
		OC.COMP_ID=B.COMPANY_ID
</cfquery>

<cfquery name="UPD_RELATION_SEG" datasource="#dsn#">
	UPDATE 
		RELATION_SEGMENT 
	SET 
		IS_FILL=1 
	WHERE 
		RELATION_TABLE='POSITION_REQ_TYPE' AND
		RELATION_FIELD_ID IN (#attributes.all_req_type_id#) AND
		(
			(RELATION_ACTION_ID=#GET_EMP.DEPARTMENT_ID# AND RELATION_ACTION=2)
			<cfif len(GET_EMP.COMP_ID)>OR (RELATION_ACTION_ID=#GET_EMP.COMP_ID# AND RELATION_ACTION=1)</cfif>
			<cfif len(GET_EMP.FUNC_ID)>OR (RELATION_ACTION_ID=#GET_EMP.FUNC_ID# AND RELATION_ACTION=5)</cfif>
			<cfif len(GET_EMP.ORGANIZATION_STEP_ID)>OR (RELATION_ACTION_ID=#GET_EMP.ORGANIZATION_STEP_ID# AND RELATION_ACTION=6)</cfif>
			<cfif len(GET_EMP.POSITION_CAT_ID)>OR (RELATION_ACTION_ID=#GET_EMP.POSITION_CAT_ID# AND RELATION_ACTION=3)</cfif>
            <cfif len(GET_EMP.TITLE_ID)>OR (RELATION_ACTION_ID=#GET_EMP.TITLE_ID# AND RELATION_ACTION=10)</cfif>
		)
</cfquery>

<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		REQ_TYPE_ID IN (#attributes.all_req_type_id#)
</cfquery>

<cfset puan = 0>
<cfquery name="DEL_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
	DELETE FROM
		EMPLOYEE_QUIZ_RESULTS_DETAILS
	WHERE	
		RESULT_ID = #RESULT_ID#
</cfquery> 	
<cfloop query="get_quiz_chapters">
	<cfset attributes.chapter_id = get_quiz_chapters.chapter_id>
	<cfif len(get_quiz_chapters.chapter_weight)>
		<cfset chapterweight = get_quiz_chapters.CHAPTER_weight>
	<cfelse>
		<cfset chapterweight = 1>
	</cfif>
	<cfquery name="get_result_detail_chapter" datasource="#dsn#">
		SELECT 
			RESULT_ID
		FROM
			EMPLOYEE_QUIZ_CHAPTER_EXPL
		WHERE	
			RESULT_ID = #RESULT_ID# AND
			CHAPTER_ID=#attributes.CHAPTER_ID#
	</cfquery>
	<cfif get_result_detail_chapter.recordcount>
		<cfquery name="UPD_RESULT_CHAPTER_EXPL" datasource="#dsn#">
			UPDATE
				EMPLOYEE_QUIZ_CHAPTER_EXPL
			SET
				EXPLANATION = '#Replace(EVALUATE("attributes.expl_#get_quiz_chapters.currentrow#"),"'"," ","all")#'
			WHERE	
				RESULT_ID = #RESULT_ID# AND
				CHAPTER_ID=#attributes.CHAPTER_ID#
		</cfquery>
	<cfelse>
		<cfquery name="ADD_RESULT_CHAPTER_EXPL" datasource="#dsn#">
			INSERT INTO
				EMPLOYEE_QUIZ_CHAPTER_EXPL
				(
					RESULT_ID,
					CHAPTER_ID,
					EXPLANATION
				)
			VALUES
				(
					#RESULT_ID#,
					#attributes.CHAPTER_ID#,
					'#replace(evaluate("attributes.expl_#get_quiz_chapters.currentrow#"),"'"," ","all")#'
				)
		</cfquery>
	</cfif>
	<cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
		SELECT 
			*
		FROM 
			EMPLOYEE_QUIZ_QUESTION
		WHERE
			CHAPTER_ID=#attributes.CHAPTER_ID#
	</cfquery>
	<cfloop query="get_quiz_questions">
		<cfif IsDefined('attributes.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
			<cfset yeni_puan = ListGetAt(
				EVALUATE('attributes.user_answer_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow&'_point'), 
				EVALUATE('attributes.user_answer_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow))
				>
							
			<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
				INSERT INTO
					EMPLOYEE_QUIZ_RESULTS_DETAILS
					(
					RESULT_ID,
					QUESTION_ID,
					QUESTION_POINT,
					QUESTION_USER_ANSWERS,
					GD
					)
				VALUES
					(
					#RESULT_ID#,
					#GET_QUIZ_QUESTIONS.QUESTION_ID#,
					#yeni_puan#,
					'#wrk_eval("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#',
					0
					)
			</cfquery> 
		<cfelse>
			<cfset yeni_puan =0>
		</cfif>
		<cfset puan = puan + yeni_puan>
	</cfloop> 
</cfloop> 


<cfquery name="UPD_RESULT" datasource="#dsn#">
	UPDATE
		EMPLOYEE_QUIZ_RESULTS
	SET
		USER_POINT = #puan#,
		<cfif isdefined("session.ep.userid")>
		UPDATE_EMP = #session.ep.userid#,
		<cfelseif isdefined("session.pp.userid")>
		UPDATE_PAR = #session.pp.userid#,
		</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		RESULT_ID = #RESULT_ID#
</cfquery>  

<cfquery name="UPD_perform_target" datasource="#dsn#">
	UPDATE
		EMPLOYEE_PERFORMANCE_TARGET
	SET	
		REQ_TYPE_LIST=<cfif listlen(attributes.req_type_list,',')>'#attributes.req_type_list#'<cfelse>NULL</cfif>,
		DEP_MANAGER_REQ_TYPE=<cfif listlen(attributes.dep_req_type_list,',')>'#attributes.dep_req_type_list#'<cfelse>NULL</cfif>,
		COACH_REQ_TYPE=<cfif listlen(attributes.coach_req_type_list,',')>'#attributes.coach_req_type_list#'<cfelse>NULL</cfif>,
		STD_REQ_TYPE=<cfif listlen(attributes.std_req_type_list,',')>'#attributes.std_req_type_list#'<cfelse>NULL</cfif>,
		PERFORM_POINT = #puan#,
		UPDATE_EMP = '#session.ep.userid#',
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #now()#
	WHERE
		PER_ID = #attributes.per_id#
</cfquery> 

<cfquery name="upd_perform" datasource="#dsn#">
	UPDATE
		EMPLOYEE_PERFORMANCE
	SET	
		UPDATE_KEY = '#SESSION.EP.USERKEY#',
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #now()#
	WHERE
		PER_ID = #attributes.PER_ID#
</cfquery>
<script type="text/javascript">
	history.back();
</script>
<!---<cflocation url="#request.self#?fuseaction=hr.popup_form_add_req_type_quiz&position_code=#attributes.position_code#&per_id=#attributes.per_id#" addtoken="no">--->
