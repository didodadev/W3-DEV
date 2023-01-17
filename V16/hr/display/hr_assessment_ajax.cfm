<cfsetting showdebugoutput="no">
<cf_ajax_list>
	<tbody>
	<cfquery name="GET_APP_QUIZ" datasource="#dsn#">
	SELECT
		EMPLOYEES_APP_QUIZ.EMP_APP_QUIZ_ID,
		EMPLOYEES_APP_QUIZ.QUIZ_ID,
		EMPLOYEE_QUIZ.QUIZ_HEAD
	FROM 
		EMPLOYEE_QUIZ,
		EMPLOYEES_APP_QUIZ
	WHERE 
		EMPLOYEE_QUIZ.QUIZ_ID = EMPLOYEES_APP_QUIZ.QUIZ_ID
		AND EMPLOYEES_APP_QUIZ.EMPAPP_ID = #attributes.EMPAPP_ID#
	</cfquery>
	<cfif GET_APP_QUIZ.recordcount>
		<cfoutput query="GET_APP_QUIZ">
		<tr>
			<td>#GET_APP_QUIZ.QUIZ_HEAD#</td>
			<td width="15" style="text-align:right;">
            <cfinclude template="../query/get_app_quiz_perf.cfm">
			<cfif GET_APP_PERF_RESULT.RecordCount>
				#TLFormat(GET_APP_PERF_RESULT.USER_POINT)#/#TLFormat(GET_APP_PERF_RESULT.PERFORM_POINT)#
				<cfif not listfindnocase(denied_pages,'hr.form_upd_app_performance')>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_form_upd_app_performance&APP_PER_ID=#GET_APP_PERF_RESULT.APP_PER_ID#&is_cv=1','page')"> <img src="/images/update_list.gif" border="0" title="Formu Güncelle"> </a>
				</cfif>
			<cfelse>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_form_add_app_performance&quiz_id=#quiz_id#&emp_app_quiz_id=#GET_APP_QUIZ.EMP_APP_QUIZ_ID#&empapp_id=#attributes.empapp_id#&is_cv=1','page')"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57762.Formu Doldur'>" border="0"></a>
			</cfif>
		</td>
		</tr>
		</cfoutput>
	</cfif>
	<cfif (GET_APP_QUIZ.recordcount eq 0)>
		<tr>
			<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt yok'> !</td>
		</tr>
	</cfif>
    </tbody>
</cf_ajax_list>
