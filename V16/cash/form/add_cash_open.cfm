<cfset cash_status = 1>
<cfinclude template="../query/get_cashes.cfm">
<cf_catalystHeader>
<cfform name="open_cash" action="#request.self#?fuseaction=cash.add_cash_open" method="post">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <div class="row"> 
        <div class="col col-12 uniqueRow"> 		
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='388.işlem tipi'> *</label>
                            <div class="col col-9 col-xs-12"> 
                                <cf_workcube_process_cat slct_width="150">
                            </div>
                        </div>
                        <div class="form-group" id="item-CASH_ACTION_TO_CASH_ID">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='108.Kasa'> *</label>
                            <div class="col col-9 col-xs-12"> 
                                <cfif get_close_cashes.recordcount gte 1>
                                    <select name="CASH_ACTION_TO_CASH_ID" id="CASH_ACTION_TO_CASH_ID" style="width:150px;" onChange="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');change_currency_info();">
                                        <cfoutput query="get_close_cashes">
                                            <option value="#CASH_ID#;#CASH_CURRENCY_ID#">
                                            #CASH_NAME#&nbsp;#CASH_CURRENCY_ID#</option>
                                        </cfoutput>
                                    </select>
                                <cfelse>
                                    <font color="red"><b><cf_get_lang no='67.Açılacak Kasa Bulunamadı'> !</b></font>
                                </cfif>                  
                            </div>
                        </div>
                        <div class="form-group" id="item-ACTION_DATE">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='330.Tarih'>*</label>
                            <div class="col col-9 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message1"><cf_get_lang_main no='330.Tarih'>!</cfsavecontent>
                                    <cfinput type="text" name="ACTION_DATE" id="ACTION_DATE" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message1#" style="width:150px;" onblur="change_money_info('open_cash','ACTION_DATE');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-CASH_ACTION_VALUE">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='261.Tutar'>*</label>
                            <div class="col col-9 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang_main no='1738.Tutar Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="CASH_ACTION_VALUE" id="CASH_ACTION_VALUE" class="moneybox" style="width:150px;" value="" onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');" onkeyup="return(FormatCurrency(this,event,2,'float'));" required="yes" message="#message#">                 
                            </div>
                        </div>
                        <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='644.Dövizli Tutar'></label>
                            <div class="col col-9 col-xs-12"> 
                                <cfinput type="text" name="OTHER_CASH_ACT_VALUE" id="OTHER_CASH_ACT_VALUE" style="width:150px;" value="" class="moneybox" onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event,2,'float'));">
                            </div>
                        </div>
                        <div class="form-group" id="item-ACTION_DETAIL">
                            <label class="col col-3 col-xs-3"><cf_get_lang_main no='217.Açıklama'></label>
                            <div class="col col-9 col-xs-12"> 
                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px; height:60px;"></textarea>  
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-islem_para_br">
                            <label class="col col-12"><cf_get_lang no='87.İşlem Para Br'></label>
                            <div class="col col-9 scrollContent scroll-x2"> 
                                <cfscript>f_kur_ekle(process_type:0,base_value:'CASH_ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'open_cash',select_input:'CASH_ACTION_TO_CASH_ID');</cfscript>
                            </div>
                        </div>
                    </div>
                </div>	
                <div class="row formContentFooter">	
                    <div class="col col-12">
                        <cfif get_close_cashes.recordcount gte 1>
                            <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
                        </cfif>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfform>
<script type="text/javascript">
	change_currency_info();
	function unformat_fields()
	{
		document.getElementById('CASH_ACTION_VALUE').value = filterNum(document.getElementById('CASH_ACTION_VALUE').value);
		document.getElementById('OTHER_CASH_ACT_VALUE').value = filterNum(document.getElementById('OTHER_CASH_ACT_VALUE').value);
		document.getElementById('system_amount').value = filterNum(document.getElementById('system_amount').value);
		for(var i=1;i<=open_cash.kur_say.value;i++)
		{
			document.getElementById('txt_rate1_' + i).value = filterNum(document.getElementById('txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById('txt_rate2_' + i).value = filterNum(document.getElementById('txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		return true;
	}
	kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');
	
	function change_currency_info()
	{
		if(document.getElementById("CASH_ACTION_TO_CASH_ID") != undefined)
		{
			new_kur_say = document.all.kur_say.value;
			var currency_type_2 = list_getat(open_cash.CASH_ACTION_TO_CASH_ID.options[open_cash.CASH_ACTION_TO_CASH_ID.options.selectedIndex].value,2,';');
			for(var i=1;i<=new_kur_say;i++)
			{
				if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == currency_type_2)
					eval('document.all.rd_money['+(i-1)+']').checked = true;
			}
			kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');
		}
	}	
	
	function kontrol()
	{
		if(document.getElementById('CASH_ACTION_VALUE').value == '')
		{
			alert('<cf_get_lang_main no="1738.Tutar Girmelisiniz">');
			return false;	
		}
		if(!chk_process_cat('open_cash')) return false;
		if(!check_display_files('open_cash')) return false;
		if(!chk_period(open_cash.ACTION_DATE,'<cf_get_lang_main no="280.İşlem">')) return false;
		return unformat_fields();
	}
</script>
