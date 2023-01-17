<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.dept_id" default="">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT	
		MONEY,
		RATE1,
		RATE2 
	FROM 
		SETUP_MONEY 
	WHERE 
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cf_popup_box title="#getLang('myhome',665)#">
<cfform name="add_target" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_target">
<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
<input type="hidden" name="dept_id" id="dept_id" value="<cfoutput>#attributes.dept_id#</cfoutput>">
<input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#session.ep.userid#</cfoutput>">
<input type="hidden" name="record_ip" id="record_ip" value="<cfoutput>#cgi.remote_addr#</cfoutput>">
	<table>
	<cfif isDefined("attributes.position_code")>
	<cfinclude template="../query/get_position.cfm">
	<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#attributes.position_code#</cfoutput>">
		<tr>
			<td width="60"><cf_get_lang_main no='164.Çalışan'></td>
			<td class="txtbold"><cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput></td>
		</tr>
			<cfelseif isDefined("attributes.employee_id")>
			<cfinclude template="../query/get_position.cfm">
			<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_position.position_code#</cfoutput>">
		<tr>
			<td><cf_get_lang_main no='164.Çalışan'></td>
			<td><cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput></td>
		</tr>
			</cfif>
		<tr>
			<td><cf_get_lang_main no='89.Başlangıç'></td>
			<td>
			<cfinput type="text" name="startdate" style="width:65px;" validate="#validate_style#">
			<cf_wrk_date_image date_field="startdate"><cf_get_lang_main no='90.Bitiş'>
			<cfinput type="text" name="finishdate" style="width:65px;" validate="#validate_style#">
			<cf_wrk_date_image date_field="finishdate">
			</td>
		</tr>
			<tr>
			<td width="60"><cf_get_lang_main no='74.Kategori'></td>
			<td><select name="targetcat_id" id="targetcat_id" style="width:305px;">
			<cfinclude template="../query/get_target_cats.cfm">
			<option value=""><cf_get_lang_main no='1535.Kategori Seçiniz'></option>
			<cfoutput query="get_target_cats">
			  <option value="#targetcat_id#">#targetcat_name#</option>
			</cfoutput>
			</select>
			</td>
		</tr>
		<tr>
			<td height="26"><cf_get_lang_main no='539.Hedef'></td>
			<td>
			<input type="text" name="target_head" id="target_head" style="width:150px;" value="" maxlength="300"></td>
		</tr>
		<tr>
			<td><cf_get_lang no ='211.Rakam'></td>
			<td>
			<input type="text" name="target_number" id="target_number" class="moneybox" style="width:150px;" value="" validate="float" onkeyup="return(FormatCurrency(this,event));">
			&nbsp;<select name="calculation_type" id="calculation_type" style="width:150px">
					<option value="1"> + (<cf_get_lang no ='385.Artış Hedefi'>)</option>
					<option value="2"> - (<cf_get_lang no ='386.Düşüş Hedefi'>)</option>
					<option value="3"> +% (<cf_get_lang no ='387.Yüzde Artış Hedefi'>)</option>
					<option value="4"> -% (<cf_get_lang no ='388.Yüzde Düşüş Hedefi'>)</option>
					<option value="5"> = (<cf_get_lang no ='389.Hedeflenen Rakam'>)</option>
				</select>
			</td>
		</tr>
		<tr>
			<td height="26"><cf_get_lang_main no ='1987.Ağırlık'></td>
			<td><input type="text" name="target_weight" id="target_weight" class="moneybox" style="width:150px;" value="" validate="float" onkeyup="return(FormatCurrency(this,event));"></td>
		</tr>
		<tr>
			<td><cf_get_lang no ='395.Hedef Veren'></td>
			<td>
			<input type="hidden" name="target_emp_id" id="target_emp_id"  value="<cfoutput>#session.ep.userid#</cfoutput>">
			<input type="text" name="target_emp" id="target_emp" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" style="width:150px;" readonly>
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_target.target_emp&field_emp_id2=add_target.target_emp_id</cfoutput>','list');"><img SRC="/images/plus_thin.gif" title="<cf_get_lang_main no ='322.Seçiniz'>"  border="0" align="absmiddle"></a>
		</td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
			<td><textarea name="target_detail" id="target_detail" style="width:305px;height:70px;"></textarea>
			  <input type="hidden" name="record_num" id="record_num" value=""></td>
		</tr>								
	</table>
	<cf_popup_box_footer><cf_workcube_buttons is_upd='0' type_format="1" add_function='check()'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function check()
{
	x = document.add_target.targetcat_id.selectedIndex;
	if (document.add_target.targetcat_id[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'>!");
		return false;
	}
	
	if ((add_target.startdate.value == "") || (add_target.finishdate.value == ""))
		{
			alert("<cf_get_lang no ='1163.Başlangıç ve Bitiş Tarihlerini Kontrol Ediniz'>!");
			return false;
		}
	
	if (add_target.target_head.value == "") 
		{
			alert("<cf_get_lang no ='1164.Hedef İsmi Girmelisiniz'>!");
			return false;
		}
	
	if (add_target.target_weight.value == "") 
		{
			alert("<cf_get_lang no ='1165.Hedef Ağırlığı Girmelisiniz'>!");
			return false;
		}

	if ((add_target.startdate.value != "") && (add_target.finishdate.value != ""))
		if (! date_check(add_target.startdate, add_target.finishdate, "<cf_get_lang no ='1166.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'> !"))
			return false;
	add_target.target_number.value = filterNum(add_target.target_number.value);
	add_target.target_weight.value = filterNum(add_target.target_weight.value);
	return true;
}
</script>
