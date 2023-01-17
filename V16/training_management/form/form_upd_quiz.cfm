<cfquery name="gET_quiz" datasource="#DSN#">
	SELECT 
    	QUIZ_ID, 
        POSITION_CAT_ID, 
        QUIZ_HEAD, 
        QUIZ_OBJECTIVE, 
        COMMETHOD_ID, 
        IS_ACTIVE, 
        RECORD_DATE, 
        RECORD_PAR, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        STAGE_ID, 
        IS_APPLICATION, 
        IS_EDUCATION, 
        IS_TRAINER, 
        IS_INTERVIEW, 
        IS_TEST_TIME, 
        FORM_OPEN_TYPE, 
        IS_EXTRA_RECORD, 
        IS_RECORD_TYPE, 
        IS_EXTRA_RECORD_EMP, 
        IS_VIEW_QUESTION, 
        IS_EXTRA_QUIZ, 
        IS_MANAGER_1, 
        IS_MANAGER_2, 
        IS_MANAGER_3, 
        IS_CAREER, 
        IS_TRAINING, 
        IS_OPINION, 
        IS_SHOW, 
        START_DATE, 
        FINISH_DATE, 
        IS_INTERVIEW_IN, 
        IS_MANAGER_4, 
        IS_ALL_EMPLOYEE, 
        IS_MAIL_CONTROL, 
        IS_MANAGER_0, 
        EMP_QUIZ_WEIGHT, 
        MANAGER_QUIZ_WEIGHT_1, 
        MANAGER_QUIZ_WEIGHT_2, 
        MANAGER_QUIZ_WEIGHT_3, 
        MANAGER_QUIZ_WEIGHT_4 
    FROM 
    	EMPLOYEE_QUIZ 
    WHERE 
    	QUIZ_ID=#ATTRIBUTES.QUIZ_ID#
</cfquery>
<cfinclude template="../query/get_quiz_stages.cfm">
<cfinclude template="../query/get_commethods.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cf_popup_box title="#getLang('training_management',316)# : #get_quiz.quiz_head#">
    <cfform name="upd_quiz" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_eval_quiz"> 
    <input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
        <table>
            <tr> 
                <td colspan="3" class="formbold" height="22"><cf_get_lang_main no='2086.Form Bilgileri'></td>
            </tr>
            <tr> 
                <td><cf_get_lang_main no='68.Başlık'>*</td>
                <td> 
                    <input type="text" name="quiz_head" id="quiz_head" style="width:300px;" value="<cfoutput>#get_quiz.quiz_head#</cfoutput>">&nbsp;<input type="checkbox" name="IS_ACTIVE" id="IS_ACTIVE" <cfif 1 IS get_quiz.IS_ACTIVE>checked</cfif>>
                    <cf_get_lang_main no='81.Aktif'>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang_main no='217.Açıklama'></td>
                <td> 
               		<textarea name="quiz_objective" id="quiz_objective" style="width:350px; height:100px;" ><cfoutput>#get_quiz.quiz_objective#</cfoutput></textarea>
                </td>
            </tr>
            <input type="hidden" name="COMMETHOD_ID" id="COMMETHOD_ID" value="5">
            <input type="hidden" name="PERIOD_PART" id="PERIOD_PART" value="1">
            <tr>
                <td><cf_get_lang no='244.Yayın Aşama'></td>
                <td>
                    <select name="STAGE_ID" id="STAGE_ID">
						<cfoutput query="get_quiz_stages">
                        	<option value="#stage_id#" <cfif get_quiz.STAGE_ID is STAGE_ID>selected</cfif>>#stage_name# 
                        </cfoutput>
                    </select>
                    &nbsp;
                    <select name="IS_TYPE" id="IS_TYPE">
                        <option value="IS_EDUCATION" <cfif 1 IS get_quiz.IS_EDUCATION>selected</cfif>> <cf_get_lang no='246.Eğitim Yönetiminde Kullanılacak'></option>
                        <option value="IS_TRAINER" <cfif 1 IS get_quiz.IS_TRAINER>selected</cfif>><cf_get_lang no='245.Eğitimci için kullanılacak'></option>
                    </select>
                </td>
            </tr>
            <tr>
            	<td colspan="2"></td>
            </tr>
		</table>
        <cf_popup_box_footer>
        	<cfquery name="get_emp_quiz_result" datasource="#dsn#">
                SELECT
                    QUIZ_ID
                FROM
                    EMPLOYEE_QUIZ_RESULTS
                WHERE
                    QUIZ_ID=#ATTRIBUTES.QUIZ_ID#
            </cfquery>
        	<cfif get_emp_quiz_result.recordcount>
                <cf_workcube_buttons is_upd='0'>
            <cfelse>
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_eval_quiz&quiz_id=#attributes.quiz_id#'>
            </cfif>
        </cf_popup_box_footer>
	</cfform>    
</cf_popup_box>

