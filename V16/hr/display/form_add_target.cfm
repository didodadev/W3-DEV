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
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="100%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang dictionary_id='55181.Hedef Ekle'>
				</td>
				<!--- <td > <a href="javascript://"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_send_mail_for_targets</cfoutput>','medium');"><img border="0" name="imageField" src="/images/mail.gif" align="absbottom"></a></td> --->
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table>
			<cfform name="add_target" method="post" action="#request.self#?fuseaction=hr.add_target">
			<input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#session.ep.userid#</cfoutput>">
			<input type="hidden" name="record_ip" id="record_ip" value="<cfoutput>#cgi.remote_addr#</cfoutput>">
			<input type="hidden" name="counter" id="counter" value="">
			<cfif isdefined('attributes.per_id')><input type="hidden" name="per_id" id="per_id" value="<cfoutput>#attributes.per_id#</cfoutput>"></cfif>
			<cfif isDefined("attributes.position_code")>
			<cfinclude template="../query/get_position.cfm">
			<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#attributes.position_code#</cfoutput>">
			<tr>
			  <td width="100"><cf_get_lang dictionary_id='57576.Çalışan'></td>
			  <td class="txtbold"><cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput></td>
			</tr>
			<cfelseif isDefined("attributes.employee_id")>
			<cfinclude template="../query/get_position.cfm">
			<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_position.position_code#</cfoutput>">
			<tr>
			  <td><cf_get_lang dictionary_id='57576.Çalışan'></td>
			  <td><cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput></td>
			</tr>
			</cfif>
			<tr>
			  <td><cf_get_lang dictionary_id='57501.Başlangıç'></td>
			  <td>
				<cfinput type="text" name="startdate" style="width:70px;" validate="#validate_style#">
				<cf_wrk_date_image date_field="startdate">
				<cf_get_lang dictionary_id='57502.Bitiş'>
				<cfinput type="text" name="finishdate" style="width:70px;" validate="#validate_style#">
				<cf_wrk_date_image date_field="finishdate">
			  </td>
			</tr>
			<tr>
			  <td width="100"><cf_get_lang dictionary_id='57486.Kategori'></td>
			  <td><select name="targetcat_id" id="targetcat_id" style="width:400px;">
				<cfinclude template="../query/get_target_cats.cfm">
			  	<option value=""><cf_get_lang dictionary_id='58947.Kategori Seçiniz'></option>
				<cfoutput query="get_target_cats">
				  <option value="#targetcat_id#">#targetcat_name#</option>
				</cfoutput>
				</select></td>
			</tr>
			<tr>
			  <td height="26"><cf_get_lang dictionary_id='57951.Hedef'></td>
			  <td><input type="text" name="target_head" id="target_head" style="width:400px;" value="" maxlength="300"></td>
			</tr>
			<tr>
			  <td><cf_get_lang dictionary_id='55486.Rakam'></td>
			  <td>
				<input type="text" name="target_number" id="target_number" class="moneybox" style="width:150px;" value="" validate="float" onkeyup="return(FormatCurrency(this,event));">
			&nbsp;<select name="calculation_type" id="calculation_type" style="width:125px">
					<option value="1"> + (<cf_get_lang dictionary_id='56010.Artış Hedefi'>)</option>
					<option value="2"> - (<cf_get_lang dictionary_id='56011.Düşüş Hedefi'>)</option>
					<option value="3"> +% (<cf_get_lang dictionary_id='56012.Yüzde Artış Hedefi'>)</option>
					<option value="4"> -% (<cf_get_lang dictionary_id='56013.Yüzde Düşüş Hedefi'>)</option>
					<option value="5"> = (<cf_get_lang dictionary_id='56014.Hedeflenen Rakam'>)</option>
				</select>
			</td>
			</tr>
			<tr>
			  <td><cf_get_lang dictionary_id='56006.Ayrılan Bütçe'></td>
			  <td>
			  <cfinput type="text" name="suggested_budget" class="moneybox" style="width:150px;"  value="" validate="float" onkeyup="return(FormatCurrency(this,event));">
		  &nbsp;<select name="money_type" id="money_type" style="width:125px;">
					<cfoutput query="get_money">
					  <option value="#money#" <cfif get_money.money eq session.ep.money>selected</cfif>>#money#</option>
					</cfoutput>
				</select></td>
			</tr>
			<tr>
			  <td height="26"><cf_get_lang dictionary_id='29784.Ağırlık'></td>
			  <td><input type="text" name="target_weight" id="target_weight" style="width:150;" value="" class="moneybox" validate="float" onkeyup="return(FormatCurrency(this,event));"></td>
			</tr>
			<tr>
			<td><cf_get_lang no='1213.Hedef Veren'></td>
			<td>
				<input type="hidden" name="target_emp_id" id="target_emp_id"  value="<cfoutput>#session.ep.userid#</cfoutput>">
				<input type="text" name="target_emp" id="target_emp" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" style="width:150px;" readonly>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_target.target_emp&field_emp_id2=add_target.target_emp_id</cfoutput>','list','popup_list_positions');"><img src="/images/plus_thin.gif" title="Seçiniz" alt="Seçiniz" border="0" align="absmiddle"></a>
			</td>
			</tr>
			<tr>
			  <td><cf_get_lang dictionary_id ='56688.Ara Görüşme Tarihi'> 1</td>
			  <td>
				<cfinput type="text" name="other_date1" style="width:150px;" validate="#validate_style#" maxlength="10">
				<cf_wrk_date_image date_field="other_date1">
			  </td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='56688.Ara Görüşme Tarihi'> 2</td>
			   <td>
				<cfinput type="text" name="other_date2" style="width:150px;" validate="#validate_style#" maxlength="10">
				<cf_wrk_date_image date_field="other_date2">
			  </td>
			</tr>
			<tr>
			  <td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
			  <td><textarea name="target_detail" id="target_detail" style="width:400px;height:60px;"></textarea>
				  <input type="hidden" name="record_num" id="record_num" value=""></td>
			</tr>
			<tr><cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
				<td width="100"><cf_get_lang dictionary_id ='56689.Destek Alınacak Bölüm'> /<cf_get_lang dictionary_id ='56690.Kişiler'> </td>
				<td><textarea name="target_help" id="target_help"style="width:400px;height:30px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
			</tr>
			<tr>
				<td width="100"><cf_get_lang dictionary_id ='56691.Hedefin Paylaşılacağı Diğer Kişiler'></td>
				<td><textarea name="target_share" id="target_share"style="width:400px;height:30px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
			</tr>
			<cfif not (isDefined("attributes.employee_id") or  isDefined("attributes.position_code"))>
			<tr>
			  <td></td><td>
				<table name="table1" id="table1" width="100%" cellpadding="0" cellspacing="0">
					<tr class="txtboldblue" height="22">
						<td align="left" id="add0" width="20"><input type="button" class="eklebuton" title="" onClick="add_row();"></td>
						<td id="employee0" style="width:125px"><cf_get_lang dictionary_id='57576.Çalışan'>*</td>
						<td style="width:125px"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
						<td style="width:125px"><cf_get_lang dictionary_id='57453.Şube'></td>
						<td></td>
					</tr>
				</table>
			  </td>		
			</tr>
			</cfif>
			<tr>
			  <td></td>
              <td  style="text-align:right;"><cf_workcube_buttons is_upd='0'  add_function='check()'>&nbsp;&nbsp;&nbsp;</td>
            </tr>				
            </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function check()
{	selected_emp=0;
	<cfif not (isDefined("attributes.employee_id") or isDefined("attributes.position_code"))>
		if(row_count >= 1)
		{
			for(i=1; i<=row_count; i++)
			{
			if((eval("document.getElementById('row_kontrol"+i+"').value") == 1) && (eval("document.getElementById('emp_id"+i+"').value") == ""))
				{	
					alert("<cf_get_lang dictionary_id ='56692.Çalışan Ekleyiniz'>!");
					return false;
				}
			else if ((eval("document.getElementById('row_kontrol"+i+"').value") == 1) && (eval("document.getElementById('emp_id"+i+"').value") != ""))
				selected_emp++
			}
		}
		
		if (selected_emp == 0)
		{	
			alert("<cf_get_lang dictionary_id='29498.Çalışan girmelisiniz'>!");
			return false;
		}
	</cfif>
	
	x = document.add_target.targetcat_id.selectedIndex;
	if (document.add_target.targetcat_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58194.Zorunlu alan'>:<cf_get_lang dictionary_id='57486.Kategori'>!");
		return false;
	}
	
	if ((add_target.startdate.value == "") || (add_target.finishdate.value == ""))
		{
			alert("<cf_get_lang dictionary_id ='56693.Başlangıç ve Bitiş Tarihlerini Kontrol Ediniz'>!");
			return false;
		}
	
	if (add_target.target_head.value == "") 
		{
			alert("<cf_get_lang dictionary_id ='56694.Hedef İsmi Girmelisiniz'>!");
			return false;
		}
	
	if (add_target.target_weight.value == "") 
		{
			alert("<cf_get_lang dictionary_id ='56695.Hedef Ağırlığı Girmelisiniz'>!");
			return false;
		}

	if ((add_target.startdate.value != "") && (add_target.finishdate.value != ""))
		if (! date_check(add_target.startdate, add_target.finishdate, "<cf_get_lang dictionary_id ='56696.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'> !"))
			return false;
	add_target.target_number.value = filterNum(add_target.target_number.value);
	add_target.target_weight.value = filterNum(add_target.target_weight.value);
	add_target.suggested_budget.value = filterNum(add_target.suggested_budget.value);
	return true;
}

function sil(sy)
	{
		var my_element=eval("add_target.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";	
	}

row_count=0;

function add_row()
{
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.add_target.record_num.value=row_count;		
	newCell = newRow.insertCell();
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil('+ row_count +');"><img  src="/images/delete_list.gif" border="0"></a><input type="hidden" name="emp_id' + row_count + '">';
	newCell = newRow.insertCell();
	newCell.innerHTML = '<input type="text" name="employee' + row_count + '" id="employee' + row_count + '" style="width:125px;" readonly class="formfieldright">';	
	newCell = newRow.insertCell();
	newCell.innerHTML = '<input type="text" readonly name="pos_name' + row_count + '" value="" style="width:125px;">';
	newCell = newRow.insertCell();
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'"  id="row_kontrol' + row_count +'"><input type="text" readonly name="branch_name' + row_count + '" value="" style="width:125px;">';					
	newCell = newRow.insertCell();
	newCell.innerHTML = '<a onclick="javascript:opage(' + row_count +');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';					

}
function opage(deger)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_target.emp_id' + deger + '&field_emp_name=add_target.employee' + deger +'&field_branch_name=add_target.branch_name'+ deger +'&field_pos_name=add_target.pos_name' + deger,'list','popup_list_positions');
}
</script>
