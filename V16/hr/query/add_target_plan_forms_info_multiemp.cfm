<cfif not isdefined('attributes.to_emp_ids')>
	<script type="text/javascript">
		alert('Lütfen Çalışan Seçiniz!');
		history.go(-1);
	</script>
    <cfabort>
</cfif>

<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfloop list="#attributes.to_emp_ids#" delimiters="," index="j">
    <cfquery name="get_per_form" datasource="#DSN#">
        SELECT 
            EP.PER_ID,
            E.EMPLOYEE_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM 
            EMPLOYEE_PERFORMANCE EP
                INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMP_ID
        WHERE 
            ((EP.START_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#) OR (EP.FINISH_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#)) AND
            EP.EMP_ID = #j# AND
            EP.PER_TYPE=2
    </cfquery>
    <cfif get_per_form.recordcount>
		<div class="bold">
            <cf_get_lang no ='1741.Tarih aralığında çalışan için form eklenmiştir'>:<cfoutput>#get_per_form.employee_name# #get_per_form.employee_surname#<br></cfoutput>
        </div>
        <cfcontinue>
    <cfelse>
        <cfquery name="GET_AMIR_ALL" datasource="#DSN#">
            SELECT 
                POSITION_CODE,
                EMPLOYEE_ID,
                UPPER_POSITION_CODE,
                IS_MASTER
            FROM
                EMPLOYEE_POSITIONS
        </cfquery>
        <cflock name="CreateUUID()" timeout="30">
            <cftransaction>
                <cfloop from="1" to="#listlen(attributes.to_emp_ids,',')#" index="i">
                    <cfquery name="ADD_QUIZ_RESULT" datasource="#DSN#">
                        INSERT INTO
                            EMPLOYEE_QUIZ_RESULTS
                        (
                            TARGET_PLAN_ID,
                            POSITION_CODE,
                            QUIZ_ID,
                            EMP_ID,
                            USER_POINT,
                            START_DATE,
                            FINISH_DATE
                        )
                        VALUES
                        (
                            NULL,
                            #listgetat(attributes.to_pos_codes,i,',')#,
                            NULL,
                            #listgetat(attributes.to_emp_ids,i,',')#,
                            0,
                            #attributes.start_date#,
                            #attributes.finish_date#
                        )
                    </cfquery>
                    
                    <cfquery name="GET_RESULT" datasource="#DSN#">
                        SELECT MAX(RESULT_ID) AS MAX_RESULT_ID FROM EMPLOYEE_QUIZ_RESULTS WHERE EMP_ID = #listgetat(attributes.to_emp_ids,i,',')#
                    </cfquery> 

                    <cfquery name="get_per_form1" datasource="#DSN#">
                        SELECT 
                            EP.PER_ID,
                            E.EMPLOYEE_ID,
                            E.EMPLOYEE_NAME,
                            E.EMPLOYEE_SURNAME
                        FROM 
                            EMPLOYEE_PERFORMANCE EP
                                INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMP_ID
                        WHERE 
                            ((EP.START_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#) OR (EP.FINISH_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#)) AND
                            EP.EMP_ID = #listgetat(attributes.to_emp_ids,i,',')# AND
                            EP.PER_TYPE=2
                    </cfquery>
                    <cfif get_per_form1.recordcount>
                        <cfcontinue>
                    <cfelse>
                        <cfquery name="add_perform" datasource="#DSN#">
                            INSERT INTO
                                EMPLOYEE_PERFORMANCE
                            (
                                EMP_ID,
                                PER_TYPE,
                                POSITION_CODE,
                                TARGET_PLAN_ID,
                                EMP_POSITION_NAME,
                                START_DATE,
                                FINISH_DATE,
                                EVAL_DATE,
                                RESULT_ID,
                                RECORD_TYPE,
                                RECORD_KEY,
                                RECORD_IP,
                                RECORD_DATE,
                                STAGE
                            )
                            VALUES
                            (
                                #listgetat(attributes.to_emp_ids,i,',')#,
                                2,
                                #listgetat(attributes.to_pos_codes,i,',')#,
                                NULL,
                                <cfif len(listgetat(attributes.to_pos_codes,i,','))>
                                (SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #listgetat(attributes.to_pos_codes,i,',')#),
                                <cfelse>
                                NULL,
                                </cfif>
                                #attributes.start_date#,
                                #attributes.finish_date#,
                                #now()#,
                                #GET_RESULT.MAX_RESULT_ID#,
                                1,
                                '#SESSION.EP.USERKEY#',
                                '#CGI.REMOTE_ADDR#',
                                #now()#,
                                <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>
                            )
                        </cfquery> 
                    </cfif>
                    <cfquery name="get_perform" datasource="#DSN#">
                        SELECT MAX(PER_ID) AS MAX_PER_ID FROM EMPLOYEE_PERFORMANCE WHERE EMP_ID = #listgetat(attributes.to_emp_ids,i,',')#
                    </cfquery>

                    <cfquery name="GET_EMP" dbtype="query">
                        SELECT 
                            POSITION_CODE,
                            EMPLOYEE_ID,
                            UPPER_POSITION_CODE
                        FROM
                            GET_AMIR_ALL
                        WHERE
                            IS_MASTER = 1 AND 
                            EMPLOYEE_ID = #listgetat(attributes.to_emp_ids,i,',')#
                    </cfquery>
            
                    <cfset amir_list="">
                    <cfset amir_pos_list="">
                    <cfloop from="1" to="6" index="i">
                        <cfif not len(get_emp.upper_position_code) or get_emp.upper_position_code eq 0>
                            <cfbreak>
                        </cfif>
                        <cfquery name="GET_EMP" dbtype="query">
                            SELECT 
                                POSITION_CODE,
                                EMPLOYEE_ID,
                                UPPER_POSITION_CODE
                            FROM
                                GET_AMIR_ALL
                            WHERE
                                POSITION_CODE = #get_emp.upper_position_code#
                        </cfquery>
                        <cfif len(get_emp.employee_id) and get_emp.employee_id gt 0>
                            <cfset amir_list = listappend(amir_list,get_emp.employee_id,',')>
                            <cfif len(get_emp.position_code)>
                                <cfset amir_pos_list = listappend(amir_pos_list,get_emp.position_code,',')>
                            <cfelse>
                                <cfset amir_pos_list = listappend(amir_pos_list,0,',')>
                            </cfif>
                        </cfif>
                    </cfloop>

                    <cfquery name="add_perform_target" datasource="#DSN#">
                        INSERT INTO
                            EMPLOYEE_PERFORMANCE_TARGET
                        (
                            PER_ID,
                            IS_COACH,
                            IS_DEP_ADMIN,
                            FIRST_BOSS_ID,
                            FIRST_BOSS_CODE,
                            SECOND_BOSS_ID,
                            SECOND_BOSS_CODE,
                            THIRD_BOSS_ID,
                            THIRD_BOSS_CODE,
                            FOURTH_BOSS_ID,
                            FOURTH_BOSS_CODE,
                            FIFTH_BOSS_ID,
                            FIFTH_BOSS_CODE,
                            RECORD_EMP,
                            RECORD_IP,
                            RECORD_DATE
                        )
                        VALUES
                        (
                            #get_perform.max_per_id#,
                            <cfif isdefined("attributes.is_coach") and attributes.is_coach eq 1>1<cfelse>0</cfif>,
                            <cfif isdefined("attributes.is_dep_admin") and attributes.is_dep_admin eq 1>1<cfelse>0</cfif>,
                            <cfif listlen(amir_list,',') gte 1>#ListGetAt(amir_list,1,',')#<cfelse>NULL</cfif>,
                            <cfif listlen(amir_pos_list,',') gte 1 and listgetat(amir_pos_list,1,',') gt 0>#listgetat(amir_pos_list,1,',')#<cfelse>NULL</cfif>,
                            <cfif listlen(amir_list,',') gte 2>#ListGetAt(amir_list,2,',')#<cfelse>NULL</cfif>,
                            <cfif listlen(amir_pos_list,',') gte 2 and listgetat(amir_pos_list,2,',') gt 0>#listgetat(amir_pos_list,2,',')#<cfelse>NULL</cfif>,
                            <cfif listlen(amir_list,',') gte 3>#ListGetAt(amir_list,3,',')#<cfelse>NULL</cfif>,
                            <cfif listlen(amir_pos_list,',') gte 3 and listgetat(amir_pos_list,3,',') gt 0>#listgetat(amir_pos_list,3,',')#<cfelse>NULL</cfif>,
                            <cfif listlen(amir_list,',') gte 4>#ListGetAt(amir_list,4,',')#<cfelse>NULL</cfif>,
                            <cfif listlen(amir_pos_list,',') gte 4 and listgetat(amir_pos_list,4,',') gt 0>#listgetat(amir_pos_list,4,',')#<cfelse>NULL</cfif>,
                            <cfif listlen(amir_list,',') gte 5>#ListGetAt(amir_list,5,',')#<cfelse>NULL</cfif>,
                            <cfif listlen(amir_pos_list,',') gte 5 and listgetat(amir_pos_list,5,',') gt 0>#listgetat(amir_pos_list,5,',')#<cfelse>NULL</cfif>,
                            #session.ep.userid#,
                            '#cgi.remote_addr#',
                            #now()#
                        )
                    </cfquery>
                </cfloop>
            </cftransaction>
        </cflock>
    </cfif>
</cfloop>
<cf_get_lang dictionary_id='58156.Diğer'><cf_get_lang dictionary_id='29768.Formlar'><cf_get_lang dictionary_id='33728.Eklendi'>