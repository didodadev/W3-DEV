<!--- Bu sayfanın aynısı Myhomeda da bulunmaktadır. Yapılan değişiklikler myhome a da eklenmeli..Senay 20060418 --->
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
<cfinclude template="../query/get_quiz_info.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfsavecontent variable="title_">
	<cf_get_lang dictionary_id='29764.Form'>:<cfoutput>#GET_QUIZ_INFO.QUIZ_HEAD#</cfoutput> 
</cfsavecontent>
<cf_form_box title="#title_#">
<cfform name="add_perform" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_app_performance">
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
	<table>
		<tr>
			<td colspan="2" class="txtbold"><cf_get_lang dictionary_id ='56672.Bu değerlendirme formu, başvuranı değerlendirecek ilgili yöneticiler tarafından yapılacaktır'>.</td>
		</tr>
		<tr>
			<td width="100"><cf_get_lang dictionary_id='29514.Başvuru Yapan'></td>
			<td width="185"><cfoutput>#attributes.app_employee_name# #attributes.app_employee_surname#</cfoutput></td>
		</tr>
		<tr>
			<td width="100"><cf_get_lang dictionary_id ='55316.Değerlendiren'> *</td>
			<td width="185">
				<input type="hidden" name="entry_employee_id" id="entry_employee_id" value="">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='56674.Değerlendiren Kişi Seçmelisiniz'> !</cfsavecontent>
				<cfinput type="text" name="entry_emp" style="width:150px;" value="" required="yes" message="#message#">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_perform.entry_employee_id&field_emp_name=add_perform.entry_emp','list','popup_list_positions');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='56675.Görüşülen Pozisyon'> *</td>
			<td>
				<input type="hidden" name="meet_position_code" id="meet_position_code" value="">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='56676.Görüşülen Pozisyon Seçmelisiniz'> !</cfsavecontent>
				<cfinput type="text" name="meet_app_position" style="width:150px;" value="" required="yes" message="#message#">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_perform.meet_position_code&field_pos_name=add_perform.meet_app_position&show_empty_pos=1','list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='56677.Görüşme Tarihi'> *</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='56678.Görüşme tarihi girilmelidir'>!</cfsavecontent>
				<cfinput type="text" name="INTERVIEW_DATE" validate="#validate_style#" value="" style="width:65px;" required="yes" message="#message#">
				<cf_wrk_date_image date_field="INTERVIEW_DATE">						  
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='56314.Görünsün'></td>
			<td><input type="checkbox" name="is_view" id="is_view" value="1" checked><!---formun myhome da görünmemesi için---></td>
		</tr>
	</table>
	<cfinclude template="../display/performance_app_quiz.cfm">
	<cfinclude template="../query/act_quiz_perf_point.cfm">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="56679.İlgililerin Görüşleri"></cfsavecontent>
	<cf_seperator title="#message#" id="ilgililerin_gorusleri_">
	<table id="ilgililerin_gorusleri_">
		<tr>
			<td><cf_get_lang dictionary_id ='56682.İngilizce Sınav Sonucu'></td>
			<td>: <input type="text" name="eng_test_result" id="eng_test_result" value=""></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='31947.Yetenek Testi Sonucu'></td>
			<td>: <input type="text" name="ability_test_result" id="ability_test_result" value=""></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='56684.Değerlendirilebileceği Diğer Pozisyonlar'></td>
			<td>:
				<select name="other_position_code" id="other_position_code" style="width:235px;">
					<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
					<cfoutput query="get_position_cats">
						<option value="#position_cat_id#">#position_cat#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2"><cf_get_lang dictionary_id ='56680.Önemli Notlar'></td>
		</tr>
		<tr>
			<td colspan="2">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
				<textarea name="notes" id="notes" style="width:300px;height:40px;" maxlength="2000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2"><cf_get_lang dictionary_id ='56681.Referans Kontrolü Sonucu'></td>
		</tr>
		<tr>
			<td colspan="2"><textarea name="ref_control" id="ref_control" style="width:300px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
		</tr>
	</table>
	<cf_seperator title="#getLang('hr',1600)#" id="degerlendirme_">
	<table id="degerlendirme_">
		<tr>
			<td><input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="1" checked></td><td><cf_get_lang dictionary_id ='56686.Pozisyona Uygundur'></td>
			<td><input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="2"></td><td><cf_get_lang dictionary_id ='56687.Pozisyona Uygun Değildir'></td>
		</tr>
	</table>
	<cf_form_box_footer>
		<cfif session.ep.admin>
			<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_app_performance&emp_app_quiz_id=#attributes.emp_app_quiz_id#'>
		<cfelse>
			<cf_workcube_buttons is_upd='0'>
		</cfif>
	</cf_form_box_footer>
</cfform>
</cf_form_box>

