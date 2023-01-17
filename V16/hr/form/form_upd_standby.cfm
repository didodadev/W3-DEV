<cfinclude template="../query/get_standby.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box> 
		<cfform name="add_standby" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_standby" enctype="multipart/form-data">
			<input type="hidden" name="counter" id="counter" value="">
			<cfif not len(get_standby.valid_1)>
				<input type="hidden" name="valid1" id="valid1" value="">
			</cfif>
			<cfif not len(get_standby.valid_2)>
				<input type="hidden" name="valid2" id="valid2" value="">
			</cfif>
			<input type="hidden" name="SB_ID" id="SB_ID" value="<cfoutput>#attributes.SB_ID#</cfoutput>">
			<cf_box_elements>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-position_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55498.Pozisyonun Çalışanı'> *</label>
						<div class="col col-4 col-xs-12">
							<cfset attributes.position_code=get_standby.position_code>
							<cfinclude template="../query/get_position.cfm">
							<cfif len(get_standby.position_code)>                      
								<cfinput name="position_emp" type="text" value="#get_position.employee_name# #get_position.employee_surname#" id="position_emp" readonly="yes">
							<cfelse>
								<cfinput name="position_emp" type="text" id="position_emp" readonly="yes">
							</cfif>
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<input name="position_code" type="hidden" id="position_code" value="<cfoutput>#get_standby.position_code#</cfoutput>">
								<cfif len(get_standby.position_code)>
									<cfset attributes.position_code = get_standby.position_code>
									<cfinclude template="../query/get_position.cfm">
									<cfinput name="position_name" type="text" id="position_name" value="#get_position.POSITION_NAME#">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.position_code&field_emp_name=add_standby.position_emp&field_pos_name=add_standby.position_name');"></span>
								<cfelse>
									<cfinput name="position_name" type="text" id="position_name">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.position_code&field_emp_name=add_standby.position_emp&field_pos_name=add_standby.position_name');"></span>
								</cfif>
							</div>
						</div>
					</div>
					<!--- Amirler --->
					<!--- Amir 1 --->
					<cfif LEN(get_standby.chief1_code)>
						<cfset attributes.employee_id = "">
						<cfset attributes.position_code = get_standby.chief1_code>
						<cfinclude template="../query/get_position.cfm">
						<cfset chief1_emp = "#get_position.employee_name# #get_position.employee_surname#">
						<cfset chief1_name = "#get_position.position_name#">
					<cfelse>
						<cfset chief1_emp = "">
						<cfset chief1_name = "">
					</cfif>
					<!--- Amir 2 --->
					<cfif LEN(get_standby.chief2_code)>
						<cfset attributes.employee_id = "">
						<cfset attributes.position_code = get_standby.chief2_code>
						<cfinclude template="../query/get_position.cfm">
						<cfset chief2_emp = "#get_position.employee_name# #get_position.employee_surname#">
						<cfset chief2_name = "#get_position.position_name#">
					<cfelse>
						<cfset chief2_emp = "">
						<cfset chief2_name = "">
					</cfif>
					<!--- Amir 3 --->
					<cfif LEN(get_standby.chief3_code)>
						<cfset attributes.employee_id = "">
						<cfset attributes.position_code = get_standby.chief3_code>
						<cfinclude template="../query/get_position.cfm">
						<cfset chief3_emp = "#get_position.employee_name# #get_position.employee_surname#">
						<cfset chief3_name = "#get_position.position_name#">
					<cfelse>
						<cfset chief3_emp = "">
						<cfset chief3_name = "">
					</cfif>
					<div class="form-group" id="item-chief">
						<label class="col col-12 bold"><cf_get_lang dictionary_id='55490.Amirler'></label>
					</div>
					<div class="form-group" id="item-chief1_emp">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56110.Birinci Amir'>*</label>
						<div class="col col-4 col-xs-12">
							<input name="chief1_code" type="hidden" id="chief1_code" value="<cfoutput>#get_standby.chief1_code#</cfoutput>">
							<input name="chief1_emp" id="chief1_emp" type="text" readonly VALUE="<cfoutput>#chief1_emp#</cfoutput>">
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<input name="chief1_name" type="text" id="chief1_name" readonly VALUE="<cfoutput>#chief1_name#</cfoutput>">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.chief1_code&field_emp_name=add_standby.chief1_emp&field_pos_name=add_standby.chief1_name');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-chief2_emp">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56111.İkinci Amir'></label>
						<div class="col col-4 col-xs-12">
							<input name="chief2_code" type="hidden" id="chief2_code" value="<cfoutput>#get_standby.chief2_code#</cfoutput>">
							<input name="chief2_emp" id="chief2_emp" type="text" VALUE="<cfoutput>#chief2_emp#</cfoutput>">
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<input name="chief2_name" type="text" id="chief2_name" VALUE="<cfoutput>#chief2_name#</cfoutput>">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.chief2_code&field_emp_name=add_standby.chief2_emp&field_pos_name=add_standby.chief2_name');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-chief3_emp">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56070.Görüş Bildirecek Kişi'></label>
						<div class="col col-4 col-xs-12">
							<input name="chief3_code" type="hidden" id="chief3_code" value="<cfoutput>#get_standby.chief3_code#</cfoutput>">
							<input name="chief3_emp" id="chief3_emp" type="text" VALUE="<cfoutput>#chief3_emp#</cfoutput>">
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<input name="chief3_name" type="text" id="chief3_name"  VALUE="<cfoutput>#chief3_name#</cfoutput>"> 
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.chief3_code&field_emp_name=add_standby.chief3_emp&field_pos_name=add_standby.chief3_name');"></span>
							</div>
						</div>
					</div>
					<!--- Yedekler --->
					<input name="CANDIDATE_POS_1" type="hidden" id="CANDIDATE_POS_1" value="<cfoutput>#get_standby.candidate_pos_1#</cfoutput>">
					<cfif len(get_standby.CANDIDATE_POS_1)>
						<cfset attributes.employee_id = "">
						<cfset attributes.position_code = get_standby.CANDIDATE_POS_1>
						<cfinclude template="../query/get_position.cfm">
						<cfset candidate_1_name = "#get_position.employee_name# #get_position.employee_surname#">
						<cfset candidate_1_pos = "#get_position.position_name#">
					<cfelse>
						<cfset candidate_1_name = "">
						<cfset candidate_1_pos = "">
					</cfif>
					<input name="CANDIDATE_POS_2" type="hidden" id="CANDIDATE_POS_2" value="<cfoutput>#get_standby.candidate_pos_2#</cfoutput>">
					<cfif len(get_standby.CANDIDATE_POS_2)>
						<cfset attributes.employee_id = "">
						<cfset attributes.position_code = get_standby.CANDIDATE_POS_2>
						<cfinclude template="../query/get_position.cfm">
						<cfset candidate_2_name = "#get_position.employee_name# #get_position.employee_surname#">
						<cfset candidate_2_pos = "#get_position.position_name#">
					<cfelse>
						<cfset candidate_2_name = "">
						<cfset candidate_2_pos = "">
					</cfif>
					<input name="CANDIDATE_POS_3" type="hidden" id="CANDIDATE_POS_3" value="<cfoutput>#get_standby.candidate_pos_3#</cfoutput>">
					<cfif len(get_standby.CANDIDATE_POS_3)>
						<cfset attributes.employee_id = "">
						<cfset attributes.position_code = get_standby.CANDIDATE_POS_3>
						<cfinclude template="../query/get_position.cfm">
						<cfset candidate_3_name = "#get_position.employee_name# #get_position.employee_surname#">
						<cfset candidate_3_pos = "#get_position.position_name#">
					<cfelse>
						<cfset candidate_3_name = "">
						<cfset candidate_3_pos = "">
					</cfif>
					<div class="form-group" id="item-CANDIDATE">
						<label class="col col-12 bold"><cf_get_lang dictionary_id='55491.Yedekler'></label>
					</div>
					<div class="form-group" id="item-CANDIDATE_POS_1_EMP">
						<label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id='55499.Yedek'></label>
						<div class="col col-4 col-xs-12">
							<input name="CANDIDATE_POS_1_EMP" type="text" id="CANDIDATE_POS_1_EMP" value="<cfoutput>#candidate_1_name#</cfoutput>"> 
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfinput name="CANDIDATE_POS_1_NAME" value="#candidate_1_pos#" type="text" id="CANDIDATE_POS_1_NAME">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.CANDIDATE_POS_1&field_emp_name=add_standby.CANDIDATE_POS_1_EMP&field_pos_name=add_standby.CANDIDATE_POS_1_NAME');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-CANDIDATE_POS_2_EMP">
						<label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id='55499.Yedek'></label>
						<div class="col col-4 col-xs-12">
							<input name="CANDIDATE_POS_2_EMP" type="text" id="CANDIDATE_POS_2_EMP" value="<cfoutput>#candidate_2_name#</cfoutput>">
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<input name="CANDIDATE_POS_2_NAME" value="<cfoutput>#candidate_2_pos#</cfoutput>" type="text" id="CANDIDATE_POS_2_NAME">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.CANDIDATE_POS_2&field_emp_name=add_standby.CANDIDATE_POS_2_EMP&field_pos_name=add_standby.CANDIDATE_POS_2_NAME');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-CANDIDATE_POS_3_EMP">
						<label class="col col-4 col-xs-12">3.<cf_get_lang dictionary_id='55499.Yedek'></label>
						<div class="col col-4 col-xs-12">
							<input name="CANDIDATE_POS_3_EMP" value="<cfoutput>#candidate_3_name#</cfoutput>" type="text" id="CANDIDATE_POS_3_EMP">
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<input name="CANDIDATE_POS_3_NAME" value="<cfoutput>#candidate_3_pos#</cfoutput>"  type="text" id="CANDIDATE_POS_3_NAME">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.CANDIDATE_POS_3&field_emp_name=add_standby.CANDIDATE_POS_3_EMP&field_pos_name=add_standby.CANDIDATE_POS_3_NAME');"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6 col-xs-12">
					<cf_record_info query_name="get_standby">
				</div>
				<div class="col col-6 col-xs-12">
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_standby&sb_id=#attributes.sb_id#&head=#get_position.employee_name# #get_position.employee_surname#' add_function='control()'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function control()
{	
	if(document.getElementById('position_emp').value == '')
	{
		alert("<cf_get_lang dictionary_id='56073.Yedekleme Pozisyonu '>");
		return false;
	}
	if(document.getElementById('position_name').value == '')
	{
		alert("<cf_get_lang dictionary_id='56073.Yedekleme Pozisyonu '>");
		return false;
	}
	if (add_standby.chief1_name.value == '')
	{
	alert("1. <cf_get_lang dictionary_id='56071.Amiri Seçmelisiniz'>");
	return false;
	}
	return true;
}
</script>
