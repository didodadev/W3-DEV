<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.form_add_payroll_bank_guaranty">
<cfinclude template="../query/get_control.cfm">
<cfinclude template="../query/get_cashes.cfm">
<cfinclude template="../query/get_money2.cfm">
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<div id="payroll_guaranty_file" style="margin-left:850px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div><!--- Div disarda olmali --->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
<cfform name="form_payroll_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_payroll_bank_guaranty" >
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
	<input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
	<input type="hidden" name="bordro_type" id="bordro_type" value="2">
	<input type="hidden" name="x_detail_acc_card" id="x_detail_acc_card" value="<cfoutput>#x_detail_acc_card#</cfoutput>">
    <cf_basket_form id="payroll_bank_quaranty">
                    <cf_box_elements>
                         <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-process_cat">
                                 <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> * </label>
                                  <div class="col col-8 col-xs-12">
                                    <cf_workcube_process_cat slct_width="237">
                                  </div>
                            </div>
                            <div class="form-group" id="item-payroll_no">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49747.Bordro No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfset belge_no = get_cheque_no(belge_tipi:'payroll')>
                                    <cfinput type="text" name="PAYROLL_NO" value="#belge_no#" required="yes"  maxlength="10" >
                                    <cfset belge_no = get_cheque_no(belge_tipi:'payroll',belge_no:belge_no+1)>
                                </div>
                            </div>
                            <div class="form-group" id="item-payroll_revenue_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                    <cfinput value="#dateformat(now(),dateformat_style)#"  validate="#validate_style#" required="Yes"  type="text" name="payroll_revenue_date" onBlur="change_money_info('form_payroll_revenue','payroll_revenue_date');">
                                    <span class="input-group-addon " ><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-branch_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='150' is_default='1' is_deny_control='1'>
                                </div>
                            </div>
                         </div>
                         <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-payroll_account_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkBankAccounts width='237' control_status = '1'>
                                </div>
                            </div>
                            <div class="form-group" id="item-masraf">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58930.Masraf'></label>
                                <div class="col col-6 col-xs-12">
                                    <cfinput type="text" name="masraf" required="yes" class="moneybox" onKeyup="return(FormatCurrency(this,event));" value="0">
                                </div>
                                <input type="hidden" name="sistem_masraf_tutari" id="sistem_masraf_tutari" value="">
                                <div class="col col-2 col-xs-12">
                                    <select name="masraf_currency" id="masraf_currency">
                                        <cfoutput query="get_money">
                                            <option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>   
                                </div>
                            </div>
                            <div class="form-group" id="item-expense_center">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="expense_center" id="expense_center">
                                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                        <cfoutput query="get_expense_center">
                                        <option value="#EXPENSE_ID#">#EXPENSE#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-EMPLOYEE_ID">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                        <cfinput type="text" name="emp_name" value="#get_emp_info(session.ep.userid,0,0)#" required="yes"  readonly>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_revenue.EMPLOYEE_ID&field_name=form_payroll_revenue.emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list','popup_list_positions');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                         <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-ACTION_DETAIL">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-exp_item_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="exp_item_id" id="exp_item_id" value="">
                                        <cfinput type="text" name="exp_item_name" id="exp_item_name" value="" onFocus="AutoComplete_Create('exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID','exp_item_id','','3','200');">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=form_payroll_revenue.exp_item_id&field_name=form_payroll_revenue.exp_item_name','list');"></span>
                                    </div>
                                </div>
                            </div>
                         </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <input type="button" value="<cf_get_lang dictionary_id='49732.Çek Seç'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:cek_sec();">
                        <cf_workcube_buttons is_upd='0' add_function='kontrol_add_guaranty()'>
                    </cf_box_footer>
    </cf_basket_form>
   <cf_basket id="payroll_bank_quaranty_bask">
		<cfset attributes.rev_date = dateformat(now(),dateformat_style)>
        <cfset attributes.bordro_type = "2">
        <cfset attributes.out = "1">
        <cfset attributes.out_bank = "1">
        <cfinclude template="../display/basket_cheque.cfm">
  </cf_basket>
</cfform>
</cf_box>
</div>
<script type="text/javascript">
	function open_file()
	{
		document.getElementById("payroll_guaranty_file").style.display='';
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=cheque.popup_add_payroll_bank_guaranty_file&cheque_currency_id='+ document.getElementById("currency_id").value +'</cfoutput>','payroll_guaranty_file',1);
		return false;
	}
	function kontrol_add_guaranty()
	{
		if (!chk_process_cat('form_payroll_revenue')) return false;
		if(!check_display_files('form_payroll_revenue')) return false;
		if(!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;
		if(document.all.cheque_num.value == 0)
		{
			alert("<cf_get_lang dictionary_id='50223.Çek Seçiniz veya Çek Ekleyiniz !'>");
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
						alert("<cf_get_lang dictionary_id='50207.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
						return false;
					}
				}
		}
		if(document.form_payroll_revenue.masraf.value != "" && filterNum(document.form_payroll_revenue.masraf.value,2)> 0)
		{
			if(document.form_payroll_revenue.exp_item_id.value == "" || document.form_payroll_revenue.exp_item_name.value == "")
			{
				alert("<cf_get_lang dictionary_id ='50368.Gider Kalemi Seçiniz'>!");
				return false;
			}
			if(document.form_payroll_revenue.expense_center.value == "")
			{
                alert("<cf_get_lang dictionary_id ='50369.Masraf Merkezi Seçiniz'>!");
				return false;
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