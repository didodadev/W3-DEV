<cfquery name="GET_SETUP_WARNING" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_WARNINGS 
	ORDER BY 
		SETUP_WARNING
</cfquery>
<cfsavecontent variable="title_">
	<cfif isdefined("attributes.per_req_id")><cf_get_lang dictionary_id="55300.Personel İstek Formu Yetkili ve Uyarılacaklar"><cfelse><cf_get_lang dictionary_id="55305.Terfi-Transfer-Rotasyon Talep Formu Yetkili ve Uyarılacaklar"></cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#title_#">
		<cfif isdefined("attributes.per_req_id")>
			<form name="add_authority" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_upd_per_form_autority">
			<cf_grid_list>
				<input name="record_num" id="record_num" type="hidden" value="0">
				<input name="record_count" id="record_count" type="hidden" value="0">
				<input type="hidden" name="per_req_id" id="per_req_id" value="<cfoutput>#attributes.per_req_id#</cfoutput>">
				<thead>
					<tr>
						<th width="15">
							 <input type="button" class="eklebuton" title="Ekle" onClick="add_row();">
						</th>
						<th>
							<input type="hidden" name="url_link" id="url_link" value="<cfoutput>#request.self#?fuseaction=myhome.from_upd_personel_requirement_form&per_req_id=#attributes.per_req_id#</cfoutput>" > <cf_get_lang dictionary_id="55973.Yetkililer"> 
							<input type="hidden" name="positions" id="positions" value="">
						</th>
					</tr>
				</thead>
				<tbody>
					<cfquery name="get_authority" datasource="#DSN#">
						SELECT 
							SLA.*,
							EP.EMPLOYEE_NAME,
							EP.EMPLOYEE_SURNAME,
							WARNING_DESCRIPTION,
							LAST_RESPONSE_DATE,
							SMS_WARNING_DATE,
							EMAIL_WARNING_DATE,
							WARNING_HEAD
						FROM
							EMPLOYEES_APP_AUTHORITY SLA,
							EMPLOYEE_POSITIONS EP
							LEFT JOIN PAGE_WARNINGS ON EP.POSITION_CODE=PAGE_WARNINGS.POSITION_CODE
						WHERE
							PER_REQ_FORM_ID=#attributes.per_req_id# AND
							EP.POSITION_CODE = SLA.POS_CODE AND
							SLA.AUTHORITY_STATUS = 1
					</cfquery>
					<cfif get_authority.RECORDCOUNT>
						<cfoutput query="get_authority">
							<tr>
								<td id="td_yetkili"><a href="#request.self#?fuseaction=hr.emptypopup_del_per_form_autority&per_req_id=#attributes.per_req_id#&pos_code=#get_authority.pos_code#&valid_status=#get_authority.valid_status#"><i class="fa fa-minus"></i></a>
								</td>
								<td>
									#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
									#WARNING_DESCRIPTION#
									#WARNING_HEAD#
									#LAST_RESPONSE_DATE#
									#SMS_WARNING_DATE#
									#EMAIL_WARNING_DATE#
								</td>
							</tr>
						</cfoutput>
					</cfif>
					
				</tbody>
				<tbody id="link_table">
					
				</tbody>
			</cf_grid_list>
			<cf_box_footer><cf_workcube_buttons is_upd='0'></cf_box_footer>
			</form>
		<cfelseif isdefined("attributes.per_rot_id")>
			<form name="add_authority" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_upd_per_form_autority">
				<cf_grid_list>        
					<input name="record_num" id="record_num" type="hidden" value="1">
					<input name="record_count" id="record_count" type="hidden" value="0">
					<input type="hidden" name="per_rot_id" id="per_rot_id" value="<cfoutput>#attributes.per_rot_id#</cfoutput>">
						<thead>     
							<tr>
								<th width="15">
									<a href="javascript://"onClick="add_row();"><i class="fa fa-plus"></i></a>
								</th>
								<th>
									<cf_get_lang dictionary_id="57578.Yetkili">*
									<input type="hidden" name="url_link" id="url_link" value="<cfoutput>#request.self#?fuseaction=myhome.upd_personel_rotation_form&per_rot_id=#attributes.per_rot_id#</cfoutput>" > 
									<input type="hidden" name="positions" id="positions" value="">
								</th>
								<th>
									<cf_get_lang dictionary_id='57527.Talepler'>*
								</th>
								<th>
									<cf_get_lang dictionary_id='59067.Açıklama'>*
								</th>
								<th style="min-width:200px"> <cf_get_lang dictionary_id='35301.Son Cevap'>*</th>
								<th style="min-width:200px"><cf_get_lang dictionary_id='49523.SMS'></th>
								<th style="min-width:200px"><cf_get_lang dictionary_id='31432.Email Uyarı'></th>
							</tr>
						</thead>
						<tbody>
							<cfquery name="get_authority" datasource="#DSN#">
								SELECT 
									SLA.*,
									EP.EMPLOYEE_NAME,
									EP.EMPLOYEE_SURNAME,
									WARNING_DESCRIPTION,
									LAST_RESPONSE_DATE,
									SMS_WARNING_DATE,
									EMAIL_WARNING_DATE,
									WARNING_HEAD
								FROM
									EMPLOYEES_APP_AUTHORITY SLA,
									EMPLOYEE_POSITIONS EP
									LEFT JOIN PAGE_WARNINGS ON EP.POSITION_CODE=PAGE_WARNINGS.POSITION_CODE
								WHERE
									ROTATION_FORM_ID=#attributes.per_rot_id# AND
									EP.POSITION_CODE = SLA.POS_CODE AND
									SLA.AUTHORITY_STATUS = 1
							</cfquery>
							<cfif get_authority.RECORDCOUNT>
								
								<cfoutput query="get_authority">
									<tr>
										<td id="td_yetkili"><a href="#request.self#?fuseaction=hr.emptypopup_del_per_form_autority&per_rot_id=#attributes.per_rot_id#&pos_code=#get_authority.pos_code#&valid_status=#get_authority.valid_status#"><i class="fa fa-minus"></i></a></td>
										<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#<br/></td>
										<td>#WARNING_HEAD#<br/></td>
										<td>#WARNING_DESCRIPTION#<br/></td>
										<td>#LAST_RESPONSE_DATE#<br/></td>
										<td>#SMS_WARNING_DATE#<br/></td>
										<td>#EMAIL_WARNING_DATE#<br/></td>
									</tr>
	
								</cfoutput>
							</cfif>
						</tbody>
						<tbody  id="link_table">							
						</tbody>
					
				</cf_grid_list>
				<cf_box_footer><cf_workcube_buttons is_upd='0'></cf_box_footer>
			</form>
		</cfif>
	</cf_box>
