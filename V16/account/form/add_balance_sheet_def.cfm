<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_balance_sheet.cfm">
<cfform name="balance_sheet_def" action="#request.self#?fuseaction=account.add_balance_sheet_def" method="post">
    <cf_box title="#getLang('','',47516)#">
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
                <tbody>
                    <cfoutput query="get_balance_sheet">
                        <tr>
                            <td>#code#</td>
                            <td>
                                <input type="Hidden" name="balance_id#currentrow#" id="balance_id#currentrow#" value="#balance_id#">
                                <cfif len(account_code) or len(ifrs_code)>
                                    <div class="form-group">
										<div class="input-group">
                                            <cf_wrk_account_codes form_name='balance_sheet_def' account_code="change_account#currentrow#" is_multi_no='#currentrow#'>
                                            <input type="text" name="change_account#currentrow#" id="change_account#currentrow#" value="#account_code#"  onkeyup="get_wrk_acc_code_#currentrow#();">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=document.balance_sheet_def.change_account#currentrow#','list');"></span>
                                        </div>
                                    </div>
                                <cfelse>
                                    <input type="hidden" name="change_account#currentrow#" id="change_account#currentrow#" value="">
                                </cfif>
                            </td>
                            <cfif session.ep.our_company_info.is_ifrs eq 1>
                                <td>
                                    <cfif len(account_code) or len(ifrs_code)>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type="text" name="change_ifrs_code#currentrow#" id="change_ifrs_code#currentrow#" value="<cfif len(ifrs_code)>#ifrs_code#</cfif>">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=document.balance_sheet_def.change_ifrs_code#currentrow#','list');"></span>
                                            </div>
                                        </div>
                                    <cfelse>
                                        <input type="hidden" name="change_ifrs_code#currentrow#" id="change_ifrs_code#currentrow#" value="">
                                    </cfif>
                                </td>
                            </cfif>
                            <td>
                                <div class="form-group">
                                    <input type="hidden" name="change_name_lang_no_#currentrow#" id="change_name_lang_no_#currentrow#" value="<cfif len(name_lang_no)>#name_lang_no#</cfif>">
                                    <div class="col col-4">
                                        <input type="text" name="change_name#currentrow#" id="change_name#currentrow#" value="<cfif len(name_lang_no)>#getLang('main',name_lang_no)#<cfelse>#name#</cfif>" readonly="yes">
                                    </div>
                                    <cfif find(".",code,3) eq 5 or len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>
                                        <div class="col col-2">
                                            <select name="sign#currentrow#" id="sign#currentrow#">
                                                <option value="">
                                                <option value="-" <cfif sign eq "-">selected</cfif>>-</option>
                                                <option value="+" <cfif sign eq "+">selected</cfif>>+</option>
                                            </select>
                                        </div>
                                    </cfif>
                                    <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>
                                        <div class="col col-2">
                                            <select name="bakiye#currentrow#" id="bakiye#currentrow#">
                                                <option value="1" <cfif ba eq "1">selected</cfif>><cf_get_lang dictionary_id ='50129.Alacaklı'></option>
                                                <option value="0" <cfif ba eq "0">selected</cfif>><cf_get_lang dictionary_id='58180.Borçlu'></option>
                                            </select>
                                        </div>
                                    </cfif>
                                    <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>
                                        <div class="col col-4">
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
                                <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and len(ifrs_code))>
                                <div class="form-group">
                                    <select name="selected#currentrow#" id="selected#currentrow#">
                                        <option value="#balance_id#"><cf_get_lang dictionary_id='58596.Göster'></option>
                                        <option value="0" <cfif listfind(selected_list,balance_id) eq 0>selected</cfif>><cf_get_lang dictionary_id='29813.Gösterme'></option>
                                    </select>
                                    </div>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
        </cf_grid_list>     
</cf_box>
<cf_box>
    <cfinclude template="../query/get_balance_setup.cfm">
    <input type="hidden" name="count" id="count" value="<cfoutput>#get_balance_sheet.recordcount#</cfoutput>">					
    <cf_box_elements vertical="1">		
        <div class="form-group">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label><cf_get_lang dictionary_id='47312.Kod Numaralarini Göster'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <input type="checkbox" name="dsp_acc_code" id="dsp_acc_code"  <cfif get_setup_balance.recordcount and get_setup_balance.account_code eq 1 >Checked</cfif>>
            </div>
        </div>
        <div class="form-group">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label><cf_get_lang dictionary_id='47347.Muhasebe Numaralarını Göster'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <input type="checkbox" name="dsp_acc_code_no" id="dsp_acc_code_no" <cfif get_setup_balance.recordcount and  get_setup_balance.account_code_no eq 1 >Checked</cfif>>
            </div>
        </div>
        <div class="form-group">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <label><cf_get_lang dictionary_id='47288.Ters Bakiyeleri Göster'></label>
            </div>
            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                <input type="checkbox" name="is_inverse_acc" id="is_inverse_acc" <cfif get_balance_def.recordcount and get_balance_def.inverse_remainder eq 1>checked</cfif>>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='47339.Yaptığınız Değişiklikler Bilanço Tablosunu Etkileyecek Emin misiniz'></cfsavecontent>
        <cf_workcube_buttons type_format='1' is_upd='0' insert_alert='#message#'>
    </cf_box_footer>
</cf_box>
</cfform>