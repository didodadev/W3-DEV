<cfquery name="get_tax_exc" datasource="#dsn#">
    SELECT 
        TAX_EXCEPTION_ID, 
        TAX_EXCEPTION, 
        START_MONTH, 
        FINISH_MONTH, 
        AMOUNT, 
        DETAIL, 
        MONEY_ID, 
        CALC_DAYS, 
        YUZDE_SINIR, 
        IS_ALL_PAY, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP,
        UPDATE_EMP, 
        UPDATE_DATE,
        UPDATE_IP, 
        IS_ISVEREN,
        IS_SSK,
        EXCEPTION_TYPE ,
		STATUS
    FROM
        TAX_EXCEPTION 
    WHERE 
        TAX_EXCEPTION_ID = #attributes.TAX_EXCEPTION_ID#
</cfquery>
<cf_catalystHeader>
<cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_tax_exception" name="upd_tax_exc" method="post">
	<input type="hidden" name="ID" id="ID" value="<cfoutput>#attributes.TAX_EXCEPTION_ID#</cfoutput>">
    <input type="hidden" name="TAX_EXCEPTION_ID" id="TAX_EXCEPTION_ID" value="<cfoutput>#attributes.TAX_EXCEPTION_ID#</cfoutput>">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        <div class="form-group" id="checkboxes">
                            <label class="hide"><cf_get_lang dictionary_id='57493.Aktif'> / <cf_get_lang dictionary_id='53309.Günlere Göre'></label>
                            <label><cf_get_lang dictionary_id='57493.Aktif'> <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_tax_exc.status eq 1> checked</cfif>></label>
                            <label><cf_get_lang dictionary_id='53309.Günlere Göre'><input type="checkbox" name="calc_days" id="calc_days" value="1" <cfif get_tax_exc.calc_days eq 1> checked</cfif>></label>
                        </div>
                        <div class="form-group" id="item-tax_exc_head">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57480.Başlık'></cfsavecontent>
                                <cfinput type="text" value="#get_tax_exc.tax_exception#" name="tax_exc_head" style="width:200px;" required="yes" message="#message#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-Aralik">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57603.Aralık'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <select name="START_MONTH" id="START_MONTH" style="width:98px;">
                                        <cfoutput>
                                            <cfloop from="1" to="12" index="I">
                                                <option value="#I#" <cfif get_tax_exc.start_month eq I>SELECTED</cfif>>#listgetat(ay_list(),I,',')#</option>
                                            </cfloop>
                                        </cfoutput>
                                    </select>
                                    <span class="input-group-addon no-bg"></span>
                                    <select name="FINISH_MONTH" id="FINISH_MONTH" style="width:99px;">
                                        <cfoutput>
                                            <cfloop from="1" to="12" index="I">
                                                <option value="#I#" <cfif get_tax_exc.finish_month eq I>SELECTED</cfif>>#listgetat(ay_list(),I,',')#</option>
                                            </cfloop>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfquery name="get_money" datasource="#dsn#">
                                        SELECT 
                                            MONEY_ID, 
                                            MONEY, 
                                            PERIOD_ID, 
                                            RECORD_DATE, 
                                            RECORD_EMP, 
                                            RECORD_IP, 
                                            UPDATE_DATE, 
                                            UPDATE_EMP,
                                            UPDATE_IP 
                                        FROM 
                                            SETUP_MONEY
                                        WHERE 
                                            PERIOD_ID = #SESSION.EP.PERIOD_ID#
                                    </cfquery>
                                    <cfinput name="amount" style="width:150px;" type="text" value="#TLFormat(get_tax_exc.amount)#" onkeyup="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon no-bg"></span> 
                                    <select name="MONEY_ID" id="MONEY_ID" style="width:47px;">
                                        <cfoutput query="get_money">
                                            <option value="#MONEY_ID#" <cfif MONEY_ID eq get_tax_exc.money_id>selected</cfif>>#MONEY#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-yuzde_sinir">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58456.Oran'> (%) *</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message">1-100 <cf_get_lang dictionary_id="30023.Arası"> <cf_get_lang dictionary_id ='54044.Vergi İstisna Oranı Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" required="yes" name="yuzde_sinir" onKeyUp="isNumber(this);" range="1,100" validate="integer" style="width:200px" value="#get_tax_exc.yuzde_sinir#" message="1-100 Arası Vergi İstisna Oranı Girmelisiniz !">
                            </div>
                        </div>
                        <div class="form-group" id="item-exception_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53941.İstisna Tipi"></label>
                            <div class="col col-8 col-xs-12">
                                <select name="exception_type" id="exception_type" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <option value="1" <cfif get_tax_exc.exception_type eq 1>selected</cfif>><cf_get_lang dictionary_id="53960.Bireysel Emeklilik Sigortası"> (<cf_get_lang dictionary_id="53550.İşveren">)</option>
                                    <option value="2" <cfif get_tax_exc.exception_type eq 2>selected</cfif>><cf_get_lang dictionary_id="53960.Bireysel Emeklilik Sigortası"> (<cf_get_lang dictionary_id="53964.Şahıs">)</option>
                                    <option value="3" <cfif get_tax_exc.exception_type eq 3>selected</cfif>><cf_get_lang dictionary_id="53965.Özel Sağlık Sigortası"> (<cf_get_lang dictionary_id="53550.İşveren">)</option>
                                    <option value="4" <cfif get_tax_exc.exception_type eq 4>selected</cfif>><cf_get_lang dictionary_id="53965.Özel Sağlık Sigortası"> (<cf_get_lang dictionary_id="53964.Şahıs">)</option>
                                    <option value="5" <cfif get_tax_exc.exception_type eq 5>selected</cfif>><cf_get_lang dictionary_id="59577.Hayat Sigortası"> (<cf_get_lang dictionary_id="53550.İşveren">)</option>
                                    <option value="6" <cfif get_tax_exc.exception_type eq 6>selected</cfif>><cf_get_lang dictionary_id="59577.Hayat Sigortası"> (<cf_get_lang dictionary_id="53964.Şahıs">)</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-DETAIL">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12"><textarea style="width:200px;height:60px;" name="DETAIL" id="DETAIL"><cfoutput>#get_tax_exc.detail#</cfoutput></textarea></div>
                        </div>
                        <div class="form-group" id="item-">
                            <label class="hide"><cf_get_lang dictionary_id ='54043.Her Koşulda Tamamını Öde'>/<cf_get_lang dictionary_id ='54042.İstisna İşverene Yansısın'>/<cf_get_lang dictionary_id="64658.Prime Esas Kazanca Dahil Et"></label>
                            <label class="col col-4 col-xs-12">&nbsp;</label>
                            <div class="col col-8 col-xs-12">
                                <label class="col col-12"><input type="checkbox" name="is_all_pay" id="is_all_pay" value="1"<cfif get_tax_exc.is_all_pay eq 1> checked</cfif>><cf_get_lang dictionary_id ='54043.Her Koşulda Tamamını Öde'> </label>
                                <label class="col col-12"><input type="checkbox" name="is_isveren" id="is_isveren" value="1"<cfif get_tax_exc.is_isveren eq 1> checked</cfif>><cf_get_lang dictionary_id ='54042.İstisna İşverene Yansısın'> </label>
                                <label class="col col-12"><input type="checkbox" name="is_ssk" id="is_ssk" value="1" <cfif get_tax_exc.is_ssk eq 1> checked</cfif>> <cf_get_lang dictionary_id="64658.Prime Esas Kazanca Dahil Et"></label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-6 col-xs-12"><cf_record_info query_name="get_tax_exc"></div>
                    <div class="col col-6 col-xs-12"><cf_workcube_buttons is_upd='1'  delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_tax_exception&tax_exception_id=#get_tax_exc.tax_exception_id#' add_function='form_chk()'></div>
                </div>
            </div>
        </div>
    </div>
</cfform>
<script type="text/javascript">
	function form_chk()
	{
		upd_tax_exc.amount.value = filterNum(upd_tax_exc.amount.value);
		return true;
	}
</script>
