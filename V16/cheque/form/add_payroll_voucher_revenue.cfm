<cf_get_lang_set module_name="cheque">
<cfinclude template="../query/get_control.cfm">
<!---<cfinclude template="../query/get_voucher_cashes.cfm">--->
<cfinclude template="../query/get_money2.cfm">
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cf_catalystHeader>
<cf_box>
<cfform name="form_payroll_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_payroll_voucher_revenue">
<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
<input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
<input type="hidden" name="bordro_type" id="bordro_type" value="1,3">
    <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat slct_width="220">
                        </div>
                    </div>
                    <div class="form-group" id="item-payroll_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50202.Bordro No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll')>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='50327.bordro no girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="payroll_no" value="#belge_no#" required="yes" message="#message#" style="width:150px;" maxlength="10">
                            <cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll',belge_no:belge_no+1)>
                        </div>
                    </div>
                    <div class="form-group" id="item-payroll_revenue_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                <cfinput value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="payroll_revenue_date" style="width:125px;" onBlur="change_money_info('form_payroll_revenue','payroll_revenue_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='33981.Tahsil Eden Girmelisiniz !'></cfsavecontent>
                                <cfinput type="text" name="emp_name" value="#get_emp_info(session.ep.userid,0,0)#" required="yes" message="#message#" style="width:220px;" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_revenue.EMPLOYEE_ID&field_name=form_payroll_revenue.emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9</cfoutput>','list','popup_list_positions');" title="<cf_get_lang dictionary_id='58586.İşlem Yapan'>"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-cash_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_Cash name="cash_id" acc_code="1" currency_branch="1" cash_status="1">
                        </div>
                    </div>
                    <div class="form-group" id="item-sistem_masraf_tutari">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58930.Masraf'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-9 col-xs-12">
                                <cfinput type="text" name="masraf" style="width:75px;" required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));" value="0">
                                <input type="hidden" name="sistem_masraf_tutari" id="sistem_masraf_tutari" value="">
                            </div><div class="col col-3 col-xs-12">
                                    <select name="masraf_currency" id="masraf_currency" style="width:47px;">
                                        <cfoutput query="get_money">
                                            <option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_center">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <select name="expense_center" id="expense_center">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_expense_center">
                                    <option value="#EXPENSE_ID#">#EXPENSE#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-ACTION_DETAIL">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-exp_item_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="exp_item_id" id="exp_item_id" value="">
                                <cfinput type="text" name="exp_item_name" id="exp_item_name" value="" style="width:125px;" onFocus="AutoComplete_Create('exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID','exp_item_id','','3','200');">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=form_payroll_revenue.exp_item_id&field_name=form_payroll_revenue.exp_item_name','list');" title="<cf_get_lang dictionary_id='58551.Gider Kalemi'>"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <input type="button" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang dictionary_id='50386.Senet Seç'>" onclick="javascript:senet_sec();">
                    <cf_workcube_buttons is_upd='0' add_function='check()'>
            </cf_box_footer>
 <cf_basket id="voucher_revenue_bask">
    <cfset attributes.rev_date = dateformat(now(),dateformat_style)>
    <cfset attributes.bordro_type = "1,3">
    <cfset attributes.out = 1>
    <cfinclude template="../display/basket_voucher.cfm">
 </cf_basket>
</cfform>
</cf_box>
<script type="text/javascript">
	function check()
	{
		if (!chk_process_cat('form_payroll_revenue')) return false;
		if(!check_display_files('form_payroll_revenue')) return false;
		if(!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;	
		if(document.form_payroll_revenue.masraf.value != "" && filterNum(document.form_payroll_revenue.masraf.value,2)> 0)
		{
			if(document.form_payroll_revenue.expense_center.value == "")
			{
				alert("<cf_get_lang dictionary_id='51382.Masraf Merkezi Seçiniz'>!");
				return false;
			}
			if(document.form_payroll_revenue.exp_item_id.value == "" || document.form_payroll_revenue.exp_item_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='50368.Gider Kalemi Seçiniz'>!");
				return false;
			}
		}					
		if(document.all.voucher_num.value == 0)
		{
			alert("<cf_get_lang dictionary_id='50322.Senet Seçiniz veya Senet Ekleyiniz !'>");
			return false;
		}
		var kontrol_process_date = document.all.kontrol_process_date.value;
		if(kontrol_process_date != '')
		{
			var liste_uzunlugu = list_len(kontrol_process_date);
			for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
				{
					var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
					var sonuc_ = datediff(document.all.payroll_revenue_date.value,tarih_,0);
					if(sonuc_ > 0)
						{
							alert("<cf_get_lang dictionary_id='50208.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
							return false;
						}
				}
		}
		upd_masraf_value();
		for(kk=1;kk<=document.all.kur_say.value;kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false)return false;
		return true;
	}
	function upd_masraf_value()
	{
		if (document.getElementById('masraf').value == '')	document.getElementById('masraf').value = 0;
		for(i=1; i<=form_payroll_revenue.kur_say.value; i++)
		{		
			rate2=filterNum(eval('form_payroll_revenue.txt_rate2_' + i + '.value'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			rate1=filterNum(eval('form_payroll_revenue.txt_rate1_' + i + '.value'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			rd_money=eval('form_payroll_revenue.hidden_rd_money_' + i + '.value');
			if(document.form_payroll_revenue.masraf_currency[document.form_payroll_revenue.masraf_currency.options.selectedIndex].value == rd_money)
				document.form_payroll_revenue.sistem_masraf_tutari.value=wrk_round(filterNum(form_payroll_revenue.masraf.value)*(rate2/rate1));
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
