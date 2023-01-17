<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>

<cfinclude template="get_quiz.cfm">
<cfinclude template="get_quiz_chapters.cfm">

<cftransaction>
<cfquery name="add_" datasource="#dsn#">
	INSERT INTO 
		EMPLOYEE_QUIZ
		(
		POSITION_CAT_ID,
		POSITION_ID,
		QUIZ_OBJECTIVE,
		QUIZ_HEAD,
		COMMETHOD_ID,
		IS_ALL_EMPLOYEE,
		IS_ACTIVE,
		IS_EDUCATION,
		IS_TRAINER,
		IS_INTERVIEW,
		IS_TEST_TIME,
		FORM_OPEN_TYPE,
		FORM_YEAR,
		IS_EXTRA_RECORD,
		IS_EXTRA_RECORD_EMP,
		IS_RECORD_TYPE,
		IS_VIEW_QUESTION,
		IS_EXTRA_QUIZ,
		IS_MANAGER_1,
		IS_MANAGER_2,
		IS_MANAGER_3,
		IS_CAREER,
		IS_TRAINING,
		IS_OPINION,
		START_DATE,
		FINISH_DATE,
		RECORD_DATE,
		RECORD_EMP, 
		RECORD_IP
		)
	VALUES
		(
		<cfif len(get_quiz.POSITION_CAT_ID)>'#get_quiz.POSITION_CAT_ID#'<cfelse>NULL</cfif>,
		<cfif len(get_quiz.POSITION_ID)>'#get_quiz.POSITION_ID#'<cfelse>NULL</cfif>,
		<cfif len(get_quiz.QUIZ_OBJECTIVE)>'#get_quiz.QUIZ_OBJECTIVE#'<cfelse>NULL</cfif>,
		'#attributes.new_quiz_head#',
		<cfif len(get_quiz.COMMETHOD_ID)>#get_quiz.COMMETHOD_ID#<cfelse>NULL</cfif>,
		<cfif len(get_quiz.IS_ALL_EMPLOYEE)>#get_quiz.IS_ALL_EMPLOYEE#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_ACTIVE)>#get_quiz.IS_ACTIVE#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_EDUCATION)>#get_quiz.IS_EDUCATION#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_TRAINER)>#get_quiz.IS_TRAINER#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_INTERVIEW)>#get_quiz.IS_INTERVIEW#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_TEST_TIME)>#get_quiz.IS_TEST_TIME#<cfelse>0</cfif>,
		<cfif len(get_quiz.FORM_OPEN_TYPE)>#get_quiz.FORM_OPEN_TYPE#<cfelse>NULL</cfif>,
		#attributes.new_form_year#,
		<cfif len(get_quiz.IS_EXTRA_RECORD)>#get_quiz.IS_EXTRA_RECORD#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_EXTRA_RECORD_EMP)>#get_quiz.IS_EXTRA_RECORD_EMP#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_RECORD_TYPE)>#get_quiz.IS_RECORD_TYPE#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_VIEW_QUESTION)>#get_quiz.IS_VIEW_QUESTION#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_EXTRA_QUIZ)>#get_quiz.IS_EXTRA_QUIZ#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_MANAGER_1)>#get_quiz.IS_MANAGER_1#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_MANAGER_2)>#get_quiz.IS_MANAGER_2#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_MANAGER_3)>#get_quiz.IS_MANAGER_3#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_CAREER)>#get_quiz.IS_CAREER#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_TRAINING)>#get_quiz.IS_TRAINING#<cfelse>0</cfif>,
		<cfif len(get_quiz.IS_OPINION)>#get_quiz.IS_OPINION#<cfelse>0</cfif>,
		#attributes.start_date#,
		#attributes.finish_date#,
		#now()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
		)
</cfquery>
	<cfquery name="get_max" datasource="#dsn#">
		SELECT MAX(QUIZ_ID) AS LATEST_RECORD_ID FROM EMPLOYEE_QUIZ
	</cfquery>
	<cfset new_quiz_id = get_max.LATEST_RECORD_ID>

