<cfscript>
    extension_time = createObject("component","V16.member.cfc.securefund_extension_time");
    get_securefund_extension = extension_time.GET_SECUREFUND_EXTENSION(extension_securefund_id : attributes.extension_securefund_id);
    GET_MONEY = extension_time.GET_MONEY();
</cfscript>
<cf_box title="#getLang('','Süre Uzatımı',62379)# #getLang('','Güncelle',57464)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="upd_secure_extension" method="post" action="" enctype="multipart/form-data">
        <input type="hidden" name="extension_securefund_id" id="extension_securefund_id" value="<cfoutput>#url.extension_securefund_id#</cfoutput>">
        <input type="hidden" name="securefund_id" id="securefund_id" value="<cfoutput>#url.securefund_id#</cfoutput>">
        <input type="hidden" name="give_take" id="give_take" value="<cfoutput>#url.give_take#</cfoutput>">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process_cat process_cat=#get_securefund_extension.ACTION_CAT_ID#>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                            <cfinput type="text" name="extension_time_finish_date" maxlength="10" validate="#validate_style#" message="#message#" value="#dateFormat(get_securefund_extension.extension_time_finish_date,dateFormat_style)#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="extension_time_finish_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-REALESTATE_DETAIL">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><textarea name="detail" id="detail">#get_securefund_extension.detail#</textarea></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-expense_total">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58930.Masraf'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="expense_total" id="expense_total" class="moneybox" value="#Tlformat(get_securefund_extension.expense_total)#" onkeyup="return(FormatCurrency(this,event));">
                            <span class="input-group-addon width">
                                <select name="money_cat_expense" id="money_cat_expense">
                                    <cfoutput query="GET_MONEY">
                                        <option value="#money#" <cfif get_securefund_extension.money_cat_expense eq money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-commission_rate">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58791.Komisyon'>%</label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="commission_rate" value="#TLformat(get_securefund_extension.commission_rate)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));">
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="false">
                <div class="form-group">
                    <label class="col col-12 bold"><cf_get_lang dictionary_id ='30636.İşlem Para Birimi'></label>
                </div>
                    <cfif session.ep.rate_valid eq 1>
                        <cfset readonly_info = "yes">
                    <cfelse>
                        <cfset readonly_info = "no">
                    </cfif>
                    <cfoutput>                        
                        <input type="hidden" name="kur_say" id="kur-say" value="#get_money.recordcount#">
                            <cfif isdefined("get_securefund_extension") and get_securefund_extension.recordcount and len(get_securefund_extension.money_cat)>
                                <cfset selected_money=get_securefund_extension.money_cat>
                            <cfelseif len(session.ep.other_money)>
                                <cfset selected_money=session.ep.other_money>
                            <cfelse>
                                <cfset selected_money=session.ep.money>
                            </cfif>
                            <cfloop query="get_money">
                                <div class="form-group">
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-6">
                                        <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                        <input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>
                                        <label>#money#</label>
                                    </div>                                        
                                    <div class="col col-2 col-md-4 col-sm-4 col-xs-12"><label>#TLFormat(rate1,0)# /</label></div>
                                    <div class="col col-6 col-xs-12">
                                        <input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="doviz_hesapla();">
                                    </div>
                                </div>
                            </cfloop>
                    </cfoutput>  
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
                <cf_record_info query_name="get_securefund_extension">
            </div>
            <div class="col col-6">
                <cf_workcube_buttons is_upd='1' add_function="unformat_fields()" delete_page_url = "V16/member/cfc/securefund_extension_time.cfc?method=DEL_SECUREFUND_EXTENSION&extension_securefund_id=#url.extension_securefund_id#">
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
    function unformat_fields()
	{
		upd_secure_extension.commission_rate.value = filterNum(upd_secure_extension.commission_rate.value);
		upd_secure_extension.expense_total.value = filterNum(upd_secure_extension.expense_total.value);
        return true;
    }
</script>