<!--- !! Form generator kopyalama sayfası. SG20121010--->
<!--- form kopyalanıyor--->
<cfquery name="add_detail_survey" datasource="#dsn#">
	INSERT INTO
		SURVEY_MAIN
		(
			SURVEY_MAIN_HEAD,
			SURVEY_MAIN_DETAILS,
			IS_ACTIVE,
			TYPE,
			PROCESS_ROW_ID,
			LANGUAGE_ID,
			SCORE1,
			COMMENT1,
			SCORE2,
			COMMENT2,
			SCORE3,
			COMMENT3,
			SCORE4,
			COMMENT4,
			SCORE5,
			COMMENT5,
			AVERAGE_SCORE,
			TOTAL_SCORE,
			MAIN_TIME_LIMIT,
			IS_MANAGER_0,
			IS_MANAGER_1,
			IS_MANAGER_2,
			IS_MANAGER_3,
			IS_MANAGER_4,
			EMP_QUIZ_WEIGHT,
			MANAGER_QUIZ_WEIGHT_1,
			MANAGER_QUIZ_WEIGHT_2,
			MANAGER_QUIZ_WEIGHT_3,
			MANAGER_QUIZ_WEIGHT_4,
			PROCESS_ID,
			START_DATE,
			FINISH_DATE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		SELECT
			SURVEY_MAIN_HEAD,
			SURVEY_MAIN_DETAILS,
			IS_ACTIVE,
			TYPE,
			PROCESS_ROW_ID,
			LANGUAGE_ID,
			SCORE1,
			COMMENT1,
			SCORE2,
			COMMENT2,
			SCORE3,
			COMMENT3,
			SCORE4,
			COMMENT4,
			SCORE5,
			COMMENT5,
			AVERAGE_SCORE,
			TOTAL_SCORE,
			MAIN_TIME_LIMIT,
			IS_MANAGER_0,
			IS_MANAGER_1,
			IS_MANAGER_2,
			IS_MANAGER_3,
			IS_MANAGER_4,
			EMP_QUIZ_WEIGHT,
			MANAGER_QUIZ_WEIGHT_1,
			MANAGER_QUIZ_WEIGHT_2,
			MANAGER_QUIZ_WEIGHT_3,
			MANAGER_QUIZ_WEIGHT_4,
			PROCESS_ID,
			START_DATE,
			FINISH_DATE,
			#now()#,
			#session.ep.userid#,
			'#cgi.REMOTE_ADDR#'
		FROM
			SURVEY_MAIN
		WHERE
			SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_main_id#">
</cfquery>
<!---//form kopyalanıyor --->
<cfquery name="get_max_id" datasource="#dsn#">
	SELECT MAX(SURVEY_MAIN_ID) AS SURVEY_ID FROM SURVEY_MAIN
</cfquery>
<!--- pozisyon tipleri ekleniyor--->
<cfquery name="add_position_cats" datasource="#dsn#">
	INSERT INTO
		SURVEY_MAIN_POSITION_CATS
		(
			SURVEY_MAIN_ID,
			POSITION_CAT_ID
		)
	SELECT
		<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_id.SURVEY_ID#">,
		POSITION_CAT_ID
	FROM
		SURVEY_MAIN_POSITION_CATS
	WHERE
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_main_id#">
</cfquery>
<!--- //pozisyon tipleri ekleniyor--->
<!--- bölümler ekleniyor--->
<cfquery name="get_chapter" datasource="#dsn#">
	SELECT 
		SURVEY_CHAPTER_ID,
		SURVEY_MAIN_ID,
		SURVEY_CHAPTER_HEAD,
		SURVEY_CHAPTER_DETAIL,
		SURVEY_CHAPTER_DETAIL2,
		IS_CHAPTER_DETAIL2,
		CHAPTER_TIME_LIMIT,
		SURVEY_CHAPTER_WEIGHT,
		IS_SHOW_GD
	FROM 
		SURVEY_CHAPTER
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_main_id#">
</cfquery>
<cfloop query="get_chapter">
	<cfquery name="add_chapter" datasource="#dsn#">
		INSERT INTO
			SURVEY_CHAPTER
			(
				SURVEY_MAIN_ID,
				SURVEY_CHAPTER_HEAD,
				SURVEY_CHAPTER_DETAIL,
				SURVEY_CHAPTER_DETAIL2,
				IS_CHAPTER_DETAIL2,
				CHAPTER_TIME_LIMIT,
				SURVEY_CHAPTER_WEIGHT,
				IS_SHOW_GD,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				#get_max_id.SURVEY_ID#,
				'#get_chapter.SURVEY_CHAPTER_HEAD#',
				<cfif len(get_chapter.SURVEY_CHAPTER_DETAIL)>'#get_chapter.SURVEY_CHAPTER_DETAIL#'<cfelse>NULL</cfif>,
				<cfif len(get_chapter.SURVEY_CHAPTER_DETAIL2)>'#get_chapter.SURVEY_CHAPTER_DETAIL2#'<cfelse>NULL</cfif>,
				<cfif len(get_chapter.IS_CHAPTER_DETAIL2)>#get_chapter.IS_CHAPTER_DETAIL2#<cfelse>NULL</cfif>,
				<cfif len(get_chapter.CHAPTER_TIME_LIMIT)>#get_chapter.CHAPTER_TIME_LIMIT#<cfelse>NULL</cfif>,
				<cfif len(get_chapter.SURVEY_CHAPTER_WEIGHT)>#get_chapter.SURVEY_CHAPTER_WEIGHT#<cfelse>NULL</cfif>,
				<cfif len(get_chapter.IS_SHOW_GD)>#get_chapter.IS_SHOW_GD#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
	<cfquery name="get_max_chapter_id" datasource="#dsn#">
		SELECT MAX(SURVEY_CHAPTER_ID) AS CHAPTER_MAX_ID FROM SURVEY_CHAPTER
	</cfquery>
	<!--- bölüme bağlı sorular ekleniyor--->
	<cfquery name="get_question" datasource="#dsn#">
		SELECT
			SURVEY_QUESTION_ID,
			SURVEY_CHAPTER_ID,
			SURVEY_MAIN_ID,
			IS_REQUIRED,
			LINE_NUMBER,
			QUESTION_HEAD,
			QUESTION_DETAIL,
			QUESTION_TYPE,
			QUESTION_DESIGN,
			IS_ADD_NOTES,
			IS_ADD_SCORE,
			QUESTION_TIME_LIMIT,
			CROSS_QUESTION_ID,
			QUESTION_IMAGE_PATH,
			QUESTION_FLASH_PATH
		FROM
			SURVEY_QUESTION
		WHERE
			SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter.survey_chapter_id#">AND
			SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_main_id#"> 
	</cfquery>
	<cfloop query="get_question">
		<cfquery name="add_question" datasource="#dsn#">
			INSERT INTO
				SURVEY_QUESTION
				(
					SURVEY_CHAPTER_ID,
					SURVEY_MAIN_ID,
					IS_REQUIRED,
					LINE_NUMBER,
					QUESTION_HEAD,
					QUESTION_DETAIL,
					QUESTION_TYPE,
					QUESTION_DESIGN,
					IS_ADD_NOTES,
					IS_ADD_SCORE,
					QUESTION_TIME_LIMIT,
					CROSS_QUESTION_ID,
					QUESTION_IMAGE_PATH,
					QUESTION_FLASH_PATH,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_chapter_id.CHAPTER_MAX_ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_id.SURVEY_ID#">,
					<cfif len(get_question.is_required)>#get_question.is_required#<cfelse>NULL</cfif>,
					<cfif len(get_question.line_number)>#get_question.line_number#<cfelse>NULL</cfif>,
					<cfif len(get_question.question_head)>'#get_question.question_head#'<cfelse>NULL</cfif>,
					<cfif len(get_question.question_detail)>'#get_question.question_detail#'<cfelse>NULL</cfif>,
					<cfif len(get_question.question_type)>#get_question.question_type#<cfelse>NULL</cfif>,
					<cfif len(get_question.question_design)>#get_question.question_design#<cfelse>NULL</cfif>,
					<cfif len(get_question.is_add_notes)>#get_question.is_add_notes#<cfelse>NULL</cfif>,
					<cfif len(get_question.is_add_score)>#get_question.is_add_score#<cfelse>NULL</cfif>,
					<cfif len(get_question.QUESTION_TIME_LIMIT)>#get_question.QUESTION_TIME_LIMIT#<cfelse>NULL</cfif>,
					<cfif len(get_question.CROSS_QUESTION_ID)>#get_question.CROSS_QUESTION_ID#<cfelse>NULL</cfif>,
					<cfif len(get_question.QUESTION_IMAGE_PATH)>'#get_question.QUESTION_IMAGE_PATH#'<cfelse>NULL</cfif>,
					<cfif len(get_question.QUESTION_FLASH_PATH)>'#get_question.QUESTION_FLASH_PATH#'<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#'
				)
		</cfquery>
		<!---// bölüme bağlı sorular ekleniyor--->
		<cfquery name="get_max_question_id" datasource="#dsn#">
			SELECT MAX(SURVEY_QUESTION_ID) AS MAX_QUESTION_ID FROM SURVEY_QUESTION
		</cfquery>
		<!---soruya bağlı şık seçenekleri ekle --->
		<cfquery name="add_survey_option" datasource="#dsn#">
			INSERT INTO
				SURVEY_OPTION
				(
					SURVEY_CHAPTER_ID,
					SURVEY_QUESTION_ID,
					OPTION_HEAD,
					OPTION_DETAIL,
					OPTION_POINT,
					OPTION_SCORE,
					OPTION_NOTE,
					SCORE_RATE1,
					SCORE_RATE2,
					OPTION_IMAGE_PATH,
					OPTION_FLASH_PATH,
					ANSWER_TYPE,
					QUESTION_TYPE,
					QUESTION_DESIGN,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			SELECT
					#get_max_chapter_id.CHAPTER_MAX_ID#,
					#get_max_question_id.MAX_QUESTION_ID#,
					OPTION_HEAD,
					OPTION_DETAIL,
					OPTION_POINT,
					OPTION_SCORE,
					OPTION_NOTE,
					SCORE_RATE1,
					SCORE_RATE2,
					OPTION_IMAGE_PATH,
					OPTION_FLASH_PATH,
					ANSWER_TYPE,
					QUESTION_TYPE,
					QUESTION_DESIGN,
					#NOW()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#'
				FROM
					SURVEY_OPTION
				WHERE 
					SURVEY_CHAPTER_ID = #get_chapter.survey_chapter_id# AND SURVEY_QUESTION_ID = #get_question.survey_question_id#
		</cfquery>
		<!--- //soruya bağlı şık seçenekleri ekle---->
	</cfloop>
	<!--- bölüme bağlı şık seçeneklerini ekle---->
		<cfquery name="add_survey_chapter_option" datasource="#dsn#">
			INSERT INTO
				SURVEY_OPTION
				(
					SURVEY_CHAPTER_ID,
					SURVEY_QUESTION_ID,
					OPTION_HEAD,
					OPTION_DETAIL,
					OPTION_POINT,
					OPTION_SCORE,
					OPTION_NOTE,
					SCORE_RATE1,
					SCORE_RATE2,
					OPTION_IMAGE_PATH,
					OPTION_FLASH_PATH,
					ANSWER_TYPE,
					QUESTION_TYPE,
					QUESTION_DESIGN,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			SELECT
					#get_max_chapter_id.CHAPTER_MAX_ID#,
					SURVEY_QUESTION_ID,
					OPTION_HEAD,
					OPTION_DETAIL,
					OPTION_POINT,
					OPTION_SCORE,
					OPTION_NOTE,
					SCORE_RATE1,
					SCORE_RATE2,
					OPTION_IMAGE_PATH,
					OPTION_FLASH_PATH,
					ANSWER_TYPE,
					QUESTION_TYPE,
					QUESTION_DESIGN,
					#NOW()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#'
				FROM
					SURVEY_OPTION
				WHERE 
					SURVEY_CHAPTER_ID = #get_chapter.survey_chapter_id# AND SURVEY_QUESTION_ID IS NULL
		</cfquery>
	<!--- bölüme bağlı şık seçeneklerini ekle---->
</cfloop>
<!--- // bölümler ekleniyor--->
<cfset attributes.actionId=get_max_id.SURVEY_ID>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_detail_survey_report&event=upd&survey_id=#get_max_id.SURVEY_ID#</cfoutput>";
</script>
