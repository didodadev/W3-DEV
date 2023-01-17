<!--- Bu sayfanın aynısı Myhome ve Eğitim modülünde de bulunmaktadır. Yapılan değişiklikler myhome ve eğitim modülüne de eklenmeli..Senay 20060418 --->
<cfset xfa.upd = "training_management.emptypopup_upd_training_performance">
<cfset xfa.del = "training_management.emptypopup_del_app_performance">
<cfinclude template="../query/get_app_perf_detail.cfm">

<cfscript>
	attributes.training_perf_id = GET_TRAINING_PERF_DETAIL.TRAINING_PERFORMANCE_ID;
	attributes.quiz_id = GET_TRAINING_PERF_DETAIL.quiz_id;
	attributes.training_name = GET_TRAINING_PERF_DETAIL.CLASS_NAME;
</cfscript>
<cfquery name="GET_QUIZ_INFO" datasource="#dsn#">
	SELECT 
		QUIZ_HEAD,
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
		FORM_OPEN_TYPE
	FROM 
		EMPLOYEE_QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
		
</cfquery>

<cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
	SELECT 
		EMPLOYEE_QUIZ_RESULTS_DETAILS.*,
		EMPLOYEE_QUIZ_RESULTS.USER_POINT
	FROM 
		EMPLOYEE_QUIZ_RESULTS_DETAILS,
		EMPLOYEE_QUIZ_RESULTS
	WHERE
		EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID
		AND EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID IN ( #GET_TRAINING_PERF_DETAIL.RESULT_ID#)
</cfquery>

<cfform name="add_perform" method="post" action="#request.self#?fuseaction=#xfa.upd#">

  <input type="hidden" name="RESULT_ID" id="RESULT_ID" value=" <cfoutput>#GET_TRAINING_PERF_DETAIL.RESULT_ID#</cfoutput>">
	<cfif isdefined('attributes.TRAINING_PER_ID')>
		<input type="hidden" name="TRAINING_PER_ID" id="TRAINING_PER_ID" value="<cfoutput>#attributes.TRAINING_PER_ID#</cfoutput>">
	</cfif>
	<cfif isdefined('attributes.quiz_id')>
		<input type="hidden" name="quiz_id" id="quiz_id" value="">
	</cfif>
	<cfif isdefined('attributes.class_id')>
		<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
	</cfif>
	<cfif isdefined('attributes.employee_id')>
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
	</cfif>
  <table width="100%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="headbold"><cf_get_lang_main no='1967.Form'> : <cfoutput>#GET_QUIZ_INFO.QUIZ_HEAD#</cfoutput></td>
	  <td>
		<!--- <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_print_app_performance&app_per_id=#attributes.app_per_id#</cfoutput>','page');"><img src="/images/print.gif" border="0"></a> --->
	  </td>
	</tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0">
    <tr>
    <td valign="top">
    <table width="98%" cellspacing="0" cellpadding="0">
      <tr class="color-border">
      <td>
      <table width="100%" cellspacing="1" cellpadding="2">
        <tr class="color-row">
          <td height="22" class="txtboldblue">Bu değerlendirme formu, başvuru yapan kişi ile ilgili yöneticiler tarafından yapılacaktır.</td>
        </tr>
        <tr>
	 <td class="color-row">
	  <table>
		<tr>
			<td width="100" class="txtbold">Eğitim Adı</td>
			<td width="185"><cfoutput>#attributes.training_name#</cfoutput></td>
        </tr>
        <tr>
			<td width="100" class="txtbold">Değerlendiren *</td>
			<td width="185">
				<input type="hidden" name="entry_employee_id" id="entry_employee_id" value="<cfoutput>#GET_TRAINING_PERF_DETAIL.ENTRY_EMP_ID#</cfoutput>">
				<cfsavecontent variable="message">Değerlendiren Kişi Seçmelisiniz !</cfsavecontent>
				<cfinput type="text" name="entry_emp" style="width:150px;" value="#GET_ENTRY_EMP.EMPLOYEE_NAME# #GET_ENTRY_EMP.EMPLOYEE_SURNAME#" required="yes" message="#message#">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_perform.entry_employee_id&field_emp_name=add_perform.entry_emp','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			</td>
        </tr>
		<tr>
			<td class="txtbold">Değerlendirme Tarihi *</td>
			<td>
				<cfsavecontent variable="message">Görüşme tarihi girilmelidir!</cfsavecontent>
				<cfinput type="text" name="INTERVIEW_DATE" validate="#validate_style#" value="#DateFormat(GET_TRAINING_PERF_DETAIL.INTERVIEW_DATE,dateformat_style)#" style="width:65px;" required="yes" message="#message#">
				<cf_wrk_date_image date_field="INTERVIEW_DATE">					  
			</td>
		</tr>
       </table>
        </td>
        </tr>
		
        <cfinclude template="../display/performance_training_quiz_upd.cfm">
        <cfinclude template="../query/act_quiz_perf_point.cfm">
        <tr class="color-header" height="22">
          <td height="22" class="form-title">Genel Değerlendirme (İK Departmanı)</td>
        </tr>
        <tr class="color-header" height="22">
          <td valign="top" class="color-row">
			<table width="320">
			<tr>
				<td colspan="2"><strong>Sonuç</strong></td>
			</tr>
			<input name="USER_POINT" id="USER_POINT" value="" type="hidden">
			<input name="PERFORM_POINT" id="PERFORM_POINT" value="<cfoutput>#Round(quiz_point)#</cfoutput>" type="hidden">
			  <tr>
				<td>Toplam Puan</td>
				<td>
					<cfif GET_TRAINING_PERF_DETAIL.perform_point gt 0>
					<cfif GET_TRAINING_PERF_DETAIL.USER_POINT gt 0 >
						<cfset last_point = ((GET_TRAINING_PERF_DETAIL.USER_POINT / GET_TRAINING_PERF_DETAIL.PERFORM_POINT) * 100)>					
						<cfoutput>#Round(last_point)# / 100</cfoutput>
					<cfelse>
						<cfset last_point =0>
						0
					</cfif>
					<cfelse>
						<cfset last_point =0>
						0
					</cfif>
				</td> 
			  </tr> 
			</table>
          </td>
        </tr>
		<cfif GET_TRAINING_PERF_DETAIL.RECORD_MEMBER eq session.ep.userid>
        <tr>
          <td height="35" align="center" class="color-row">
		  	<cfif session.ep.admin>
		  		<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_training_performance&training_per_id=#attributes.training_per_id#'> </td>
			<cfelse>
				<cf_workcube_buttons is_upd='0'>
			</cfif>
        </tr>
		</cfif>
      </table>
      </td>
      </tr>
    </table>
    </td>
    </tr>
  </table>
</cfform>
<br/>
