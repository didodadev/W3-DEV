<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.process_stage_id" default="">
<cfquery name="get_survey_participants" datasource="#dsn#">
	SELECT 
		SURVEY_MAIN_RESULT_ID,
		PARTNER_ID,
		CONSUMER_ID,
		EMP_ID,
		RECORD_EMP,
		COMPANY_ID,
		ACTION_TYPE,
		ACTION_ID,
		RECORD_DATE,
		SCORE_RESULT,
		CASE WHEN (ACTION_TYPE=6 OR ACTION_TYPE=8 OR ACTION_TYPE= 10)
			THEN (SELECT PC.POSITION_CAT FROM EMPLOYEE_POSITIONS AS EP INNER JOIN SETUP_POSITION_CAT AS PC ON EP.POSITION_CAT_ID = PC.POSITION_CAT_ID WHERE EP.IS_MASTER= 1 AND EP.EMPLOYEE_ID = SURVEY_MAIN_RESULT.ACTION_ID)
			ELSE ''
		END AS POSITION_CAT_NAME,
		CASE WHEN (ACTION_TYPE=6 OR ACTION_TYPE=8 OR ACTION_TYPE= 10)
			THEN (SELECT D.DEPARTMENT_HEAD FROM EMPLOYEE_POSITIONS AS EP INNER JOIN DEPARTMENT AS D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID WHERE EP.IS_MASTER= 1 AND EP.EMPLOYEE_ID = SURVEY_MAIN_RESULT.ACTION_ID)
			ELSE ''
		END AS DEPARTMENT_NAME,
		CASE WHEN (ACTION_TYPE=6 OR ACTION_TYPE=8 OR ACTION_TYPE= 10)
			THEN (SELECT B.BRANCH_NAME FROM EMPLOYEE_POSITIONS AS EP INNER JOIN DEPARTMENT AS D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID INNER JOIN BRANCH AS B ON D.BRANCH_ID = D.BRANCH_ID WHERE EP.IS_MASTER= 1 AND EP.EMPLOYEE_ID = SURVEY_MAIN_RESULT.ACTION_ID AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID)
			ELSE ''
		END AS BRANCH,
		PROCESS_ROW_ID,
		SCORE_RESULT_EMP,
		SCORE_RESULT_MANAGER1,
		SCORE_RESULT_MANAGER2,
		SCORE_RESULT_MANAGER3,
		SCORE_RESULT_MANAGER4,
		UPDATE_IP,
		RECORD_IP,
		CLASS_ATTENDER_EMP_ID,
		CLASS_ATTENDER_CONS_ID,
		CLASS_ATTENDER_PAR_ID
	FROM 
		SURVEY_MAIN_RESULT 
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> 
		<cfif isdefined("attributes.related_id") and len(attributes.related_id) and isdefined("attributes.related_head") and len(attributes.related_head)>
			AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_id#">
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND ACTION_ID IN(SELECT 
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS AS EP 
								INNER JOIN DEPARTMENT AS D 
								ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
							WHERE 
								D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
							)
		</cfif>
		<cfif isdefined("attributes.department") and len(attributes.department)>
			AND ACTION_ID IN(SELECT 
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS AS EP 
								INNER JOIN DEPARTMENT AS D 
								ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
							WHERE 
								D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
							)
		</cfif>
		<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
			AND ACTION_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS AS EP WHERE EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">)
		</cfif>
		<cfif isdefined("attributes.process_stage_id") and len(attributes.process_stage_id)>
			AND PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_id#">
		</cfif>
	ORDER BY 
		SURVEY_MAIN_RESULT_ID DESC
</cfquery>

<cfquery name="get_survey" datasource="#dsn#">
	SELECT 
    #dsn#.Get_Dynamic_Language(SURVEY_MAIN_ID,'#session.ep.language#','SURVEY_MAIN','SURVEY_MAIN.SURVEY_MAIN_HEAD',NULL,NULL,SURVEY_MAIN_HEAD) AS SURVEY_MAIN_HEAD,
        TYPE,
		TOTAL_SCORE,
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
		PROCESS_ID,
		IS_MANAGER_0,
		IS_MANAGER_3,
		IS_MANAGER_1,
		IS_MANAGER_4,
		IS_MANAGER_2,
		MANAGER_QUIZ_WEIGHT_2,
		MANAGER_QUIZ_WEIGHT_1,
		EMP_QUIZ_WEIGHT,
		MANAGER_QUIZ_WEIGHT_3,
		MANAGER_QUIZ_WEIGHT_4,
		IS_SELECTED_ATTENDER,
        IS_NOT_SHOW_SAVED
	FROM 
		SURVEY_MAIN 
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
<cfif len(get_survey.process_id)>
	<cfquery name="get_process_row" datasource="#dsn#">
		SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey.process_id#"> ORDER BY STAGE
	</cfquery>
