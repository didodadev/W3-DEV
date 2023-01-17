<cfquery name="MONEYS" datasource="#dsn#">
	SELECT
		MONEY_ID,
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
<cf_form_box title="#getLang('correspondence',168)#">
<cfform name="add_form" method="post" action="#request.self#?fuseaction=correspondence.emptypopup_add_personel_rotation">
	<table border="0">
		<tr>
			<td width="150"><cf_get_lang_main no="1447.Süreç">*</td>
			<td class="3"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></td>
		</tr>
		<tr>
			<td width="150"><cf_get_lang no ='153.Form Tipi'>*</td>
			<td colspan="3"><input type="checkbox" name="rise" id="rise" value="1"><cf_get_lang_main no='1155.Terfi'>
			<input type="checkbox" name="transfer" id="transfer" value="1"><cf_get_lang_main no ='1156.Transfer'>
			<input type="checkbox" name="rotation" id="rotation" value="1"><cf_get_lang_main no='1157.Rotasyon'>
			<input type="checkbox" name="salary_change" id="salary_change" value="1"><cf_get_lang_main no='1158.Ücret Değişikliği'></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='68.Başlık'> *</td>
			<td colspan="3"><cfinput type="text" name="form_head" style="width:492px;" value="" maxlength="150" required="yes" message="<cf_get_lang_main no='647.Başlık Girmelisiniz'>!"></td>
		</tr>
		<tr>
			<td class="txtbold" colspan="2"><cf_get_lang_main no='1159.Mevcut'>*</td>
			<td class="txtbold" colspan="2" width="150"><cf_get_lang no='146.Talep Edilen'> *</td>
		</tr>
		<tr>
			<td><cf_get_lang no ='157.Grup Başkanlığı'></td>
			<td>
				<input type="hidden" name="headquarters_exist_id" id="headquarters_exist_id" value="">
				<input type="text" name="headquarters_exist" id="headquarters_exist" value="" style="width:150px">
			</td>
			<td><cf_get_lang no ='157.Grup Başkanlığı'></td>
			<td>
				<input type="hidden" name="headquarters_request_id" id="headquarters_request_id" value="">
				<input type="text" name="headquarters_request" id="headquarters_request" value="" style="width:150px">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='162.Şirket'></td>
			<td>
				<input type="hidden" name="company_exist_id" id="company_exist_id" value="">
				<input type="text" name="company_exist" id="company_exist" value="" style="width:150px">
			</td>
			<td><cf_get_lang_main no ='162.Şirket'></td>
			<td>
				<input type="hidden" name="company_request_id" id="company_request_id" value="">
				<input type="text" name="company_request" id="company_request" value="" style="width:150px">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='41.Şube'></td>
			<td>
				<input type="hidden" name="branch_exist_id" id="branch_exist_id" value="">
				<input type="text" name="branch_exist" id="branch_exist" value="" style="width:150px">
			</td>
			<td><cf_get_lang_main no ='41.Şube'></td>
			<td>
				<input type="hidden" name="branch_request_id" id="branch_request_id" value="">
				<input type="text" name="branch_request" id="branch_request" value="" style="width:150px">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='160.Departman'></td>
			<td>
				<input type="hidden" name="department_exist_id" id="department_exist_id" value="">
				<input type="text" name="department_exist" id="department_exist" value="" style="width:150px">
			</td>
			<td><cf_get_lang_main no='160.Departman'></td>
			<td>
				<input type="hidden" name="department_request_id" id="department_request_id" value="">
				<input type="text" name="department_request" id="department_request" value="" style="width:150px">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='159.Unvan'></td>
			<td>
				<!--- <input type="hidden" name="pos_exist_id" value=""> --->
				<input type="text" name="pos_exist" id="pos_exist" value="" style="width:150px">
			</td>
			<td><cf_get_lang_main no='159.Unvan'></td>
			<td>
				<input type="hidden" name="pos_request_id" id="pos_request_id" value="">
				<input type="text" name="pos_request" id="pos_request" value="" style="width:150px">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='158.Adı Soyadı'></td>
			<td>
				<input type="hidden" name="pos_code" id="pos_code" value="">
				<input type="hidden" name="emp_id" id="emp_id" value="">
				<input type="text" name="emp_name" id="emp_name" value="" style="width:150px">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_pos_name=add_form.pos_exist&field_code=add_form.pos_code&field_name=add_form.emp_name&field_emp_id=add_form.emp_id&field_dep_name=add_form.department_exist&field_dep_id=add_form.department_exist_id&field_branch_name=add_form.branch_exist&field_branch_id=add_form.branch_exist_id&field_comp=add_form.company_exist&field_comp_id=add_form.company_exist_id&field_head_id=add_form.headquarters_exist_id&field_head=add_form.headquarters_exist','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			</td>
			<td><cf_get_lang_main no='158.Adı Soyadı'></td>
			<td>
				<input type="hidden" name="emp_id_req" id="emp_id_req" value="">
				<input type="text" name="emp_name_req" id="emp_name_req" value="" style="width:150px">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_form.pos_request_id&field_pos_name=add_form.pos_request&field_dep_name=add_form.department_request&field_dep_id=add_form.department_request_id&field_branch_name=add_form.branch_request&field_branch_id=add_form.branch_request_id&field_comp=add_form.company_request&field_comp_id=add_form.company_request_id&field_head_id=add_form.headquarters_request_id&field_head=add_form.headquarters_request&field_name=add_form.emp_name_req&field_emp_id=add_form.emp_id_req&show_empty_pos=0','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='158.Adı Soyadı'>" align="absmiddle" border="0"></a>
			</td>
			
		</tr>
		<tr>
			<td><cf_get_lang no ='161.Ücret'></td>
			<td>
				<input type="text" name="salary_exist" id="salary_exist" value="" onKeyup='return(FormatCurrency(this,event));' class="moneybox" style="width:100px">
				<select name="salary_exist_money" id="salary_exist_money">
				<cfoutput query="moneys">
					<option <cfif session.ep.money eq moneys.money>selected</cfif>>#moneys.money#</option>
				</cfoutput>
				</select>
			</td>
			<td><cf_get_lang no ='161.Ücret'></td>
			<td>
				<input type="text" name="salary_request" id="salary_request" value="" onKeyup='return(FormatCurrency(this,event));' class="moneybox" style="width:100px">
				<select name="salary_request_money" id="salary_request_money">
				<cfoutput query="moneys">
					<option <cfif session.ep.money eq moneys.money>selected</cfif>>#moneys.money#</option>
				</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="3" class="txtbold"><cf_get_lang no ='167.Özlük Hakları'></td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no='1068.Araç'></td>
			<td><textarea name="tool_exist" id="tool_exist" style="width:150px;height:50px;" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="150 Karakterden Fazla Yazmayınız!"></textarea></td>
			<td valign="top"><cf_get_lang_main no='1068.Araç'></td>
			<td><textarea name="tool_request" id="tool_request" style="width:150px;height:50px;"></textarea></td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no ='87.Telefon'></td>
			<td><textarea name="tel_exist" id="tel_exist" style="width:150px;height:50px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="100 Karakterden Fazla Yazmayınız!"></textarea></td>
			<td valign="top"><cf_get_lang_main no ='87.Telefon'></td>
			<td><textarea name="tel_request" id="tel_request" style="width:150px;height:50px;"></textarea></td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no='744.Diğer'></td>
			<td><textarea name="other_exist" id="other_exist" style="width:150px;height:50px;"></textarea></td>
			<td valign="top"><cf_get_lang_main no='744.Diğer'></td>
			<td><textarea name="other_request" id="other_request" style="width:150px;height:50px;"></textarea></td>
		</tr>
		<tr>
			<td><cf_get_lang no ='163.Taşınma Yardım Tutarı'></td>
			<td>
				<input type="text" name="move_amount" id="move_amount" value="" onKeyup='return(FormatCurrency(this,event));' maxlength="50" class="moneybox" style="width:90px">
				<select name="move_amount_money" id="move_amount_money">
					<cfoutput query="moneys">
                        <option <cfif moneys.money eq session.ep.money>selected</cfif>>#moneys.money#</option>
                    </cfoutput>
				</select>
			</td>
			<td><cf_get_lang no ='165.Yeni Göreve Başlama Tarihi'></td>
			<td>
				<input type="text" name="new_start_date" id="new_start_date" value="" style="width:150px">
				<cf_wrk_date_image date_field="new_start_date"> 
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no ='164.Tahmini Taşınma Tarihi'></td>
			<td>
				<input type="text" name="move_date" value="" id="move_date" style="width:150px">
				<cf_wrk_date_image date_field="move_date"> 
			</td>
			<td><cf_get_lang no ='166.Rotasyon İse Tamamlanma Tarihi'></td>
			<td>
				<input type="text" name="rotation_finish_date" id="rotation_finish_date" value="" style="width:150px">
				<cf_wrk_date_image date_field="rotation_finish_date"> 
			</td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no ='217.Açıklama'></td>
			<td colspan="3"><textarea name="detail" id="detail" style="width:492px;height:75px"></textarea></td>
		</tr>
	</table>