</div>


<script type="text/javascript">
var row_count=0;
var main_row_count=0;
function sil(sy)
{
	for(i=sy;i<sy+4;i++){
		var my_element=eval("add_authority.row_kontrol"+i);
		my_element.value=0;

		var my_element=eval("frm_row"+i);
		my_element.style.display="none";		
	}
	//document.add_authority.record_count.value=parseInt(document.add_authority.record_count.value)-1;
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
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + (row_count) + ');" ><i class="fa fa-minus"></i></a><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';

	


	
	document.add_authority.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="employee' + main_row_count + '" id="employee' + main_row_count + '"  value=""> <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=position_code" + main_row_count + "&field_name=employee" + main_row_count + "','list');"+'"></span><input type="hidden" name="position_code' + main_row_count + '" id="position_code' + main_row_count + '" value=""></div></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="warning_head' + main_row_count + '" style="width:165px;"><cfoutput query="GET_SETUP_WARNING"><option value="#SETUP_WARNING#--#SETUP_WARNING_ID#">#SETUP_WARNING#</option></cfoutput></select></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="warning_description' + main_row_count + '" ><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ></div>';


	

	
	document.add_authority.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	HTMLStr = '<div class="form-group"><div class="col col-6"><div class="input-group"><input type="text" name="response_date' + main_row_count + '" style="width:65px;" maxlength="10" value="<cfoutput>#dateformat(now(), dateformat_style)#</cfoutput>">';
	HTMLStr = HTMLStr + '<span class="input-group-addon" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=add_authority.response_date" + main_row_count + "','date');"+'"><i class="fa fa-calendar"></i></span></div></div>';
	HTMLStr = HTMLStr + '<div class="col col-3"><select name="response_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#i#">#numberformat(i,00)#</option></cfoutput></cfloop></select></div>';
	HTMLStr = HTMLStr + '<div class="col col-3"><select name="response_min' + main_row_count + '" style="width:37px;;"><option value="00" selected>00</option>';
	HTMLStr = HTMLStr + '<option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option>';
	HTMLStr = HTMLStr + '<option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
	HTMLStr = HTMLStr + '</select></div></div>';
	newCell.innerHTML = HTMLStr;
	
	newCell = newRow.insertCell(newRow.cells.length);
	HTMLStr = '<div class="form-group"><div class="col col-6"><div class="input-group"><input type="text" name="sms_startdate' + main_row_count + '" style="width:65px;" maxlength="10">';
	HTMLStr = HTMLStr + '<span class="input-group-addon" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=add_authority.sms_startdate" + main_row_count + "','date');"+'"><i class="icn-md fa fa-calendar"></i></span></div></div>';
	HTMLStr = HTMLStr + '<div class="col col-3"><select name="sms_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select></div>';
	HTMLStr = HTMLStr + '<div class="col col-3"><select name="sms_start_min' + main_row_count + '" style="width:37px;;">';
	HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
	HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
	HTMLStr = HTMLStr + '</select></div></div>';
	newCell.innerHTML = HTMLStr;
	
	newCell = newRow.insertCell(newRow.cells.length);
	HTMLStr = '<div class="form-group"><div class="col col-6"><div class="input-group"><input type="text" name="email_startdate' + main_row_count + '" style="width:65px;" maxlength="10">';
	HTMLStr = HTMLStr + '<span class="input-group-addon" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=add_authority.email_startdate" + main_row_count + "','date');"+'"><i class="icn-md fa fa-calendar"></i></span></div></div>';
	HTMLStr = HTMLStr + '<div class="col col-3"><select name="email_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select></div>';
	HTMLStr = HTMLStr + '<div class="col col-3"><select name="email_start_min' + main_row_count + '" style="width:37px;;">';
	HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
	HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
	HTMLStr = HTMLStr + '</select><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ></div></div>';
	newCell.innerHTML = HTMLStr;
	
}
</script>
