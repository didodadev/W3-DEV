<cfquery name="GET_SETUP_WARNING" datasource="#dsn#">
	SELECT SETUP_WARNING_ID,SETUP_WARNING FROM SETUP_WARNINGS ORDER BY SETUP_WARNING
</cfquery>
<cfsavecontent variable="head_">
	<cfif isdefined("attributes.per_req_id")>Personel İstek Formu Yetkili ve Uyarılacaklar<cfelse>Terfi-Transfer-Rotasyon Talep Formu Yetkili ve Uyarılacaklar</cfif>
</cfsavecontent>
<cf_popup_box title="#head_#">
    <table width="535">
		<cfif isdefined("attributes.per_req_id")>
            <form name="add_authority" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_upd_per_form_autority">
            <input name="record_num" id="record_num" type="hidden" value="0">
            <input name="record_count" id="record_count" type="hidden" value="0">
            <input type="hidden" name="per_req_id" id="per_req_id" value="<cfoutput>#attributes.per_req_id#</cfoutput>">
                <tr>
                    <td colspan="3" class="txtbold">
                        <input type="hidden" name="url_link" id="url_link" value="<cfoutput>#request.self#?fuseaction=myhome.upd_personel_requirement_form&per_req_id=#attributes.per_req_id#</cfoutput>"><cf_get_lang dictionary_id="51229.Yetkililer"> 
                        <input type="button" class="eklebuton" title="Ekle" onClick="add_row();">
                        <input type="hidden" name="positions" id="positions" value="">
                    </td>
                </tr>
                <tr>
                    <cfquery name="get_authority" datasource="#DSN#">
                        SELECT 
                            SLA.*,
                            EP.EMPLOYEE_NAME,
                            EP.EMPLOYEE_SURNAME
                        FROM
                            EMPLOYEES_APP_AUTHORITY SLA,
                            EMPLOYEE_POSITIONS EP
                        WHERE
                            PER_REQ_FORM_ID=#attributes.per_req_id# AND
                            EP.POSITION_CODE = SLA.POS_CODE AND
                            SLA.AUTHORITY_STATUS = 1
                    </cfquery>
                    <td id="td_yetkili" colspan="3" valign="top">
						<cfif get_authority.RECORDCOUNT>
                            <cfoutput query="get_authority">
                                <a href="#request.self#?fuseaction=correspondence.emptypopup_del_per_form_autority&per_req_id=#attributes.per_req_id#&pos_code=#get_authority.pos_code#&valid_status=#get_authority.valid_status#"><img src="/images/delete_list.gif" alt="" border="0"></a>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#<br/>
                            </cfoutput>
                        </cfif>
                    </td>
                </tr>
                <tr><td colspan="4"><hr></td></tr>
                <tr>
                    <td colspan="4">
                        <table id="link_table">
                        <!--- uyarılacak kişiler--->
                        </table>
                    </td>
                    </tr>
                    <tr>
                    	<td style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
                    </tr>
            </form>
			<!---<cfelseif isdefined("attributes.per_rot_id")>--->            
            <form name="add_authority" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_upd_per_form_autority">
            <input name="record_num" id="record_num" type="hidden" value="0">
            <input name="record_count" id="record_count" type="hidden" value="0">
            <input type="hidden" name="per_rot_id" id="per_rot_id" value="<cfoutput>#attributes.per_rot_id#</cfoutput>">
                <tr>
                    <td colspan="3" class="txtbold">
                        <input type="hidden" name="url_link" id="url_link" value="<cfoutput>#request.self#?fuseaction=myhome.upd_personel_rotation_form&per_rot_id=#attributes.per_rot_id#</cfoutput>"><cf_get_lang dictionary_id="51229.Yetkililer"> 
                        <input type="button" class="eklebuton" title="Ekle" onClick="add_row();">
                        <input type="hidden" name="positions" id="positions" value="">
                    </td>
                </tr>
                <tr>
                    <cfquery name="get_authority" datasource="#DSN#">
                    SELECT 
                        SLA.*,
                        EP.EMPLOYEE_NAME,
                        EP.EMPLOYEE_SURNAME
                    FROM
                        EMPLOYEES_APP_AUTHORITY SLA,
                        EMPLOYEE_POSITIONS EP
                    WHERE
                        ROTATION_FORM_ID=#attributes.per_rot_id# AND
                        EP.POSITION_CODE = SLA.POS_CODE AND
                        SLA.AUTHORITY_STATUS = 1
                    </cfquery>
                    <td id="td_yetkili" colspan="3" valign="top">
						<cfif get_authority.RECORDCOUNT>
							<cfoutput query="get_authority">
                                <a href="#request.self#?fuseaction=correspondence.emptypopup_del_per_form_autority&per_rot_id=#attributes.per_rot_id#&pos_code=#get_authority.pos_code#&valid_status=#get_authority.valid_status#"><img src="/images/delete_list.gif" alt="" border="0"></a>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#<br/>
                            </cfoutput>
                        </cfif>
                    </td>
                </tr>
                <tr><td colspan="4"><hr></td></tr>
                <tr>
                	<td colspan="4">
                        <table id="link_table">
						<!--- uyarılacak kişiler--->
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
                </tr>
            </form>
        </cfif>
    </table>