<cf_form_box_footer><cf_workcube_buttons is_upd='0' type_format="1" add_function='kontrol()'></cf_form_box_footer>
</cfform>
</cf_form_box>
<script type="text/javascript">
function kontrol()
{
if(document.add_form.rise.checked==false && document.add_form.transfer.checked==false && document.add_form.rotation.checked==false && document.add_form.salary_change.checked==false)
{
	alert("<cf_get_lang_main no ='1069.Terfi Transfer Rotasyon ve Ücret Değişikliği Seçeneklerinden Birini Seçmelisiniz'>!");
	return false;
}
if(document.add_form.emp_name.value.length==0 || document.add_form.pos_code.value.length==0)
{
	alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='186.Mevcut çalışanın'><cf_get_lang_main no ='485.adı'>!");
	return false;
}
if(document.add_form.pos_request.value.length==0 || document.add_form.pos_request_id.value.length==0)
{
	alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='146.Talep edilen'><cf_get_lang_main no='159.ünvan'>!");
	return false;
}
if(document.add_form.rotation.checked && document.add_form.rotation_finish_date.value.length==0)
{
	alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='184.Rotasyon tarihini'>!");
	return false;
}
	add_form.salary_exist.value = filterNum(add_form.salary_exist.value);
	add_form.salary_request.value = filterNum(add_form.salary_request.value);
	return process_cat_control();
}
</script>
