<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.TABLE_NAME = "CASH_ACTIONS">
<cfinclude template="../query/get_cashes.cfm">
<cfinclude template="../query/get_action_detail.cfm">
<cf_catalystHeader>
<cfform name="open_cash" method="post" action="#request.self#?fuseaction=cash.form_add_cash_open&event=upd">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
    <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_cash_open'>
        <input type="hidden" name="is_popup" id="is_popup" value="1">
    <cfelse>
        <input type="hidden" name="is_popup" id="is_popup" value="0">
    </cfif>
    <div class="row"> 
        <div class="col col-12 uniqueRow"> 		
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='388.işlem tipi'> *</label>
                            <div class="col col-9 col-xs-12"> 
                                <cf_workcube_process_cat slct_width="150" process_cat=#get_action_detail.process_cat#>
                            </div>
                        </div>
                        <div class="form-group" id="item-CASH_ACTION_TO_CASH_ID">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='108.Kasa'> *</label>
                            <div class="col col-9 col-xs-12"> 
                                <select disabled name="CASH_ACTION_TO_CASH_ID" id="CASH_ACTION_TO_CASH_ID" style="width:150px;" onChange="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');">
									<cfoutput query="get_cashes">
                                        <option value="#get_cashes.CASH_ID#;#get_cashes.CASH_CURRENCY_ID#" <cfif get_cashes.CASH_ID eq get_action_detail.CASH_ACTION_TO_CASH_ID>selected</cfif>>#cash_name#</option>
                                    </cfoutput>
                                </select>               
                            </div>
                        </div>
                        <div class="form-group" id="item-ACTION_DATE">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='330.Tarih'>*</label>
                            <div class="col col-9 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message1"><cf_get_lang_main no='330.Tarih'>!</cfsavecontent>
									<cfinput value="#dateformat(get_action_detail.action_date,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message1#" type="text" name="ACTION_DATE" style="width:150px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-CASH_ACTION_VALUE">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='261.Tutar'>*</label>
                            <div class="col col-9 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang_main no='1738.Tutar Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="CASH_ACTION_VALUE" style="width:150px;" class="moneybox" value="#TLFormat(get_action_detail.CASH_ACTION_VALUE)#"  onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');" onkeyup="return(FormatCurrency(this,event));" required="yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='644.Dövizli Tutar'></label>
                            <div class="col col-9 col-xs-12"> 
								<cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#" style="width:150px;" class="moneybox" onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event));">                            </div>
                        </div>
                        <div class="form-group" id="item-ACTION_DETAIL">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='217.Açıklama'></label>
                            <div class="col col-9 col-xs-12"> 
								<textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px; height:60px;"><cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-islem_para_br">
                            <label class="col col-12"><cf_get_lang no='87.İşlem Para Br'></label>
                            <div class="col col-9 scrollContent scroll-x2"> 
                                <cfscript>f_kur_ekle(action_id:URL.ID,process_type:1,base_value:'CASH_ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'open_cash',action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'CASH_ACTION_TO_CASH_ID');</cfscript>
                            </div>
                        </div>
                    </div>
                </div>	
                <div class="row formContentFooter">	
                    <div class="col col-6">
                        <cf_record_info query_name="get_action_detail">
						<cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_cash_open'>
                            <cfset url_link = "&is_popup=1">
                        <cfelse>
                            <cfset url_link = "">
                        </cfif>
                    </div>
                    <div class="col col-6">
                        <cf_workcube_buttons
                        is_upd='1'
                        delete_alert='Kayıtlı Bilgileri sileceksiniz'
                        delete_page_url='#request.self#?fuseaction=cash.del_cash_open&id=#attributes.id##url_link#'
                        add_function='kontrol()'>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfform>
<script type="text/javascript">
	function unformat_fields()
	{
		open_cash.CASH_ACTION_VALUE.value = filterNum(open_cash.CASH_ACTION_VALUE.value);
		open_cash.OTHER_CASH_ACT_VALUE.value = filterNum(open_cash.OTHER_CASH_ACT_VALUE.value);
		open_cash.system_amount.value = filterNum(open_cash.system_amount.value);
		for(var i=1;i<=open_cash.kur_say.value;i++)
		{
			eval('open_cash.txt_rate1_' + i).value = filterNum(eval('open_cash.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('open_cash.txt_rate2_' + i).value = filterNum(eval('open_cash.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		open_cash.CASH_ACTION_TO_CASH_ID.disabled = false;
	}
	kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');
	function kontrol()
	{
		if(document.getElementById('CASH_ACTION_VALUE').value == '')
		{
			alert('<cf_get_lang_main no="1738.Tutar Girmelisiniz">');
			return false;	
		}
		if(!chk_process_cat('open_cash')) return false;
		if(!check_display_files('open_cash')) return false;
		unformat_fields();
		return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