</cfif>
<cfif fuseaction contains 'objects'>
	<cfset fuseact = 'popup_add_detailed_survey_main_result'>
	<cfset fuseact2 = 'popup_form_upd_detailed_survey_main_result'>
<cfelse>
	<cfset fuseact = 'form_add_detailed_survey_main_result'>
	<cfset fuseact2 = 'form_upd_detailed_survey_main_result'>
</cfif>
<cfquery name="get_position_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfset pageHead = #getLang('hr',674)#>
<cf_catalystHeader>
        <div class="col col-9 col-xs-12">
            <cf_box>
                <cfform name="search" method="post" action="#request.self#?fuseaction=hr.list_detail_survey_report&event=report">
                    <cf_box_elements>
                        <input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
                        <input type="hidden" name="action_type_" id="action_type_" value="<cfoutput>#attributes.action_type_#</cfoutput>">
                        <cfif listfind('6,8,10',attributes.action_type_,',')><!--- performans,deneme süresi ve işten çıkış ta gelecek--->
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                                <div class="form-group" id="item-branch_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="branch_id" id="branch_id" style="width:150px;" onChange="showDepartment(this.value)">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfquery name="get_branch" datasource="#dsn#">
                                                SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 ORDER BY BRANCH_NAME
                                            </cfquery>
                                            <cfoutput query="get_branch">
                                                <option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="DEPARTMENT_PLACE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="department" id="department" style="width:150px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
                                                <cfquery name="get_department" datasource="#dsn#">
                                                    SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
                                                </cfquery>
                                                <cfoutput query="get_department">
                                                    <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                                </cfoutput>
                                            </cfif>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                            <div class="form-group" id="item-related_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29912.Eğitimler'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfoutput>
                                            <input type="hidden" name="related_id" id="related_id" value="<cfif isdefined("attributes.related_id") and len(attributes.related_id) and isdefined("attributes.related_head") and len(attributes.related_head)>#attributes.related_id#</cfif>">
                                            <input type="text" name="related_head" id="related_head" value="<cfif isdefined("attributes.related_id") and len(attributes.related_id) and isdefined("attributes.related_head") and len(attributes.related_head)>#attributes.related_head#</cfif>" style="width:125px;">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="open_related_popup(<cfoutput>#attributes.action_type_#</cfoutput>);"></span>
                                        </cfoutput>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <cfif listfind('6,8,10',attributes.action_type_,',')><!--- performans,deneme süresi ve işten çıkış ta gelecek--->
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                                <div class="form-group" id="item-position_cat_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="position_cat_id" id="position_cat_id" style="width:150px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="GET_POSITION_CATS">
                                                <option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
                                <div class="form-group" id="item-process_stage_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="process_stage_id" id="process_stage_id" style="width:150px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfif len(get_survey.process_id)>
                                                <cfoutput query="get_process_row">
                                                    <option value="#PROCESS_ROW_ID#"<cfif attributes.process_stage_id eq PROCESS_ROW_ID> selected</cfif>>#STAGE#</option>
                                                </cfoutput>
                                            </cfif>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    </cf_box_elements>
                    
                    <div class="ui-form-list-btn">
                        <cf_wrk_search_button button_type="5" >
                    </div>
                </cfform>
            </cf_box>

            <cf_box closable="0" collapsable="1" uidrop="1">
                <table>
                    <tr>
                        <td colspan="6" class="formbold"><cfoutput>#get_survey.survey_main_head#</cfoutput></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='60122.Katılımcı Sayısı'></td>
                        <td>:
                            <cfquery name="get_count_emp" dbtype="query">
                                SELECT COUNT(RECORD_EMP) AS COUNT_EMP FROM get_survey_participants WHERE PARTNER_ID IS NULL AND CONSUMER_ID IS NULL
                            </cfquery>
                            <cfquery name="get_count_par" dbtype="query">
                                SELECT COUNT(PARTNER_ID) AS COUNT_PAR FROM get_survey_participants WHERE PARTNER_ID IS NOT NULL
                            </cfquery>
                            <cfquery name="get_count_cons" dbtype="query">
                                SELECT COUNT(CONSUMER_ID) AS COUNT_CONS FROM get_survey_participants WHERE CONSUMER_ID IS NOT NULL
                            </cfquery>
                            <cfoutput>(Çalışan) <cfif get_count_emp.recordcount>#get_count_emp.COUNT_EMP#<cfelse>0</cfif><cfif attributes.action_type_ eq 9>, (<cf_get_lang dictionary_id='57255.Kurumsal'>) <cfif get_count_par.recordcount>#get_count_par.COUNT_PAR#<cfelse>0</cfif>, (<cf_get_lang dictionary_id='41200.Bireysel'>) <cfif get_count_cons.recordcount>#get_count_cons.COUNT_CONS#<cfelse>0</cfif></cfif></cfoutput>
                        </td>
                        <td><cf_get_lang dictionary_id='58909.Max'> <cf_get_lang dictionary_id='58984.Puan'></td>
                        <td>:<cfoutput>#get_survey.total_score#</cfoutput></td>
                        <td><cf_get_lang dictionary_id='29774.Uygunluk Sınırı'></td>
                        <td style="width:60px;">:<cfoutput>#get_survey.average_score#</cfoutput></td>
                    </tr>
                </table>
                <cf_grid_list>
                        <thead>
                            <tr> 
                                <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                                <th>
                                    <cfif attributes.action_type_ eq 1>
                                    <cf_get_lang dictionary_id='57612.Firsat'>
                                    <cfelseif attributes.action_type_ eq 2>
                                        <cf_get_lang dictionary_id='57653.Içerik'>
                                    <cfelseif attributes.action_type_ eq 3>
                                        <cf_get_lang dictionary_id='57446.Kampanya'>
                                    <cfelseif attributes.action_type_ eq 4>
                                        <cf_get_lang dictionary_id='57657.Ürün'>
                                    <cfelseif attributes.action_type_ eq 5>
                                        <cf_get_lang dictionary_id='57416.Proje'>
                                    <cfelseif attributes.action_type_ eq 6>
                                        <cf_get_lang dictionary_id='29776.Deneme Süresi'>(<cf_get_lang dictionary_id='57576.Çalışan'>)
                                    <cfelseif attributes.action_type_ eq 7>
                                        <cf_get_lang dictionary_id='57996.Ise Alim'>(<cf_get_lang dictionary_id='29767.Cv'>)
                                    <cfelseif attributes.action_type_ eq 8>
                                        <cf_get_lang dictionary_id='58003.Performans'>(<cf_get_lang dictionary_id='57576.Çalışan'>)
                                    <cfelseif attributes.action_type_ eq 9>
                                        <cf_get_lang dictionary_id='57419.Egitim'>
                                    <cfelseif attributes.action_type_ eq 10>
                                        <cf_get_lang dictionary_id='29832.İşten Çıkış'>(<cf_get_lang dictionary_id='57576.Çalışan'>)
                                    </cfif>		
                                </th>
                                <cfif not listfind('8',attributes.action_type_,',')>
                                    <th><cfif attributes.action_type_ eq 9 and get_survey.is_selected_attender neq 1><cf_get_lang dictionary_id='29780.Katılımcı'><cfelse><cf_get_lang dictionary_id='57483.Kayıt'></cfif></th>
                                    <cfif attributes.action_type_ eq 9 and get_survey.is_selected_attender eq 1><!--- form içerisinde Katılımcı seçtitiliyor ise bu bilgiyi goster--->
                                    <th><cf_get_lang dictionary_id='29780.Katılımcı'></th>
                                    </cfif>
                                </cfif>
                                <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                                <cfif listfind('6,8,10',attributes.action_type_,',')>
                                <th><cf_get_lang dictionary_id='57453.Şube'></th>
                                <th><cf_get_lang dictionary_id="57572.Departman"></th>
                                <th><cf_get_lang dictionary_id="59004.Pozisyon tipi"></th>
                                <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                                </cfif>
                                <th><cf_get_lang dictionary_id='58984.Puan'></th>
                                <th><cf_get_lang dictionary_id='57684.Sonuç'></th>
                                <th><cf_get_lang dictionary_id='29764.Form'></th>
                                <th></th>				
                            </tr>
                        </thead>
                        <tbody>
                            <cfif get_survey_participants.recordcount>
                                <cfset opp_list = "">
                                <cfset prod_list = "">
                                <cfset content_list = "">
                                <cfset project_list = "">
                                <cfset emp_app_list = "">
                                <cfset training_id_list = "">
                                <cfset process_id_list = "">
                                <cfoutput query="get_survey_participants"> 
                                    <cfif get_survey_participants.action_type eq 1 and len(action_id) and not listfind(opp_list,action_id)><!---firsat --->
                                        <cfset opp_list=listappend(opp_list,action_id,',')>
                                    <cfelseif get_survey_participants.action_type eq 2 and len(action_id) and not listfind(content_list,action_id)><!--- içerik--->
                                        <cfset content_list=listappend(content_list,action_id,',')>
                                    <cfelseif get_survey_participants.action_type eq 3 and len(action_id) and not listfind(prod_list,action_id)><!--- ürün--->
                                        <cfset prod_list=listappend(prod_list,action_id,',')>
                                    <cfelseif get_survey_participants.action_type eq 4 and len(action_id) and not listfind(project_list,action_id)><!--- proje--->
                                        <cfset project_list=listappend(project_list,action_id,',')>
                                    <cfelseif get_survey_participants.action_type eq 5 and len(action_id) and not listfind(emp_app_list,action_id)><!--- proje--->
                                        <cfset emp_app_list=listappend(emp_app_list,action_id,',')>
                                    <cfelseif get_survey_participants.action_type eq 7 and len(action_id) and not listfind(emp_app_list,action_id)><!--- ise alim--->
                                        <cfset emp_app_list=listappend(emp_app_list,action_id,',')>
                                    <cfelseif get_survey_participants.action_type eq 9 and len(action_id) and not listfind(training_id_list,action_id)><!--- egitim--->
                                        <cfset training_id_list=listappend(training_id_list,action_id,',')>
                                    </cfif>	
                                    <cfif len(get_survey_participants.process_row_id) and not listfind(process_id_list,get_survey_participants.process_row_id)>
                                        <cfset process_id_list = listappend(process_id_list,get_survey_participants.process_row_id,',')>
                                    </cfif>	
                                </cfoutput>
                                <cfif len(opp_list)><!---firsat --->
                                    <cfquery name="get_opp" datasource="#dsn3#">
                                        SELECT OPP_ID,OPP_HEAD AS RELATION_HEAD FROM OPPORTUNITIES WHERE OPP_ID IN(#opp_list#) ORDER BY OPP_ID
                                    </cfquery>
                                    <cfset opp_list = listsort(listdeleteduplicates(valuelist(get_opp.OPP_ID,',')),'numeric','ASC',',')>
                                <cfelseif len(prod_list)><!--- ürün--->
                                    <cfquery name="get_product" datasource="#dsn3#">
                                        SELECT STOCK_ID,PRODUCT_NAME AS RELATION_HEAD FROM STOCKS WHERE STOCK_ID IN(#prod_list#) ORDER BY STOCK_ID
                                    </cfquery>
                                    <cfset prod_list = listsort(listdeleteduplicates(valuelist(get_product.STOCK_ID,',')),'numeric','ASC',',')>
                                <cfelseif len(content_list)><!--- içerik--->
                                    <cfquery name="get_content" datasource="#dsn#">
                                        SELECT CONTENT_ID,CONT_HEAD AS RELATION_HEAD FROM CONTENT WHERE CONTENT_ID IN(#content_list#) ORDER BY CONTENT_ID
                                    </cfquery>
                                    <cfset content_list = listsort(listdeleteduplicates(valuelist(get_content.CONTENT_ID,',')),'numeric','ASC',',')>
                                <cfelseif len(project_list)><!--- proje--->
                                    <cfquery name="get_project" datasource="#dsn#">
                                        SELECT PROJECT_ID,PROJECT_HEAD AS RELATION_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN(#project_list#) ORDER BY PROJECT_ID
                                    </cfquery>
                                    <cfset project_list = listsort(listdeleteduplicates(valuelist(get_project.PROJECT_ID,',')),'numeric','ASC',',')>
                                <cfelseif len(emp_app_list)><!--- ise alim--->
                                    <cfquery name="get_cv" datasource="#dsn#">
                                        SELECT EMPAPP_ID,NAME+' '+SURNAME AS RELATION_HEAD FROM EMPLOYEES_APP WHERE EMPAPP_ID IN(#emp_app_list#) ORDER BY EMPAPP_ID
                                    </cfquery>
                                    <cfset emp_app_list = listsort(listdeleteduplicates(valuelist(get_cv.EMPAPP_ID,',')),'numeric','ASC',',')>
                                <cfelseif len(training_id_list)><!--- egitim--->
                                    <cfquery name="get_class" datasource="#dsn#">
                                        SELECT CLASS_ID,CLASS_NAME AS RELATION_HEAD FROM TRAINING_CLASS WHERE CLASS_ID IN(#training_id_list#) ORDER BY CLASS_ID
                                    </cfquery>
                                    <cfset training_id_list = listsort(listdeleteduplicates(valuelist(get_class.CLASS_ID,',')),'numeric','ASC',',')>
                                </cfif>	
                                <cfif len(process_id_list)>
                                    <cfquery name="get_process_name" datasource="#dsn#">
                                        SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(#process_id_list#) ORDER BY PROCESS_ROW_ID
                                    </cfquery>
                                    <cfset process_id_list = listsort(listdeleteduplicates(valuelist(get_process_name.PROCESS_ROW_ID,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfoutput query="get_survey_participants"> 
                                    <tr class="color-row">
                                        <td align="left">#currentrow#</td>
                                        <td>
                                            <cfif action_type_ eq 1><!---firsat --->
                                                #get_opp.relation_head[listfind(opp_list,action_id,',')]#
                                            <cfelseif action_type_ eq 2><!--- ürün--->
                                                #get_product.relation_head[listfind(product_list,action_id,',')]#
                                            <cfelseif action_type_ eq 3><!--- içerik--->
                                                #get_content.relation_head[listfind(content_list,action_id,',')]#
                                            <cfelseif action_type_ eq 4><!--- proje--->
                                                #get_project.relation_head[listfind(project_list,action_id,',')]#
                                            <cfelseif action_type_ eq 5><!--- ise alim--->
                                                #get_cv.relation_head[listfind(emp_app_list,action_id,',')]#
                                            <cfelseif action_type_ eq 6><!---deneme süresi --->
                                                #get_emp_info(action_id,0,0)#
                                            <cfelseif action_type_ eq 7><!--- işe alım--->
                                                <a href="#request.self#?fuseaction=hr.form_upd_cv&empapp_id=#action_id#"  target="_blank">#get_cv.relation_head[listfind(emp_app_list,action_id,',')]#</a>
                                            <cfelseif action_type_ eq 8><!--- performans--->
                                                #get_emp_info(action_id,0,0)#
                                            <cfelseif action_type_ eq 9 and len(trim(action_id)) and len(training_id_list)><!--- egitim--->
                                                #get_class.relation_head[listfind(training_id_list,action_id,',')]#
                                            <cfelseif action_type_ eq 10><!---işten çıkış çalışan --->
                                                #get_emp_info(action_id,0,0)#
                                            </cfif>
                                        </td>
                                        <cfif not listfind('8',attributes.action_type_,',')>					
                                        <td height="2" nowrap="nowrap">
                                            <cfif get_survey.IS_NOT_SHOW_SAVED eq 1><!--- kaydeden bilgileri gizlensin seçili ise--->
                                                ********
                                            <cfelse>
                                                <!--- Kurumsal ise --->
                                                <cfif len(partner_id)>
                                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium','popup_par_det');">#get_par_info(partner_id,0,1,0)#</a>
                                                    (<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium','popup_com_det');">#get_par_info(partner_id,0,-1,0)#</a>)
                                                <!--- bireysel ise --->
                                                <cfelseif len(consumer_id)>
                                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium','popup_con_det');">#get_cons_info(consumer_id,0,0)#</a>
                                                <!--- calisan ise --->
                                                <cfelseif len(emp_id)>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');">#get_emp_info(emp_id,0,0)#</a>
                                                <!--- calisan ise --->
                                                <cfelseif len(record_emp)>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');">#get_emp_info(record_emp,0,0)#</a>
                                                <!--- site ziyaretcisi --->
                                                <cfelse>
                                                    <cfif len(update_ip)>
                                                        #update_ip#
                                                    <cfelseif len(record_ip)>
                                                        #record_ip#
                                                    </cfif>
                                                </cfif>
                                            </cfif>
                                        </td>
                                        <cfif attributes.action_type_ eq 9 and get_survey.is_selected_attender eq 1>
                                            <td>
                                                <cfif len(CLASS_ATTENDER_EMP_ID)>
                                                    #get_emp_info(CLASS_ATTENDER_EMP_ID,0,0)#
                                                <cfelseif len(CLASS_ATTENDER_PAR_ID)>
                                                    #get_emp_info(CLASS_ATTENDER_PAR_ID,0,-1,0)#
                                                <cfelseif len(CLASS_ATTENDER_CONS_ID)>
                                                    #get_cons_info(CLASS_ATTENDER_CONS_ID,0,0)#
                                                </cfif>
                                            </td>
                                        </cfif>
                                        </cfif>
                                        <td>#dateformat(record_date,dateformat_style)#</td>
                                        <cfif listfind('6,8,10',attributes.action_type_,',')>
                                        <td>#branch#</td>
                                        <td>#department_name#</td>
                                        <td>#position_cat_name#</td>
                                        <td><cfif len(process_row_id)>#get_process_name.stage[listfind(process_id_list,process_row_id,',')]#</cfif></td>
                                        </cfif>
                                        <td style="text-align:right">
                                            <cfset user_point = 0>
                                            <cfif attributes.action_type_ eq 8>
                                                <cfif not len(get_survey_participants.score_result_emp)>
                                                    <cfset attributes.score_result_emp = 0>
                                                <cfelse>
                                                    <cfset attributes.score_result_emp = get_survey_participants.score_result_emp>
                                                </cfif>
                                                <cfif not len(get_survey_participants.score_result_manager1)>
                                                    <cfset attributes.score_result_manager1 = 0>
                                                <cfelse>
                                                    <cfset attributes.score_result_manager1 = get_survey_participants.score_result_manager1>
                                                </cfif>
                                                <cfif not len(trim(get_survey_participants.score_result_manager2))>
                                                    <cfset attributes.score_result_manager2 = 0>
                                                <cfelse>
                                                    <cfset attributes.score_result_manager2 = get_survey_participants.score_result_manager2>
                                                </cfif>
                                                <cfif not len(get_survey_participants.score_result_manager3)>
                                                    <cfset attributes.score_result_manager3 = 0>
                                                <cfelse>
                                                    <cfset attributes.score_result_manager3 = get_survey_participants.score_result_manager3>
                                                </cfif>
                                                <cfif not len(get_survey_participants.score_result_manager4)>
                                                    <cfset attributes.score_result_manager4 = 0>
                                                <cfelse>
                                                    <cfset attributes.score_result_manager4 = get_survey_participants.score_result_manager4>
                                                </cfif>
                                                <!--- çalışan--->
                                                <cfif get_survey.is_manager_0 is 1 and len(get_survey.emp_quiz_weight)>
                                                    <cfset user_point = user_point+(attributes.score_result_emp * get_survey.emp_quiz_weight)>
                                                </cfif>
                                                <!--- görüş bildiren--->
                                                <cfif get_survey.is_manager_3 is 1 and len(get_survey.manager_quiz_weight_3)>
                                                    <cfset user_point = user_point+(attributes.score_result_manager3 * get_survey.manager_quiz_weight_3)>
                                                </cfif>
                                                <!--- 1.amir--->
                                                <cfif get_survey.is_manager_1 is 1 and len(get_survey.manager_quiz_weight_1)>
                                                    <cfset user_point = user_point+(attributes.score_result_manager1 * get_survey.manager_quiz_weight_1)>
                                                </cfif>
                                                <!--- ortak değerlendirme--->
                                                <cfif get_survey.is_manager_4 is 1 and len(get_survey.manager_quiz_weight_4)>
                                                    <cfset user_point = user_point+(attributes.score_result_manager4 * get_survey.manager_quiz_weight_4)>
                                                </cfif>
                                                <!--- 2.amir--->
                                                <cfif get_survey.is_manager_2 is 1 and len(get_survey.manager_quiz_weight_2)>
                                                    <cfset user_point = user_point+(attributes.score_result_manager2 * get_survey.manager_quiz_weight_2)>
                                                </cfif>
                                                <cfset user_point_ = user_point/100>
                                                #TlFormat(user_point_)# / 100						
                                            <cfelse>
                                                #TlFormat(score_result,0)#
                                            </cfif>
                                        </td>
                                        <td>
                                            <cfif len(get_survey.TOTAL_SCORE)>
                                                <cfset "new_score6" = get_survey.TOTAL_SCORE+1>
                                            <cfelse>
                                                <cfset "new_score6" = 100>
                                            </cfif>
                                            <cfloop from="1" to="5" index="scr">
                                                <cfset "new_score#scr#" = Evaluate("get_survey.score#scr#")>
                                                <cfif scr neq 5><cfset "new_score#scr+1#" = Evaluate("get_survey.score#scr+1#")></cfif>
                                                <cfif not Len(Evaluate("new_score#scr#"))><cfset "new_score#scr#" = score_result></cfif>
                                                <cfif not Len(Evaluate("new_score#scr+1#"))><cfset "new_score#scr+1#" = score_result></cfif>
                                                <cfif (score_result gte Evaluate("new_score#scr#")) and (score_result lt Evaluate("new_score#scr+1#"))>
                                                    #Evaluate("get_survey.comment#scr#")#
                                                </cfif> 
                                            </cfloop>
                                        </td>
                                        <!-- sil --><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_detailed_survey_main_result&survey_id=#attributes.survey_id#&result_id=#survey_main_result_id#','wide')"><i class="fa fa-book" border="0" title="<cf_get_lang dictionary_id='29764.Form'>"></i></a></td>
                                        <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&survey_id=#attributes.survey_id#&result_id=#survey_main_result_id#&is_popup=1','wide')"><i class="fa fa-pencil" border="0" title="<cf_get_lang dictionary_id='29764.Form'>"></i></a></td><!-- sil -->
                                    </tr>
                                </cfoutput> 
                            <cfelse>
                                <tr height="20">
                                    <td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                                </tr>
                            </cfif>
                        </tbody>
                </cf_grid_list>
            </cf_box>
        </div>
        <div class="col col-3 col-xs-12 ">
                <!-- sil -->
                    <cf_box 
                    	scroll="1"
                        closable="0" 
                        title="#getLang('','Sonuç Grafiği',64193)#" 
                        box_page="#request.self#?fuseaction=hr.result_graphic_ajax&survey_id=#attributes.survey_id#">
                    </cf_box>
                <!-- sil -->
        </div>
<script type="text/javascript">
function showDepartment(branch_id)	
{
	var branch_id = document.search.branch_id.value;
	if (branch_id != "")
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	else
	document.search.department.value ="";
	
}

function open_related_popup(op)
{
	if(op =='')
	{
		alert("<cf_get_lang dictionary_id='29785.Lütfen Tip Seçiniz'>!");
		return false;
	}
	var y = "";
	if (op == 1)//Fırsat
	{
		y='popup_list_opportunities&field_opp_id=search.related_id&field_opp_head=search.related_head';
	}
	else if (op == 2)//İçerik
	//http://ep.workcube/index.cfm?fuseaction=objects.popup_list_content_relation&action_type_id=143&action_type=CAMPAIGN_ID
	{ 
		y='popup_list_content_relation&no_function=1&action_type_id=<cfoutput>#attributes.survey_id#</cfoutput>&action_type_=SURVEY_ID&content=search.related_id&content_name=search.related_head';
	}
	else if (op==3)//kampanya
	{
		y='popup_list_campaigns&field_id=search.related_id&field_name=search.related_head';
	}
	else if (op == 4)//Ürün
	{ 
		y='popup_product_names&field_id=search.related_id&field_name=search.related_head';
	}
	else if(op == 5)//Proje
	{
		 y='popup_list_projects&project_id=search.related_id&project_head=search.related_head';
	}
	else if(op == 6 || op == 8 || op == 10|| op == 14)//deneme süresi,performans,işten çıkış
	{
		 y='popup_list_positions&field_emp_id=search.related_id&field_name=search.related_head&select_list=1';
	}
	else if(op ==7)//işe alım
	{
		 y='popup_list_employees_app&field_id=search.related_id&field_name=search.related_head';
	}
	else if(op == 9)//Eğitim
	{
		 y='popup_list_classes&field_id=search.related_id&field_name=search.related_head';
	}
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.'+y,'list');
}
</script>
