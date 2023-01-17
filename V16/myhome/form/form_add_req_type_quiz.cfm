<cfinclude template="../query/target_perf_control.cfm">
<cfquery name="GET_PERFORMANCE" datasource="#dsn#">
    SELECT 
        EPT.*,
        EP.RESULT_ID,
        EP.START_DATE,
        EP.FINISH_DATE
    FROM 
        EMPLOYEE_PERFORMANCE_TARGET EPT,
        EMPLOYEE_PERFORMANCE EP
    WHERE 
        EPT.PER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
        AND EP.PER_ID=EPT.PER_ID
</cfquery>
<cfquery name="GET_EMP" datasource="#dsn#">
    SELECT
        EP.EMPLOYEE_ID, 
        EP.POSITION_CODE,
        EP.EMPLOYEE_NAME,
        EP.EMPLOYEE_SURNAME,
        EP.POSITION_NAME,
        EP.POSITION_CAT_ID,
        EP.TITLE_ID,
        EP.FUNC_ID,
        EP.ORGANIZATION_STEP_ID,
        D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD,
        B.BRANCH_NAME,
        OC.COMPANY_NAME,
        B.BRANCH_ID,
        OC.COMP_ID
    FROM
        EMPLOYEE_POSITIONS EP,
        DEPARTMENT D,
        BRANCH B,
        OUR_COMPANY OC
    WHERE 
        POSITION_CODE= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#"> AND
        EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND
        B.BRANCH_ID=D.BRANCH_ID AND
        OC.COMP_ID=B.COMPANY_ID
</cfquery>
<cfset pos_cat=GET_EMP.POSITION_CAT_ID>
<cfset EMP_DEP_ID=GET_EMP.DEPARTMENT_ID>
<cfset emp_comp_id=GET_EMP.COMP_ID>
<cfset emp_func_id=GET_EMP.FUNC_ID>
<cfset emp_org_step_id=GET_EMP.ORGANIZATION_STEP_ID>
<cfset emp_branch_id=GET_EMP.BRANCH_ID>
<cfset emp_title_id=GET_EMP.TITLE_ID>
<cfif listlen(GET_PERFORMANCE.REQ_TYPE_LIST,',')>
	<cfset yetkinlik_list_all=GET_PERFORMANCE.REQ_TYPE_LIST&','&GET_PERFORMANCE.DEP_MANAGER_REQ_TYPE&','&GET_PERFORMANCE.COACH_REQ_TYPE&','&GET_PERFORMANCE.STD_REQ_TYPE>
    <cfset yetkinlik_list=GET_PERFORMANCE.REQ_TYPE_LIST>
    <cfset kocluk_yetkinlik_list=GET_PERFORMANCE.COACH_REQ_TYPE>
    <cfset dep_yetkinlik_list=GET_PERFORMANCE.DEP_MANAGER_REQ_TYPE>
    <cfset std_yetkinlik_list=GET_PERFORMANCE.STD_REQ_TYPE>
