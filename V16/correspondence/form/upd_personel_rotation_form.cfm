<!--- Bu sayfanın nerde ise aynısı myhome da var burda yapılan değişiklik ordada yapılsın--->
<cfquery name="GET_PER_FORM" datasource="#dsn#">
	SELECT
		*
	FROM
		PERSONEL_ROTATION_FORM
	WHERE
		ROTATION_FORM_ID=#attributes.per_rot_id#
</cfquery>

<cfquery name="get_exist" datasource="#dsn#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE=#GET_PER_FORM.POS_CODE_EXIST#
</cfquery>
<cfif len(get_per_form.company_exist)>
	<cfquery name="get_comp_exist" datasource="#dsn#">
		SELECT
			COMP_ID,
			NICK_NAME
		FROM
			OUR_COMPANY
		WHERE
			COMP_ID=#get_per_form.company_exist#
	</cfquery>
</cfif>
<cfif len(get_per_form.department_exist)>
	<cfquery name="get_dep_exist" datasource="#dsn#">
		SELECT
			DEPARTMENT_ID,
			DEPARTMENT_HEAD
		FROM
			DEPARTMENT
		WHERE
			DEPARTMENT_ID=#get_per_form.department_exist#
	</cfquery>
</cfif>
<cfif len(get_per_form.branch_exist)>
	<cfquery name="get_branch_exist" datasource="#dsn#">
		SELECT
			BRANCH_ID,
			BRANCH_NAME
		FROM
			BRANCH
		WHERE
			BRANCH_ID=#get_per_form.branch_exist#
	</cfquery>
</cfif>
<cfif len(get_per_form.headquarters_exist)>
	<cfquery name="get_head_exist" datasource="#dsn#">
		SELECT
			HEADQUARTERS_ID,
			NAME
		FROM
			SETUP_HEADQUARTERS
		WHERE
			HEADQUARTERS_ID=#get_per_form.headquarters_exist#
	</cfquery>
</cfif>
<cfif len(get_per_form.pos_code_request)>
	<cfquery name="get_request" datasource="#dsn#">
		SELECT
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			POSITION_NAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_CODE=#GET_PER_FORM.POS_CODE_REQUEST#
	</cfquery>
</cfif>
<cfif len(get_per_form.company_request)>
	<cfquery name="get_comp_request" datasource="#dsn#">
		SELECT
			COMP_ID,
			NICK_NAME
		FROM
			OUR_COMPANY
		WHERE
			COMP_ID=#get_per_form.company_request#
	</cfquery>
</cfif>
<cfif len(get_per_form.department_request)>
	<cfquery name="get_dep_request" datasource="#dsn#">
		SELECT
			DEPARTMENT_ID,
			DEPARTMENT_HEAD
		FROM
			DEPARTMENT
		WHERE
			DEPARTMENT_ID=#get_per_form.department_request#
	</cfquery>
</cfif>
<cfif len(get_per_form.branch_request)>
	<cfquery name="get_branch_request" datasource="#dsn#">
		SELECT
			BRANCH_ID,
			BRANCH_NAME
		FROM
			BRANCH
		WHERE
			BRANCH_ID=#get_per_form.branch_request#
	</cfquery>
</cfif>
<cfif len(get_per_form.headquarters_request)>
	<cfquery name="get_head_exist" datasource="#dsn#">
		SELECT
			HEADQUARTERS_ID,
			NAME
		FROM
			SETUP_HEADQUARTERS
		WHERE
			HEADQUARTERS_ID=#get_per_form.headquarters_request#
	</cfquery>
