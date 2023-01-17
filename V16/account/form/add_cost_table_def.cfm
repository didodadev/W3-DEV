<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_cost_table.cfm">
<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box closable="0">
			<cfform name="cost_table_def" action="#request.self#?fuseaction=account.add_cost_table_def" method="post">
				<cf_grid_list>
					<thead>
						<tr>
							<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
							<th><cf_get_lang dictionary_id ='47299.Hesap Kodu'></th>
							<cfif session.ep.our_company_info.is_ifrs eq 1>
								<th><cf_get_lang dictionary_id='58308.UFRS'></th>
							</cfif>
							<th><cf_get_lang dictionary_id ='47300.Hesap Adı'></th>
							<th width="20"></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="get_cost_table" >
							<tr class="color-row" height="20">
								<td>#code#</td>
								<td>
									<input type="Hidden" name="cost_id#currentrow#" id="cost_id#currentrow#" value="#cost_id#">
									<div class="input-group">
										<cf_wrk_account_codes form_name='cost_table_def' account_code="change_account#currentrow#" is_multi_no='#currentrow#'>
										<input type="text" name="change_account#currentrow#" id="change_account#currentrow#" value="<cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>#account_code#</cfif>" style="width:70px;" onkeyup="get_wrk_acc_code_#currentrow#();">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=document.cost_table_def.change_account#currentrow#&field_name=cost_table_def.change_name#currentrow#','list');"></span>
									</div>
								</td>
								<cfif session.ep.our_company_info.is_ifrs eq 1>
								<td>
									<div class="input-group">
										<input type="text" name="change_ifrs_code#currentrow#" id="change_ifrs_code#currentrow#" value="<cfif len(ifrs_code)>#ifrs_code#</cfif>" style="width:60px;">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=document.cost_table_def.change_ifrs_code#currentrow#','list');"></span>
									</div>
								</td>
								</cfif>
								<td>
									<input type="hidden" name="change_name_lang_no_#currentrow#" id="change_name_lang_no_#currentrow#" onBlur="get_change_name(this.value,'#currentrow#')" value="<cfif len(NAME_LANG_NO)>#NAME_LANG_NO#</cfif>" style="width:50px;" >
									<input type="text" name="change_name#currentrow#" id="change_name#currentrow#" value="<cfif len(NAME_LANG_NO) and NAME_LANG_NO neq 0>#getLang('main',NAME_LANG_NO)#<cfelse>#name#</cfif>" style="width:250px;" readonly="yes">
									<select name="sign#currentrow#" id="sign#currentrow#">
										<option value="">
										<option value="-" <cfif sign eq "-">selected</cfif>>-</option>
										<option value="+" <cfif sign eq "+">selected</cfif>>+</option>
									</select>
									<select name="bakiye#currentrow#" id="bakiye#currentrow#">
										<option value="1" <cfif ba eq "1">selected</cfif>><cf_get_lang dictionary_id ='47372.Alacaklı'></option>
										<option value="0" <cfif ba eq "0">selected</cfif>><cf_get_lang dictionary_id='58180.Borçlu'></option>
									</select>
									<select name="view_amount_type#currentrow#" id="view_amount_type#currentrow#">
										<option value="0" <cfif view_amount_type eq "0">selected</cfif>><cf_get_lang dictionary_id ='47380.Borç Göster'></option>
										<option value="1" <cfif view_amount_type eq "1">selected</cfif>><cf_get_lang dictionary_id ='47381.Alacak Göster'></option>
										<option value="2" <cfif view_amount_type eq "2">selected</cfif>><cf_get_lang dictionary_id ='47320.Bakiye Göster'></option>
									</select>
								</td>
								<td>
									<select name="selected#currentrow#" id="selected#currentrow#">
										<option value="#cost_id#"><cf_get_lang dictionary_id='58596.Göster'></option>
										<option value="0" <cfif listfind(selected_list,cost_id) eq 0>selected</cfif>><cf_get_lang dictionary_id ='29813.Gösterme'></option>
									</select>
								</td>
							</tr>
						</cfoutput>
						</tbody>
						<input type="hidden" name="count" id="count" value="<cfoutput>#get_cost_table.recordcount#</cfoutput>">
						<tfoot>
				</cf_grid_list>
				<cf_box_footer>
					<cf_get_lang dictionary_id='47288.Ters Bakiyeleri Göster'><input type="Checkbox" name="IsInverseOk" id="IsInverseOk"  <cfif inv_rem is 1> checked<cfelse> value="1"</cfif>>
					<cf_workcube_buttons type_format='1' is_upd='0'>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>

<script type="text/javascript">
function get_change_name(lang_no,row_no)
{
	$.ajax({ url :'WMO/utility.cfc?method=getName', data : {langNo : lang_no , module : 'main'}, async:false,success : function(res){ if ( res ) { if(res != 0) $("#change_name"+row_no).val(res); else $("#change_name_lang_no_"+row_no).val(''); } } });
}
</script>