<cfelse>
    <cfquery name="GET_EMP_REQ" datasource="#dsn#">
        SELECT 
            T1.REQ_TYPE_ID,
            T1.REQ_TYPE,
            T1.IS_GROUP
        FROM (
            SELECT 
                *,
                ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 1 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_COMPANY,
                (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 1 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_comp_id)>#emp_comp_id#<cfelse>NULL</cfif>) AS COMPANY_ID,
                ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 2 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_DEPARTMENT,
                (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 2 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(EMP_DEP_ID)>#EMP_DEP_ID#<cfelse>NULL</cfif>) AS DEPARTMENT_ID,
                ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 3 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_POS_CAT,
                (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 3 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(pos_cat)>#pos_cat#<cfelse>NULL</cfif>) AS POS_CAT_ID,
                ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 5 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_FUNC,
                (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 5 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_func_id)>#emp_func_id#<cfelse>NULL</cfif>) AS FUNC_ID,
                ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 6 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_ORG_STEP,
                (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 6 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_org_step_id)>#emp_org_step_id#<cfelse>NULL</cfif>) AS ORG_STEP_ID,
                ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 7 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_BRANCH,
                (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 7 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_branch_id)>#emp_branch_id#<cfelse>NULL</cfif>) AS BRANCH_ID,
                ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 10 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_TITLE,
                (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 10 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_title_id)>#emp_title_id#<cfelse>NULL</cfif>) AS TITLE_ID
            FROM 
                POSITION_REQ_TYPE,
                RELATION_SEGMENT RS
         	WHERE
            	RS.RELATION_TABLE='POSITION_REQ_TYPE'
            	<cfif len(GET_PERFORMANCE.START_DATE)>
					AND PERFECTION_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateformat(GET_PERFORMANCE.START_DATE,'yyyy')#">
            	</cfif>
        ) T1 
        WHERE 
            (IS_COMPANY > 0 OR IS_BRANCH > 0 OR IS_DEPARTMENT > 0 OR IS_POS_CAT > 0 OR IS_FUNC > 0 OR IS_ORG_STEP > 0 OR IS_TITLE > 0)
            AND
            (
                ((IS_COMPANY > 0 AND COMPANY_ID = <cfif len(emp_comp_id)>#emp_comp_id#<cfelse>NULL</cfif>) OR (IS_COMPANY = 0 AND COMPANY_ID IS NULL))
                AND
                ((IS_DEPARTMENT > 0 AND DEPARTMENT_ID = <cfif len(EMP_DEP_ID)>#EMP_DEP_ID#<cfelse>NULL</cfif>) OR (IS_DEPARTMENT = 0 AND DEPARTMENT_ID IS NULL))
                AND
                ((IS_BRANCH > 0 AND BRANCH_ID = <cfif len(emp_branch_id)>#emp_branch_id#<cfelse>NULL</cfif>) OR (IS_BRANCH = 0 AND BRANCH_ID IS NULL))
                AND
                ((IS_POS_CAT > 0 AND POS_CAT_ID = <cfif len(pos_cat)>#pos_cat#<cfelse>NULL</cfif>) OR (IS_POS_CAT = 0 AND POS_CAT_ID IS NULL))
                AND
                ((IS_FUNC > 0 AND FUNC_ID = <cfif len(emp_func_id)>#emp_func_id#<cfelse>NULL</cfif>) OR (IS_FUNC = 0 AND FUNC_ID IS NULL))
                AND
                ((IS_ORG_STEP > 0 AND ORG_STEP_ID = <cfif len(emp_org_step_id)>#emp_org_step_id#<cfelse>NULL</cfif>) OR (IS_ORG_STEP = 0 AND ORG_STEP_ID IS NULL))
                AND
                ((IS_TITLE > 0 AND TITLE_ID = <cfif len(emp_title_id)>#emp_title_id#<cfelse>NULL</cfif>) OR (IS_TITLE = 0 AND TITLE_ID IS NULL))
           )
        GROUP BY 
            T1.IS_GROUP,
			T1.REQ_TYPE_ID,
			T1.REQ_TYPE
        ORDER BY 
        	T1.IS_GROUP DESC
    </cfquery>
    <cfif GET_EMP_REQ.RECORDCOUNT>
    	<cfset yetkinlik_list=valuelist(GET_EMP_REQ.REQ_TYPE_ID,',')>
    <cfelse>
    	<cfset yetkinlik_list=0>
    </cfif>
    <!---<cfset yetkinlik_list_all=yetkinlik_list_all&','&yetkinlik_list>--->
    <cfset yetkinlik_list_all=yetkinlik_list>
    <cfset kocluk_yetkinlik_list=0>
    <!--- <cfif GET_PERFORMANCE.IS_COACH eq 1>
		<cfquery name="GET_REQ_WORK_GROUP" datasource="#DSN#">
			SELECT 
				REQ_TYPE_ID,
				REQ_TYPE
			FROM 
				POSITION_REQ_TYPE
			WHERE 
				IS_COACH=1
				<cfif len(GET_PERFORMANCE.START_DATE)>
					AND PERFECTION_YEAR = #dateformat(GET_PERFORMANCE.START_DATE,'yyyy')#
				</cfif>
		</cfquery>
		<cfif GET_REQ_WORK_GROUP.RECORDCOUNT>
			<cfset kocluk_yetkinlik_list=valuelist(GET_REQ_WORK_GROUP.REQ_TYPE_ID,',')>
		</cfif>
    </cfif>
    <cfset yetkinlik_list_all=yetkinlik_list&','&kocluk_yetkinlik_list> --->
    <cfset dep_yetkinlik_list=0>
    <!--- <cfif GET_PERFORMANCE.IS_DEP_ADMIN eq 1>
		<cfquery name="GET_REQ_DEP" datasource="#DSN#">
			SELECT 
				REQ_TYPE_ID,
				REQ_TYPE
			FROM 
				POSITION_REQ_TYPE
			WHERE 
				IS_DEP_ADMIN=1
				<cfif len(GET_PERFORMANCE.START_DATE)>
					AND PERFECTION_YEAR = #dateformat(GET_PERFORMANCE.START_DATE,'yyyy')#
				</cfif>
		</cfquery>
		<cfif GET_REQ_DEP.RECORDCOUNT>
			<cfset dep_yetkinlik_list=valuelist(GET_REQ_DEP.REQ_TYPE_ID,',')>
		</cfif>
    </cfif>
    <cfset yetkinlik_list_all=yetkinlik_list_all&','&dep_yetkinlik_list> --->
    <cfset std_yetkinlik_list=0>
    <!--- <cfif GET_PERFORMANCE.IS_COACH neq 1 and GET_PERFORMANCE.IS_DEP_ADMIN neq 1>
		<cfquery name="GET_REQ_DEP" datasource="#DSN#">
			SELECT 
				REQ_TYPE_ID,
				REQ_TYPE
			FROM 
				POSITION_REQ_TYPE
			WHERE 
				IS_STANDART=1
				<cfif len(GET_PERFORMANCE.START_DATE)>
					AND PERFECTION_YEAR = #dateformat(GET_PERFORMANCE.START_DATE,'yyyy')#
				</cfif>
		</cfquery>
		<cfif GET_REQ_DEP.RECORDCOUNT>
			<cfset std_yetkinlik_list=valuelist(GET_REQ_DEP.REQ_TYPE_ID,',')>
		</cfif>
    </cfif>
    <cfset yetkinlik_list_all=yetkinlik_list_all&','&std_yetkinlik_list> --->
</cfif>
<cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
    SELECT 
        EMPLOYEE_QUIZ_RESULTS_DETAILS.*, 
        EMPLOYEE_QUIZ_RESULTS.USER_POINT,
        '' AS RECORD_EMP,
        EMPLOYEE_QUIZ_RESULTS.RECORD_DATE,
        EMPLOYEE_QUIZ_RESULTS.UPDATE_EMP,
        EMPLOYEE_QUIZ_RESULTS.UPDATE_DATE
    FROM 
        EMPLOYEE_QUIZ_RESULTS_DETAILS, 
        EMPLOYEE_QUIZ_RESULTS
    WHERE
        EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID AND
        EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PERFORMANCE.RESULT_ID#">
</cfquery>
<div id="add_req_type_div">
	<!---<cf_popup_box title="#lang_array.item[1565]#">--->
    <cfform name="add_quiz" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_req_type_quiz">
        <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#attributes.position_code#</cfoutput>">
        <input type="hidden" name="result_id" id="result_id" value="<cfoutput>#GET_PERFORMANCE.RESULT_ID#</cfoutput>">
        <input type="hidden" name="per_id" id="per_id" value="<cfoutput>#GET_PERFORMANCE.PER_ID#</cfoutput>">
        <input type="hidden" name="all_req_type_id" id="all_req_type_id" value="<cfoutput>#yetkinlik_list_all#</cfoutput>">
        <input type="hidden" name="req_type_list" id="req_type_list" value="<cfoutput>#yetkinlik_list#</cfoutput>">
        <input type="hidden" name="coach_req_type_list" id="coach_req_type_list" value="<cfoutput>#kocluk_yetkinlik_list#</cfoutput>">
        <input type="hidden" name="dep_req_type_list" id="dep_req_type_list" value="<cfoutput>#dep_yetkinlik_list#</cfoutput>">
        <input type="hidden" name="std_req_type_list" id="std_req_type_list" value="<cfoutput>#std_yetkinlik_list#</cfoutput>">
        <cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
        	SELECT * FROM EMPLOYEE_QUIZ_CHAPTER WHERE REQ_TYPE_ID IN(#yetkinlik_list_all#) 
        </cfquery>
        <cfif get_quiz_chapters.recordcount>
			<cfoutput query="get_quiz_chapters">
				<cfset answer_number_gelen = get_quiz_chapters.answer_number>
                <cfset attributes.CHAPTER_ID = CHAPTER_ID>
                <cfquery name="chapter_exp_#get_quiz_chapters.currentrow#" datasource="#dsn#">
                	SELECT EXPLANATION,MANAGER_EXPLANATION FROM EMPLOYEE_QUIZ_CHAPTER_EXPL WHERE CHAPTER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#CHAPTER_ID#"> AND RESULT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PERFORMANCE.RESULT_ID#">
                </cfquery>
                <cfscript>
					for (i=1; i lte answer_number_gelen; i = i+1)
					{
						"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
						"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
						"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
					}
                </cfscript>
                <cf_seperator title="Yetkinlik #get_quiz_chapters.currentrow#: #chapter#" id="b_#get_quiz_chapters.currentrow#">
                <table id="b_#get_quiz_chapters.currentrow#">
					<cfif len(chapter_info)>
                        <tr>
                        	<td>#chapter_info# </td>
                        </tr>
                    </cfif>
                    <cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
                    	SELECT * FROM EMPLOYEE_QUIZ_QUESTION WHERE CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CHAPTER_ID#">
                    </cfquery>
                    <cfif get_quiz_questions.recordcount>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td></td>
                                        <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
                                        <cfif get_quiz_chapters.answer_number neq 0>
                                            <cfloop from="1" to="20" index="i">
												<cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                                                    <td class="" align="center">
														<cfif len(evaluate("answer"&i&"_photo"))>
                                                        	<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_link="1">
                                                        </cfif>
                                                        #evaluate('answer#i#_text')# 
                                                        &nbsp;
                                                    </td>
                                                </cfif>
                                            </cfloop>
                                        </cfif>
                                    </tr>
                                    <!--- Sorular basliyor --->
                                    <cfloop query="get_quiz_questions">
										<cfset q_id = get_quiz_questions.QUESTION_ID>
                                        <tr>
                                            <td class="blue"> #get_quiz_questions.question# </td>
                                            <cfif answer_number_gelen neq 0>
                                            	<cfloop from="1" to="#answer_number_gelen#" index="i">
													<cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
                                                    	<td align="center">
                                                    		<input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#" 
                                                    			<cfloop query="GET_EMP_QUIZ_ANSWERS">
																	<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS IS i>
                                                                        checked
                                                                    </cfif>
                                            					</cfloop>
                                            				><!--- calc_user_point('#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#',#i#,#evaluate('c#i#')#); --->
                                            				<input type="hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- evaluate('get_quiz_chapters.answer'&i&'_point') --->
                                           			 	</td>
                                            		</cfif>
                                    			</cfloop>
                                            	</tr>
                                    		<cfelse>
                                                <td style="text-align:right;"> </td>
                                                <td style="text-align:right;"> </td>
                                    		</tr>
                                    			<cfloop from="1" to="#answer_number_gelen#" index="i">
                                    				<cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
                                    					<tr class="color-list">
                                    						<td class="blue"><!--- <input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1">  ---></td>
                                    						<td>
                                    							<input type="radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#"><!--- calc_user_point('#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#',#i#,#evaluate('get_quiz_questions.answer'&i&'_point')#); --->
                                    							<input type="hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('get_quiz_questions.answer'&i&'_point')#">
                                    							<cfif len(evaluate("answer"&i&"_photo"))>
                                    								<!--- <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
                                    								<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0" image_link="1">
                                    							</cfif>
                                    							#evaluate('get_quiz_questions.answer#i#_text')#<br/>
                                    						</td>
                                    						<td> </td>
                                    						<td> </td>
                                    					</tr>
                                    				</cfif>
                                    			</cfloop>
                                    		</cfif>
											<cfif len(question_info)>
                                                <tr height="20" class="color-list">
                                                	<td colspan="#1+answer_number_gelen#"> #get_quiz_questions.question_info#</td>
                                                </tr>
                                            </cfif>
                                    </cfloop>
                                </table>
                        	</td>
                        </tr>
                        <cfelse>
                        <tr>
                        <td><cf_get_lang dictionary_id='31428.Kayıtlı Soru Bulunamadı'></td>
                        </tr>
                    </cfif>
                </table>
                <table>
                    <tr>
                        <td valign="top" nowrap><cf_get_lang dictionary_id='57629.Açıklama'><textarea name="expl_#get_quiz_chapters.currentrow#" id="expl_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION")#</textarea></td>
                    </tr>
                </table>
            </cfoutput>
      	<cfelse>
            <table>
                <tr>
                    <td><cf_get_lang dictionary_id='31429.Kayıtlı Bölüm Bulunamadı'></td>
                </tr>
            </table>
        </cfif>
        <cfset amir_onay = "">
        <cfif GET_PERFORMANCE.recordcount><!--- Çalışanın son amirinin onayladıktan sonra performans formunun güncellemenmemesi için.. --->
        <cfif len(GET_PERFORMANCE.FIRST_BOSS_CODE)>
        <cfset amir_onay= GET_PERFORMANCE.FIRST_BOSS_VALID_FORM>
        </cfif>
        <cfif len(GET_PERFORMANCE.SECOND_BOSS_CODE)>
        <cfset amir_onay=GET_PERFORMANCE.SECOND_BOSS_VALID>
        </cfif>
        <cfif len(GET_PERFORMANCE.THIRD_BOSS_CODE)>
        <cfset amir_onay=GET_PERFORMANCE.THIRD_BOSS_VALID>
        </cfif>
        <cfif len(GET_PERFORMANCE.FOURTH_BOSS_CODE)>
        <cfset amir_onay=GET_PERFORMANCE.FOURTH_BOSS_VALID>
        </cfif>
        <cfif len(GET_PERFORMANCE.FIFTH_BOSS_CODE)>
        <cfset amir_onay=GET_PERFORMANCE.FIFTH_BOSS_VALID>
        </cfif>
        </cfif>		
        <!---<cf_popup_box_footer>--->
        <table width="99%">
            <tr>
                <td style="text-align:right;">
                    <cfif not len(amir_onay)>
                        <cf_workcube_buttons is_upd='0' type_format='1'>
                    <cfelse>
                        <font color="FFF0000"><cf_get_lang dictionary_id='32322.Performans Sonuç Formu Tamemen Onaylandığı İçin Güncelleme Yapılamaz'></font>
                    </cfif>
                </td>
            </tr>
        </table>
        <!---</cf_popup_box_footer>--->
    </cfform>
</div>
<!---</cf_popup_box>--->
