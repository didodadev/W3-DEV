<cfinclude template="../query/get_income_table_definition.cfm">
<cfform name="income_table_def" action="#request.self#?fuseaction=account.add_income_table_def" method="post">
<cf_big_list_search title="#getLang('account',253)#"> </cf_big_list_search>
	<cf_big_list>
		<thead>
			<tr>
            	<th><cf_get_lang_main no="1165.Sıra"></th>
				<th>&nbsp;</th>
				<th><cf_get_lang no ='37.Hesap Kodu'></th>
				<cfif session.ep.our_company_info.is_ifrs eq 1>
					<th><cf_get_lang_main no='896.UFRS'></th>
				</cfif>
				<th><cf_get_lang no ='38.Hesap Adı'></th>
				<th>&nbsp;</th>
			</tr>
		</thead>
		<cfif get_income_table.recordcount>
            <tbody>
                <cfoutput query="get_income_table">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#code#</td>
                        <td>
                            <input type="Hidden" name="income_id#currentrow#" id="income_id#currentrow#" value="#income_id#">
                            <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and isdefined('ifrs_code') and len(ifrs_code))>
                                <div class="input-group">
                                    <cf_wrk_account_codes form_name='income_table_def' account_code="change_account#currentrow#" is_multi_no='#currentrow#'>
                                    <input type="text" name="change_account#currentrow#" id="change_account#currentrow#" value="#account_code#" style="width:60px;" onkeyup="get_wrk_acc_code_#currentrow#();">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=document.income_table_def.change_account#currentrow#&field_name=income_table_def.change_name#currentrow#','list');"></span>
                                </div>
                            <cfelse>
                                <input type="hidden" name="change_account#currentrow#" id="change_account#currentrow#" value="">
                            </cfif>
                        </td>
                        <cfif session.ep.our_company_info.is_ifrs eq 1>
                            <td>
                                <cfif len(account_code) or (isdefined('ifrs_code') and len(ifrs_code))>
                                    <div class="input-group">
                                        <input type="text" name="change_ifrs_code#currentrow#" id="change_ifrs_code#currentrow#" value="<cfif isdefined('ifrs_code') and len(ifrs_code)>#ifrs_code#</cfif>" style="width:60px;">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=document.income_table_def.change_ifrs_code#currentrow#','list');"></span>
                                	</div>
                                <cfelse>
                                    <input type="hidden" name="change_ifrs_code#currentrow#" id="change_ifrs_code#currentrow#" value="">
                                </cfif>
                            </td>
                        </cfif>
                        <td>
                            <input type="hidden" name="change_name_lang_no_#currentrow#" id="change_name_lang_no_#currentrow#" onBlur="get_change_name(this.value,'#currentrow#')" value="<cfif len(NAME_LANG_NO)>#NAME_LANG_NO#</cfif>" style="width:50px;" >
                            <input type="text" name="change_name#currentrow#" id="change_name#currentrow#" value="<cfif len(NAME_LANG_NO)>#getLang('main',NAME_LANG_NO)#<cfelse>#name#</cfif>" style="width:250px;" readonly="yes">
                            <cfif find(".",code,1) eq 3 or len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and isdefined('ifrs_code') and len(ifrs_code))>
                                <select name="sign#currentrow#" id="sign#currentrow#">
                                    <option value="">
                                    <option value="-" <cfif sign eq "-">selected</cfif>>-</option>
                                    <option value="+" <cfif sign eq "+">selected</cfif>>+</option>
                                </select>
                            </cfif>
                            <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and (isdefined('ifrs_code') and len(ifrs_code)))>
                                <select name="bakiye#currentrow#" id="bakiye#currentrow#">
                                    <option value="1" <cfif ba eq "1">selected</cfif>><cf_get_lang no ='110.Alacaklı'></option>
                                    <option value="0" <cfif ba eq "0">selected</cfif>><cf_get_lang_main no='768.Borçlu'></option>
                                </select>
                            </cfif>
                            <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and isdefined('ifrs_code') and len(ifrs_code))>
                                <select name="view_amount_type#currentrow#" id="view_amount_type#currentrow#">
                                    <option value="0" <cfif view_amount_type eq "0">selected</cfif>><cf_get_lang no ='118.Borç Göster'></option>
                                    <option value="1" <cfif view_amount_type eq "1">selected</cfif>><cf_get_lang no ='119.Alacak Göster'></option>
                                    <option value="2" <cfif view_amount_type eq "2">selected</cfif>><cf_get_lang no='58.Bakiye Göster'></option>
                                </select>
                            </cfif>
                        </td>
                        <td>
                            <cfif len(account_code) or (session.ep.our_company_info.is_ifrs eq 1 and isdefined('ifrs_code') and len(ifrs_code))>
                                <select name="selected#currentrow#" id="selected#currentrow#">
                                    <option value="#income_id#"><cf_get_lang_main no='1184.Göster'></option>
                                    <option value="0" <cfif listfind(selected_list,income_id) eq 0>selected</cfif>><cf_get_lang_main no ='2016.Gösterme'></option>
                                </select>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            </tbody>
            <input type="hidden" name="count" id="count" value="<cfoutput>#get_income_table.recordcount#</cfoutput>">
            <tfoot>
                <tr>
                    <td colspan="6" style="text-align:right;"><cf_get_lang no='26.Ters Bakiyeleri Göster'>
                        <input type="checkbox" name="is_inverse_acc" id="is_inverse_acc" <cfif get_income_def.recordcount and get_income_def.INVERSE_REMAINDER eq 1>checked</cfif>>
                        <cf_workcube_buttons type_format='1' is_upd='0'>
                    </td>
                </tr>
            </tfoot>
        </cfif>
	</cf_big_list> 
</cfform>
<script type="text/javascript">
	function get_change_name(lang_no,row_no)
	{       
        $.ajax({ url :'WMO/utility.cfc?method=getName', data : {langNo : lang_no , module : 'main'}, async:false,success : function(res){ if ( res ) { if(res != 0) $("#change_name"+row_no).val(res); else $("#change_name_lang_no_"+row_no).val(''); } } });
	}
</script>