</cf_popup_box>
<script type="text/javascript">
var row_count=0;
var main_row_count=0;
function sil(sy)
{
	for(i=sy;i<sy+5;i++){
		var my_element=eval("add_authority.row_kontrol"+i);
		my_element.value=0;

		var my_element=eval("frm_row"+i);
		my_element.style.display="none";		
	}
	document.add_authority.record_count.value=parseInt(document.add_authority.record_count.value)-1;
}

function add_row()
{
	row_count++;
	main_row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
				
	document.add_authority.record_num.value=row_count;
	document.add_authority.record_count.value=parseInt(document.add_authority.record_count.value)+1;
	
	newCell = newRow.insertCell();
	newCell.innerHTML = '<hr size="1" color="#000066"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
	
	row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.add_authority.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<cf_get_lang_main no="166.Yetkili">*';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = "<cf_get_lang no='56.Talep'>*";
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = "<cf_get_lang dictionary_id='57629.Açıklama'>";
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '&nbsp;';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + (row_count - 1) + ');" ><img  src="images/delete_list.gif" alt="" border="0"></a><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';

	row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.add_authority.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="employee' + main_row_count + '" style="width:150px;"><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_authority.position_code" + main_row_count + "&field_name=add_authority.employee" + main_row_count + "','list');"+'"><img src="/images/plus_list.gif" align="absmiddle" alt="" border="0"></a><input type="hidden" name="position_code' + main_row_count + '">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="warning_head' + main_row_count + '" style="width:165px;"><cfoutput query="GET_SETUP_WARNING"><option value="#SETUP_WARNING#--#SETUP_WARNING_ID#">#SETUP_WARNING#</option></cfoutput></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="warning_description' + main_row_count + '" style="width:150px;">';
	
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
	
	document.add_authority.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = "<cf_get_lang dictionary_id='31431.Son Cevap'>*";
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = "<cf_get_lang dictionary_id='32002.SMS'>";
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = "<cf_get_lang dictionary_id='31432.Email Uyarı'>";
	
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
	
	document.add_authority.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	HTMLStr = '<input type="text" name="response_date' + main_row_count + '" style="width:65px;" maxlength="10" value="<cfoutput>#dateformat(now(), dateformat_style)#</cfoutput>">';
	HTMLStr = HTMLStr + '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=add_authority.response_date" + main_row_count + "','date');"+'"><img src="/images/calendar.gif" alt="Tairh" border="0" align="absbottom"></a>';
	HTMLStr = HTMLStr + '<select name="response_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#i#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
	HTMLStr = HTMLStr + '<select name="response_min' + main_row_count + '" style="width:37px;;"><option value="00" selected>00</option>';
	HTMLStr = HTMLStr + '<option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option>';
	HTMLStr = HTMLStr + '<option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
	HTMLStr = HTMLStr + '</select>';
	newCell.innerHTML = HTMLStr;
	
	newCell = newRow.insertCell(newRow.cells.length);
	HTMLStr = '<input type="text" name="sms_startdate' + main_row_count + '" style="width:65px;" maxlength="10">';
	HTMLStr = HTMLStr + '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=add_authority.sms_startdate" + main_row_count + "','date');"+'"><img src="/images/calendar.gif" alt="Tarih" border="0" align="absbottom"></a>';
	HTMLStr = HTMLStr + '<select name="sms_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
	HTMLStr = HTMLStr + '<select name="sms_start_min' + main_row_count + '" style="width:37px;;">';
	HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
	HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
	HTMLStr = HTMLStr + '</select>';
	newCell.innerHTML = HTMLStr;
	
	newCell = newRow.insertCell(newRow.cells.length);
	HTMLStr = '<input type="text" name="email_startdate' + main_row_count + '" style="width:65px;" maxlength="10">';
	HTMLStr = HTMLStr + '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=add_authority.email_startdate" + main_row_count + "','date');"+'"><img src="/images/calendar.gif" alt="" border="0" align="absbottom"></a>';
	HTMLStr = HTMLStr + '<select name="email_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
	HTMLStr = HTMLStr + '<select name="email_start_min' + main_row_count + '" style="width:37px;;">';
	HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
	HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
	HTMLStr = HTMLStr + '</select>';
	newCell.innerHTML = HTMLStr;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
}
</script>
