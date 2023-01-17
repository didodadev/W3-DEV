<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact="bank.form_add_bank_account_open">
<!--- <cfinclude template="../query/get_control.cfm"> --->
<cf_catalystHeader>
    <div class="col col-12 col-xs-12">
        <cf_box>
            <cfform name="open_cash" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_bank_account_open" method="post">
                <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57800.işlem tipi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat slct_width="285">
                            </div>
                        </div>
                        <div class="form-group" id="item-BankAccounts">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48706.Banka/Hesap'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkBankAccounts width='285' call_function='kur_ekle_f_hesapla' control_status='1' is_open_accounts='1'>
                            </div>
                        </div>
                        <cfif x_select_branch eq 1 and session.ep.isBranchAuthorization eq 0>
                        <div class="form-group" id="item-DepartmentBranch">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='150' is_default='1' is_deny_control='1'>
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item-ba_status">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57867.Borç/Alacak'> *</label>
                            <div class="col col-8 col-xs-12">
                                <select name="ba_status" id="ba_status" style="width:150px;">
                                    <option value="0" selected><cf_get_lang_main dictionary_id='57587.Borç'></option>
                                    <option value="1" ><cf_get_lang_main dictionary_id='57588.Alacak'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-ACTION_VALUE">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57673.Tutar'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ACTION_VALUE" style="width:150px;" class="moneybox" required="yes" maxlength="20" value="" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event,2,'float'));">
                            </div>
                        </div>
                        <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34116.Diğer Döviz İşlemi'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="OTHER_CASH_ACT_VALUE" class="moneybox" style="width:150px;" value="" onBlur="kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-action_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57742.Tarih'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="action_date" maxlength="10" required="yes" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#" style="width:150px;" onBlur="change_money_info('open_cash','action_date');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-action_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="action_detail" id="action_detail" style="width:150px; height:60px;"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group">
                            <label class="bold"><cf_get_lang dictionary_id='50114.Döviz Birimi'></label>
                        </div>
                        <div class="form-group" id="item-account_id">
                            <div class="col col-12 col-xs-12 scrollContent scroll-x2">
                                <cfscript>f_kur_ekle(process_type:0,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'open_cash',select_input:'account_id');</cfscript>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-12">
                        <cf_workcube_buttons type_format="1" is_upd='0' add_function="kontrol()">
                    </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
<script type="text/javascript">
	function kontrol()
	{
		if(!$("#ACTION_VALUE").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='29943.Miktar Giriniz !'></cfoutput>"})    
			return false;
		}
		if(!$("#action_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang_main dictionary_id='58503.Lutfen Tarih Giriniz !'></cfoutput>"})    
			return false;
		}
		if(!chk_process_cat('open_cash')) return false;
		if(!check_display_files('open_cash')) return false;
		if(!chk_period(document.open_cash.action_date, 'İşlem')) return false;
		if(!acc_control()) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
		return(unformat_fields());
		return true;
	}
	function unformat_fields()
	{
		open_cash.ACTION_VALUE.value = filterNum(open_cash.ACTION_VALUE.value);
		open_cash.OTHER_CASH_ACT_VALUE.value = filterNum(open_cash.OTHER_CASH_ACT_VALUE.value);
		open_cash.system_amount.value = filterNum(open_cash.system_amount.value);
		for(var i=1;i<=open_cash.kur_say.value;i++)
		{
			eval('open_cash.txt_rate1_' + i).value = filterNum(eval('open_cash.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('open_cash.txt_rate2_' + i).value = filterNum(eval('open_cash.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	kur_ekle_f_hesapla('account_id');
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