<cfoutput query="GET_QUIZ_CHAPTERS">
<cfset active_chapter_id = CHAPTER_ID>
<cfquery name="add_" datasource="#dsn#">
	INSERT INTO 
		EMPLOYEE_QUIZ_CHAPTER
		(
			QUIZ_ID,
			CHAPTER,
			CHAPTER_INFO,
			CHAPTER_WEIGHT,
			ANSWER_NUMBER,
			<cfloop FROM="1" TO="20" INDEX="I">
				ANSWER#EVALUATE(I)#_TEXT,
				ANSWER#EVALUATE(I)#_PHOTO,
				ANSWER#EVALUATE(I)#_PHOTO_SERVER_ID,
				ANSWER#EVALUATE(I)#_POINT,
			</cfloop>
			IS_EXP1,
			IS_EXP2,
			IS_EXP3,
			IS_EXP4,
			EXP1_NAME,
			EXP2_NAME,
			EXP3_NAME,
			EXP4_NAME,
			IS_EMP_EXP1,
			IS_CHIEF3_EXP1,
			IS_CHIEF1_EXP1,
			IS_CHIEF2_EXP1,
			IS_EMP_EXP2,
			IS_CHIEF3_EXP2,
			IS_CHIEF1_EXP2,
			IS_CHIEF2_EXP2,
			IS_EMP_EXP3,
			IS_CHIEF3_EXP3,
			IS_CHIEF1_EXP3,
			IS_CHIEF2_EXP3,
			IS_EMP_EXP4,
			IS_CHIEF3_EXP4,
			IS_CHIEF1_EXP4,
			IS_CHIEF2_EXP4,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
		)
	VALUES
		(
			#new_quiz_id#,
			'#CHAPTER#',
			'#CHAPTER_INFO#',
			#CHAPTER_WEIGHT#,
			#ANSWER_NUMBER#,
			<cfloop FROM="1" TO="20" INDEX="I">
				<cfif len(evaluate("ANSWER#I#_TEXT"))>'#wrk_eval("ANSWER#I#_TEXT")#'<cfelse>NULL</cfif>,
				NULL,
				NULL,
				<cfif len(evaluate("ANSWER#I#_POINT"))>#evaluate("ANSWER#I#_POINT")#<cfelse>NULL</cfif>,
			</cfloop>
			<cfif len('is_exp1')>#is_exp1#<cfelse>0</cfif>,
			<cfif len('is_exp2')>#is_exp2#<cfelse>0</cfif>,
			<cfif len('is_exp3')>#is_exp3#<cfelse>0</cfif>,
			<cfif len('is_exp4')>#is_exp4#<cfelse>0</cfif>,
			'#exp1_name#',
			'#exp2_name#',
			'#exp3_name#',
			'#exp4_name#',
			<cfif len('IS_EMP_EXP1')>#IS_EMP_EXP1#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF3_EXP1')>#IS_CHIEF3_EXP1#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF1_EXP1')>#IS_CHIEF1_EXP1#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF2_EXP1')>#IS_CHIEF2_EXP1#<cfelse>0</cfif>,
			<cfif len('IS_EMP_EXP2')>#IS_EMP_EXP2#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF3_EXP2')>#IS_CHIEF3_EXP2#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF1_EXP2')>#IS_CHIEF1_EXP2#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF2_EXP2')>#IS_CHIEF2_EXP2#<cfelse>0</cfif>,
			<cfif len('IS_EMP_EXP3')>#IS_EMP_EXP3#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF3_EXP3')>#IS_CHIEF3_EXP3#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF1_EXP3')>#IS_CHIEF1_EXP3#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF2_EXP3')>#IS_CHIEF2_EXP3#<cfelse>0</cfif>,
			<cfif len('IS_EMP_EXP4')>#IS_EMP_EXP4#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF3_EXP4')>#IS_CHIEF3_EXP4#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF1_EXP4')>#IS_CHIEF1_EXP4#<cfelse>0</cfif>,
			<cfif len('IS_CHIEF2_EXP4')>#IS_CHIEF2_EXP4#<cfelse>0</cfif>,
			#now()#,
			'#CGI.REMOTE_ADDR#',
			#SESSION.EP.USERID#
		)