</cfif>
<cfquery name="get_moneys" datasource="#dsn#">
	SELECT
		MONEY_ID,
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
<cfsavecontent variable="right">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=correspondence.popup_upd_per_form_autority&per_rot_id=#attributes.per_rot_id#</cfoutput>','list');"><img src="../../images/partner.gif" alt="<cf_get_lang no ='185.Yetkililer'>" border="0" title="<cf_get_lang no ='185.Yetkililer'>"></a>
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_personel_rotation&action=print&id=#attributes.per_rot_id#&module=correspondence&iframe=1&trail=0</cfoutput>','page');return false;"><img src="/images/print.gif" alt="<cf_get_lang_main no='62.yazıcıya gönder'>" border="0" title="<cf_get_lang_main no='62.yazıcıya gönder'>"></a>
</cfsavecontent>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=correspondence.add_personel_rotation_form</cfoutput>"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>
<cf_form_box title="#getLang('correspondence',168)#" right_images="#img#">
	<cfform name="add_form" method="post" action="#request.self#?fuseaction=correspondence.emptypopup_upd_personel_rotation">
	<input type="hidden" name="per_rot_id" id="per_rot_id" value="<cfoutput>#attributes.per_rot_id#</cfoutput>">
		<table>
			<tr>
				<td width="150"><cf_get_lang_main no ='70.Aşama'>*</td>
				<td colspan="3"><cf_workcube_process
					is_upd='0'
					select_value='#get_per_form.form_stage#' 
					process_cat_width='150'
					is_detail='1'></td>
			</tr>
			<tr>
				<td><cf_get_lang no ='153.Form Tipi'> retwe*</td>
				<td colspan="3"><input type="checkbox" name="rise" id="rise" value="1" <cfif get_per_form.is_rise>checked</cfif>><cf_get_lang_main no='1155.Terfi'>
				<input type="checkbox" name="transfer" id="transfer" value="1" <cfif get_per_form.is_transfer>checked</cfif>><cf_get_lang_main no ='1156.Transfer'>
				<input type="checkbox" name="rotation" id="rotation" value="1" <cfif get_per_form.is_rotation>checked</cfif>><cf_get_lang_main no='1157.Rotasyon'>
				<input type="checkbox" name="salary_change" id="salary_change" value="1" <cfif get_per_form.is_salary_change>checked</cfif>><cf_get_lang_main no='1158.Ücret Değişikliği'></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no ='68.Başlık'> *</td>
				<cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.Başlık'></cfsavecontent>
				<td colspan="3"><cfinput type="text" name="form_head" style="width:485px;" value="#get_per_form.rotation_form_head#" maxlength="150" required="yes" message="#alert#"></td>
			</tr>
			<tr>
				<td class="txtbold" colspan="2"><cf_get_lang_main no='1159.Mevcut'> *</td>
				<td class="txtbold" colspan="2"><cf_get_lang no ='146.Talep Edilen '>*</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='157.Grup Başkanlığı'></td>
				<td>
					<input type="hidden" name="headquarters_exist_id" id="headquarters_exist_id" value="<cfif isdefined("get_head_exist")><cfoutput>#get_head_exist.headquarters_id#</cfoutput></cfif>">
					<input type="text" name="headquarters_exist" id="headquarters_exist" value="<cfif isdefined("get_head_exist")><cfoutput>#get_head_exist.name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
				<td width="150"><cf_get_lang no ='157.Grup Başkanlığı'></td>
				<td>
					<input type="hidden" name="headquarters_request_id" id="headquarters_request_id" value="<cfif isdefined("get_head_request")><cfoutput>#get_head_request.headquarters_id#</cfoutput></cfif>">
					<input type="text" name="headquarters_request" id="headquarters_request" value="<cfif isdefined("get_head_request")><cfoutput>#get_head_request.name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no ='162.Şirket'></td>
				<td>
					<input type="hidden" name="company_exist_id" id="company_exist_id" value="<cfif isdefined("get_comp_exist")><cfoutput>#get_comp_exist.comp_id#</cfoutput></cfif>">
					<input type="text" name="company_exist" id="company_exist" value="<cfif isdefined("get_comp_exist")><cfoutput>#get_comp_exist.nick_name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
				<td><cf_get_lang_main no ='162.Şirket'></td>
				<td>
					<input type="hidden" name="company_request_id" id="company_request_id" value="<cfif isdefined("get_head_request")><cfoutput>#get_head_request.comp_id#</cfoutput></cfif>">
					<input type="text" name="company_request" id="company_request" value="<cfif isdefined("get_head_request")><cfoutput>#get_head_request.nick_name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no ='41.Şube'></td>
				<td>
					<input type="hidden" name="branch_exist_id" id="branch_exist_id" value="<cfif isdefined("get_branch_exist")><cfoutput>#get_branch_exist.branch_id#</cfoutput></cfif>">
					<input type="text" name="branch_exist" id="branch_exist" value="<cfif isdefined("get_branch_exist")><cfoutput>#get_branch_exist.branch_name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
				<td><cf_get_lang_main no ='41.Şube'></td>
				<td>
					<input type="hidden" name="branch_request_id" id="branch_request_id" value="<cfif isdefined("get_branch_request")><cfoutput>#get_branch_request.branch_id#</cfoutput></cfif>">
					<input type="text" name="branch_request" id="branch_request" value="<cfif isdefined("get_branch_request")><cfoutput>#get_branch_request.branch_name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='160.Departman'></td>
				<td>
					<input type="hidden" name="department_exist_id" id="department_exist_id" value="<cfif isdefined("get_dep_exist")><cfoutput>#get_dep_exist.department_id#</cfoutput></cfif>">
					<input type="text" name="department_exist" id="department_exist" value="<cfif isdefined("get_dep_exist")><cfoutput>#get_dep_exist.department_head#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
				<td><cf_get_lang_main no='160.Departman'></td>
	
				<td>
					<input type="hidden" name="department_request_id" id="department_request_id" value="<cfif isdefined("get_dep_request")><cfoutput>#get_dep_request.department_id#</cfoutput></cfif>">
					<input type="text" name="department_request" id="department_request" value="<cfif isdefined("get_dep_request")><cfoutput>#get_dep_request.department_head#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no ='159.Unvan'></td>
				<td>
					<input type="text" name="pos_exist" id="pos_exist" value="<cfoutput>#get_exist.position_name#</cfoutput>" style="width:150px" readonly>
				</td>
				<td><cf_get_lang_main no ='159.Unvan'></td>
				<td>
					<input type="hidden" name="pos_request_id" id="pos_request_id" value="<cfif len(get_per_form.pos_code_request)><cfoutput>#get_per_form.pos_code_request#</cfoutput></cfif>">
					<input type="text" name="pos_request" id="pos_request" value="<cfif len(get_per_form.pos_code_request)><cfoutput>#get_request.position_name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='158.Adı Soyadı'></td>
				<td>
					<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#get_per_form.pos_code_exist#</cfoutput>">
					<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_per_form.employee_id#</cfoutput>">
					<input type="text" name="emp_name" id="emp_name" value="<cfoutput>#get_exist.employee_name# #get_exist.employee_surname#</cfoutput>" style="width:150px">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_pos_name=add_form.pos_exist&field_code=add_form.pos_code&field_name=add_form.emp_name&field_emp_id=add_form.emp_id&field_dep_name=add_form.department_exist&field_dep_id=add_form.department_exist_id&field_branch_name=add_form.branch_exist&field_branch_id=add_form.branch_exist_id&field_comp=add_form.company_exist&field_comp_id=add_form.company_exist_id&field_head_id=add_form.headquarters_exist_id&field_head=add_form.headquarters_exist','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='158.Adı Soyadı'>" align="absmiddle" border="0"></a>
				</td>
				<td><cf_get_lang_main no='158.Adı Soyadı'></td>
				<td>
					<input type="hidden" name="emp_id_req" id="emp_id_req" value="">
					<input type="text" name="emp_name_req" id="emp_name_req" value="" style="width:150px">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_form.pos_request_id&field_pos_name=add_form.pos_request&field_name=add_form.emp_name_req&field_emp_id=add_form.emp_id_req&field_dep_name=add_form.department_request&field_dep_id=add_form.department_request_id&field_branch_name=add_form.branch_request&field_branch_id=add_form.branch_request_id&field_comp=add_form.company_request&field_comp_id=add_form.company_request_id&field_head_id=add_form.headquarters_request_id&field_head=add_form.headquarters_request&show_empty_pos=0','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='158.Adı Soyadı'>" align="absmiddle" border="0"></a>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='161.Ücret'></td>
				<td>
					<input type="text" name="salary_exist" id="salary_exist" value="<cfoutput>#TLFormat(get_per_form.salary_exist)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px">
					<select name="salary_exist_money" id="salary_exist_money">
					<cfoutput query="get_moneys">
						<option <cfif get_per_form.salary_exist_money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
					</cfoutput>
					</select>
				</td>
				<td><cf_get_lang no ='161.Ücret'></td>
				<td>
					<input type="text" name="salary_request" id="salary_request" value="<cfoutput>#TLFormat(get_per_form.salary_request)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px">
					<select name="salary_request_money" id="salary_request_money">
					<cfoutput query="get_moneys">
						<option <cfif get_per_form.salary_request_money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="4" class="txtbold"><cf_get_lang no ='186.Mevcut Çalışanın'></td>
			</tr>
			<tr>
				<td><cf_get_lang no ='187.Sicil No'></td>
				<td><input type="text" name="sicil_no" id="sicil_no" value="<cfoutput>#get_per_form.sicil_no#</cfoutput>" style="width:150px;"></td>
				<td><cf_get_lang no ='188.İşe Giriş Tarihi'></td>
				<td><input type="text" name="start_work" id="start_work" value="<cfif len(get_per_form.work_startdate)><cfoutput>#dateformat(get_per_form.work_startdate,dateformat_style)#</cfoutput></cfif>" style="width:150px;" readonly></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='378.Doğum Yeri'></td>
				<td><input type="text" name="emp_birth_city" id="emp_birth_city" value="<cfoutput>#get_per_form.emp_birth_city#</cfoutput>" readonly style="width:150px;"></td>
				<td><cf_get_lang_main no ='1315.Doğum Tarihi'></td>
				<td><input type="text" name="emp_birth_date" id="emp_birth_date" value="<cfif len(get_per_form.emp_birth_date)><cfoutput>#dateformat(get_per_form.emp_birth_date,dateformat_style)#</cfoutput></cfif>" readonly style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no ='190.Öğrenim Durumu'></td>
				<cfif len(get_per_form.training_level)>
					<cfquery name="get_edu_level" datasource="#dsn#">
						SELECT
							EDUCATION_NAME
						FROM
							SETUP_EDUCATION_LEVEL
						WHERE
							EDU_LEVEL_ID=#get_per_form.training_level#
					</cfquery>
				</cfif>
				<td><input type="text" name="training_level" id="training_level" value="<cfif isdefined("get_edu_level")><cfoutput>#get_edu_level.education_name#</cfoutput></cfif>" readonly style="width:150px;"></td>
				<td><cf_get_lang no ='191.Askerlik Durumu'></td>
				<cfif get_per_form.military_status eq 0><cfset askerlik="Yapmadı">
				<cfelseif get_per_form.military_status eq 1><cfset askerlik="Yaptı">
				<cfelseif get_per_form.military_status eq 2><cfset askerlik="Muaf">
				<cfelseif get_per_form.military_status eq 3><cfset askerlik="Yabancı">
				<cfelseif get_per_form.military_status eq 4><cfset askerlik="Tecilli">
				<cfelse>
					<cfset askerlik="">
				</cfif>
				<td><input type="text" name="training_level" id="training_level" value="<cfoutput>#askerlik#</cfoutput>" readonly style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no ='192.Toplam Çalıştığı Süre'></td>
				<td colspan="3"><cfoutput>#get_per_form.work_year#<cf_get_lang_main no ='1043.Yıl'>  - #get_per_form.work_month#<cf_get_lang_main no ='1312.Ay'>  - #get_per_form.work_day# <cf_get_lang_main no ='78.Gün'></cfoutput></td>
			</tr>
			<tr>
				<td colspan="4" class="txtbold"><cf_get_lang no ='167.Özlük Hakları'></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no ='1068.Araç'></td>
				<td><textarea name="tool_exist" id="tool_exist" style="width:150px;height:50px;"><cfoutput>#get_per_form.tool_exist#</cfoutput></textarea></td>
				<td valign="top"><cf_get_lang_main no ='1068.Araç'></td>
				<td><textarea name="tool_request" id="tool_request" style="width:150px;height:50px;"><cfoutput>#get_per_form.tool_request#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no ='87.Telefon'></td>
				<td><textarea name="tel_exist" id="tel_exist" style="width:150px;height:50px;"><cfoutput>#get_per_form.tel_exist#</cfoutput></textarea></td>
				<td valign="top"><cf_get_lang_main no ='87.Telefon'></td>
				<td><textarea name="tel_request" id="tel_request" style="width:150px;height:50px;"><cfoutput>#get_per_form.tel_request#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='744.Diğer'></td>
				<td><textarea name="other_exist" id="other_exist" style="width:150px;height:50px;"><cfoutput>#get_per_form.other_exist#</cfoutput></textarea></td>
				<td valign="top"><cf_get_lang_main no='744.Diğer'></td>
				<td><textarea name="other_request" id="other_request" style="width:150px;height:50px;"><cfoutput>#get_per_form.other_request#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td><cf_get_lang no ='163.Taşınma Yardım Tutarı'></td>
				<td>
					<input type="text" name="move_amount" id="move_amount" value="<cfoutput>#TLFormat(get_per_form.move_amount)#</cfoutput>" onKeyup='return(FormatCurrency(this,event));' class="moneybox" style="width:90px">
					<select name="move_amount_money" id="move_amount_money">
					<cfoutput query="get_moneys">
						<option <cfif get_per_form.move_amount_money eq session.ep.money>selected</cfif>>#get_moneys.money#</option>
					</cfoutput>
					</select>
				</td>
				<td><cf_get_lang no ='165.Yeni Göreve Başlama Tarihi'></td>
				<td>
					<input type="text" name="new_start_date" id="new_start_date" value="<cfoutput>#dateformat(get_per_form.new_start_date,dateformat_style)#</cfoutput>" style="width:150px">
					<cf_wrk_date_image date_field="new_start_date">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='164.Tahmini Taşınma Tarihi'></td>
				<td><input type="text" name="move_date" id="move_date" value="<cfoutput>#dateformat(get_per_form.move_date,dateformat_style)#</cfoutput>" style="width:150px">
				<cf_wrk_date_image date_field="move_date"></td>
				<td><cf_get_lang no ='166.Rotasyon ise Tamamlanma Tarihi'></td>
				<td>
					<input type="text" name="rotation_finish_date" id="rotation_finish_date" value="<cfoutput>#dateformat(get_per_form.rotation_finish_date,dateformat_style)#</cfoutput>" style="width:150px">
					<cf_wrk_date_image date_field="rotation_finish_date"> 
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no ='217.Açıklama'></td>
				<td colspan="3"><textarea name="detail" id="detail" style="width:485px;height:75px;"><cfoutput>#get_per_form.detail#</cfoutput></textarea></td>
			</tr>
		</table>
	<cf_form_box_footer>
		<cf_record_info query_name="get_per_form">
			<cf_workcube_buttons is_upd='1' type_format="1" is_delete='0' add_function='kontrol()'>
	</cf_form_box_footer>
	</cfform>
