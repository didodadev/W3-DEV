<cf_xml_page_edit fuseact="cheque.form_add_payroll_bank_revenue">
<cf_get_lang_set module_name="cheque">
<cfinclude template="../query/get_money2.cfm">
<cfif isnumeric(url.id)>
	<cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
		SELECT
			P.*
		FROM
			PAYROLL P
		WHERE 
			P.ACTION_ID = #url.id# AND
			P.PAYROLL_TYPE = 92
		<cfif session.ep.isBranchAuthorization>
			AND P.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>	
	</cfquery>
<cfelse>
	<cfset get_action_detail.recordcount = 0>
</cfif>
<cfif not get_action_detail.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58002.Böyle Bir Çek Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
    <cfoutput><b>#hata_mesaj#</b></cfoutput><!--- dsp_hata düzenlenince kaldıralacak--->
	<!---<cfinclude template="../../dsp_hata.cfm">--->
<cfelse>
	<!---<cfinclude template="../query/get_cashes.cfm">--->
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
	</cfquery>
	<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfform name="form_payroll_revenue" id="form_payroll_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_payroll_bank_revenue">
				<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput>">
				<input type="hidden" name="bordro_type" id="bordro_type" value="3,1">
				<input type="hidden" name="payroll_acc_cari_cheque_based" id="payroll_acc_cari_cheque_based" value="<cfoutput>#GET_ACTION_DETAIL.CHEQUE_BASED_ACC_CARI#</cfoutput>">
				<input type="hidden" name="x_detail_acc_card" id="x_detail_acc_card" value="<cfoutput>#x_detail_acc_card#</cfoutput>">
				<cf_basket_form id="payroll_bank_revenue">
                	<cf_box_elements>
                    	<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-process_cat">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
                                <div class="col col-8 col-xs-12">
                                	<cf_workcube_process_cat slct_width="150" process_cat=#get_action_detail.process_cat#>
                            	</div>
                            </div>
							<div class="form-group" id="item-payroll_no">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49747.Bordro No'></label>
                                <div class="col col-8 col-xs-12">
									<cfinput type="text" name="payroll_no" value="#get_action_detail.PAYROLL_NO#" required="yes" style="width:150px;" maxlength="10">
                            	</div>
                            </div>
							<div class="form-group" id="item-action_date">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
										<cfinput name="payroll_revenue_date" value="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#" readonly validate="#validate_style#" required="Yes" type="text"  style="width:125px;" onBlur="change_money_info('form_payroll_revenue','payroll_revenue_date');">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info" control_date="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#"></span>
	                                </div>
	                            </div>
	                        </div>
                        	<div class="form-group" id="item-emp_name">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
				                        <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#get_action_detail.PAYROLL_REV_MEMBER#</cfoutput>">
				                        <cfinput type="text" name="emp_name" value="#get_emp_info(get_action_detail.PAYROLL_REV_MEMBER,0,0)#" required="yes" style="width:150px;" readonly>
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='58586.İşlem Yapan'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_revenue.EMPLOYEE_ID&field_name=form_payroll_revenue.emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list','popup_list_positions');"></span>
                                	</div>
                            	</div>
                        	</div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-cash_id">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
	                            <div class="col col-8 col-xs-12">
									<cf_wrk_Cash name="cash_id" value="#get_action_detail.PAYROLL_CASH_ID#" cash_status="1" currency_branch="1" cash_id="#get_action_detail.PAYROLL_CASH_ID#">
                            	</div>
                        	</div>
                            <div class="form-group" id="item-sistem_masraf_tutari">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58930.Masraf'></label>
                                <div class="col col-4 col-xs-12">
                                	<cfinput type="text" name="masraf" style="width:75px;" required="yes" onKeyup="return(FormatCurrency(this,event));" value="#TLformat(get_action_detail.MASRAF)#">
                                    <input type="hidden" name="sistem_masraf_tutari" id="sistem_masraf_tutari" value="">
                                </div>
                                <div class="col col-4 col-xs-12">
                                    <select name="masraf_currency" id="masraf_currency" style="width:47px;">
                                        <cfoutput query="get_money">
                                            <option value="#money#" <cfif money is GET_ACTION_DETAIL.MASRAF_CURRENCY>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                            	</div>
                            </div>
                            <div class="form-group" id="item-expense_center">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="expense_center" id="expense_center" style="width:125px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_expense_center">
                                            <option value="#EXPENSE_ID#" <cfif len(get_action_detail.exp_center_id) and get_action_detail.exp_center_id eq expense_id>selected</cfif>>#EXPENSE#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">

                            <div class="form-group" id="item-exp_item_name">
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
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='58551.Gider Kalemi'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=form_payroll_revenue.exp_item_id&field_name=form_payroll_revenue.exp_item_name','list');"></span>
                                	</div>
                            	</div>
                        	</div>
							<div class="form-group" id="item-action_detail">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
	                            <div class="col col-8 col-xs-12">
	                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"><cfoutput>#get_action_detail.action_detail#</cfoutput></textarea>
	                            </div>
                        	</div>
                        </div>
                    </cf_box_elements>
	                <cf_box_footer>
						<cf_record_info query_name="get_action_detail">
							<input type="button" value="<cf_get_lang dictionary_id='49732.Çek Seç'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:cek_sec();">
							<cf_workcube_buttons is_upd='1' update_status = '#GET_ACTION_DETAIL.UPD_STATUS#'
							del_function_for_submit='delete_action()'
							add_function='kontrol_upd_revenue()'
							delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_payroll&id=#attributes.id#&head=#get_action_detail.PAYROLL_NO#'>
                    </cf_box_footer>
				</cf_basket_form>
				<cf_basket id="payroll_bank_revenue_bask">
					<cfset attributes.rev_date = dateformat(get_action_detail.payroll_revenue_date,dateformat_style)>
					<cfset attributes.bordro_type = "3,1">
					<cfset attributes.out = "1">
					<cfinclude template="../display/basket_cheque.cfm">
				</cf_basket>
			</cfform>
		</cf_box>
	</div>
</cfif>
<script type="text/javascript">	
	function delete_action()
	{
		if(!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;
		if (form_payroll_revenue.del_flag.value != 0)
		{
			alert("<cf_get_lang dictionary_id='49814.İşlem Görmüş Çekler Var, Bordroyu Silemezsiniz !'>");
			return false;
		}
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
	}
	function kontrol_upd_revenue()				                     

	{
		if(!$("#payroll_revenue_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfoutput>"})    
			return false;
		}
		if(!$("#payroll_no").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='50327.Bordro No Girmelisiniz!'></cfoutput>"})    
			return false;
		}
		if(!$("#emp_name").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='50260.İşlem Yapanı Seçiniz !'></cfoutput>"})    
			return false;
		}
		if(!chk_process_cat('form_payroll_revenue')) return false;
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
		upd_masraf_value();
		for(kk=1;kk<=document.all.kur_say.value;kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false)return false;
		document.form_payroll_revenue.cash_id.disabled = false;
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
