<div class="ui-row">
    <div id="sepetim_total" class="padding-0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <div class="totalBox">
                <div class="totalBoxHead font-grey-mint">
                    <span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
                    <div class="collapse">
                        <span class="icon-minus"></span>
                    </div>
                </div>				
                <div class="totalBoxBody">
                    <input type="hidden" name="kur_say" value="<cfoutput>#get_money_rate.recordcount#</cfoutput>">  
                    <table cellspacing="0" id="money_rate_table">
                        <tbody>
                            <cfoutput query="get_money_rate">
                                <cfif xml_money_type eq 0>
                                    <cfset currency_rate_ = RATE2>
                                <cfelseif xml_money_type eq 1>
                                    <cfset currency_rate_ = RATE3>
                                <cfelseif xml_money_type eq 2>
                                    <cfset currency_rate_ = RATE2>
                                <cfelseif xml_money_type eq 3>
                                    <cfset currency_rate_ = EFFECTIVE_PUR>
                                <cfelseif xml_money_type eq 4>
                                    <cfset currency_rate_ = EFFECTIVE_SALE>
                                </cfif>
                                        <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                <tr>                     
                                    <td> #money# </td>
                                    <cfif session.ep.rate_valid eq 1>
                                        <cfset readonly_info = "yes">
                                    <cfelse>
                                        <cfset readonly_info = "no">
                                    </cfif>
                                    <td nowrap="nowrap">#TLFormat(rate1,0)# /</td>
                                    <td>
                                        <input type="hidden" class="box" name="txt_rate2_1_#money#" id="txt_rate2_1_#money#" value="#TLFormat(currency_rate_,session.ep.our_company_info.rate_round_num)#"><input type="text" class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(currency_rate_,session.ep.our_company_info.rate_round_num)#" style="width:75px;" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(filterNum(this.value,#session.ep.our_company_info.rate_round_num#) <=0) this.value=commaSplit(1);toplam_hesapla();">
                                    </td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
            <cf_box_elements vertical="1">
                <div class="form-group" id="item-date2">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang_main no='494.İşlem Tarihi Giriniz'></cfsavecontent>
                            <cfinput type="text" name="action_date" validate="#validate_style#" required="yes" message="#message#" onBlur="change_money_info('add_rate_valuation_2','action_date','#xml_money_type#')&toplam_hesapla();" value="#dateformat(now(),dateformat_style)#" maxlength="10" style="width:70px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date" call_function="change_money_info_set&toplam_hesapla" function_currency_type="#xml_money_type#"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-action_account_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1399.Muhasebe Kodu'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput message="#message#" type="Text"  name="action_account_code" id="action_account_code" style="width:150px;" onFocus="AutoComplete_Create('action_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_rate_valuation_2.action_account_code','list');" title="<cf_get_lang_main no='1399.Muhasebe Kodu'>"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-expense_center_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='823.Masraf/Gelir Merkezi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input name="expense_center_id" id="expense_center_id" type="hidden" value="">
                            <cfinput name="expense_center" type="text" value="" style="width:150px;" id="expense_center" onFocus="AutoComplete_Create('expense_center','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_ID','expense_center_id','',3);">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_name=add_rate_valuation_2.expense_center&field_id=add_rate_valuation_2.expense_center_id</cfoutput>','list');" title="<cf_get_lang_main no='823.Masraf/Gelir Merkezi'>"></span>
                        </div>
                    </div>
                </div>
                </cf_box_elements>
        </div>
        <div class="col col-4 col-xs-12" type="column" index="2" sort="true">
            <cf_box_elements vertical="1">
                <div class="form-group" id="item-expense_item_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1492.Gider/Gelir Kalemi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="expense_item_id" id="expense_item_id" value="">
                            <cfinput type="text" name="expense_item_name" value="" style="width:150px;" id="expense_item_name" onFocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID','expense_item_id','',3);">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_rate_valuation_2.expense_item_id&field_name=add_rate_valuation_2.expense_item_name&is_budget_items=1','list');" title="<cf_get_lang_main no='1492.Gider/Gelir Kalemi'>"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-pro_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="pro_id" id="pro_id" value="">
                            <input name="project_name" type="text" id="project_name" style="width:150px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','pro_id','','3','215');" value="" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_rate_valuation_2.project_name&project_id=add_rate_valuation_2.pro_id</cfoutput>');" title="<cf_get_lang_main no='4.Proje'>"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-is_minus">
                    <label><cf_get_lang no="219.Eksileri Getir"><input type="checkbox" name="is_minus" id="is_minus_currency" value="1" onclick="check_currency(1)"/></label>
                    <label><cf_get_lang no="220.Artıları Getir"><input type="checkbox" name="is_minus" id="is_plus_currency" value="1" onclick="check_currency(2)"/></label>
                </div>     
            </cf_box_elements>   
        </div>
    </div>
</div>
<cf_box_footer>
    <div class="form-group" id="item-button">
        <div class="col col-12 col-xs-12 text-right">
            <cf_workcube_buttons is_upd='0' insert_info='#getLang('','',50045)#' is_cancel='0' add_function='open_dekont()'>
        </div>
    </div>
</cf_box_footer>
<script type="text/javascript">
	function change_money_info_set()
	{
		change_money_info('add_rate_valuation_2','action_date','<cfoutput>#xml_money_type#</cfoutput>');
	}
</script>
