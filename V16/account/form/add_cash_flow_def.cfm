<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_cash_flow.cfm">
 <cfform name="cash_flow_def" action="#request.self#?fuseaction=account.emptypopup_add_cash_flow_sheet_def" method="post">
<cf_box title="#getLang('account',255)#">
   
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id ='47299.Hesap Kodu'> 1</th>
                <th><cf_get_lang dictionary_id ='47299.Hesap Kodu'> 2</th>
                <cfif session.ep.our_company_info.is_ifrs eq 1>
                    <th><cf_get_lang dictionary_id='58308.UFRS'></th>
                </cfif>
                <th><cf_get_lang dictionary_id ='55271.Hesap Adı'></th>
                <th><cf_get_lang dictionary_id ='58628.Gizle'>/<cf_get_lang dictionary_id ='58596.Göster'></th>
            </tr>
        </thead>
            <cfif get_cash_flow.recordcount>
                <tbody>
                    <cfoutput query="get_cash_flow">
                        <tr>
                            <td>#code#</td>
                            <td>
                                <div class="form-group">
									<div class="input-group">
                                        <input type="Hidden" name="get_cash_flow#currentrow#" id="get_cash_flow#currentrow#" value="#cash_flow_id#">
                                        <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>
                                            <cf_wrk_account_codes form_name='cash_flow_def' account_code="change_account#currentrow#" is_multi_no='#currentrow#'>
                                            <input type="Text" name="change_account#currentrow#" id="change_account#currentrow#" value="#account_code#" onkeyup="get_wrk_acc_code_#currentrow#();">
                                            <span class="input-group-addon icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=document.cash_flow_def.change_account#currentrow#&field_name=cash_flow_def.change_name#currentrow#','list');"></span>
                                        <cfelse>
                                            <input type="hidden" name="change_account#currentrow#" id="change_account#currentrow#" value="">
                                        </cfif>
                                    </div>
                                </div>
                            </td>
                            <cfif session.ep.our_company_info.is_ifrs eq 1>
                            <td>
                                <div class="form-group">
									<div class="input-group">
                                        <cfif len(account_code) or len(ifrs_code)>
                                            <input type="text" name="change_ifrs_code#currentrow#" id="change_ifrs_code#currentrow#" value="<cfif len(ifrs_code)>#ifrs_code#</cfif>">
                                            <span class="input-group-addon icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=document.cash_flow_def.change_ifrs_code#currentrow#','list');"></span>
                                        <cfelse>
                                            <input type="hidden" name="change_ifrs_code#currentrow#" id="change_ifrs_code#currentrow#" value="">
                                        </cfif>
                                    </div>
                                </div>
                            </td>
                            </cfif>
                            <td nowrap="nowrap">
                                <div class="form-group">
                                <div class="col col-4">
                                    <input type="hidden" name="change_name_lang_no_#currentrow#" id="change_name_lang_no_#currentrow#" value="<cfif len(NAME_LANG_NO)>#NAME_LANG_NO#</cfif>">
                                    <input type="text" name="change_name#currentrow#" id="change_name#currentrow#" value="<cfif len(NAME_LANG_NO)>#getLang('main',NAME_LANG_NO)#<cfelse>#name#</cfif>" readonly="yes">
                                    </div>
                                    <cfif find(".",code,1) eq 3 or len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>
                                        <div class="col col-2"><select name="sign#currentrow#" id="sign#currentrow#">
                                            <option value="-" <cfif sign eq "-">selected</cfif>>-</option>
                                            <option value="+" <cfif sign eq "+">selected</cfif>>+</option>
                                        </select></div>
                                    <cfelse>
                                        <input type="hidden" name="sign#currentrow#" id="sign#currentrow#" value="b">
                                    </cfif>
                                    
                                    <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>
                                        <div class="col col-3"><select name="bakiye#currentrow#" id="bakiye#currentrow#">
                                            <option value="1" <cfif ba eq "1">selected</cfif>><cf_get_lang dictionary_id ='50129.Alacaklı'></option>
                                            <option value="0" <cfif ba eq "0">selected</cfif>><cf_get_lang dictionary_id='58180.Borçlu'></option>
                                        </select></div>
                                    </cfif>
                                    <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>
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
                            <div class="form-group">
                                <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>
                                    <select name="selected#currentrow#" id="selected#currentrow#">
                                        <option value="#cash_flow_id#"><cf_get_lang dictionary_id ='58596.Göster'></option>
                                        <option value="0" <cfif listfind(selected_list,cash_flow_id) eq 0>selected</cfif>><cf_get_lang dictionary_id ='29813.Gösterme'></option>
                                    </select>
                                <cfelse>
                                    <input type="hidden" name="selected#currentrow#" id="selected#currentrow#" value="#cash_flow_id#">
                                </cfif>
                                </div>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>                               
            <cfelse>
                <tbody>
                    <tr>
                        <td colspan="5" height="20"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
                    </tr>
                </tbody>
            </cfif>
    </cf_grid_list>
    
</cf_box>
<cf_box>
    <cf_box_elements>
        <div class="form-group col col-6">
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <input type="hidden" name="count" id="count" value="<cfoutput>#get_cash_flow.recordcount#</cfoutput>">
                    <input type="checkbox" name="is_dept_claim_detail_" id="is_dept_claim_detail_" <cfif isdefined('dsp_dept_claim_') and dsp_dept_claim_ eq 1> checked </cfif> value="1">
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                <label><cf_get_lang dictionary_id='47383.Borç-Alacak Durumu'></label>
            </div>
            
        </div>	
    </cf_box_elements>
    <cf_box_footer>
        <cf_workcube_buttons type_format='1' is_upd='0'>
    </cf_box_footer>                        
</cf_box>
</cfform>