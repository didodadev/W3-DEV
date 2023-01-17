<cfquery name="get_empapp" datasource="#dsn#">
	SELECT
		NAME,
		SURNAME
	FROM
		EMPLOYEES_APP
	WHERE
		EMPAPP_ID=#attributes.empapp_id#
</cfquery>
<cfsavecontent variable="txt">
    <cf_get_lang dictionary_id="57570.ad soyad"> : <cfoutput>#get_empapp.name# #get_empapp.surname#</cfoutput>
</cfsavecontent>
<cf_box title="#txt#" scroll="1" collapsable="1" resize="0" settings="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<!--- yazışmalar --->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57459.Yazışmalar"></cfsavecontent>
        <cf_box title="#message#" closable="0">
            <cf_ajax_list>
                <tbody>
                <cfquery name="GET_EMPAPP_MAIL" datasource="#DSN#">
                    SELECT 
        	            EMP_APP_MAIL_ID, 
                        EMPAPP_ID, 
                        APP_POS_ID, 
                        LIST_ID, 
                        LIST_ROW_ID, 
                        MAIL_HEAD, 
                        EMPAPP_MAIL, 
                        RECORD_PAR, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        RECORD_DATE, 
                        UPDATE_PAR, 
                        UPDATE_EMP, 
                        UPDATE_IP, 
                        UPDATE_DATE 
                    FROM 
    	                EMPLOYEES_APP_MAILS 
                    WHERE 
	                    LIST_ID=#attributes.list_id# AND LIST_ROW_ID=#attributes.list_row_id#
                </cfquery> 
                <cfif isDefined("GET_EMPAPP_MAIL") and GET_EMPAPP_MAIL.recordcount>
                    <cfoutput query="GET_EMPAPP_MAIL">
                    <tr>
                        <td>#GET_EMPAPP_MAIL.MAIL_HEAD#</td>
                        <td width="15" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_app_upd_mail&emp_app_mail_id=#get_empapp_mail.emp_app_mail_id#&empapp_id=#get_empapp_mail.empapp_id#','medium');"><img src="/images/update_list.gif" border="0"></a></td>
                    </tr>
                    </cfoutput>
                </cfif>
                <cfif isDefined("GET_EMPAPP_MAIL") and (GET_EMPAPP_MAIL.recordcount eq 0)>
                    <tr>
                        <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok	'>!</td>
                    </tr>
                </cfif>
                </tbody>
            </cf_ajax_list>
        </cf_box>
        <!---form generator değerlendirme formları SG 20120905---->
        <cf_get_workcube_form_generator action_type='7' related_type='7' action_type_id='#attributes.empapp_id#' design='3' box_id="eva_form2">
        
        <!--- degerlendirme --->
        <!---
        <cfquery name="GET_QUIZS" datasource="#dsn#">
            SELECT 
                EQ.QUIZ_ID,
                EQ.QUIZ_HEAD,
                EQ.QUIZ_OBJECTIVE,
                EQ.IS_ACTIVE,
                EQ.STAGE_ID,
                EQ.POSITION_CAT_ID,
                EQ.POSITION_ID,
                EQ.IS_APPLICATION,
                EQ.IS_EDUCATION,
                EQ.IS_TRAINER,
                EQ.IS_INTERVIEW,
                EQ.IS_TEST_TIME,
                EQ.RECORD_EMP,
                EQ.RECORD_PAR,
                EQ.RECORD_DATE
            FROM 
                EMPLOYEE_QUIZ EQ
            WHERE
                EQ.QUIZ_ID IS NOT NULL
                AND EQ.IS_INTERVIEW = 1
        </cfquery>
        <table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
            <tr class="color-border">
                <td>
                    <table cellspacing="1" cellpadding="2" width="100%" border="0">
                        <tr class="color-header" height="22">
                          <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="form-title"><cf_get_lang no='674.Değerlendirmeler'></td>
                                    <td width="10"  style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_form_generators&type=7<cfif isdefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif></cfoutput>','list');"> <img src="/images/plus_square.gif" title="Form Ekle" border="0"></a></td>
                                </tr>
                            </table>
                          </td>
                        </tr>
                        <tr class="color-row" height="20">
                          <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                              <cfquery name="GET_APP_QUIZ" datasource="#dsn#">
                                SELECT 
                                    EMPLOYEES_APP_QUIZ.EMP_APP_QUIZ_ID,
                                    EMPLOYEES_APP_QUIZ.QUIZ_ID,
                                    SURVEY_MAIN.SURVEY_MAIN_ID,
                                    SURVEY_MAIN.SURVEY_MAIN_HEAD,
                                    EMPLOYEES_APP_QUIZ.APP_POS_ID
                                FROM 
                                    SURVEY_MAIN,
                                    EMPLOYEES_APP_QUIZ
                                WHERE 
                                    SURVEY_MAIN.SURVEY_MAIN_ID = EMPLOYEES_APP_QUIZ.QUIZ_ID
                                    AND EMPLOYEES_APP_QUIZ.EMPAPP_ID = #attributes.EMPAPP_ID#
                            </cfquery>
                             <cfif GET_APP_QUIZ.recordcount>
                                <cfoutput query="GET_APP_QUIZ">
                                <!--- bu aday için kayıt edilmiş tum formlar--->
                                <cfquery name="get_survey_result" datasource="#dsn#">
                                    SELECT 
                                        SURVEY_MAIN_RESULT_ID
                                    FROM 
                                        SURVEY_MAIN_RESULT 
                                    WHERE 
                                        SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_APP_QUIZ.SURVEY_MAIN_ID#"> AND
                                        ACTION_TYPE = 5 AND<!--- işe alım(cv)--->
                                        ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPAPP_ID#"> AND
                                        EMP_ID = #session.ep.userid#
                                        <!---EMPAPP_ID = #attributes.EMPAPP_ID#--->
                                </cfquery>
        
                                <tr>
                                    <td width="778">#GET_APP_QUIZ.SURVEY_MAIN_HEAD#</td>
                                    <td width="164"  style="text-align:right;">
                                        <cfif get_survey_result.RecordCount>
                                            <!---<cfif not get_app_perf_result.perform_point gt 0>
                                                <cfset last_point=0>
                                            <cfelse>
                                                <cfset last_point = ((GET_APP_PERF_RESULT.USER_POINT / GET_APP_PERF_RESULT.PERFORM_POINT) * 100)>
                                            </cfif>
                                            #Round(last_point)#&nbsp;/&nbsp;100--->
                                            <!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.form_upd_detailed_survey_main_result&survey_id=#GET_APP_QUIZ.SURVEY_MAIN_ID#&empapp_id=#attributes.empapp_id#<cfif len(get_survey_result.survey_main_result_id)>&result_id=#get_survey_result.survey_main_result_id#</cfif>','page')"><img src="/images/update_list.gif" title="<cf_get_lang no='503.Formu Doldur'>" border="0" align="absmiddle"></a>
                                            --->
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&survey_id=#GET_APP_QUIZ.survey_main_id#&result_id=#get_survey_result.survey_main_result_id#&is_popup=1','page');" class="tableyazi"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a>
                                        <cfelse>
                                                <!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.form_add_detailed_survey_main_result&survey_id=#GET_APP_QUIZ.SURVEY_MAIN_ID#&empapp_id=#attributes.empapp_id#','page')"> <img src="/images/plus_list.gif" border="0" title="Formu Güncelle" align="absmiddle"> </a>
                                                --->
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#GET_APP_QUIZ.survey_main_id#&action_type=5&action_type_id=#attributes.empapp_id#&is_popup=1','list');" class="tableyazi"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='350.Formu Doldur'>" border="0" align="absmiddle"></a>
                                        </cfif>
                                    </td>
                                </tr>
                                </cfoutput>
                             </cfif>
                              <cfif (GET_APP_QUIZ.recordcount eq 0)>
                                <tr>
                                  <td colspan="2"><cf_get_lang_main no='72.Kayıt yok'></td>
                                </tr>
                              </cfif>
                            </table> 
                          </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        --->
        <!--- kabul edildigi ucret --->
        <cfsavecontent variable="txt">
        <cfoutput>
            #request.self#?fuseaction=hr.popup_add_salary<cfif isdefined('attributes.list_id')>&list_id=#attributes.list_id#</cfif><cfif isdefined('attributes.list_row_id')>&list_row_id=#attributes.list_row_id#</cfif>
        </cfoutput>
        </cfsavecontent>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55580.Kabul Edildiği Ücret"></cfsavecontent>
        <cf_box closable="0" title="#message#" add_href="#txt#" add_href_size="small">
            <cf_ajax_list>
            <cfquery name="get_list_row" datasource="#dsn#">
                SELECT SALARY FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID = #attributes.list_id# AND LIST_ROW_ID = #attributes.list_row_id#
            </cfquery>
                <tbody>
                <cfif get_list_row.recordcount and len(get_list_row.salary)>
                    <cfoutput query="get_list_row">
                    <tr>
                        <td><cfif len(salary)>#salary#</cfif></td>
                    </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
                </tbody>
            </cf_ajax_list>
        </cf_box>
        <cf_get_workcube_note  action_section='EMPLOYEES_APP_ID' action_id='#attributes.EMPAPP_ID#' box_id="notes2">
        <cf_get_related_events action_section='SELECT_LIST_ROW_ID' action_id='#attributes.list_row_id#' company_id='#session.ep.company_id#'>
</cf_box>