</cf_form_box>
<script type="text/javascript">
function isSayi(nesne) 
{
	inputStr=nesne.value;
	if(inputStr.length>0)
	{
		var oneChar = inputStr.substring(0,1)
		if (oneChar < "1" ||  oneChar > "9") 
		{
			nesne.focus();
		}
	}
}

function kontrol()
{
if(document.add_form.rise.checked==false && document.add_form.transfer.checked==false && document.add_form.rotation.checked==false && document.add_form.salary_change.checked==false)
{
	alert("<cf_get_lang_main no ='1069.Terfi,Transfer,Rotasyon ve Ücret Değişikliği Seçeneklerinden Birini Seçmelisiniz'>!");
	return false;
}
if(document.add_form.emp_name.value.length==0)
{
	alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='186.Mevcut çalışanın'><cf_get_lang_main no ='485.adı'>!");
	return false;
}
if(document.add_form.pos_request.value.length==0)
{
	alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='146.Talep edilen'><cf_get_lang_main no='159.ünvan'>!");
	return false;
}
	document.add_form.move_amount.value=filterNum(document.add_form.move_amount.value);
	document.add_form.salary_exist.value = filterNum(document.add_form.salary_exist.value);
	document.add_form.salary_request.value = filterNum(document.add_form.salary_request.value);
	return process_cat_control();
}
</script>
