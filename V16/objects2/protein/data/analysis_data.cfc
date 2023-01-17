<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset company_id = session.pp.our_company_id>
        <cfset period_year = session.pp.period_year>
        <cfset language = session.pp.language>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
        <cfset company_id = session.ep.our_company_id>
        <cfset period_year = session.ep.period_year>
        <cfset language = session.ep.language>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
        <cfset company_id = session.ww.our_company_id>
        <cfset period_year = session.ww.period_year>
        <cfset language = session.ww.language>
    <cfelse>
        <cfset session_base = evaluate('session.qq')>
        <cfset company_id = session.qq.our_company_id>
        <cfset period_year = session.qq.period_year>
        <cfset language = session.qq.language>
    </cfif>    

    <cfset dsn1_alias = "#dsn#_product">
    <cfset dsn_alias = '#dsn#'>
    <cfset dsn2 = dsn2_alias = '#dsn#_#session_base.period_year#_#session_base.OUR_COMPANY_ID#' />
    <cfset dsn3 = dsn3_alias = '#dsn#_#session_base.OUR_COMPANY_ID#' />

    <cffunction name="GET_ANALYSIS" access="remote">
        
        <cfquery name="GET_ANALYSIS" datasource="#DSN#">
            SELECT 
                ANALYSIS_HEAD,
                ANALYSIS_ID,
                ANALYSIS_OBJECTIVE,
                ANALYSIS_AVERAGE,
                ANALYSIS_STAGE,
                TOTAL_POINTS,
                PRODUCT_ID,
                COMMENT1,
                COMMENT2,
                COMMENT3,
                COMMENT4,
                COMMENT5,
                RECORD_EMP,
                RECORD_DATE,
                ANALYSIS_PARTNERS,
                ANALYSIS_CONSUMERS,
                ANALYSIS_RIVALS,
                IS_ACTIVE,
                IS_PUBLISHED,
                LANGUAGE_SHORT,
                UPDATE_EMP,
                UPDATE_DATE
                <cfloop from="1" to="5" index="i">
                    ,SCORE#i#
                </cfloop>		
            FROM 
                MEMBER_ANALYSIS 
           WHERE 
                ANALYSIS_ID = #arguments.analysis_id#
        </cfquery>
        
        <cfreturn GET_ANALYSIS>
    </cffunction>
    

    <cffunction name="GET_QUESTION_ANSWERS" access="remote">
        
        <cfquery name="GET_QUESTION_ANSWERS" datasource="#DSN#">
            SELECT
                QUESTION_ANSWER_ID,
                QUESTION_ID,
                ANSWER_TEXT,
                ANSWER_INFO,
                ANSWER_POINT,
                ANSWER_PHOTO,
                ANSWER_PHOTO_SERVER_ID,
                ANSWER_PRODUCT_ID,
                ROW
            FROM
                MEMBER_QUESTION_ANSWERS
            WHERE
                QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_id#"> 
            ORDER BY
                QUESTION_ANSWER_ID
        </cfquery>

        <cfreturn GET_QUESTION_ANSWERS>
    </cffunction>

    <cffunction name="GET_ANALYSIS_QUESTIONS" access="remote">        
        <cfquery name="GET_ANALYSIS_QUESTIONS" datasource="#DSN#">
            SELECT 
                QUESTION_ID,
                QUESTION,
                ANSWER_NUMBER,
                QUESTION_TYPE,
                ANALYSIS_ID,
                QUESTION_INFO,
                QUESTION_TYPE
            FROM 
                MEMBER_QUESTION 
            WHERE 
                ANALYSIS_ID IS NOT NULL
                <cfif isdefined("arguments.analysis_id") and len(arguments.analysis_id)>
                    AND ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analysis_id#"> 
                </cfif>
                <cfif isdefined("arguments.question_id") and len(arguments.question_id)>
                    AND QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_id#">
                </cfif>
            ORDER BY 
                QUESTION_ID
        </cfquery>
        
        <cfreturn GET_ANALYSIS_QUESTIONS>
    </cffunction>

    <cffunction name="QUESTION_TYPE_TEXT" access="remote">        
        <cfquery name="QUESTION_TYPE_TEXT" datasource="#DSN#">
            SELECT 
                QUESTION_ID,
                QUESTION,
                ANSWER_NUMBER,
                QUESTION_TYPE,
                ANALYSIS_ID,
                QUESTION_INFO,
                QUESTION_TYPE
            FROM 
                MEMBER_QUESTION 
			WHERE 
                QUESTION_TYPE = 3
        </cfquery>
        

        <cfreturn QUESTION_TYPE_TEXT>
    </cffunction>       

    <cffunction name="ADD_RESULT" access="remote" returntype="string" returnformat="json">        
        <cftry>            
            <cftransaction>  
            
                <cfquery name="GET_ANALYSIS" datasource="#DSN#">
                    SELECT 
                       *	
                    FROM 
                         MEMBER_ANALYSIS
                   WHERE 
                        ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analysis_id#"> 
                </cfquery>

                <cfquery name="GET_QUESTION_COUNT" datasource="#DSN#">
                    SELECT 
                    *	
                    FROM 
                        MEMBER_QUESTION
                    WHERE 
                        ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analysis_id#"> 
                </cfquery>
               
                <cfquery name="ADD_RESULT" datasource="#DSN#" result="MAX_ID">
                    INSERT INTO
                        MEMBER_ANALYSIS_RESULTS
                    (   
                        ANALYSIS_ID,
                        ATTENDANCE_NAME,
                        ATTENDANCE_MAIL,
                        ATTENDANCE_COMPANY,
                        ATTENDANCE_JOB,
                        COMPANY_ID,
                        RECORD_DATE,	
                        RECORD_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value=#arguments.analysis_id#>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments.attendance_name#'>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments.attendance_mail#'>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments.attendance_company#'>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments.attendance_job#'>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value='#arguments.is_company_id#'>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
                </cfquery>                

                 <cfquery name="ADD_RESULT" datasource="#DSN#">
                    UPDATE
                        MEMBER_ANALYSIS_RESULTS
                    SET
                        USER_POINT = #arguments.sum_point#,
                        AVERAGE = #get_analysis.analysis_average#,
                        QUESTION_COUNT = #GET_QUESTION_COUNT.recordCount#
                    WHERE
                        RESULT_ID = #MAX_ID.IDENTITYCOL#
                </cfquery>             
                <cfset get_analysis_question_ = this.GET_ANALYSIS_QUESTIONS(analysis_id: arguments.analysis_id)>
                <cfset puan = 0>
                
                <cfoutput query="get_analysis_questions">
                   
                    <cfset puan0 = 0>
                    <cfif isdefined("arguments.user_answer_#currentrow#") and isArray(evaluate('arguments.user_answer_'&currentrow))>
                        <cfset list_answers = ArrayToList(evaluate('arguments.user_answer_'&currentrow))>
                    <cfelseif isdefined("arguments.user_answer_#currentrow#") and isStruct(evaluate('arguments.user_answer_'&currentrow))>
                        <cfset list_answers = StructKeyList(evaluate('arguments.user_answer_'&currentrow))>
                    <cfelseif isdefined("arguments.user_answer_#currentrow#")>
                        <cfset list_answers = evaluate('arguments.user_answer_'&currentrow)>
                    </cfif>
                    <cfif isdefined("arguments.user_answer_#currentrow#") and isdefined("arguments.user_answer_#currentrow#_point") and len(list_answers) and get_analysis_questions.question_type neq 3>
                        <cfloop list="#list_answers#"  index="aaa">
                            <cfset puan0 = puan0 + aaa>
                        </cfloop>
                        <cfif isDefined("arguments.user_answer_#currentrow#")>
                            <cfset temp_user_answer =list_answers>
                            <cfquery name="ADD_RESULT_DETAIL" datasource="#DSN#">
                                INSERT INTO
                                    MEMBER_ANALYSIS_RESULTS_DETAILS
                                (
                                    RESULT_ID,
                                    QUESTION_ID,
                                    QUESTION_POINT,
                                    QUESTION_USER_ANSWERS
                                )
                                VALUES
                                (
                                    #MAX_ID.IDENTITYCOL#,
                                    #get_analysis_questions.question_id#,
                                    #puan0#,
                                    '#temp_user_answer#'
                                )
                            </cfquery>
                        </cfif>
                    <cfelse>
                    <!--- acik uclu soru ise kaydi yapiliyor --->
                        <cfif isDefined("arguments.user_answer_#currentrow#")>
                            <cfset temp_user_answer = evaluate("arguments.user_answer_#currentrow#")>
                            <cfquery name="ADD_RESULT_DETAIL" datasource="#DSN#">
                                INSERT INTO
                                    MEMBER_ANALYSIS_RESULTS_DETAILS
                                (
                                    RESULT_ID,
                                    QUESTION_ID,
                                    QUESTION_POINT,
                                    QUESTION_USER_ANSWERS
                                )
                                VALUES
                                (
                                    #MAX_ID.IDENTITYCOL#,
                                    #get_analysis_questions.question_id#,
                                    0,
                                    '#temp_user_answer#'
                                )
                            </cfquery>
                        </cfif>
                    </cfif>
                  
                </cfoutput>  
            </cftransaction> 

            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            <cfset result.identity = max_id.identitycol>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>