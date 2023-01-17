<cfset emp_id = attributes.employee_id.split(",")[1]>
<cfset cfc = createObject("component","V16.hr.cfc.competencies")>
<cfset getReqTypeForEmp = cfc.getReqTypeForEmp(employee_id: emp_id)>
<cfif getReqTypeForEmp.recordcount gt 0>
    <cfloop from = "1" to="#getReqTypeForEmp.recordcount#" index="i">
        <cfset competencies_total = 0>
        <cfif len(evaluate("attributes.competencies_score#i#")) and len(evaluate("attributes.competencies_weight#i#"))>
            <cfset competencies_total = evaluate("attributes.competencies_score#i#") * evaluate("attributes.competencies_weight#i#") / 100>
        <cfelse>
            <cfset competencies_total = 0>
        </cfif>
        <cfquery name="upd_competencies_score" datasource="#dsn#">
            UPDATE
                EMPLOYEES_COMPETENCIES
            SET
                COMPETENCIES_COMMENT = <cfif len(evaluate('attributes.competencies_comment#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.competencies_comment#i#')#"><cfelse>NULL</cfif>,
                COMPETENCIES_WEIGHT = <cfif len(evaluate('attributes.competencies_weight#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.competencies_weight#i#')#"><cfelse>0</cfif>,
                COMPETENCIES_SCORE = <cfif len(evaluate("attributes.competencies_score#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.competencies_score#i#')#"><cfelse>NULL</cfif>,
                COMPETENCIES_TOTAL = <cfif len(competencies_total)><cfqueryparam cfsqltype="cf_sql_float" value="#competencies_total#"><cfelse>0</cfif>
            WHERE
                COMPETENCIES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.competenciesid#i#')#">
                AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
        </cfquery>
    </cfloop>
</cfif>
<cfif attributes.cons_uppos2_cont neq 1>
	<!--- hedef sonuclari--->
    <cfset target_score = 0>
    <cfset req_type_score = 0>
    <cfset target_result = 0>
    <cfset req_type_result = 0>
    <cfset emp_perf_result = 0>
    <cfset emp_perf_result2 = 0>
    <cfset comp_perf_result = 0>
    <cfset perf_result = 0>
    <cfif attributes.is_stage eq 1>
		<cfquery name="get_perf_def" datasource="#dsn#">
            SELECT 
                IS_EMPLOYEE,
                IS_UPPER_POSITION,
                IS_UPPER_POSITION2,
                EMPLOYEE_WEIGHT,
                UPPER_POSITION_WEIGHT,
                UPPER_POSITION2_WEIGHT
            FROM
                EMPLOYEE_PERFORMANCE_DEFINITION
            WHERE
                YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.startdate_year#">
                AND IS_ACTIVE = 1
                AND (','+TITLE_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#emp_title_id#,%">
                OR ','+FUNC_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#emp_func_id#,%">)
        </cfquery>
	</cfif>
    <cfquery name="get_target" datasource="#dsn#">
        SELECT 
            COUNT(TARGET_ID) AS TARGET_COUNT
        FROM 
            TARGET
        WHERE 
            EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
            AND YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.finishdate_year#"> 
            AND YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.startdate_year#">
    </cfquery>
    <cfif get_target.target_count gt 0>
        <cfloop from="1" to="#get_target.target_count#" index="i">
        	<cfset target_comment = evaluate("attributes.target_comment#i#")>
            <cfset target_comment = replace(target_comment,"'","''","all")>
            <cfquery name="upd_target" datasource="#dsn#">
                UPDATE
                    TARGET
                SET
                    PERFORM_COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#target_comment#">,
                    TARGET_RESULT = <cfif len(evaluate("attributes.target_result#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.target_result#i#')#"><cfelse>NULL</cfif>
					<cfif attributes.emp_id eq session.ep.userid>,EMP_TARGET_RESULT = <cfif len(evaluate("attributes.target_result#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.target_result#i#')#"><cfelse>NULL</cfif></cfif>
                    <cfif attributes.upper_position_code eq session.ep.position_code>,UPPER_POSITION_TARGET_RESULT = <cfif len(evaluate("attributes.target_result#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.target_result#i#')#"><cfelse>NULL</cfif></cfif>
                    <cfif attributes.upper_position_code2 eq session.ep.position_code>,UPPER_POSITION2_TARGET_RESULT = <cfif len(evaluate("attributes.target_result#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.target_result#i#')#"><cfelse>NULL</cfif></cfif>
                WHERE
                    TARGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.targetid#i#')#">
            </cfquery>
        </cfloop>
        <cfif attributes.is_stage eq 1>
            <cfif get_perf_def.IS_EMPLOYEE eq 1>
            	<cfquery name="get_target_emp_score" datasource="#dsn#">
                    SELECT 
                        SUM(CASE WHEN EMP_TARGET_RESULT IS NULL THEN 0 ELSE EMP_TARGET_RESULT END * #get_perf_def.EMPLOYEE_WEIGHT# / 100 * TARGET_WEIGHT / 100) AS EMP_SCORE 
                    FROM 
                        TARGET 
                    WHERE
                        EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> 
                        AND YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.finishdate_year#"> 
                        AND YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.startdate_year#">
                </cfquery>
			</cfif>
            <cfif isdefined('get_target_emp_score') and get_target_emp_score.recordcount><cfset emp_target_res = get_target_emp_score.EMP_SCORE><cfelse><cfset emp_target_res = 0></cfif>
            <cfif get_perf_def.is_upper_position eq 1>
            	<cfset upper_pos_weight = get_perf_def.upper_position_weight>
				<cfif get_perf_def.is_upper_position2 eq 1 and not len(attributes.upper_position_code2)><cfset upper_pos_weight = get_perf_def.upper_position_weight + get_perf_def.upper_position2_weight></cfif>
            	<cfquery name="get_target_uppos_score" datasource="#dsn#">
                    SELECT 
                        SUM(CASE WHEN UPPER_POSITION_TARGET_RESULT IS NULL THEN 0 ELSE UPPER_POSITION_TARGET_RESULT END * #upper_pos_weight# / 100 * TARGET_WEIGHT / 100) AS UPPOS_SCORE 
                    FROM 
                        TARGET 
                    WHERE
                        EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> 
                        AND YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.finishdate_year#"> 
                        AND YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.startdate_year#">
                </cfquery>
			</cfif>
            <cfif isdefined('get_target_uppos_score') and get_target_uppos_score.recordcount><cfset uppos_target_res = get_target_uppos_score.UPPOS_SCORE><cfelse><cfset uppos_target_res = 0></cfif>
            <cfif get_perf_def.IS_UPPER_POSITION2 eq 1 and len(attributes.upper_position_code2)>
            	<cfquery name="get_target_uppos2_score" datasource="#dsn#">
                    SELECT 
                        SUM(CASE WHEN UPPER_POSITION2_TARGET_RESULT IS NULL THEN 0 ELSE UPPER_POSITION2_TARGET_RESULT END * #get_perf_def.UPPER_POSITION2_WEIGHT# / 100 * TARGET_WEIGHT / 100) AS UPPOS2_SCORE 
                    FROM 
                        TARGET 
                    WHERE
                        EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> 
                        AND YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.finishdate_year#"> 
                        AND YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.startdate_year#">
                </cfquery>
			</cfif>
            <cfif isdefined('get_target_uppos2_score') and get_target_uppos2_score.recordcount><cfset uppos2_target_res = get_target_uppos2_score.UPPOS2_SCORE><cfelse><cfset uppos2_target_res = 0></cfif>
            <cfset target_score = uppos2_target_res + uppos_target_res + emp_target_res>
       	<cfelse>
        	<cfquery name="get_target_score" datasource="#dsn#">
                SELECT 
                    SUM(TARGET_WEIGHT/100*TARGET_RESULT) AS SCORE 
                FROM 
                    TARGET 
                WHERE
                    EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> 
                    AND YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.finishdate_year#"> 
                    AND YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.startdate_year#">
            </cfquery>
            <cfif len(get_target_score.score)><cfset target_score = get_target_score.score></cfif>
		</cfif>
        <cfif len(target_score) and len(attributes.emp_performance_weight)>
            <cfset target_result = target_score * attributes.emp_performance_weight / 100>
        </cfif>
    </cfif>
    <!--- hedef sonuclari--->
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
            EP.TITLE_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM
        	EMPLOYEES E,
            EMPLOYEE_POSITIONS EP,
            DEPARTMENT D,
            BRANCH B,
            OUR_COMPANY OC
        WHERE 
            EP.POSITION_CODE= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#"> AND
            E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
            EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND
            B.BRANCH_ID=D.BRANCH_ID AND
            OC.COMP_ID=B.COMPANY_ID
    </cfquery>
    
    <cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
        SELECT 
            *
        FROM 
            EMPLOYEE_QUIZ_CHAPTER
        WHERE
            REQ_TYPE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.all_req_type_id#">)
    </cfquery>
    <cfset puan = 0>
    <cfquery name="get_all_res_det" datasource="#dsn#">
    	SELECT RESULT_ID,QUESTION_ID,QUESTION_EMPLOYEE_ANSWERS,QUESTION_UPPER_POSITION_ANSWERS,QUESTION_UPPER_POSITION2_ANSWERS,QUESTION_POINT_EMP,QUESTION_POINT_MANAGER1,QUESTION_POINT_MANAGER2 FROM
            EMPLOYEE_QUIZ_RESULTS_DETAILS
        WHERE	
            RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#">
    </cfquery>
    <cfquery name="DEL_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
        DELETE FROM
            EMPLOYEE_QUIZ_RESULTS_DETAILS
        WHERE	
            RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#">
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
                RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#"> AND
                CHAPTER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#">
        </cfquery>
        <cfif get_result_detail_chapter.recordcount>
            <cfquery name="UPD_RESULT_CHAPTER_EXPL" datasource="#dsn#">
                UPDATE
                    EMPLOYEE_QUIZ_CHAPTER_EXPL
                SET
                    EXPLANATION = '#Replace(EVALUATE("attributes.expl_#get_quiz_chapters.currentrow#"),"'"," ","all")#'
                WHERE	
                    RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#"> AND
                    CHAPTER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#">
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
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#">,
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
                CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#">
        </cfquery>
       	
        <cfset is_checked = 0>
        <cfloop query="get_quiz_questions">
            <cfif IsDefined('attributes.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
                <cfset is_checked = 1>
                <cfset yeni_puan = ListGetAt(
                    EVALUATE('attributes.user_answer_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow&'_point'), 
                    EVALUATE('attributes.user_answer_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow))
                    >		
              	<cfelse>
					<cfset yeni_puan =0>
                    <cfset temp_score = 0>
                </cfif>
                <cfset temp_score = yeni_puan * get_quiz_chapters.chapter_weight / 100>
                <cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
                    INSERT INTO
                        EMPLOYEE_QUIZ_RESULTS_DETAILS
                        (
                        RESULT_ID,
                        QUESTION_ID,
                        QUESTION_POINT,
                        QUESTION_USER_ANSWERS,
                        QUESTION_POINT_EMP,
                        QUESTION_EMPLOYEE_ANSWERS,
                        QUESTION_POINT_MANAGER1,
                        QUESTION_UPPER_POSITION_ANSWERS,
                        QUESTION_POINT_MANAGER2,
                        QUESTION_UPPER_POSITION2_ANSWERS,
                        GD
                        )
                    VALUES
                        (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_quiz_questions.question_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#yeni_puan#">,
                        <cfif IsDefined('attributes.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>'#wrk_eval("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#'<cfelse>0</cfif>,
                        <cfif attributes.emp_id eq session.ep.userid>#yeni_puan#<cfelse>'#wrk_eval("emp_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow&"_point")#'</cfif>,
						<cfif attributes.emp_id eq session.ep.userid><cfif IsDefined('attributes.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>'#wrk_eval("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#'<cfelse>0</cfif><cfelse>'#wrk_eval("attributes.emp_answer_i_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#'</cfif>,
                        <cfif attributes.upper_position_code eq session.ep.position_code>#yeni_puan#<cfelse>'#wrk_eval("uppos_answer_point_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#'</cfif>,
                        <cfif attributes.upper_position_code eq session.ep.position_code><cfif IsDefined('attributes.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>'#wrk_eval("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#'<cfelse>0</cfif><cfelse>'#wrk_eval("attributes.uppos_answer_i_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#'</cfif>,
                       <cfif attributes.upper_position_code2 eq session.ep.position_code>#yeni_puan#<cfelse>'#wrk_eval("uppos2_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow&"_point")#'</cfif>,
                       <cfif attributes.upper_position_code2 eq session.ep.position_code><cfif IsDefined('attributes.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>'#wrk_eval("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#'<cfelse>0</cfif><cfelse>'#wrk_eval("uppos2_answer_i_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#'</cfif>,
                        0
                        )
                </cfquery>
            <cfset puan = puan + yeni_puan>
            <cfset req_type_score = req_type_score + temp_score>
        </cfloop>   
        <cfif is_checked eq 1>
            <cfquery name="UPD_RELATION_SEG" datasource="#dsn#">
                UPDATE 
                    RELATION_SEGMENT 
                SET 
                    IS_FILL=1 
                WHERE 
                    RELATION_TABLE='POSITION_REQ_TYPE' AND
                    RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#req_type_id#"> AND
                    (
                        (RELATION_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.department_id#"> AND RELATION_ACTION=2)
                        <cfif len(GET_EMP.COMP_ID)>OR (RELATION_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.comp_id#"> AND RELATION_ACTION=1)</cfif>
                        <cfif len(GET_EMP.FUNC_ID)>OR (RELATION_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.func_id#"> AND RELATION_ACTION=5)</cfif>
                        <cfif len(GET_EMP.ORGANIZATION_STEP_ID)>OR (RELATION_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.organization_step_id#"> AND RELATION_ACTION=6)</cfif>
                        <cfif len(GET_EMP.POSITION_CAT_ID)>OR (RELATION_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.position_cat_id#"> AND RELATION_ACTION=3)</cfif>
                        <cfif len(GET_EMP.TITLE_ID)>OR (RELATION_ACTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.title_id#"> AND RELATION_ACTION=10)</cfif>
                    )
            </cfquery>
        </cfif> 
    </cfloop> 
    <cfquery name="UPD_RESULT" datasource="#dsn#">
        UPDATE
            EMPLOYEE_QUIZ_RESULTS
        SET
            USER_POINT = <cfqueryparam cfsqltype="cf_sql_integer" value="#puan#">,
            <cfif isdefined("session.ep.userid")>
            	UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfelseif isdefined("session.pp.userid")>
            	UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
            </cfif>
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
        WHERE
            RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#">
    </cfquery> 
    
    <cfif attributes.is_stage eq 1>
		<cfif get_perf_def.IS_EMPLOYEE eq 1>
            <cfquery name="get_req_emp_score" datasource="#dsn#">
                SELECT 
                    SUM(CASE WHEN QUESTION_POINT_EMP IS NULL THEN 0 ELSE QUESTION_POINT_EMP END * #get_perf_def.EMPLOYEE_WEIGHT# / 100 * EC.CHAPTER_WEIGHT / 100) AS EMP_SCORE 
                FROM 
                    EMPLOYEE_QUIZ_QUESTION EQ,
                    EMPLOYEE_QUIZ_CHAPTER EC,
                    EMPLOYEE_QUIZ_RESULTS_DETAILS QR
                WHERE
                    QR.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#">
                    AND EQ.CHAPTER_ID = EC.CHAPTER_ID
                    AND QR.QUESTION_ID = EQ.QUESTION_ID
            </cfquery>
        </cfif>
        <cfif isdefined('get_req_emp_score') and get_req_emp_score.recordcount and len(get_req_emp_score.EMP_SCORE)><cfset emp_req_res = get_req_emp_score.EMP_SCORE><cfelse><cfset emp_req_res = 0></cfif>
        <cfif get_perf_def.is_upper_position eq 1>
        	<cfset upper_pos_weight = get_perf_def.upper_position_weight>
			<cfif get_perf_def.is_upper_position2 eq 1 and not len(attributes.upper_position_code2)><cfset upper_pos_weight = get_perf_def.upper_position_weight + get_perf_def.upper_position2_weight></cfif>
            <cfquery name="get_req_uppos_score" datasource="#dsn#">
                SELECT 
                    SUM(CASE WHEN QUESTION_POINT_MANAGER1 IS NULL THEN 0 ELSE QUESTION_POINT_MANAGER1 END * #upper_pos_weight# / 100 * EC.CHAPTER_WEIGHT / 100) AS UPPOS_SCORE 
                FROM 
                    EMPLOYEE_QUIZ_QUESTION EQ,
                    EMPLOYEE_QUIZ_CHAPTER EC,
                    EMPLOYEE_QUIZ_RESULTS_DETAILS QR 
                WHERE
                    QR.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#">
                    AND EQ.CHAPTER_ID = EC.CHAPTER_ID
                    AND QR.QUESTION_ID = EQ.QUESTION_ID
            </cfquery>
        </cfif>
        <cfif isdefined('get_req_uppos_score') and get_req_uppos_score.recordcount and len(get_req_uppos_score.UPPOS_SCORE)><cfset uppos_req_res = get_req_uppos_score.UPPOS_SCORE><cfelse><cfset uppos_req_res = 0></cfif>
        <cfif get_perf_def.IS_UPPER_POSITION2 eq 1 and len(attributes.upper_position_code2)>
            <cfquery name="get_req_uppos2_score" datasource="#dsn#">
                SELECT 
                    SUM(CASE WHEN QUESTION_POINT_MANAGER2 IS NULL THEN 0 ELSE QUESTION_POINT_MANAGER2 END * #get_perf_def.UPPER_POSITION2_WEIGHT# / 100 * EC.CHAPTER_WEIGHT / 100) AS UPPOS2_SCORE 
                FROM 
                    EMPLOYEE_QUIZ_QUESTION EQ,
                    EMPLOYEE_QUIZ_CHAPTER EC,
                    EMPLOYEE_QUIZ_RESULTS_DETAILS QR  
                WHERE
                    QR.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result_id#">
                    AND EQ.CHAPTER_ID = EC.CHAPTER_ID
                    AND QR.QUESTION_ID = EQ.QUESTION_ID
            </cfquery>
        </cfif>
        <cfif isdefined('get_req_uppos2_score') and get_req_uppos2_score.recordcount and len(get_req_uppos2_score.UPPOS2_SCORE)><cfset uppos2_req_res = get_req_uppos2_score.UPPOS2_SCORE><cfelse><cfset uppos2_req_res = 0></cfif>
        <cfset req_type_score = uppos2_req_res + uppos_req_res + emp_req_res>
    </cfif> 
    <cfif len(attributes.emp_req_weight)>
        <cfset req_type_result = req_type_score * attributes.emp_req_weight / 100>
    </cfif>
    <cfquery name="UPD_perform_target" datasource="#dsn#">
        UPDATE
            EMPLOYEE_PERFORMANCE_TARGET
        SET	
            REQ_TYPE_LIST=<cfif listlen(attributes.req_type_list,',')><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.req_type_list#"><cfelse>NULL</cfif>,
            DEP_MANAGER_REQ_TYPE=<cfif listlen(attributes.dep_req_type_list,',')><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dep_req_type_list#"><cfelse>NULL</cfif>,
            COACH_REQ_TYPE=<cfif listlen(attributes.coach_req_type_list,',')><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.coach_req_type_list#"><cfelse>NULL</cfif>,
            STD_REQ_TYPE=<cfif listlen(attributes.std_req_type_list,',')><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.std_req_type_list#"><cfelse>NULL</cfif>,
            PERFORM_POINT = <cfqueryparam cfsqltype="cf_sql_float" value="#puan#">,
            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        WHERE
            PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
    </cfquery> 
    <cfset emp_perf_result = target_result + req_type_result>
    <cfif len(attributes.emp_performance_weight2)>
        <cfset emp_perf_result2 = emp_perf_result * emp_performance_weight2 /100>
    </cfif>
    <cfif len(attributes.comp_target_wght) and len(attributes.comp_performance_result)>
        <cfset comp_perf_result = attributes.comp_target_wght * attributes.comp_performance_result /100>
    </cfif>
    <cfset perf_result = emp_perf_result2 + comp_perf_result>
    <cfif attributes.is_stage eq 1 and ((isdefined('attributes.valid_1') and len(attributes.valid_1)) or (isdefined('attributes.valid_2') and len(attributes.valid_2)) or (isdefined('attributes.valid_3') and len(attributes.valid_3)) or (isdefined('attributes.valid_4') and len(attributes.valid_4)) or (isdefined('attributes.valid_5') and len(attributes.valid_5)))>
        <cfquery name="get_valids" datasource="#dsn#">
                SELECT VALID_1,VALID_2,VALID_3,VALID_4,VALID_5 FROM EMPLOYEE_PERFORMANCE WHERE PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
            </cfquery>
        <cfquery name="get_our_company" datasource="#dsn#">
            SELECT EMAIL FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfset sender = get_our_company.email>
		<cfif isdefined('attributes.valid_1') and len(attributes.valid_1) and attributes.valid_1 eq 1 and get_valids.VALID_1 neq attributes.valid_1>
			<cfif attributes.is_consultant eq 1 and len(attributes.chief3_code) and attributes.valid_2 neq 1>
                <cfset next_stage = 'consultant'>
            <cfelseif attributes.is_upper_position eq 1 and len(attributes.upper_position_code) and attributes.valid_3 neq 1>
                <cfset next_stage = 'upper_position'>
            <cfelseif attributes.is_mutual_assessment eq 1 and len(attributes.upper_position_code) and attributes.valid_4 neq 1>
                <cfset next_stage = 'mutual_assessment'>
            <cfelseif attributes.is_upper_position2 eq 1 and len(attributes.upper_position_code2) and attributes.valid_5 neq 1>
                <cfset next_stage = 'upper_position2'>
            <cfelse>
                <cfset next_stage = 'last_stage'>
            </cfif>       
        <cfelseif isdefined('attributes.valid_2') and len(attributes.valid_2) and attributes.valid_2 eq 1 and get_valids.VALID_2 neq attributes.valid_2>
			<cfif attributes.is_upper_position eq 1 and len(attributes.upper_position_code) and attributes.valid_3 neq 1>
                <cfset next_stage = 'upper_position'>
            <cfelseif attributes.is_mutual_assessment eq 1 and len(attributes.upper_position_code) and attributes.valid_4 neq 1>
                <cfset next_stage = 'mutual_assessment'>
            <cfelseif attributes.is_upper_position2 eq 1 and len(attributes.upper_position_code2) and attributes.valid_5 neq 1>
                <cfset next_stage = 'upper_position2'>
            <cfelse>
                <cfset next_stage = 'last_stage'>
            </cfif>
        <cfelseif isdefined('attributes.valid_3') and len(attributes.valid_3) and attributes.valid_3 eq 1 and get_valids.VALID_3 neq attributes.valid_3>
			<cfif attributes.is_mutual_assessment eq 1 and len(attributes.upper_position_code) and attributes.valid_4 neq 1>
				<cfset next_stage = 'mutual_assessment'>
			<cfelseif attributes.is_upper_position2 eq 1 and len(attributes.upper_position_code2) and attributes.valid_5 neq 1>
				<cfset next_stage = 'upper_position2'>
			<cfelse>
				<cfset next_stage = 'last_stage'>
			</cfif>
        <cfelseif isdefined('attributes.valid_4') and len(attributes.valid_4) and attributes.valid_4 eq 1 and get_valids.VALID_4 neq attributes.valid_4>
			<cfif attributes.is_upper_position2 eq 1 and len(attributes.upper_position_code2) and attributes.valid_5 neq 1>
				<cfset next_stage = 'upper_position2'>
			<cfelse>
				<cfset next_stage = 'last_stage'>
			</cfif>
        <cfelseif isdefined('attributes.valid_5') and len(attributes.valid_5) and attributes.valid_5 eq 1 and get_valids.VALID_5 neq attributes.valid_5>
			<cfset next_stage = 'last_stage'>
        </cfif>
        <cfif isdefined('next_stage') and next_stage eq 'last_stage'>
        	<cfquery name="get_emp_mail" datasource="#dsn#">
                SELECT 
                    E.EMPLOYEE_EMAIL,
                    E.EMPLOYEE_SURNAME,
                    E.EMPLOYEE_ID,
                    E.EMPLOYEE_NAME
                FROM 
                    EMPLOYEES E
                WHERE 
                    E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND 
                    NOT (E.EMPLOYEE_EMAIL IS NULL OR E.EMPLOYEE_EMAIL = '')
            </cfquery>
            <cfif get_emp_mail.recordcount>
                <cfmail charset="utf-8" to="#get_emp_mail.employee_email#" from="#sender#" subject="Performans Değerlendirme" type="HTML">
                       Sayın #get_emp_mail.employee_name# #get_emp_mail.employee_surname#,<br/><br/>
						Performans değerlendirmeniz tamamlanmıştır.<br/>
                        Değerlendirme ile ilgili görüşlerinizi belirtip formunuzu kaydetmenizi rica ederiz.<br/><br/>
                        <a href="#employee_domain##request.self#?fuseaction=myhome.list_target_perf">Performans Formu</a> <br/><br/>
                        Herhangi bir sorunla karşılaşmanız durumunda lütfen İnsan Kaynakları' na başvurunuz.<br/><br/>
                    </cfmail>
            </cfif>
        <cfelseif isdefined('next_stage') and next_stage eq 'consultant'>
            <cfif len(attributes.chief3_code)>
                <cfquery name="get_emp_mail" datasource="#dsn#">
                    SELECT 
                        E.EMPLOYEE_EMAIL,
                        E.EMPLOYEE_SURNAME,
                        E.EMPLOYEE_ID,
                        E.EMPLOYEE_NAME,
                        EP.POSITION_NAME
                    FROM 
                        EMPLOYEES E LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER=1
                    WHERE 
                        EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chief3_code#"> AND 
                        NOT (E.EMPLOYEE_EMAIL IS NULL OR E.EMPLOYEE_EMAIL = '')
                </cfquery>
                <cfif get_emp_mail.recordcount>
                    <cfmail charset="utf-8" to="#get_emp_mail.employee_email#" from="#sender#" subject="Performans Değerlendirme" type="HTML">
                       Sayın #get_emp_mail.employee_name# #get_emp_mail.employee_surname#,<br/><br/>
						#get_emp.employee_name# #get_emp.employee_surname# adlı çalışanın performans değerlendirmesini doldurunuz.<br/><br/>
                        <a href="#employee_domain##request.self#?fuseaction=myhome.list_target_perf">Performans Formu</a> <br/><br/>
                        Herhangi bir sorunla karşılaşmanız durumunda lütfen İnsan Kaynakları' na başvurunuz.<br/><br/>
                    </cfmail>
                </cfif>
            </cfif>
        <cfelseif isdefined('next_stage') and (next_stage eq 'upper_position' or next_stage eq 'mutual_assessment')>
            <cfif len(attributes.upper_position_code)>
                <cfquery name="get_emp_mail" datasource="#dsn#">
                    SELECT 
                        E.EMPLOYEE_EMAIL,
                        E.EMPLOYEE_SURNAME,
                        E.EMPLOYEE_ID,
                        E.EMPLOYEE_NAME,
                        EP.POSITION_NAME
                    FROM 
                        EMPLOYEES E LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER=1
                    WHERE 
                        EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#"> AND 
                        NOT (E.EMPLOYEE_EMAIL IS NULL OR E.EMPLOYEE_EMAIL = '')
                </cfquery>
                <cfif get_emp_mail.recordcount>
                    <cfmail charset="utf-8" to="#get_emp_mail.employee_email#" from="#sender#" subject="Performans Değerlendirme" type="HTML">
                       Sayın #get_emp_mail.employee_name# #get_emp_mail.employee_surname#,<br/><br/>
						#get_emp.employee_name# #get_emp.employee_surname# adlı çalışanın performans değerlendirmesini doldurunuz.<br/><br/>
                        <a href="#employee_domain##request.self#?fuseaction=myhome.list_target_perf">Performans Formu</a> <br/><br/>
                        Herhangi bir sorunla karşılaşmanız durumunda lütfen İnsan Kaynakları' na başvurunuz.<br/><br/>
                    </cfmail>
                </cfif>
            </cfif>
        <cfelseif isdefined('next_stage') and next_stage eq 'upper_position2'>
            <cfif len(attributes.upper_position_code2)>
                <cfquery name="get_emp_mail" datasource="#dsn#">
                    SELECT 
                        E.EMPLOYEE_EMAIL,
                        E.EMPLOYEE_SURNAME,
                        E.EMPLOYEE_ID,
                        E.EMPLOYEE_NAME,
                        EP.POSITION_NAME
                    FROM 
                        EMPLOYEES E LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER=1
                    WHERE 
                        EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code2#"> AND 
                        NOT (E.EMPLOYEE_EMAIL IS NULL OR E.EMPLOYEE_EMAIL = '')
                </cfquery>
                <cfif get_emp_mail.recordcount>
                    <cfmail charset="utf-8" to="#get_emp_mail.employee_email#" from="#sender#" subject="Performans Değerlendirme" type="HTML">
                       Sayın #get_emp_mail.employee_name# #get_emp_mail.employee_surname#,<br/><br/>
						#get_emp.employee_name# #get_emp.employee_surname# adlı çalışanın performans değerlendirmesini doldurunuz.<br/><br/>
                        <a href="#employee_domain##request.self#?fuseaction=myhome.list_target_perf">Performans Formu</a> <br/><br/>
                        Herhangi bir sorunla karşılaşmanız durumunda lütfen İnsan Kaynakları' na başvurunuz.<br/><br/>
                    </cfmail>
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <cfquery name="upd_performance" datasource="#DSN#">
        UPDATE
            EMPLOYEE_PERFORMANCE
        SET
            MANAGER_1_COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.manager1_comment#">,
            MANAGER_2_COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.manager2_comment#">,
            EMPLOYEE_COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.emp_comment#">,
            CONSULTANT_COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consultant_comment#">,
            POWERFUL_ASPECTS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.powerful_aspects#">,
            TRAIN_NEED_ASPECTS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.train_need_aspects#">,
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_KEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userkey#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            TARGET_SCORE = <cfif len(target_score)><cfqueryparam cfsqltype="cf_sql_float" value="#target_score#"><cfelse>NULL</cfif>,
            EMP_TARGET_RESULT = <cfif len(target_result)><cfqueryparam cfsqltype="cf_sql_float" value="#target_result#"><cfelse>NULL</cfif>,
            REQ_TYPE_SCORE = <cfif len(req_type_score)><cfqueryparam cfsqltype="cf_sql_float" value="#req_type_score#"><cfelse>NULL</cfif>,
            EMP_REQ_TYPE_RESULT = <cfif len(req_type_result)><cfqueryparam cfsqltype="cf_sql_float" value="#req_type_result#"><cfelse>NULL</cfif>,
            EMP_PERF_RESULT = <cfif len(emp_perf_result)><cfqueryparam cfsqltype="cf_sql_float" value="#emp_perf_result#"><cfelse>NULL</cfif>,
            EMP_PERF_RESULT2 = <cfif len(emp_perf_result2)><cfqueryparam cfsqltype="cf_sql_float" value="#emp_perf_result2#"><cfelse>NULL</cfif>,
            COMP_PERF_RESULT = <cfif len(comp_perf_result)><cfqueryparam cfsqltype="cf_sql_float" value="#comp_perf_result#"><cfelse>NULL</cfif>,
            PERF_RESULT = <cfif len(perf_result)><cfqueryparam cfsqltype="cf_sql_float" value="#perf_result#"><cfelse>NULL</cfif>,
            DEPARTMENT_ID = <cfif len(emp_dep_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_dep_id#"><cfelse>NULL</cfif>,
            POSITION_CAT_ID =<cfif len(pos_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#pos_cat#"><cfelse>NULL</cfif>,
            COMP_ID = <cfif len(emp_comp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_comp_id#"><cfelse>NULL</cfif>,
            BRANCH_ID = <cfif len(emp_branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_branch_id#"><cfelse>NULL</cfif>,
            TITLE_ID = <cfif len(emp_title_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_title_id#"><cfelse>NULL</cfif>,
            FUNC_ID = <cfif len(emp_func_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_func_id#"><cfelse>NULL</cfif>,
            IS_CLOSED = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_closed#">,
            STAGE = <cfif isdefined('attributes.process_stage')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>
            <cfif isdefined('attributes.valid') and len(attributes.valid)>
                ,VALID = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.valid#">
            </cfif>
            <cfif isdefined('attributes.valid_1') and len(attributes.valid_1)>
                ,VALID_1 = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.valid_1#">
                ,VALID_1_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ,VALID_1_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            </cfif>
            <cfif isdefined('attributes.valid_2') and len(attributes.valid_2)>
                ,VALID_2 = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.valid_2#">
                ,VALID_2_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ,VALID_2_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            </cfif>
            <cfif isdefined('attributes.valid_3') and len(attributes.valid_3)>
                ,VALID_3 = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.valid_3#">
                ,VALID_3_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ,VALID_3_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            </cfif>
            <cfif isdefined('attributes.valid_4') and len(attributes.valid_4)>
                ,VALID_4 = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.valid_4#">
                ,VALID_4_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ,VALID_4_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            </cfif>
            <cfif isdefined('attributes.valid_5') and len(attributes.valid_5)>
                ,VALID_5 = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.valid_5#">
                ,VALID_5_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ,VALID_5_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            </cfif>
        WHERE
            PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
    </cfquery>
<cfelse>
	<cfquery name="upd_performance" datasource="#DSN#">
        UPDATE
            EMPLOYEE_PERFORMANCE
        SET
            <cfif attributes.upper_position_code2 eq session.ep.position_code>
                MANAGER_2_COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.manager2_comment#">,
            <cfelseif attributes.chief3_code eq session.ep.position_code>
                CONSULTANT_COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consultant_comment#">,
            </cfif>
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_KEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userkey#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
        WHERE
            PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
   	</cfquery>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='EMPLOYEE_PERFORMANCE'
	action_column='PER_ID'
	action_id='#attributes.per_id#' 
	action_page='#request.self#?fuseaction=#fusebox.circuit#.list_target_perf&event=upd&per_id=#attributes.per_id#&pos_code=#attributes.pos_code#' 
	warning_description='Hedef Yetkinlik Değerlendirme'>
<cfif fusebox.circuit eq 'myhome'>
	<cfset attributes.per_id = contentEncryptingandDecodingAES(isEncode:1,content:attributes.per_id,accountKey:'wrk') >
	<cfset attributes.pos_code = contentEncryptingandDecodingAES(isEncode:1,content:attributes.pos_code,accountKey:'wrk') >
</cfif>
<cfif isdefined('next_stage') and len(next_stage)>
	<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.list_target_perf" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.list_target_perf&event=upd&per_id=#attributes.per_id#&pos_code=#attributes.pos_code#" addtoken="no">
</cfif>
