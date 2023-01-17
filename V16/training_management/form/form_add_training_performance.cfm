<!--- Bu sayfanın aynısı Myhomeda da bulunmaktadır. Yapılan değişiklikler myhome a da eklenmeli..Senay 20060418 --->
<cfset employee_id = attributes.employee_id>
<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
	SELECT
		EMPLOYEE_NAME AS NAME,
		EMPLOYEE_SURNAME AS SURNAME
	FROM
		EMPLOYEES
	WHERE
		EMPLOYEE_ID = #EMPLOYEE_ID#
</cfquery>
<cfscript>
	attributes.app_employee_name = GET_EMPLOYEE.NAME;
	attributes.app_employee_surname = GET_EMPLOYEE.SURNAME;
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
		IS_INTERVIEW,
		IS_OPINION,
		FORM_OPEN_TYPE
	FROM 
		EMPLOYEE_QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>

<cfquery name="get_position_cats" datasource="#dsn#">
	SELECT POSITION_CAT, POSITION_CAT_ID FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfset interview_date = dateformat(attributes.to_day,dateformat_style)>
<cfform name="add_perform" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_app_performance">
	<cfif isdefined('attributes.employee_id')>
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
	</cfif>
	<cfif isdefined('attributes.class_id')>
		<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
	</cfif>
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="headbold"><cf_get_lang no='115.Form'>:<cfoutput>#GET_QUIZ_INFO.QUIZ_HEAD#</cfoutput> </td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0">
<tr>
<td valign="top">
<table width="98%" cellspacing="0" cellpadding="0">
  <tr class="color-border">
  <td>
  <table width="100%" cellspacing="1" cellpadding="2" border="0">
    <tr class="color-row">
      <td height="22" class="txtboldblue">Bu değerlendirme formu, başvuranı değerlendirecek ilgili yöneticiler tarafından yapılacaktır.</td>
    </tr>
    <tr>
      <td class="color-row">
      <table>
        <tr>
			<td width="100" class="txtbold">Değerlendiren *</td>
			<td width="185">
				<input type="Hidden" name="entry_employee_id" id="entry_employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
				<cfsavecontent variable="message">Değerlendiren Kişi Seçmelisiniz !</cfsavecontent>
				<cfinput type="text" name="entry_emp" style="width:150px;" value="#get_emp_info(attributes.employee_id,0,0)#" required="yes" message="#message#">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_perform.entry_employee_id&field_emp_name=add_perform.entry_emp','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
			</td>
        </tr>
		<tr>
			<td class="txtbold">Değerlendirme Tarihi *</td>
			<td>
				<cfsavecontent variable="message">Görüşme tarihi girilmelidir!</cfsavecontent>
				<cfinput type="text" name="INTERVIEW_DATE" validate="#validate_style#" value="#interview_date#" style="width:65px;" required="yes" message="#message#">
				<cf_wrk_date_image date_field="INTERVIEW_DATE">						  
			</td>
		</tr>
      </table>
    </td>
    </tr>
    <cfinclude template="../display/performance_training_quiz.cfm">
    <cfinclude template="../query/act_quiz_perf_point.cfm">
      <tr>
        <td height="35" align="center" class="color-row">
		<!--- <cfif session.ep.admin>
			<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.popup_del_app_performance&emp_app_quiz_id=#attributes.emp_app_quiz_id#'>
		<cfelse> --->
			<cf_workcube_buttons is_upd='0' add_function='kontrol_chapter()'>
		<!--- </cfif> --->
		</td>
      </tr>
    </table>
    </td>
    </tr>
  </table>
  </td>
  </tr>
</table>
</cfform>
