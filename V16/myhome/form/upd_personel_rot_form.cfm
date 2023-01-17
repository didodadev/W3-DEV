<!--- bu sayfanın benzeri hr dada var burda yapılan değişikleri hr ada taşıyın--->
<cfif get_module_user(3) eq 0>
<cfquery name="GET_PER_FORM" datasource="#dsn#">
		SELECT
			PRF.*
		FROM
			PERSONEL_ROTATION_FORM PRF,
			EMPLOYEES_APP_AUTHORITY EA
		WHERE
			EA.POS_CODE=#session.ep.position_code# AND
			EA.ROTATION_FORM_ID=#attributes.per_rot_id# AND
			PRF.ROTATION_FORM_ID=#attributes.per_rot_id#
</cfquery>
<cfif not GET_PER_FORM.recordcount>
		<script type="text/javascript">
			alert('<cf_get_lang dictionary_id="60007.Forma Yetkiniz Yok">');
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfquery name="GET_PER_FORM" datasource="#dsn#">
		SELECT
			*
		FROM
			PERSONEL_ROTATION_FORM
		WHERE
			ROTATION_FORM_ID=#attributes.per_rot_id#
	</cfquery>
</cfif>

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
<cfinclude template="../query/get_moneys.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31344.Terfi-Transfer-Rotasyon Talep Formu'></cfsavecontent>
<cf_form_box title="#message#">
<cfform name="add_form" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_personel_rotation">
<input type="hidden" name="per_rot_id" id="per_rot_id" value="<cfoutput>#attributes.per_rot_id#</cfoutput>">
	<table>
		<tr>
			<td><cf_get_lang dictionary_id ='57482.Aşama'></td>
			<td><cf_workcube_process
				is_upd='0'
				select_value='#get_per_form.form_stage#' 
				process_cat_width='150'
				is_detail='1'></td>
		</tr>
		<tr>
			<td width="177"><cf_get_lang dictionary_id ='57480.Başlık'>*</td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58059.Başlık Girmelisiniz'></cfsavecontent>
		<td width="754"><cfinput type="text" name="form_head" style="width:310px;" value="#get_per_form.rotation_form_head#" maxlength="150" required="yes" message="#message#"></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='31759.Form Tipi'>*</td>
			<td>
				<input type="checkbox" name="rise" id="rise" value="1" <cfif get_per_form.is_rise>checked</cfif>><cf_get_lang dictionary_id='58567.Terfi'>&nbsp;
				<input type="checkbox" name="transfer" id="transfer" value="1" <cfif get_per_form.is_transfer>checked</cfif>><cf_get_lang dictionary_id='58568.Transfer'>&nbsp;
				<input type="checkbox" name="rotation" id="rotation" value="1" <cfif get_per_form.is_rotation>checked</cfif>><cf_get_lang dictionary_id='58569.Rotasyon'>&nbsp;
				<input type="checkbox" name="salary_change" id="salary_change" value="1" <cfif get_per_form.is_salary_change>checked</cfif>><cf_get_lang dictionary_id ='31763.Ücret Değişikliği'>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='57570.Ad Soyad'>*</td>
			<td>
				<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#get_per_form.pos_code_exist#</cfoutput>">
				<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_per_form.employee_id#</cfoutput>">
				<input type="text" name="emp_name" id="emp_name" value="<cfoutput>#get_exist.employee_name# #get_exist.employee_surname#</cfoutput>" style="width:310px" readonly>
			</td>
		</tr>
		<tr>
		<td colspan="2">
			<table border="0" cellpadding="2" cellspacing="0">
			<tr>
				<td width="175">&nbsp;</td>
				<td align="center" class="txtbold"><cf_get_lang dictionary_id='58571.Mevcut'></td>
				<td align="center" class="txtbold"><cf_get_lang dictionary_id='31181.Talep Edilen'>*</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='31765.Grup Başkanlığı'></td>
			<td>
					<input type="hidden" name="headquarters_exist_id" id="headquarters_exist_id" value="<cfif isdefined("get_head_exist")><cfoutput>#get_head_exist.headquarters_id#</cfoutput></cfif>">
					<input type="text" name="headquarters_exist" id="headquarters_exist" value="<cfif isdefined("get_head_exist")><cfoutput>#get_head_exist.name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
				<td>
					<input type="hidden" name="headquarters_request_id" id="headquarters_request_id" value="<cfif isdefined("get_head_request")><cfoutput>#get_head_request.headquarters_id#</cfoutput></cfif>">
					<input type="text" name="headquarters_request" id="headquarters_request" value="<cfif isdefined("get_head_request")><cfoutput>#get_head_request.name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57574.Şirket'></td>
				<td>
					<input type="hidden" name="company_exist_id" id="company_exist_id" value="<cfif isdefined("get_comp_exist")><cfoutput>#get_comp_exist.comp_id#</cfoutput></cfif>">
					<input type="text" name="company_exist" id="company_exist" value="<cfif isdefined("get_comp_exist")><cfoutput>#get_comp_exist.nick_name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
				<td>
					<input type="hidden" name="company_request_id" id="company_request_id" value="<cfif isdefined("get_head_request")><cfoutput>#get_head_request.comp_id#</cfoutput></cfif>">
					<input type="text" name="company_request" id="company_request" value="<cfif isdefined("get_head_request")><cfoutput>#get_head_request.nick_name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57453.Şube'></td>
				<td>
					<input type="hidden" name="branch_exist_id" id="branch_exist_id" value="<cfif isdefined("get_branch_exist")><cfoutput>#get_branch_exist.branch_id#</cfoutput></cfif>">
					<input type="text" name="branch_exist" id="branch_exist" value="<cfif isdefined("get_branch_exist")><cfoutput>#get_branch_exist.branch_name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
				<td>
					<input type="hidden" name="branch_request_id" id="branch_request_id" value="<cfif isdefined("get_branch_request")><cfoutput>#get_branch_request.branch_id#</cfoutput></cfif>">
					<input type="text" name="branch_request" id="branch_request" value="<cfif isdefined("get_branch_request")><cfoutput>#get_branch_request.branch_name#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57572.Departman'></td>
				<td>
					<input type="hidden" name="department_exist_id" id="department_exist_id" value="<cfif isdefined("get_dep_exist")><cfoutput>#get_dep_exist.department_id#</cfoutput></cfif>">
					<input type="text" name="department_exist" id="department_exist" value="<cfif isdefined("get_dep_exist")><cfoutput>#get_dep_exist.department_head#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
				<td>
					<input type="hidden" name="department_request_id" id="department_request_id" value="<cfif isdefined("get_dep_request")><cfoutput>#get_dep_request.department_id#</cfoutput></cfif>">
					<input type="text" name="department_request" id="department_request" value="<cfif isdefined("get_dep_request")><cfoutput>#get_dep_request.department_head#</cfoutput></cfif>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57571.Unvan'></td>
				<td>
					<!--- <input type="hidden" name="pos_exist_id" value=""> --->
					<input type="text" name="pos_exist" id="pos_exist" value="<cfoutput>#get_exist.position_name#</cfoutput>" style="width:150px" readonly>
				</td>
				<td>
					<input type="hidden" name="pos_request_id" id="pos_request_id" value="<cfoutput>#get_per_form.pos_code_request#</cfoutput>">
					<input type="text" name="pos_request" id="pos_request" value="<cfoutput>#get_request.position_name#</cfoutput>" style="width:150px" readonly>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='31282.Ücret'></td>
				<td>
					<input type="text" name="salary_exist" id="salary_exist" value="<cfoutput>#TLFormat(get_per_form.salary_exist)#</cfoutput>" class="moneybox" style="width:100px">
					<select name="salary_exist_money" id="salary_exist_money">
					<cfoutput query="get_moneys">
						<option <cfif get_per_form.salary_exist_money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
					</cfoutput>
					</select>
				</td>
				<td>
					<input type="text" name="salary_request" id="salary_request" value="<cfoutput>#TLFormat(get_per_form.salary_request)#</cfoutput>" class="moneybox" style="width:100px">
					<select name="salary_request_money" id="salary_request_money">
					<cfoutput query="get_moneys">
						<option <cfif get_per_form.salary_request_money eq get_moneys.money>selected</cfif>>#get_moneys.money#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr height="20">
				<td colspan="3" class="txtbold"><cf_get_lang dictionary_id ='31766.Özlük Hakları'></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='58480.Araç'></td>
				<td><textarea name="tool_exist" id="tool_exist" style="width:150px;height:50px;"><cfoutput>#get_per_form.tool_exist#</cfoutput></textarea></td>
				<td><textarea name="tool_request" id="tool_request" style="width:150px;height:50px;"><cfoutput>#get_per_form.tool_request#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57499.Telefon'></td>
				<td><textarea name="tel_exist" id="tel_exist" style="width:150px;height:50px;"><cfoutput>#get_per_form.tel_exist#</cfoutput></textarea></td>
				<td><textarea name="tel_request" id="tel_request" style="width:150px;height:50px;"><cfoutput>#get_per_form.tel_request#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58156.Diğer'></td>
				<td><textarea name="other_exist" id="other_exist" style="width:150px;height:50px;"><cfoutput>#get_per_form.other_exist#</cfoutput></textarea></td>
				<td><textarea name="other_request" id="other_request" style="width:150px;height:50px;"><cfoutput>#get_per_form.other_request#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='31767.Taşınma Yardım Tutarı'></td>
				<td>
					<input type="text" name="move_amount" id="move_amount" value="<cfoutput>#TLFormat(get_per_form.move_amount)#</cfoutput>" style="width:100px">
					<select name="move_amount_money" id="move_amount_money">
					<cfoutput query="get_moneys">
						<option <cfif get_per_form.move_amount_money eq session.ep.money>selected</cfif>>#get_moneys.money#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='31768.Tahmini Taşınma Tarihi'></td>
				<td><input type="text" name="move_date" id="move_date" value="<cfoutput>#dateformat(get_per_form.move_date,dateformat_style)#</cfoutput>" style="width:65px">
				<cf_wrk_date_image date_field="move_date"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57629.Açıklama'></td>
				<td colspan="2"><textarea name="detail" id="detail" style="width:315px;height:75px;"><cfoutput>#get_per_form.detail#</cfoutput></textarea></td>
			</tr>
			</table>
		</td>
		</tr>
		<tr>
			<td>
				<cf_get_lang dictionary_id ='31769.Toplam Çalıştığı Süre'>
			</td>
			<td><cfoutput>#get_per_form.work_year# <cf_get_lang dictionary_id='58455.Yıl'> - #get_per_form.work_month# <cf_get_lang dictionary_id='58724.Ay'> - #get_per_form.work_day# <cf_get_lang dictionary_id='57490.Gün'></cfoutput></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='31770.Yeni Göreve Başlama Tarihi'></td>
			<td>
				<input type="text" name="new_start_date" id="new_start_date" value="<cfoutput>#dateformat(get_per_form.new_start_date,dateformat_style)#</cfoutput>" style="width:65px">
				<cf_wrk_date_image date_field="new_start_date">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id ='31771.Rotasyon ise Tamamlanma Tarihi'></td>
			<td >
				<input type="text" name="rotation_finish_date" id="rotation_finish_date" value="<cfoutput>#dateformat(get_per_form.rotation_finish_date,dateformat_style)#</cfoutput>" style="width:65px">
				<cf_wrk_date_image date_field="rotation_finish_date">
			</td>
		</tr>
	</table>
<cf_form_box_footer><cf_workcube_buttons is_upd='1' type_format="1" is_delete='0'></cf_form_box_footer>
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
	alert("<cf_get_lang dictionary_id='58481.Terfi,Transfer,Rotasyon ve Ücret Değişikliği Seçeneklerinden Birini Seçmelisiniz'>!");
	return false;
}
if(document.add_form.emp_name.value.length==0)
{
	alert("<cf_get_lang dictionary_id ='31773.Mevcut kadroya bir çalışan seçmelisiniz'>!");
	return false;
}
if(document.add_form.pos_request.value.length==0)
{
	alert("<cf_get_lang dictionary_id ='31774.Talep edilen unvanı seçmelisiniz'>!");
	return false;
}
	add_form.salary_exist.value = filterNum(add_form.salary_exist.value);
	add_form.salary_request.value = filterNum(add_form.salary_request.value);
	return process_cat_control();
}
</script>
