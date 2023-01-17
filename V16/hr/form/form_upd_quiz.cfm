<cfinclude template="../query/get_quiz.cfm">
<cfinclude template="../query/get_commethods.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfif len(get_quiz.start_date)>
	<cfset attributes.start_date = dateformat(get_quiz.start_date,dateformat_style)>
<cfelse>
	<cfset attributes.start_date = "01/01/#session.ep.period_year#">
</cfif>
<cfif len(get_quiz.finish_date)>
	<cfset attributes.finish_date = dateformat(get_quiz.finish_date,dateformat_style)>
<cfelse>
	<cfset attributes.finish_date = "31/12/#session.ep.period_year#">
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55296.Ölçme Değerlendirme Formu Ekle"></cfsavecontent>
<cf_popup_box title="#message#">
		<cfform name="add_quiz" method="post" action="#request.self#?fuseaction=hr.upd_quiz">
		<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
        	<cf_area width="200">
				<div id="tra_sol" style="position:absolute;width:200px;height:300px; z-index:88;overflow:auto;">
					<table width="98%" border="0">
						<!--- 
						<tr>
							<td><input type="checkbox" name="is_all_employee" value="1" <cfif get_quiz.is_all_employee eq 1>checked</cfif>> Tüm Çalışanlar</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="is_mail_control" value="1" <cfif get_quiz.is_mail_control eq 1>checked</cfif>> Mail Gidenler</td>
						</tr>
						 --->
						<tr>
							<td><cfsavecontent variable="pos_typ"><cf_get_lang dictionary_id ='57779.Pozisyon Değerleri'></cfsavecontent>
								<cf_relation_segment
									is_upd='1'
									is_form='1'
									field_id= '#attributes.quiz_id#'
									table_name='EMPLOYEE_QUIZ'
									tag_head='#pos_typ#'
									action_table_name='RELATION_SEGMENT_QUIZ'
									select_list='3'>
							</td>
						</tr>
					</table>
				</div>
				</cf_area>
                <cf_area>
					<table border="0">
						<tr>
							<td style="width:90px;">&nbsp;</td>
							<td colspan="2">
								<input type="checkbox" name="is_active" id="is_active" <cfif get_quiz.is_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'><!--- <cf_get_lang no='213.Seçili İse Aktif'> --->
								<input type="checkbox" name="is_show" id="is_show" <cfif get_quiz.is_show eq 1>checked</cfif>><cf_get_lang dictionary_id='55811.Talep Sayfasında Göster'>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58820.Başlık'></td>
							<td colspan="2">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
								<cfinput type="text" name="quiz_head" value="#get_quiz.quiz_head#" style="width:350px;" required="Yes" message="#message#">
							</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
							<td colspan="2"><textarea name="quiz_objective" id="quiz_objective" style="width:350px;height:100px;"><cfoutput>#get_quiz.quiz_objective#</cfoutput></textarea></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57630.Tip'></td>
							<td colspan="2">
								<select name="IS_TYPE" id="IS_TYPE" onChange="findType()" style="width:150px;">
									<option value="0"><cf_get_lang dictionary_id='58003.Performans'></option>
									<option value="IS_TEST_TIME" <cfif get_quiz.IS_TEST_TIME eq 1>selected</cfif>><cf_get_lang dictionary_id='29776.Deneme Süresi'></option>
									<option value="IS_INTERVIEW_IN" <cfif get_quiz.IS_INTERVIEW_IN eq 1>selected</cfif>><cf_get_lang dictionary_id='56666.Mülakat'>(<cf_get_lang dictionary_id='55098.İşe Giris'>)</option>
									<option value="IS_INTERVIEW" <cfif get_quiz.IS_INTERVIEW eq 1>selected</cfif>><cf_get_lang dictionary_id='56666.Mülakat'>(<cf_get_lang dictionary_id='29832.İşte Çıkış'>)</option>
								</select>
							</td>
						</tr>
						<!--- 
						<tr style="display:none;">
							<td><cf_get_lang_main no='642.Süreç-Aşama'></td>
							<td><cf_workcube_process is_upd='0' is_detail="0" process_cat_width='150px'></td>
						</tr>
						 --->
						<tr id="COMMETHOD1">
							<td><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></td>
							<td colspan="2"><select name="COMMETHOD_ID" id="COMMETHOD_ID" style="width:150px;">
									<cfoutput query="GET_COMMETHODS">
										<option value="#COMMETHOD_ID#" <cfif get_quiz.COMMETHOD_ID eq GET_COMMETHODS.COMMETHOD_ID>selected</cfif>>#COMMETHOD#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<!--- 
						<tr id="COMMETHOD2">
							<td><cf_get_lang no='915.Form Tipi'></td>	
							<td><select name="form_open_type_id" style="width:75px;">
									<option value="1" <cfif get_quiz.FORM_OPEN_TYPE is 1>selected</cfif>><cf_get_lang_main no='1305.Açık'></option>
									<option value="2" <cfif get_quiz.FORM_OPEN_TYPE is 2>selected</cfif>><cf_get_lang no='917.Yarı Açık'></option>
									<!--- <option value="3" <cfif get_quiz.FORM_OPEN_TYPE is 3>selected</cfif>><cf_get_lang no='918.Kapalı'></option> --->
								</select>
							</td>
						</tr>
						 --->
						<tr>
							<td><cf_get_lang dictionary_id='58472.Dönem'></td>
							<td colspan="2">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
								<cfinput required="Yes" message="#message#" maxlength="10" type="text" name="start_date" validate="#validate_style#" value="#attributes.start_date#" style="width:75px;">
								<cf_wrk_date_image date_field="start_date">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
								<cfinput required="Yes" message="#message#" maxlength="10" type="text" name="finish_date" validate="#validate_style#" value="#attributes.finish_date#" style="width:75px;">
								<cf_wrk_date_image date_field="finish_date">
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td colspan="2">
								<input type="checkbox" name="IS_EXTRA_RECORD_EMP" id="IS_EXTRA_RECORD_EMP" <cfif get_quiz.IS_EXTRA_RECORD_EMP eq 1>checked</cfif>><cf_get_lang dictionary_id ='56455.Çalışan Not Kaydı'>
								<input type="checkbox" name="IS_EXTRA_RECORD" id="IS_EXTRA_RECORD" <cfif get_quiz.IS_EXTRA_RECORD eq 1>checked</cfif>><cf_get_lang dictionary_id ='56456.Yönetici Not Kaydı'>
								
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td colspan="2">
								<input type="checkbox" name="IS_RECORD_TYPE" id="IS_RECORD_TYPE" <cfif get_quiz.IS_RECORD_TYPE eq 1>checked</cfif>><cf_get_lang dictionary_id='56005.Görüş bildiren kaydı'>
								<input type="checkbox" name="IS_EXTRA_QUIZ" id="IS_EXTRA_QUIZ" <cfif get_quiz.IS_EXTRA_QUIZ eq 1>checked</cfif>><cf_get_lang dictionary_id ='41013.Ortak Değerlendirme Not Kaydı'> 
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td colspan="2"><input type="checkbox" name="IS_VIEW_QUESTION" id="IS_VIEW_QUESTION" <cfif get_quiz.IS_VIEW_QUESTION eq 1>checked</cfif>><cf_get_lang dictionary_id ='56458.Sorular Görüntülensin'></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><b><cf_get_lang dictionary_id="29907.Değerlendiriciler"></b></td>
							<td><b><cf_get_lang dictionary_id="29784.Ağırlık"></b></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><input type="checkbox" name="IS_MANAGER_0" id="IS_MANAGER_0" <cfif get_quiz.IS_MANAGER_0 eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id="30368.Çalışan"></td>
							<td style="width:250px;"><cfinput type="text" name="emp_quiz_weight" value="#get_quiz.emp_quiz_weight#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><input type="checkbox" name="IS_MANAGER_3" id="IS_MANAGER_3" <cfif get_quiz.IS_MANAGER_3 eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td>
							<td><cfinput type="text" name="manager_quiz_weight_3" value="#get_quiz.manager_quiz_weight_3#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><input type="checkbox" name="IS_MANAGER_1" id="IS_MANAGER_1" <cfif get_quiz.IS_MANAGER_1 eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='35927.1 Amir'></td>
							<td><cfinput type="text" name="manager_quiz_weight_1" value="#get_quiz.manager_quiz_weight_1#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><input type="checkbox" name="IS_MANAGER_4" id="IS_MANAGER_4" <cfif get_quiz.IS_MANAGER_4 eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id="29909.Ortak Değerlendirme"></td>
							<td><cfinput type="text" name="manager_quiz_weight_4" value="#get_quiz.manager_quiz_weight_4#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><input type="checkbox" name="IS_MANAGER_2" id="IS_MANAGER_2" <cfif get_quiz.IS_MANAGER_2 eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='35921.2 Amir'></td>
							<td><cfinput type="text" name="manager_quiz_weight_2" value="#get_quiz.manager_quiz_weight_2#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td colspan="2">
								<input type="checkbox" name="IS_CAREER" id="IS_CAREER" <cfif get_quiz.IS_CAREER eq 1>checked</cfif>><cf_get_lang dictionary_id ='58030.Kariyer'>
								<input type="checkbox" name="IS_TRAINING" id="IS_TRAINING" <cfif get_quiz.IS_TRAINING eq 1>checked</cfif>><cf_get_lang dictionary_id ='56459.Gelişim'>
								<input type="checkbox" name="IS_OPINION" id="IS_OPINION" <cfif get_quiz.IS_OPINION eq 1>checked</cfif>><cf_get_lang dictionary_id ='55527.Amirlerin Görüşleri'>
							</td>
						</tr>
					</table>
				</cf_area>
                <cf_area width="220">
					<cf_get_workcube_asset asset_cat_id="-9" module_id='3' action_section='QUIZ_ID' action_id='#attributes.quiz_id#'><br/>
                </cf_area>
        <cf_popup_box_footer><cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()"></cf_popup_box_footer>
		</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if(document.add_quiz.IS_MANAGER_0.checked == true && document.add_quiz.emp_quiz_weight.value == '')
	{
		alert("<cf_get_lang dictionary_id='41011.Çalışan için 1 ile 100 arasında ağırlık değeri giriniz'>!");
		return false;
	}
	if(document.add_quiz.IS_MANAGER_3.checked == true && document.add_quiz.manager_quiz_weight_3.value == '')
	{
		alert("<cf_get_lang dictionary_id='41009.Görüş Bildiren için 1 ile 100 arasında ağırlık değeri giriniz'>!");
		return false;
	}
	if(document.add_quiz.IS_MANAGER_1.checked == true && document.add_quiz.manager_quiz_weight_1.value == '')
	{
		alert("<cf_get_lang dictionary_id='41008.1inci Amir için 1 ile 100 arasında ağırlık değeri giriniz!'>");
		return false;
	}
	if(document.add_quiz.IS_MANAGER_4.checked == true && document.add_quiz.manager_quiz_weight_4.value == '')
	{
		alert("<cf_get_lang dictionary_id='41007.Ortak Değerlendirme için 1 ile 100 arasında ağırlık değeri giriniz !'>");
		return false;
	}
	if(document.add_quiz.IS_MANAGER_2.checked == true && document.add_quiz.manager_quiz_weight_2.value == '')
	{
		alert("<cf_get_lang dictionary_id='41004.2inci Amir için 1 ile 100 arasında ağırlık değeri giriniz'>!");
		return false;
	}		
}
function findType()
{
	if (document.add_quiz.IS_TYPE.value == "IS_INTERVIEW")
	{
		gizle(COMMETHOD1);
	}
	else if (document.add_quiz.IS_TYPE.value == "IS_TEST_TIME")
	{
		gizle(COMMETHOD1);
	}
	else if (document.add_quiz.IS_TYPE.value == 0 || document.add_quiz.IS_TYPE.value != "IS_INTERVIEW" || document.add_quiz.IS_TYPE.value != "IS_TEST_TIME")
	{
		goster(COMMETHOD1);
	}
}
</script>
