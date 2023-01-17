<!--- Bu sayfanın aynısı hr da da bulunmaktadır. Yapılan değişikliklerin hr daki sayfayada eklenmesi gerekiyor.. Senay 20060418 --->
<cfset empapp_id = attributes.empapp_id>
<cfquery name="GET_APP" datasource="#DSN#">
	SELECT
		NAME,
		SURNAME
	FROM
		EMPLOYEES_APP
	WHERE
		EMPAPP_ID = #EMPAPP_ID#
</cfquery>
<cfscript>
	attributes.app_employee_name = GET_APP.NAME;
	attributes.app_employee_surname = GET_APP.SURNAME;
</cfscript>
<!--- <cfinclude template="../query/get_quiz_info.cfm"> --->
<cfquery name="GET_QUIZ_INFO" datasource="#dsn#">
	SELECT 
		QUIZ_HEAD,
		IS_EXTRA_RECORD,
		IS_EXTRA_RECORD_EMP,
		IS_RECORD_TYPE
	FROM 
		EMPLOYEE_QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<cfform name="add_perform" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_app_performance">
	<cfif isdefined('attributes.emp_app_quiz_id')>
		<input type="hidden" name="emp_app_quiz_id" id="emp_app_quiz_id" value="<cfoutput>#attributes.emp_app_quiz_id#</cfoutput>">
	</cfif>
	<cfif isdefined('attributes.is_cv')>
		<input type="hidden" name="is_cv" id="is_cv" value="1">
	</cfif>
	<cfif isdefined('attributes.empapp_id')>
		<input type="hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#attributes.empapp_id#</cfoutput>">
	</cfif>
	<cfif isdefined('attributes.is_app')>
		<input type="hidden" name="is_app" id="is_app" value="1">
	</cfif>
	<cfif isdefined('attributes.app_pos_id')>
		<input type="hidden" name="app_pos_id" id="app_pos_id" value="<cfoutput>#attributes.app_pos_id#</cfoutput>">
	</cfif>
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="headbold"><cf_get_lang dictionary_id='29764.Form'>:<cfoutput>#get_quiz_info.quiz_head#</cfoutput> </td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0">
<tr>
<td valign="top">
  <table width="98%" cellspacing="1" cellpadding="2" class="color-border" align="center">
    <tr class="color-row">
      <td height="22" class="txtboldblue"><cf_get_lang dictionary_id ='31936.Bu değerlendirme formu, başvuranı değerlendirecek ilgili yöneticiler tarafından yapılacaktır'>.</td>
    </tr>
    <tr>
      <td class="color-row">
      <table>
        <tr>
			<td width="100" class="txtbold"><cf_get_lang dictionary_id='29514.Başvuru Yapan'></td>
			<td width="185"><cfoutput>#attributes.app_employee_name# #attributes.app_employee_surname#</cfoutput></td>
        </tr>
        <tr>
			<td width="100" class="txtbold"><cf_get_lang dictionary_id ='31937.Değerlendiren'> *</td>
			<td width="185">
				<input type="Hidden" name="entry_employee_id" id="entry_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
				<!--- <cfsavecontent variable="message"><cf_get_lang no='1201.Değerlendiren Kişi Seçmelisiniz'>!</cfsavecontent> --->
				<cfinput type="text" name="entry_emp" style="width:150px;" value="#get_emp_info(session.ep.userid,0,0)#" readonly>
				<!--- <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_perform.entry_employee_id&field_emp_name=add_perform.entry_emp','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> --->
			</td>
        </tr>
        <tr>
			<td class="txtbold"><cf_get_lang dictionary_id ='31938.Görüşülen Pozisyon'> *</td>
			<td>
				<input type="hidden" name="meet_position_code" id="meet_position_code" value="">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31939.Görüşülen Pozisyon Seçmelisiniz'> !</cfsavecontent>
				<cfinput type="text" name="meet_app_position" style="width:150px;" value="" required="yes" message="#message#">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_perform.meet_position_code&field_pos_name=add_perform.meet_app_position&show_empty_pos=1&select_list=1','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
			</td>
        </tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id ='31940.Görüşme Tarihi'> *</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31941.Görüşme tarihi girilmelidir'>!</cfsavecontent>
				<cfinput type="text" name="interview_date" validate="#validate_style#" value="" style="width:65px;" required="yes" message="#message#">
				<cf_wrk_date_image date_field="interview_date">						  
			</td>
		</tr>
		<tr class="txtbold">
			<td><cf_get_lang dictionary_id ='31942.Form Görünsün'></td>
			<td><input type="checkbox" name="is_view" id="is_view" value="1" checked></td>
		</tr>	
      </table>
    </td>
    </tr>
    <cfinclude template="../../hr/display/performance_app_quiz.cfm">
    <cfinclude template="../../hr/query/act_quiz_perf_point.cfm">
    <tr class="color-list" height="22">
      <td height="22" class="txtboldblue"><cf_get_lang dictionary_id ='31943.İlgililerin Görüşleri'></td>
    </tr>
    <tr>
      <td class="color-row">
        <table>
          <tr>
            <td valign="top"><cf_get_lang dictionary_id ='31944.Önemli Notlar'></td>
          </tr>
          <tr>
		  	<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
            <td><textarea name="notes" id="notes" style="width:300px;height:40px;" maxlength="2000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
          </tr>
          <tr>
			<td valign="top"><cf_get_lang dictionary_id ='31945.Referans Kontrolü Sonucu'></td>
          </tr>
          <tr>
			<td><textarea name="ref_control" id="ref_control" style="width:300px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
          </tr>
        </table>
      </td>
    </tr>
	<tr>
		<td class="color-row">
			<table width="550">
				<tr>
					<td><cf_get_lang dictionary_id ='31946.İngilizce Sınav Sonucu'>: <input type="text" name="eng_test_result" id="eng_test_result" value=""></td>
					<td><cf_get_lang dictionary_id ='31947.Yetenek Testi Sonucu'>: <input type="text" name="ability_test_result" id="ability_test_result" value=""></td>
				</tr>
			</table>
		</td>
	  </tr>
	  <tr>
	  	<td class="color-row">
			<table class="color-row">
				<tr>
					<td><cf_get_lang dictionary_id ='31948.Değerlendirilebileceği Diğer Pozisyonlar'>:</td>
					<td>
					<input type="hidden" name="other_position_code" id="other_position_code" value="">
					<input type="text" name="other_position" id="other_position" value="">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_position_cats&field_cat_id=add_perform.other_position_code&field_cat=add_perform.other_position','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</td>
				</tr>
			</table>
		</td>
	  </tr>
    <tr class="color-header" height="22">
      <td height="22" class="form-title"><cf_get_lang dictionary_id ='31949.Değerlendirme'></td>
    </tr>
    <tr class="color-header" height="22">
    <td valign="top" class="color-row">
      <table width="450">
        <tr>
			<td><input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="1" checked><cf_get_lang dictionary_id ='31950.Pozisyona Uygundur'></td>
		  	<td><input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="2"><cf_get_lang dictionary_id ='31951.Pozisyona Uygun Değildir'></td>
        </tr>
      </table>
      </td>
      </tr>
      <tr>
        <td height="35" align="center" class="color-row">
			<cf_workcube_buttons is_upd='0'>
		</td>
      </tr>
    </table>
    </td>
    </tr>
  </table>
</cfform>
