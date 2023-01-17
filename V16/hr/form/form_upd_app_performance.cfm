<!--- Bu sayfanın aynısı Myhomeda da bulunmaktadır. Yapılan değişiklikler myhome a da eklenmeli..Senay 20060418 --->
<cfinclude template="../query/get_app_perf_detail.cfm">
<cfscript>
	attributes.app_emp_id = GET_APP_PERF_DETAIL.EMP_APP_ID;
	attributes.quiz_id = GET_APP_PERF_DETAIL.quiz_id;
	attributes.app_employee_name = GET_APP_PERF_DETAIL.NAME;
	attributes.app_employee_surname = GET_APP_PERF_DETAIL.SURNAME;
</cfscript>
<cfinclude template="../query/get_quiz_info.cfm">
<cfinclude template="../query/get_app_emp_quiz_answers.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfsavecontent variable="title_">
	<cf_get_lang dictionary_id='29764.Form'>:<cfoutput>#GET_QUIZ_INFO.QUIZ_HEAD#</cfoutput> 
</cfsavecontent>
<cfsavecontent variable="img_">
    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_print_app_performance&app_per_id=#attributes.app_per_id#</cfoutput>','page','popup_print_app_performance');"><img src="/images/print.gif" border="0"></a>
</cfsavecontent>
<cf_form_box title="#title_#" right_images="#img_#">
<cfform name="add_perform" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_app_performance">
  <input type="hidden" name="RESULT_ID" id="RESULT_ID" value=" <cfoutput>#GET_APP_PERF_DETAIL.RESULT_ID#</cfoutput>">
	<cfif isdefined('attributes.APP_PER_ID')>
		<input type="hidden" name="APP_PER_ID" id="APP_PER_ID" value="<cfoutput>#attributes.APP_PER_ID#</cfoutput>">
	</cfif>
	<cfif isdefined('attributes.emp_app_quiz_id')>
		<input type="hidden" name="emp_app_quiz_id" id="emp_app_quiz_id" value="<cfoutput>#attributes.emp_app_quiz_id#</cfoutput>">
	</cfif>
	<cfif isdefined('attributes.app_pos_id')>
		<input type="hidden" name="app_pos_id" id="app_pos_id" value="<cfoutput>#attributes.app_pos_id#</cfoutput>">
	</cfif>
	<cfif isdefined('attributes.is_cv')>
		<input type="hidden" name="is_cv" id="is_cv" value="1">
	</cfif>
	<cfif isdefined('attributes.is_app')>
			<input type="hidden" name="is_app" id="is_app" value="1">
	</cfif>
    <table>
	  	<tr>
			<td colspan="2" class="txtbold"><cf_get_lang dictionary_id ='56697.Bu değerlendirme formu, başvuru yapan kişi ile ilgili yöneticiler tarafından yapılacaktır'>.</td>
		</tr>
		<tr>
			<td width="100" class="txtbold"><cf_get_lang dictionary_id='29514.Başvuru Yapan'></td>
			<td width="185"><cfoutput>#attributes.app_employee_name# #attributes.app_employee_surname#</cfoutput></td>
        </tr>
        <tr>
			<td width="100" class="txtbold"><cf_get_lang dictionary_id ='55316.Değerlendiren'> *</td>
			<td width="185">
				<input type="hidden" name="entry_employee_id" id="entry_employee_id" value="<cfoutput>#GET_APP_PERF_DETAIL.ENTRY_EMP_ID#</cfoutput>">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='56674.Değerlendiren Kişi Seçmelisiniz'>!</cfsavecontent>
				<cfinput type="text" name="entry_emp" style="width:150px;" value="#GET_ENTRY_EMP.EMPLOYEE_NAME# #GET_ENTRY_EMP.EMPLOYEE_SURNAME#" required="yes" message="#message#">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_perform.entry_employee_id&field_emp_name=add_perform.entry_emp','list','popup_list_positions');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
			</td>
        </tr>
        <tr>
			<td class="txtbold"><cf_get_lang dictionary_id ='56675.Görüşülen Pozisyon'> *</td>
			<td>
				<input type="hidden" name="meet_position_code" id="meet_position_code" value="<cfoutput>#GET_APP_PERF_DETAIL.MEET_POS_CODE#</cfoutput>">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='56676.Görüşülen Pozisyon Seçmelisiniz'> !</cfsavecontent>
				<cfinput type="text" name="meet_app_position" style="width:150px;" value="#GET_MEET_POS.POSITION_NAME#" required="yes" message="#message#">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_perform.meet_position_code&field_pos_name=add_perform.meet_app_position&show_empty_pos=1','list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			</td>
        </tr>
		<tr class="txtbold">
			<td><cf_get_lang dictionary_id ='56698.Form Görünsün'></td>
			<td><input type="checkbox" name="is_view" id="is_view" value="1" <cfif GET_APP_PERF_DETAIL.IS_VIEW>checked</cfif>></td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id ='56677.Görüşme Tarihi'>*</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='56678.Görüşme tarihi girilmelidir'>!</cfsavecontent>
				<cfinput type="text" name="INTERVIEW_DATE" validate="#validate_style#" value="#DateFormat(GET_APP_PERF_DETAIL.INTERVIEW_DATE,dateformat_style)#" style="width:65px;" required="yes" message="#message#">
				<cf_wrk_date_image date_field="INTERVIEW_DATE">					  
			</td>
		</tr>
		<tr>
			<cfif GET_APP_PERF_DETAIL.VALID_EMP_ID eq "">
				<td class="txtbold"><cf_get_lang dictionary_id ='55933.Onay ve Tarih'></td>
				<td>
					<input name="is_valid" id="is_valid" value="" type="hidden">
					<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56074.Onaylamakta Oldugunuz belge sirketinizi ve sizi baglayacak konular içerebilir Onaylamak istediginizden emin misiniz'></cfsavecontent>
					<input type="image" onclick="if (confirm('<cfoutput>#alert#</cfoutput>')) {add_perform.is_valid.value='1'} else {return false}" src="/images/valid.gif" alt="<cf_get_lang_main no ='1063.Onayla'>" border="0">
					<cfsavecontent variable="alert2"><cf_get_lang dictionary_id ='56075.Reddettiginiz belge sirketinizi ve sizi baglayacak konular içerebilir Reddetmek istediginizden emin misiniz'></cfsavecontent>
					<input type="image" onclick="if (confirm('<cfoutput>#alert2#</cfoutput>')) {add_perform.is_valid.value='0';} else {return false;}" src="/images/refusal.gif" alt="<cf_get_lang_main no='1049.Reddet'>">
				</td>
			<cfelse>
				<td class="txtbold"><cf_get_lang dictionary_id ='55933.Onay ve Tarih'></td>
				<td>
					<cfif GET_APP_PERF_DETAIL.IS_VALID eq 1>
						<cfoutput>#DateFormat(GET_APP_PERF_DETAIL.VALID_DATE,dateformat_style)# #TimeFORMAT(GET_APP_PERF_DETAIL.VALID_DATE,timeformat_style)# </cfoutput>
						<cf_get_lang dictionary_id ='55260.Onaylayan'>:
					<cfelseif GET_APP_PERF_DETAIL.IS_VALID eq 0>
						<cfoutput>#DateFormat(GET_APP_PERF_DETAIL.VALID_DATE,dateformat_style)# #TimeFORMAT(GET_APP_PERF_DETAIL.VALID_DATE,timeformat_style)# </cfoutput>
						<cf_get_lang dictionary_id ='55529.Reddeden'>:
					</cfif>
					<cfoutput>#get_emp_info(GET_APP_PERF_DETAIL.VALID_EMP_ID,0,0)#</cfoutput></td>
			</cfif>
		</tr>
      </table>
      <cfinclude template="../display/performance_app_quiz_upd.cfm">
	  <cfinclude template="../query/act_quiz_perf_point.cfm">
	  <cfsavecontent variable="message"><cf_get_lang dictionary_id="56679.İlgililerin Görüşleri"></cfsavecontent>
	  <cf_seperator title="#message#" id="ilgililerin_gorusleri_">
	  <table id="ilgililerin_gorusleri_">
		<tr>
			<td><cf_get_lang dictionary_id ='56682.İngilizce Sınav Sonucu'></td>
			<td>: <input type="text" name="eng_test_result" id="eng_test_result" value="<cfoutput>#get_app_perf_detail.eng_test_result#</cfoutput>"></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='31947.Yetenek Testi Sonucu'></td>
			<td>: <input type="text" name="ability_test_result" id="ability_test_result" value="<cfoutput>#get_app_perf_detail.ability_test_result#</cfoutput>"></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='56684.Değerlendirilebileceği Diğer Pozisyonlar'>:</td>
			<td>:
				<select name="other_position_code" id="other_position_code" style="width:200px;">
					<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
					<cfoutput query="GET_POSITION_CATS">
					<option value="#POSITION_CAT_ID#"<cfif get_app_perf_detail.other_position_code eq POSITION_CAT_ID> selected</cfif>>#POSITION_CAT#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
	    <tr>
			<td colspan="2"><cf_get_lang dictionary_id ='56680.Önemli Notlar'></td>
		</tr>
	    <tr><cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
		     <td colspan="2"><textarea name="notes" id="notes" style="width:300px;height:40px;" maxlength="2000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#GET_APP_PERF_DETAIL.NOTES#</cfoutput></textarea></td>
	    </tr>
	    <tr>
			<td colspan="2"><cf_get_lang dictionary_id ='56681.Referans Kontrolü Sonucu'></td>
	    </tr>
	    <tr>
			<td colspan="2"><textarea name="ref_control" id="ref_control" style="width:300px;height:40px;" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#GET_APP_PERF_DETAIL.REF_CONTROL#</cfoutput></textarea></textarea></td>
	    </tr>
	</table>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="55532.Genel Değerlendirme (İK Departmanı)"></cfsavecontent>
	<cf_seperator title="#message#" id="genel_degerlendirme_">
	<table id="genel_degerlendirme_">
		<tr>
			<td colspan="2"><strong><cf_get_lang dictionary_id ='57684.Sonuç'></strong></td>
		</tr>
		<input name="USER_POINT" id="USER_POINT" value="" type="hidden">
		<input name="PERFORM_POINT" id="PERFORM_POINT" value="<cfoutput>#Round(quiz_point)#</cfoutput>" type="hidden">
		<tr>
			<td><cf_get_lang dictionary_id='57776.Kişinin Aldığı Puan / Toplam Puan'></td>
			<td>
				<cfif get_app_perf_detail.perform_point gt 0>
					<cfset last_point = ((GET_APP_PERF_DETAIL.USER_POINT / GET_APP_PERF_DETAIL.PERFORM_POINT) * 100)>					
					<cfoutput>#Round(last_point)# / 100</cfoutput>
				<cfelse>0
				</cfif>
			</td> 
		  </tr> 
		  <tr>
				<td><input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="1" <cfif GET_APP_PERF_DETAIL.PERFORM_POINT_ID IS 1>checked</cfif>><cf_get_lang dictionary_id ='56686.Pozisyona Uygundur'></td>
				<td><input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="2" <cfif GET_APP_PERF_DETAIL.PERFORM_POINT_ID IS 2>checked</cfif>><cf_get_lang dictionary_id ='56687.Pozisyona Uygun Değildir'></td>
		   </tr>
	 </table>
 	<cf_form_box_footer>
		  	<cfif session.ep.admin>
		  		<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_app_performance&app_per_id=#attributes.app_per_id#'> </td>
			<cfelse>
				<cf_workcube_buttons is_upd='0'>
			</cfif>
    </cf_form_box_footer>
</cfform>
</cf_form_box>
