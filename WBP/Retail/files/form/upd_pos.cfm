<cfquery name="BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	ORDER BY 
		BRANCH_NAME
</cfquery>

<cfquery name="GET_POS_EQUIPMENT" datasource="#DSN3#">
	SELECT
		*
	FROM
		POS_EQUIPMENT
	WHERE
		POS_ID = #attributes.pos_id#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#iif(isDefined("attributes.draggable"),"getLang('','Yazar Kasa Güncelle',62544)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="add_pos" id="add_pos" method="post" action="#request.self#?fuseaction=retail.emptypopup_upd_pos">
			<input type="hidden" name="pos_id" id="pos_id" value="<cfoutput>#attributes.pos_id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_status">
						<label class="col col-12">
							<input type="checkbox" name="is_status" id="is_status" value="1" <cfif get_pos_equipment.is_status> checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
						</label>
					</div>
				</div>
				<div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-equipment">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49775.Kasa Adı'> *</label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="equipment" id="equipment" maxlength="100" required="yes" value="#get_pos_equipment.equipment#" message="#getLang('','Kasa Girmelisiniz',54596)#">
						</div>
					</div>
					<div class="form-group" id="item-equipment">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49778.Kasa Kodu'> *</label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="equipment_code" value="#get_pos_equipment.equipment_code#" maxlength="50" required="yes" message="#getLang('','Kasa Kodu Girmelisiniz',62623)#!">
						</div>
					</div>
					<div class="form-group" id="item-branch_id">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-9 col-xs-12">
							<cfselect name="branch_id" id="branch_id" required="yes" message="#getLang('','Şube Seçiniz',30126)#!">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="branches">
									<option value="#branch_id#" <cfif branch_id eq get_pos_equipment.branch_id> selected</cfif>>#branch_name#</option>
								</cfoutput>
							</cfselect>
						</div>
					</div>
					<div class="form-group" id="item-pos_code3">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='47708.Path'> *</label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="path" value="#get_pos_equipment.path#" maxlength="200" required="yes" message="#getLang('','Path Girmelisiniz',43428)#!">
						</div>
					</div>
					<div class="form-group" id="item-pos_code3">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='62624.Offline Path'> *</label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="offline_path" value="#get_pos_equipment.offline_path#" maxlength="200" required="yes" message="#getLang('','Offline Path Girmelisiniz',62625)#!">
						</div>
					</div>
					<div class="form-group" id="item-pos_code3">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='62626.Filename'> *</label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="filename" value="#get_pos_equipment.filename#" maxlength="100" required="yes" message="#getLang('','Filename Girmelisiniz',62627)#!">
						</div>
					</div>
					<div class="form-group" id="item-pos_code3">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='52735.Type'></label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="type" value="#get_pos_equipment.type#" maxlength="100">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-assetp_id">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_pos_equipment.assetp_id#</cfoutput>">
								<cfif len(get_pos_equipment.assetp_id)>
									<cfset attributes.assetp_id = get_pos_equipment.assetp_id>
									<cfinclude template="../../../../v16/finance/query/get_assetp_name.cfm">
									<input type="text" name="assetp" id="assetp" value="<cfoutput>#get_assetp_name.assetp#</cfoutput>" style="width:200px;">
								<cfelse>
									<input type="text" name="assetp" id="assetp" style="width:200px;">
								</cfif>                
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_assets&field_id=add_pos.assetp_id&field_name=add_pos.assetp&event_id=0','list');return false"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-pos_code3">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='62628.Seri Numarası'></label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="serial_number" value="#get_pos_equipment.serial_number#" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-pos_code3">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='62629.Mali No'></label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="mali_no" value="#get_pos_equipment.mali_no#" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-pos_code1">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 1</label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="pos_code1" id="pos_code1" value="<cfoutput>#get_pos_equipment.cashier1#</cfoutput>">
								<cfif len(get_pos_equipment.cashier1)>
									<input type="text" name="pos_code_text1" id="pos_code_text1" value="<cfoutput>#get_emp_info(get_pos_equipment.cashier1,1,0)#</cfoutput>" readonly style="width:150px;">
								<cfelse>
									<input type="text" name="pos_code_text1" id="pos_code_text1" value="" readonly style="width:200px;">
								</cfif>                
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code1&field_name=add_pos.pos_code_text1&select_list=1','list');return false"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-pos_code1">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 2</label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="pos_code2" id="pos_code2" value="<cfoutput>#get_pos_equipment.cashier2#</cfoutput>">
								<cfif len(get_pos_equipment.cashier2)>
									<input type="text" name="pos_code_text2" id="pos_code_text2" value="<cfoutput>#get_emp_info(get_pos_equipment.cashier2,1,0)#</cfoutput>" readonly style="width:150px;" >
								<cfelse>
									<input type="text" name="pos_code_text2" id="pos_code_text2" value="" readonly style="width:200px;">
								</cfif>  
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code2&field_name=add_pos.pos_code_text2&select_list=1','list');return false"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-pos_code1">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 2</label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="pos_code3" id="pos_code3" value="<cfoutput>#get_pos_equipment.cashier3#</cfoutput>">
								<cfif len(get_pos_equipment.cashier3)>
									<input type="text" name="pos_code_text3" id="pos_code_text3" value="<cfoutput>#get_emp_info(get_pos_equipment.cashier3,1,0)#</cfoutput>" readonly style="width:200px;">
								<cfelse>
									<input type="text" name="pos_code_text3" id="pos_code_text3" value="" readonly style="width:200px;">
								</cfif>  
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code3&field_name=add_pos.pos_code_text3&select_list=1','list');return false"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info 
					query_name = "get_pos_equipment"
					record_emp = "record_emp"
					update_emp = "update_emp" 
					record_date = "record_date"
					update_date ="update_date">
				<cf_workcube_buttons type_format="1" is_upd='1' delete_page_url='#request.self#?fuseaction=retail.list_pos_equipment&event=del&pos_id=#attributes.pos_id#' >
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