</cfquery>
	<cfquery name="get_max_chapter" datasource="#dsn#">
		SELECT MAX(CHAPTER_ID) AS LATEST_RECORD_ID FROM EMPLOYEE_QUIZ_CHAPTER
	</cfquery>
	<cfset new_chapter_id = get_max_chapter.LATEST_RECORD_ID>
	
	<cfquery name="get_chapter_questions" datasource="#dsn#">
		SELECT 
    	    QUESTION_ID, 
            CHAPTER_ID, 
            QUESTION, 
            QUESTION_INFO, 
            ANSWER_NUMBER, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_EMP, 
            UPDATE_DATE,
            UPDATE_IP, 
            OPEN_ENDED 
        FROM 
	        EMPLOYEE_QUIZ_QUESTION 
        WHERE 
        	CHAPTER_ID = #active_chapter_id#
	</cfquery>
	
		<cfloop query="get_chapter_questions">
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				EMPLOYEE_QUIZ_QUESTION
					(
					CHAPTER_ID,
					QUESTION,
					QUESTION_INFO,
					ANSWER_NUMBER,
					<cfloop FROM="1" TO="20" INDEX="I">
						ANSWER#EVALUATE(I)#_TEXT,
						ANSWER#EVALUATE(I)#_PHOTO,
						ANSWER#EVALUATE(I)#_PHOTO_SERVER_ID,
						ANSWER#EVALUATE(I)#_POINT,
					</cfloop>
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
					)
				VALUES
					(
					#new_chapter_id#,
					'#get_chapter_questions.QUESTION#',
					'#get_chapter_questions.QUESTION_INFO#',
					<cfif len(get_chapter_questions.ANSWER_NUMBER)>#get_chapter_questions.ANSWER_NUMBER#<cfelse>NULL</cfif>,
					<cfloop FROM="1" TO="20" INDEX="I">
						<cfif len(evaluate("ANSWER#I#_TEXT"))>'#wrk_eval("ANSWER#I#_TEXT")#'<cfelse>NULL</cfif>,
						NULL,
						NULL,
						<cfif len(evaluate("ANSWER#I#_POINT"))>#evaluate("ANSWER#I#_POINT")#<cfelse>NULL</cfif>,
					</cfloop>
					#now()#,
					'#CGI.REMOTE_ADDR#',
					#SESSION.EP.USERID#
					)
		</cfquery>
		</cfloop>
</cfoutput>

<CFQUERY name="get_relation" datasource="#dsn#">
	SELECT 
        RELATION_TABLE, 
        RELATION_FIELD_ID,
        RELATION_ACTION, 
        RELATION_ACTION_ID, 
        RELATION_YEAR
    FROM 
    	RELATION_SEGMENT_QUIZ 
    WHERE 
	    RELATION_TABLE = 'EMPLOYEE_QUIZ' 
    AND 
    	RELATION_FIELD_ID = #attributes.QUIZ_ID#
</CFQUERY>

<CFOUTPUT query="get_relation">
	<cfquery name="add_" datasource="#dsn#">
		INSERT INTO 
			RELATION_SEGMENT_QUIZ
		(
			RELATION_TABLE,
			RELATION_FIELD_ID,
			RELATION_ACTION,
			RELATION_ACTION_ID,
			RELATION_YEAR
		)VALUES
		(
			'EMPLOYEE_QUIZ',
			#new_quiz_id#,
			3,
			#RELATION_ACTION_ID#,
			NULL
		)
	</cfquery>
</CFOUTPUT>
</cftransaction>
<cflocation url="#request.self#?fuseaction=hr.quiz&quiz_id=#new_quiz_id#" addtoken="no">
