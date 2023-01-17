<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.form_add_voucher_payroll_bank_tem">
<cfif isnumeric(attributes.id)>
	<cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
		SELECT
			*
		FROM
			VOUCHER_PAYROLL VP
		WHERE
			VP.ACTION_ID = #attributes.id# AND
			VP.PAYROLL_TYPE = 100
		<cfif session.ep.isBranchAuthorization>
			AND VP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>		
	</cfquery>
<cfelse>
	<cfset get_action_detail.recordcount = 0>
</cfif>
<cfif not get_action_detail.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58004.Böyle Bir Senet Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
	</cfquery>
	<cfinclude template="../query/get_money2.cfm">
    <cf_catalystHeader>
    <cf_box>
	<cfform name="form_payroll_revenue">
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput>">
		<input type="hidden" name="bordro_type" id="bordro_type" value="2">
		<input type="hidden" name="payroll_acc_cari_voucher_based" id="payroll_acc_cari_voucher_based" value="<cfoutput>#GET_ACTION_DETAIL.VOUCHER_BASED_ACC_CARI#</cfoutput>">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
		<cf_basket_form id="payroll_revenue">
         <cf_box_elements>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index = "1" sort = "true">
                                <div class="form-group" id="item-process_cat">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_workcube_process_cat process_cat=#get_action_detail.process_cat#>
                                    </div>
                                </div>
                                <div class="form-group" id="item-payroll_no">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50225.Bordro No'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='50327.Bordro No Girmelisiniz!'></cfsavecontent>
										<cfinput type="text" name="payroll_no" value="#get_action_detail.PAYROLL_NO#" required="yes" message="#message#" maxlength="10">
                                    </div>
                                </div>
                                <div class="form-group" id="item-payroll_revenue_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                                    <div class="col col-8 col-xs-12">
                                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                        <div class="input-group">
                                            <cfinput value="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#" validate="#validate_style#" required="Yes" readonly message="#message#" type="text" name="payroll_revenue_date" onBlur="change_money_info('form_payroll_revenue','payroll_revenue_date');">
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info" control_date="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#"></span>
                                        </div>
                                    </div>
                                </div>
                                <cfif session.ep.isBranchAuthorization eq 0>
                                    <div class="form-group" id="item-branch_id">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' selected_value='#get_action_detail.branch_id#' is_deny_control='1'>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group" id="item-emp_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'> *</label>
                                    <div class="col col-8 col-xs-12">
                                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='50260.İşlem Yapanı Seçiniz'></cfsavecontent>
                                        <div class="input-group">
                                            <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#get_action_detail.PAYROLL_REV_MEMBER#</cfoutput>">
                                            <cfinput type="text" name="emp_name" value="#get_emp_info(get_action_detail.PAYROLL_REV_MEMBER,0,0)#" required="yes" message="#message#" readonly>
                                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_revenue.EMPLOYEE_ID&field_name=form_payroll_revenue.emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1','list','popup_list_positions');"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index = "2" sort = "true">
                                <div class="form-group" id="item-account">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesap'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif x_account_type eq 1><cfset acc_type_ = 2><cfelse><cfset acc_type_ = 0></cfif>
                                        <cf_wrkBankAccounts control_status = '1' selected_value = '#get_action_detail.payroll_account_id#' account_type='#acc_type_#'>
                                    </div>
                                </div>
                                <div class="form-group" id="item-expense">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58930.Masraf'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="col col-9 col-xs-12">
                                            <cfinput type="text" name="masraf" required="yes" message="#message#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" value="#TLformat(get_action_detail.MASRAF)#">
											<input type="hidden" name="sistem_masraf_tutari" id="sistem_masraf_tutari" value="">
                                        </div> <div class="col col-3 col-xs-12">
                                                <select name="masraf_currency" id="masraf_currency">
                                                  <cfoutput query="get_money">
                                                    <option value="#money#" <cfif money is GET_ACTION_DETAIL.MASRAF_CURRENCY>selected</cfif>>#money#</option>
                                                  </cfoutput>
                                                </select>
                                        </div>
                                </div></div>
                                <div class="form-group" id="item-expense_center">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                                    <div class="col col-8 col-xs-12">
                                            <select name="expense_center" id="expense_center">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="get_expense_center">
                                                    <option value="#EXPENSE_ID#" <cfif len(get_action_detail.exp_center_id) and get_action_detail.exp_center_id eq expense_id>selected</cfif>>#EXPENSE#</option>
                                                </cfoutput>
                                            </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-credit_limit">
                                	<cfif len(get_action_detail.CREDIT_LIMIT)>
                                        <cfquery name="GET_CREDIT_LIMIT" datasource="#dsn3#">
                                            SELECT * FROM CREDIT_LIMIT WHERE CREDIT_LIMIT_ID = #get_action_detail.CREDIT_LIMIT#
                                        </cfquery>
                                    </cfif>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58963.Kredi Limiti'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="credit_limit_id" id="credit_limit_id" value="<cfif isdefined("get_credit_limit.credit_limit_id")><cfoutput>#get_credit_limit.credit_limit_id#</cfoutput></cfif>">
                                            <input type="text" name="credit_limit_name" id="credit_limit_name" value="<cfif len(get_action_detail.CREDIT_LIMIT)><cfoutput>#get_credit_limit.limit_head#</cfoutput></cfif>">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_credit_limit&credit_limit_id=form_payroll_revenue.credit_limit_id&limit_head=form_payroll_revenue.credit_limit_name','list');"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index = "3" sort = "true">
                                <div class="form-group" id="item-action_detail">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="height:50px;"><cfoutput>#get_action_detail.action_detail#</cfoutput></textarea>
                                    </div>
                                </div>
                                <div class="form-group" id="item-expense_item">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="exp_item_id" id="exp_item_id" value="<cfif len(get_action_detail.exp_item_id)><cfoutput>#get_action_detail.exp_item_id#</cfoutput></cfif>">
                                            <cfif len(get_action_detail.exp_item_id)>
                                                <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
                                                    SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_action_detail.exp_item_id#
                                                </cfquery>
                                            </cfif>
                                            <input type="text" name="exp_item_name" id="exp_item_name" value="<cfif len(get_action_detail.exp_item_id)><cfoutput>#get_expense_item.expense_item_name#</cfoutput></cfif>" style="width:125px;" onFocus="AutoComplete_Create('exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID','exp_item_id','','3','200');">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=form_payroll_revenue.exp_item_id&field_name=form_payroll_revenue.exp_item_name','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-contract">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29522.Sozlesme'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#get_action_detail.contract_id#</cfoutput>">
                                            <cfif len(get_action_detail.contract_id)>
                                                <cfquery name="get_contract_head" datasource="#dsn3#">
                                                    SELECT CONTRACT_ID,CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.contract_id#">
                                                </cfquery>
                                            </cfif>
                                            <input type="text" name="contract_head" id="contract_head" value="<cfif len(get_action_detail.contract_id)><cfoutput>#get_contract_head.contract_head#</cfoutput></cfif>">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_payroll_revenue.contract_id&field_name=form_payroll_revenue.contract_head'</cfoutput>,'large');"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </cf_box_elements>
                        <cf_box_footer>
                               	<cf_record_info query_name="get_action_detail">
                                    <input type="button" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang dictionary_id='50386.Senet Seç'>" onclick="javascript:senet_sec();">
                                <cf_workcube_buttons 
                                    is_upd='1'  update_status='#get_action_detail.UPD_STATUS#'
                                    del_function_for_submit='delete_action()'
                                    delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_payroll_bank_tem&event=del&id=#attributes.id#&head=#get_action_detail.PAYROLL_NO#'
                                    add_function='check()'> 
                        </cf_box_footer>
		</cf_basket_form>
		<cf_basket id="voucher_payroll_bank_tem_bask">
			<cfset attributes.rev_date = dateformat(get_action_detail.payroll_revenue_date,dateformat_style)>
			<cfset attributes.bordro_type = "13">
			<cfset attributes.out = "1">
			<cfinclude template="../display/basket_voucher.cfm">
		</cf_basket>
	</cfform>
</cf_box>
</cfif>
<script type="text/javascript">
	function delete_action()
	{
		if (!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;			
		if (document.all.del_flag.value != 0)
		{
			alert("<cf_get_lang dictionary_id='56609.İşlem Görmüş Senetler Var Bordroyu Silemezsiniz'>!");
			return false;
		}
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
	}
	function check()
	{
		if(!chk_process_cat('form_payroll_revenue')) return false;
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
		if(toplam(1,0,1)==false)return false;;
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
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
