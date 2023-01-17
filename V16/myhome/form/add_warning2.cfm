<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border">
	<tr class="color-list" valign="middle">
		<td height="35" class="headbold"><cfif isdefined("attributes.is_content")><cf_get_lang dictionary_id ='31776.Döküman Talebi Ekle'><cfelse><cf_get_lang dictionary_id='57935.Uyari Ekle'></cfif></td>
	</tr>
	<tr class="color-row" valign="top">
		<td>
		<cfform name="warning" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_warning">
			<input name="record_num" id="record_num" type="hidden" value="0">
			<table>
				<tr>
					<td>
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td width="70" valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
							<td><textarea name="warning_description" id="warning_description" style="width:480px;height:80px;"></textarea></td>
						</tr>
						<cfoutput>
							<tr>
								<td height="30"><cf_get_lang dictionary_id='30973.Baglanti Yolu'></td>
								<cfif isdefined("attributes.act") and not len(attributes.act)><cfset attributes.act = 'myhome.welcome'></cfif>
								<td height="30" nowrap>
									<input type="text" name="url_link_dsp" id="url_link_dsp" class="boxtext" style="font-family: Geneva, Verdana, Arial, sans-serif;font-weight:bold;color:3399CC;width:480px;"  value="<cfif isdefined("attributes.act")>#employee_domain##request.self#?fuseaction=#attributes.act#</cfif>">
								</td>
								<input type="hidden" name="url_link" id="url_link" value="<cfif isdefined("attributes.act")>#request.self#?fuseaction=#attributes.act#</cfif>">
							</tr>
						</cfoutput>
						<tr>
							<td>&nbsp;</td>
							<td height="35"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">
					<table cellpadding="0" cellspacing="0" id="link_table" border="0">
						<tr>
							<td colspan="7" height="1"><br/><hr size="1" class="txtboldblue"></td>
						</tr>
						<tr>
							<td colspan="2" width="185"><cf_get_lang dictionary_id='57578.Yetkili'>*</td>
							<td colspan="2" width="185"><cf_get_lang dictionary_id='30828.Talep'></td>
							<td colspan="2" width="185">&nbsp;</td>
							<td><input type="hidden" value="" name="sayac" id="sayac"><!--- Uyari eklenen satirlarin sayisini tutar. --->
								<input type="button" class="eklebuton" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row();"></td>
						</tr>
						<tr>
							<td colspan="2">
								<input type="hidden" name="position_code0" id="position_code0">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57578.Yetkili'>!</cfsavecontent>
								<cfinput type="text" name="employee0" id="employee0" message="#message#" required="yes" onFocus="AutoComplete_Create('employee0','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','POSITION_CODE','position_code0','','3','220');"style="width:150px;">
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=warning.position_code0&field_name=warning.employee0&select_list=1,7,8','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
							</td>
							<td colspan="2">
								<cfquery name="get_setup_warning" datasource="#dsn#">
									SELECT * FROM SETUP_WARNINGS ORDER BY SETUP_WARNING
								</cfquery>
								<select name="warning_head0" id="warning_head0" style="width:170px;">
									<cfoutput query="get_setup_warning">
										<option value="#setup_warning#--#setup_warning_id#">#setup_warning#</option>
									</cfoutput>  
								</select>
							</td>
							<td colspan="2"><input type="checkbox" name="is_agenda" id="is_agenda" value="1" />&nbsp;<cf_get_lang dictionary_id='32369.Ajandada Göster'></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2"><cf_get_lang dictionary_id='31431.Son Cevap'></td>
							<td colspan="2"><cf_get_lang dictionary_id='32002.SMS'></td>
							<td colspan="2"><cf_get_lang dictionary_id='31432.Email Uyari'></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td valign="bottom">
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'>!</cfsavecontent>
								<cfinput validate="#validate_style#" message="#message1#" type="text" name="response_date0" required="yes" style="width:65px;" maxlength="10" value="#dateformat(now(), dateformat_style)#">
								<cf_wrk_date_image date_field="response_date0">
							</td>
							<td valign="bottom">
								<select name="response_clock0" id="response_clock0" style="width:37px;;">
									<cfloop from="0" to="23" index="i">
										<cfoutput><option value="#i#">#numberformat(i,00)#</option></cfoutput>
									</cfloop>
								</select>
								<select name="response_min0" id="response_min0">
									<cfloop from="0" to="55" index="a" step="5">
									<cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
									</cfloop>			  
								</select>	
							</td>
							<td valign="bottom">
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz !'></cfsavecontent>
								<cfinput validate="#validate_style#" message="#message1#" type="text" name="sms_startdate0" style="width:65px;" maxlength="10">
								<cf_wrk_date_image date_field="sms_startdate0">
							</td>
							<td valign="bottom">
								<select name="sms_start_clock0" id="sms_start_clock0" style="width:37px;;">
									<cfloop from="0" to="23" index="i">
										<cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput>
									</cfloop>
								</select>
								<select name="sms_start_min0" id="sms_start_min0">
									<cfloop from="0" to="55" index="a" step="5">
									<cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
									</cfloop>			  
								</select>	
							</td>
							<td valign="baseline">
								<cfsavecontent variable="message2"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz '>!</cfsavecontent>
								<cfinput validate="#validate_style#" message="#message2#" type="text" name="email_startdate0" style="width:65px;" maxlength="10">
								<cf_wrk_date_image date_field="email_startdate0">	
							</td>
							<td valign="bottom">		  
								<select name="email_start_clock0" id="email_start_clock0" style="width:37px;;">
									<cfloop from="0" to="23" index="i"><cfoutput>
										<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
									</cfoutput></cfloop>
								</select>
								<select name="email_start_min0" id="email_start_min0">
									<cfloop from="0" to="55" index="a" step="5">
									<cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
									</cfloop>			  
								</select>	
							</td>
							<td>&nbsp;</td>
						</tr>	   
					</table>
					</td>
				</tr>
			</table>
		</cfform>
		</td>
	</tr>
