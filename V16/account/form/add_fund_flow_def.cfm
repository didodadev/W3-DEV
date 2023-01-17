<cfinclude template="../query/get_fund_table_setup.cfm">
<cfinclude template="../query/get_fund_flow.cfm">
<cfform name="fund_flow_def" action="#request.self#?fuseaction=account.add_fund_flow_sheet_def" method="post">
	<cf_box title="#getLang('account',63)#">		
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id ='47299.Hesap Kodu'> 1</th>
					<th><cf_get_lang dictionary_id ='47299.Hesap Kodu'> 2</th>
					<th><cf_get_lang dictionary_id ='55271.Hesap Adı'></th>
					<th><cf_get_lang dictionary_id ='58628.Gizle'>/<cf_get_lang dictionary_id ='58596.Göster'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_fund_flow.recordcount>
					<cfoutput query="get_fund_flow">
						<tr>
							<td>#code#</td>
							<td>
								<input type="Hidden" name="fund_flow_id#currentrow#" id="fund_flow_id#currentrow#" value="#fund_flow_id#">
								<cfif len(account_code) and account_code neq "bos" >
									<div class="form-group">
										<div class="input-group">
											<cf_wrk_account_codes form_name='fund_flow_def' account_code="change_account#currentrow#" is_multi_no='#currentrow#'>
											<input type="text" name="change_account#currentrow#" id="change_account#currentrow#" value="#account_code#" onkeyup="get_wrk_acc_code_#currentrow#();">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=document.fund_flow_def.change_account#currentrow#&field_name=fund_flow_def.change_name#currentrow#','list');"></span>
										</div>
									</div>
								<cfelse>
									<input type="hidden" name="change_account#currentrow#"  id="change_account#currentrow#" value="bos">
								</cfif>
							</td>
							<td>
								<div class="form-group">
									<cfif len(NAME_LANG_NO)>
										<div class="col col-3">
											<input type="text" name="change_name_lang_no_#currentrow#" id="change_name_lang_no_#currentrow#" onblur="get_change_name(this.value,'#currentrow#')" value="#NAME_LANG_NO#">
										</div>
									</cfif>
									<div class="col col-4">
										<input type="text" name="change_name#currentrow#" id="change_name#currentrow#" value="#name#">
									</div>
									<cfif (find(".",code,1) eq 3 or len(account_code)) and account_code neq "bos">
										<div class="col col-2">
											<select name="sign#currentrow#" id="sign#currentrow#">
												<option value="">
												<option value="-" <cfif sign eq "-">selected</cfif>>-</option>
												<option value="+" <cfif sign eq "+">selected</cfif>>+</option>
											</select>
										</div>
									<cfelse>
										<div class="col col-2">
											<select name="sign#currentrow#" id="sign#currentrow#">
												<option value="b" selected="selected">b</option>
											</select>
										</div>
									</cfif>
									<cfif len(account_code)>
										<div class="col col-3">
											<select name="bakiye#currentrow#" id="bakiye#currentrow#">
												<option value="1" <cfif ba eq "1">selected</cfif>><cf_get_lang dictionary_id ='50129.Alacaklı'></option>
												<option value="0" <cfif ba eq "0">selected</cfif>><cf_get_lang dictionary_id='58180.Borçlu'></option>
											</select>
										</div>
									</cfif>
									<cfif len(account_code)>
										<div class="col col-3">
											<select name="view_amount_type#currentrow#" id="view_amount_type#currentrow#">
												<option value="0" <cfif view_amount_type eq "0">selected</cfif>><cf_get_lang dictionary_id ='47380.Borç Göster'></option>
												<option value="1" <cfif view_amount_type eq "1">selected</cfif>><cf_get_lang dictionary_id ='47381.Alacak Göster'></option>
												<option value="2" <cfif view_amount_type eq "2">selected</cfif>><cf_get_lang dictionary_id='47320.Bakiye Göster'></option>
											</select>
										</div>
									</cfif>
								</div>
							</td>
							<td>
								<cfif len(account_code) and  account_code neq "bos">
									<div class="form-group">
										<select name="selected#currentrow#" id="selected#currentrow#">
											<option value="#fund_flow_id#"><cf_get_lang dictionary_id='58596.Göster'></option>
											<option value="0" <cfif listfind(selected_list,fund_flow_id) eq 0>selected</cfif>><cf_get_lang dictionary_id ='29813.Gösterme'></option>
										</select>
									</div>
								<cfelse>
									<input type="hidden" name="selected#currentrow#" id="selected#currentrow#" value="#fund_flow_id#">
								</cfif>
							</td>
						</tr>
					</cfoutput>					
				<cfelse>
					<tr>
						<td colspan="4" height="20"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
	<cf_box>
		<input type="hidden" name="count" id="count" value="<cfoutput>#get_fund_flow.recordcount#</cfoutput>">					
		<cf_box_elements vertical="1">		
		<div class="form-group">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
				<label><cf_get_lang dictionary_id='47383.Borç-Alacak Durumu'></label>
			</div>
			<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
				<input type="Checkbox" name="listele" id="listele"  <cfif get_setup.recordcount and get_setup.displays contains 1> checked </cfif> value="1">
			</div>
		</div>
		<div class="form-group">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
				<label><cf_get_lang dictionary_id='47389.Sadece İstenen Toplam'></label>
			</div>
			<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
				<input type="Checkbox" name="listele" id="listele" <cfif get_setup.recordcount and get_setup.displays contains 2> checked</cfif> value="2">
			</div>
		</div>
		<div class="form-group">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
				<label><cf_get_lang dictionary_id='47288.Ters Bakiyeleri Göster'></label>
			</div>
			<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
				<input type="Checkbox" name="IsInverseOk" id="IsInverseOk"  <cfif  isdefined('inv_rem') and inv_rem is 1>  checked<cfelse>value="1" </cfif>>
			</div>
		</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0'>
		</cf_box_footer>
	</cf_box>
</cfform>
<script type="text/javascript">
	function get_change_name(lang_no,row_no)
	{
		$.ajax({ url :'WMO/utility.cfc?method=getName', data : {langNo : lang_no , module : 'main'}, async:false,success : function(res){ if ( res ) { if(res != 0) $("#change_name"+row_no).val(res); else $("#change_name_lang_no_"+row_no).val(''); } } });
	}
</script>