</table>
<script type="text/javascript">
	<cfif not isdefined("attributes.act")>
		document.warning.url_link.value = '<cfoutput>#request.self#?fuseaction=</cfoutput>'+list_getat(opener.location.href,2,'fuseaction=');
		document.warning.url_link_dsp.value = '<cfoutput>#employee_domain##request.self#?fuseaction=</cfoutput>'+list_getat(opener.location.href,2,'fuseaction=');
	</cfif>
	row_count=0;
	main_row_count=0;
	var sayac=0;
	function sil(sy)
	{
		sayac = sayac-1;	
		for(i=sy;i<sy+5;i++){
			var my_element=eval("warning.row_kontrol"+i);
			my_element.value=0;
			var my_element=eval("frm_row"+i);
			my_element.style.display="none";
			
		}
	}
	function add_row()
	{
			sayac = sayac+1;
			row_count++;
			main_row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			document.warning.record_num.value=row_count;
			newCell = newRow.insertCell();
			newCell.setAttribute("id","td_" + row_count);
			newCell.innerHTML = '<br/><hr size="1" class="txtboldblue"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
			eval("td_" + row_count).colSpan = 7;
			
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.warning.record_num.value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","yetkili_" + row_count);
			newCell.innerHTML = '<cf_get_lang dictionary_id="57578.Yetkili">*';
			eval("yetkili_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","talep_" + row_count);
		 	newCell.innerHTML = '<cf_get_lang dictionary_id="30828.Talep">*';
			eval("talep_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","space_" + row_count);
			newCell.innerHTML = '&nbsp;';
			eval("space_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + (row_count - 1) + ');" ><img  src="images/delete_list.gif" border="0"></a><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
	
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.warning.record_num.value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","yetkili_in_" + row_count);
			eval("yetkili_in_" + row_count).colSpan = 2;
			newCell.innerHTML = '<input type="text" name="employee' + main_row_count + '"  id="employee' + main_row_count +'"  style="width:150px;" onFocus="autocomp('+main_row_count+');">&nbsp;<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=warning.position_code" + main_row_count + "&field_name=warning.employee" + main_row_count + "&select_list=1,7,8"+"','list');"+'"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a><input type="hidden" name="position_code' + main_row_count + '"  id="position_code' + main_row_count +'" >';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","talep_in_" + row_count);
			eval("talep_in_" + row_count).colSpan = 2;
			newCell.innerHTML = '<select name="warning_head' + main_row_count + '" style="width:170px;"><cfoutput query="GET_SETUP_WARNING"><option value="#SETUP_WARNING#--#SETUP_WARNING_ID#">#SETUP_WARNING#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","space_in_" + row_count); 
			eval("space_in_" + row_count).colSpan = 2;
			newCell.innerHTML = '<input type="checkbox" name="is_agenda' + main_row_count +'" value="1" />&nbsp;Ajandada G�ster';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
			
			
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.warning.record_num.value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","son_cevap_" + row_count);
			newCell.innerHTML = "<cf_get_lang dictionary_id='31431.Son Cevap'>*";
			eval("son_cevap_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","SMS_" + row_count);
			newCell.innerHTML = 'SMS';
			eval("SMS_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","email_" + row_count);
			newCell.innerHTML = "<cf_get_lang dictionary_id='31432.Email Uyari'>";
			eval("email_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
			
			
			
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.warning.record_num.value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","response_date" + main_row_count + "_td");
			newCell.innerHTML = '<input type="text" name="response_date' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), dateformat_style)#</cfoutput>">&nbsp;';
			wrk_date_image('response_date' + main_row_count);

			newCell = newRow.insertCell(newRow.cells.length);
			HTMLStr = '<select name="response_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#i#">#numberformat(i,00)#</option></cfoutput></cfloop></select>&nbsp;';
			HTMLStr = HTMLStr + '<select name="response_min' + main_row_count + '" style="width:37px;;"><option value="00" selected>00</option>';
			HTMLStr = HTMLStr + '<option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option>';
			HTMLStr = HTMLStr + '<option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
			HTMLStr = HTMLStr + '</select>';
			newCell.innerHTML = HTMLStr;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","sms_startdate" + main_row_count + "_td");
			newCell.innerHTML = '<input type="text" name="sms_startdate' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">&nbsp;';
			wrk_date_image('sms_startdate' + main_row_count);

			newCell = newRow.insertCell(newRow.cells.length);
			HTMLStr = '<select name="sms_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>&nbsp;';
			HTMLStr = HTMLStr + '<select name="sms_start_min' + main_row_count + '" style="width:37px;;">';
			HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
			HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
			HTMLStr = HTMLStr + '</select>';
			newCell.innerHTML = HTMLStr;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","email_startdate" + main_row_count + "_td");
			newCell.innerHTML = '<input type="text" name="email_startdate' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">&nbsp;';
			wrk_date_image('email_startdate' + main_row_count);
			
			newCell = newRow.insertCell(newRow.cells.length);
			HTMLStr = '<select name="email_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>&nbsp;';
			HTMLStr = HTMLStr + '<select name="email_start_min' + main_row_count + '" style="width:37px;;">';
			HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
			HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
		    HTMLStr = HTMLStr + '</select>';
			newCell.innerHTML = HTMLStr;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
	}
function autocomp(no)
{
	AutoComplete_Create("employee" + no,"MEMBER_NAME,MEMBER_PARTNER_NAME2","MEMBER_PARTNER_NAME2,MEMBER_NAME2","get_member_autocomplete","\'1,2,3\'","POSITION_CODE","position_code" + no,"warning",3,220);
}
function kontrol()
	{	
		document.warning.sayac.value=sayac;  
		if (document.warning.warning_description.value.length>1000)
		{
			alert("<cf_get_lang dictionary_id ='31775.Açıklama Alanı Uzunluğu 1000 karakterden fazla olamaz'>!");    
			return false;		
		}		
		return true;
	}
</script>
