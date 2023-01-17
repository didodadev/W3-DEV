<script type="text/javascript">
	function toplam_tahsilat()
	{
		tahsilat_tutari=0;
		tahsilat_tutari_pos=0;
		satir_rate2=0;
		for(var n=1; n <= form_basket.kur_say.value; n++)
		{
			if(eval('form_basket.cash_amount'+n)!= undefined && eval('form_basket.cash_amount'+n).value!="")
			{
				tahsilat_tutari = tahsilat_tutari+parseFloat(eval('form_basket.system_cash_amount'+n).value);
			}
			if('<cfoutput>#session.ep.money2#</cfoutput>' != '' && eval('form_basket.hidden_rd_money_'+n).value == '<cfoutput>#session.ep.money2#</cfoutput>')
			{
				satir_rate2= eval("document.form_basket.txt_rate2_"+n).value;
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		form_basket.total_cash_amount.value=commaSplit(tahsilat_tutari); 
		form_basket.row_total_cash_amount.value=commaSplit(tahsilat_tutari); 
		
		if(form_basket.record_num2!= undefined)
		{
			for(var m=1; m<= form_basket.record_num2.value; m++)
			{
				if(eval('form_basket.row_kontrol_2'+m).value == 1 && eval('form_basket.pos_amount_'+m)!= undefined && eval('form_basket.pos_amount_'+m).value!="")
				{
					tahsilat_tutari = tahsilat_tutari+parseFloat(eval('form_basket.system_pos_amount_'+m).value);
					tahsilat_tutari_pos = tahsilat_tutari_pos+parseFloat(eval('form_basket.system_pos_amount_'+m).value);
				}
			}
		}
		form_basket.total_pos_amount.value=commaSplit(tahsilat_tutari_pos); 
		form_basket.row_total_pos_amount.value=commaSplit(tahsilat_tutari_pos); 
		if(window.basketManager !== undefined)
			genel_toplam = basketManagerObject.basketFooter.basket_net_total();
		else
			genel_toplam = form_basket.basket_net_total.value
		form_basket.total_diff_amount.value=commaSplit(genel_toplam-tahsilat_tutari);
		form_basket.total_pay_amount.value=commaSplit(tahsilat_tutari); 
		form_basket.total_sale_amount.value=commaSplit(genel_toplam); 
		if('<cfoutput>#session.ep.money2#</cfoutput>' != '')
		{
			form_basket.total_sale_amount2.value=commaSplit(parseFloat(filterNum(form_basket.total_sale_amount.value)/satir_rate2)); 
			form_basket.total_cash_amount2.value=commaSplit(parseFloat(filterNum(form_basket.total_cash_amount.value)/satir_rate2)); 
			form_basket.total_pos_amount2.value=commaSplit(parseFloat(filterNum(form_basket.total_pos_amount.value)/satir_rate2)); 
			form_basket.total_pay_amount2.value=commaSplit(parseFloat(filterNum(form_basket.total_pay_amount.value)/satir_rate2)); 
			form_basket.total_diff_amount2.value=commaSplit(parseFloat(filterNum(form_basket.total_diff_amount.value)/satir_rate2)); 
		}
	}
	function kasa_dovizi_hesapla(sira_no,is_common)
	{	
		if(window.basketManager !== undefined){
		kasa_money_rate2 = rate2Array[sira_no-1];
		kasa_money_rate1 = rate1Array[sira_no-1];	
		if (eval('form_basket.cash_amount' + sira_no)!=undefined && eval('form_basket.cash_amount' + sira_no).value!= "")
			{
			sistem_tutar=(filterNum(eval('form_basket.cash_amount' + sira_no).value,4)*(kasa_money_rate2/kasa_money_rate1));
			eval('form_basket.system_cash_amount'+sira_no).value=wrk_round(sistem_tutar);
			}
		}
		else{
		kasa_money_rate2 = eval('form_basket.txt_rate2_' + sira_no).value;
		kasa_money_rate1=eval('form_basket.txt_rate1_' + sira_no).value;	
		if (eval('form_basket.cash_amount' + sira_no)!=undefined && eval('form_basket.cash_amount' + sira_no).value!= "")
			{
			sistem_tutar=(filterNum(eval('form_basket.cash_amount' + sira_no).value,4)*(filterNum(kasa_money_rate2,4)/filterNum(kasa_money_rate1,4)));
			eval('form_basket.system_cash_amount'+sira_no).value=wrk_round(sistem_tutar);
			}
		}
		if (!is_common)
			toplam_tahsilat();
	}
	function pos_hesapla(pos_row,is_common)
	{	
		if(eval('form_basket.pos_amount_'+pos_row)!= undefined)
		{
			if(eval('form_basket.pos_amount_'+pos_row).value!="")
			{
				pos_money_list=new Array(1);
				<cfoutput query="get_money_bskt">
					pos_money_list.push('#get_money_bskt.money_type#');
				</cfoutput>
				for(var jxj=1; jxj<=pos_money_list.length-1; jxj++ )
				{
					pos_deger = eval('form_basket.pos_'+pos_row).value.split(';');
					pos_currency=pos_deger[1];
					if(pos_money_list[jxj] == pos_currency)
						{
							temp_pos_amount= eval('form_basket.pos_amount_'+pos_row).value;
							if(window.basketManager !== undefined){
							temp_rate2=rate2Array[jxj-1];
							temp_rate1=rate1Array[jxj-1];
							eval('form_basket.system_pos_amount_'+pos_row).value=wrk_round(filterNum(temp_pos_amount,4)*(temp_rate2/temp_rate1));
							}
							else{
							temp_rate2=eval('form_basket.txt_rate2_' + jxj).value;
							temp_rate1=eval('form_basket.txt_rate1_' + jxj).value;
							eval('form_basket.system_pos_amount_'+pos_row).value=wrk_round(filterNum(temp_pos_amount,4)*(filterNum(temp_rate2,4)/filterNum(temp_rate1,4)));
							}
						}
				}
			}
			else
				eval('form_basket.system_pos_amount_'+pos_row).value=0;
			if (!is_common)
				toplam_tahsilat();
		}
	}
</script>
<cfquery name="get_cashes" datasource="#dsn2#">
	SELECT 
		CASH_ID,
		CASH_NAME,
		CASH_ACC_CODE,
		CASH_CODE,
		BRANCH_ID,		
		CASH_CURRENCY_ID,		
		CASH_EMP_ID
	FROM
		CASH
	WHERE
		CASH_ACC_CODE IS NOT NULL AND 
		CASH_STATUS = 1
		<cfif session.ep.isBranchAuthorization>
			AND CASH.BRANCH_ID IN(SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
		</cfif>
	ORDER BY 
		CASH_NAME
</cfquery>
<cfquery name="get_pos_detail" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO,
		CPT.PAYMENT_RATE
	FROM
		ACCOUNTS ACCOUNTS,
		CREDITCARD_PAYMENT_TYPE CPT
	WHERE
		<cfif session.ep.period_year lt 2009>
			(ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') AND
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) AND
		</cfif>
		ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
		CPT.IS_ACTIVE = 1 AND 
		ACCOUNTS.ACCOUNT_STATUS = 1
		<cfif session.ep.isBranchAuthorization>
			AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID IN(SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#))
		</cfif>
	ORDER BY
		CPT.CARD_NO
</cfquery>
<cfquery name="control_cashes" datasource="#dsn2#">
	SELECT 
		INVOICE_CASH_POS.KASA_ID,
		CASH_ACTIONS.*
	FROM
		INVOICE,
		INVOICE_CASH_POS,
		CASH_ACTIONS
	WHERE
		CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID
		AND INVOICE_CASH_POS.INVOICE_ID=INVOICE.INVOICE_ID 
		AND INVOICE.INVOICE_ID=#url.iid#
	ORDER BY 
		INVOICE_CASH_POS.KASA_ID DESC
</cfquery>
<cfset kasa_listesi=listsort(valuelist(control_cashes.KASA_ID,','),'numeric','desc',',')>
<cfquery name="CONTROL_POS_PAYMENT" datasource="#dsn2#">
	SELECT 
		INVOICE_CASH_POS.*,
		CREDIT_CARD_BANK_PAYMENTS.*
	FROM
		INVOICE,
		INVOICE_CASH_POS,
		#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS
	WHERE
		INVOICE.INVOICE_ID=INVOICE_CASH_POS.INVOICE_ID
		AND INVOICE_CASH_POS.POS_ACTION_ID=CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID
		AND INVOICE.INVOICE_ID=#url.iid# AND
		INVOICE_CASH_POS.POS_PERIOD_ID = #session_base.period_id#
	ORDER BY
		INVOICE_CASH_POS.POS_ACTION_ID
</cfquery>
<cf_basket_form id="tahsilat">
	<table>
		<tr>
			<td valign="top" width="270">
				<cf_grid_list>
					<cfif get_cashes.recordcount>
						<cfquery name="get_session_cash" dbtype="query">
							SELECT * FROM get_cashes WHERE CASH_CURRENCY_ID = '#session.ep.money#'
						</cfquery>
						<thead>
							<tr>
								<th><cf_get_lang dictionary_id='54869.Kasa Ödeme'></th>
								<th><cf_get_lang dictionary_id='57520.Kasa'></th>
							</tr>
						</thead>
						<cfoutput query="get_money_bskt">
							<cfquery name="get_money_cashes" dbtype="query">
								SELECT
									CASH_ID, CASH_NAME,
									CASH_CURRENCY_ID
								FROM 
									GET_CASHES
								WHERE 
									CASH_CURRENCY_ID='#money_type#'
							</cfquery>
							<cfif get_money_cashes.recordcount>
								<tr>
									<cfif control_cashes.recordcount>
										<cfquery name="get_cash_amount" dbtype="query">
											SELECT CASH_ACTION_VALUE,ACTION_ID FROM control_cashes WHERE CASH_ACTION_CURRENCY_ID='#money_type#'
										</cfquery>
									</cfif>
									<td><div class="form-group">
										<input type="text" name="cash_amount#get_money_bskt.currentrow#" id="cash_amount#get_money_bskt.currentrow#" value="<cfif control_cashes.recordcount>#TLFormat(get_cash_amount.CASH_ACTION_VALUE)#</cfif>" class="moneybox" onKeyUp="kasa_dovizi_hesapla(#get_money_bskt.currentrow#,0);return(FormatCurrency(this,event));"><!--- onBlur="kasa_dovizi_hesapla(#get_money_bskt.currentrow#,0);" --->
										<input type="hidden" name="cash_action_id_#get_money_bskt.currentrow#" id="cash_action_id_#get_money_bskt.currentrow#" value="<cfif control_cashes.recordcount>#get_cash_amount.ACTION_ID#</cfif>"></div>
									</td>
									<td><div class="form-group medium">
										<select name="kasa#get_money_bskt.currentrow#" id="kasa#get_money_bskt.currentrow#">
											<cfloop query="get_money_cashes">
												<option value="#get_money_cashes.CASH_ID#" <cfif listfind(kasa_listesi,get_money_cashes.CASH_ID,',')>selected</cfif>>#get_money_cashes.CASH_NAME#-#get_money_cashes.CASH_CURRENCY_ID#</option>
											</cfloop>
										</select>
										<input type="hidden" name="system_cash_amount#get_money_bskt.currentrow#" id="system_cash_amount#get_money_bskt.currentrow#" value=""><!--- simdilik gerek olmadigi icin commasplitten gecirilmeden deger atanıyor ve submitten oncede filterNum kontrolu yok, sistem para birimine gore para miktarini tutuyor --->
										<input type="hidden" name="currency_type#get_money_bskt.currentrow#" id="currency_type#get_money_bskt.currentrow#" value="#money_type#"></div>
									</td>
								</tr>
								<script type="text/javascript">kasa_dovizi_hesapla(#get_money_bskt.currentrow#,1);</script>
							</cfif>
						</cfoutput>
							<tr>
								<td nowrap="nowrap">
									<input type="text" name="row_total_cash_amount" id="row_total_cash_amount" value="<cfoutput>#TlFormat(0)#</cfoutput>" class="moneybox" readonly="yes">
								</td>
								<td><cf_get_lang dictionary_id='54870.Toplam Kasa Tahsilat'></td>
							</tr>
					<cfelse>
						<strong><cf_get_lang dictionary_id='58739.Kasa Tanımları Eksik'>!</strong>
					</cfif>
				</cf_grid_list>
			</td>
			<td valign="top">
				<cf_grid_list>
					<cfif get_pos_detail.recordcount>
						<thead>
							<tr id="pos_td_1">
								<th><a href="javascript://" onClick="add_row_2();"><i class="fa fa-plus"></i></a></th>
								<th><cf_get_lang dictionary_id='54872.POS Ödeme'></th>
								<th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>					
							</tr>
					</thead>
					<tbody id="table2" name="table2">
							<cfif control_pos_payment.recordcount lt 5>
								<cfset new_count = 5>
							<cfelse>
								<cfset new_count = control_pos_payment.recordcount>
							</cfif>
							<input name="record_num2" id="record_num2" type="hidden" value="<cfoutput>#new_count#</cfoutput>">
							<cfoutput>
								<cfloop from="1" to="#new_count#" index="kkm">
									<tr id="frm_row2#kkm#">
										<td><input type="hidden" name="row_kontrol_2#kkm#" id="row_kontrol_2#kkm#" value="1"><a href="javascript://" onClick="sil_2('#kkm#');"><i class="fa fa-minus"></i></a></td>
										<td>
											<input type="text" name="pos_amount_#kkm#" id="pos_amount_#kkm#" value="<cfif control_pos_payment.recordcount and len(control_pos_payment.SALES_CREDIT[#kkm#])>#TLFormat(control_pos_payment.SALES_CREDIT[kkm])#</cfif>" class="moneybox" onKeyUp="pos_hesapla(#kkm#,0);return(FormatCurrency(this,event));" >
											<input type="hidden" name="pos_action_id_#kkm#" id="pos_action_id_#kkm#" value="<cfif control_pos_payment.recordcount and len(control_pos_payment.CREDITCARD_PAYMENT_ID[#kkm#])>#control_pos_payment.CREDITCARD_PAYMENT_ID[kkm]#</cfif>">
											<input type="hidden" name="system_pos_amount_#kkm#" id="system_pos_amount_#kkm#" value="">
										</td>
										<td align="left" nowrap><div class="form-group">
											<select name="pos_#kkm#" id="pos_#kkm#" onChange="pos_hesapla(#kkm#,0);">
												<cfloop query="GET_POS_DETAIL">
													<option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#;#PAYMENT_TYPE_ID#" <cfif control_pos_payment.recordcount and (GET_POS_DETAIL.PAYMENT_TYPE_ID eq control_pos_payment.PAYMENT_TYPE_ID[#kkm#])>selected</cfif>>#ACCOUNT_NAME# / #CARD_NO#</option>
												</cfloop>
											</select></div>
										</td>				
									</tr>
									<script type="text/javascript">pos_hesapla(#kkm#,1);</script>
								</cfloop>
							</cfoutput>
						</tbody>
					<cfelse>
						<strong><cf_get_lang dictionary_id='58740.Pos Tanımları Eksik'>!</strong>
					</cfif>
					<tfoot>
						<tr id="pos_td_2">
							<td>&nbsp;</td>
							<td><div class="form-group"><input type="text" name="row_total_pos_amount" id="row_total_pos_amount" value="<cfoutput>#TlFormat(0)#</cfoutput>" class="moneybox" readonly="yes"></div></td>
							<td><cf_get_lang dictionary_id='54874.Toplam POS Tahsilat'></td>
						</tr>	
					</tfoot>
				</cf_grid_list>
			</td>
		</tr>
	</table>
</cf_basket_form>
<script type="text/javascript">
	<cfif control_pos_payment.recordcount lt 5>
		row_count_2 = 5;
	<cfelse>
		row_count_2 = <cfoutput>#control_pos_payment.recordcount#</cfoutput>;
	</cfif>
	function sil_2(sy)
	{
		
		var my_element=eval("form_basket.row_kontrol_2"+sy);
		my_element.value=0;
		var my_element=eval("frm_row2"+sy);
		my_element.style.display="none";
		toplam_tahsilat();
	}
	function add_row_2()
	{
		row_count_2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
		newRow.setAttribute("name","frm_row2" + row_count_2);
		newRow.setAttribute("id","frm_row2" + row_count_2);		
		newRow.setAttribute("NAME","frm_row2" + row_count_2);
		newRow.setAttribute("ID","frm_row2" + row_count_2);		
		newRow.className = 'color-row';
		document.getElementById('record_num2').value=row_count_2;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_2' + row_count_2 +'"  id="row_kontrol_2' + row_count_2 +'"><input  type="hidden" value="" name="pos_action_id_' + row_count_2 +'" ><a href="javascript://" onclick="sil_2(' + row_count_2 + ');"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="pos_amount_' + row_count_2 +'" class="moneybox" maxlength="50" onKeyUp="pos_hesapla(' + row_count_2 + ',0);return(FormatCurrency(this,event));" ><input type="hidden" name="system_pos_amount_' + row_count_2 +'" id="system_pos_amount_' + row_count_2 +'" value="">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="pos_' + row_count_2  +'" class="text"><cfoutput query="GET_POS_DETAIL"><option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#;#PAYMENT_TYPE_ID#">#ACCOUNT_NAME# / #CARD_NO#</option></cfoutput></select></div>';
	}
	function check_cash_pos()
	{ 
		<cfoutput query="get_money_bskt">
			if(eval(form_basket.kasa#get_money_bskt.currentrow#)!= undefined && eval(form_basket.cash_amount#get_money_bskt.currentrow#)!= undefined && eval(form_basket.cash_amount#get_money_bskt.currentrow#).value!="")
			{
				eval(form_basket.cash_amount#get_money_bskt.currentrow#).value=filterNum((eval(form_basket.cash_amount#get_money_bskt.currentrow#).value));
				form_basket.is_cash.value=1;
			}
		</cfoutput>
		for(var a=1; a<= form_basket.record_num2.value; a++)
		{
			if(eval('form_basket.row_kontrol_2'+a).value && eval('form_basket.pos_amount_'+a)!= undefined && eval('form_basket.pos_amount_'+a).value!="")
			{
				eval('form_basket.pos_amount_'+a).value=filterNum((eval('form_basket.pos_amount_'+a).value));
				form_basket.is_pos.value=1;
			}
		}
		return true;
	}
	function kontrol()
	{
		if(window.basketManager !== undefined){
			$("#hidden_fields_zreport").html('<input type="hidden" id="basket_tax_count" name="basket_tax_count" value="'+basketService.sepetTaxArray().length+'">');
			if (basketService.sepetTaxArray().length != 0)
			{
				for(tax_i=0;tax_i<basketService.sepetTaxArray().length;tax_i++){
					
					$("#hidden_fields_zreport").html($("#hidden_fields_zreport").html()+'<input type="hidden" id="basket_tax_'+(tax_i+1)+'" name="basket_tax_'+(tax_i+1)+'" value="'+basketService.sepetTaxArray()[tax_i][0]+'">');
					$("#hidden_fields_zreport").html($("#hidden_fields_zreport").html()+'<input type="hidden" id="basket_tax_value_'+(tax_i+1)+'" name="basket_tax_value_'+(tax_i+1)+'" value="'+basketService.sepetTaxArray()[tax_i][1]+'">');
				}
			} 
		} 
		toplam_tahsilat();
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chk_period(form_basket.invoice_date,"İşlem")) return false;
		if(!check_product_accounts()) return false;
		var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.invoice_number.value;
		var BELGE_NO_CONTROL = wrk_safe_query("fin_BELGE_NO_CONTROL_2",'dsn2',0,listParam);
		if(BELGE_NO_CONTROL.recordcount)
		{
			alert("<cf_get_lang dictionary_id='58122.Girdiğiniz Belge No Kullanılıyor'>! ");
			return false;
		}
		
		<cfif x_show_cost_info eq 1>
			if(filterNum(form_basket.total_diff_amount.value) != 0 && document.form_basket.expense_center.value == "")
			{
				if(filterNum(form_basket.total_diff_amount.value) < 0)
					alert("<cf_get_lang dictionary_id='54875.Oluşan Fark İçin Gelir Merkezi Seçmelisiniz'>!");
				else
					alert("<cf_get_lang dictionary_id='54876.Oluşan Fark İçin Masraf Merkezi Seçmelisiniz'> !");
				return false;
			}
			
			if(filterNum(form_basket.total_diff_amount.value) != 0 && document.form_basket.expense_item_name.value == "")
			{
				if(filterNum(form_basket.total_diff_amount.value) < 0 )
					alert("<cf_get_lang dictionary_id='54877.Oluşan Fark İçin Gelir Kalemi Seçmelisiniz'>!");
				else
					alert("<cf_get_lang dictionary_id='54878.Oluşan Fark İçin Gider Kalemi Seçmelisiniz'>!");
				return false;
			}
		<cfelse>
			if(filterNum(form_basket.total_diff_amount.value) != 0)
			{
				alert('<cfoutput>#getLang('hr',1132)#</cfoutput>');
				return false;
			}	
		</cfif>
		if(check_stock_action('form_basket')) //islem kategorisi stock hareketi yapıyorsa
		{
			var basket_zero_stock_status = wrk_safe_query('fin_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.invoice_id.value,temp_process_type.value)) return false;
			}
		}
		
		<cfif x_show_info eq 1>
			//istatistiksel degerler icin
			form_basket.total_number_receipt.value=filterNum(form_basket.total_number_receipt.value);
			form_basket.valid_number_receipt.value=filterNum(form_basket.valid_number_receipt.value);
			form_basket.cancel_number_receipt.value=filterNum(form_basket.cancel_number_receipt.value);
			form_basket.total_number_sales_receipt.value=filterNum(form_basket.total_number_sales_receipt.value);
			form_basket.cancel_number_sales_receipt.value=filterNum(form_basket.cancel_number_sales_receipt.value);
			
			form_basket.total_cancellation.value=filterNum(form_basket.total_cancellation.value);		
			form_basket.total_bonus.value=filterNum(form_basket.total_bonus.value);
			form_basket.total_discount.value=filterNum(form_basket.total_discount.value);
			form_basket.total_deposit.value=filterNum(form_basket.total_deposit.value);
			form_basket.total_discount2.value=filterNum(form_basket.total_discount2.value);
			form_basket.cancel_invoice_total.value=filterNum(form_basket.cancel_invoice_total.value);
			form_basket.not_financial_invoice_total.value=filterNum(form_basket.not_financial_invoice_total.value);
			form_basket.total_number_invoice.value=filterNum(form_basket.total_number_invoice.value);
			form_basket.valid_number_invoice.value=filterNum(form_basket.valid_number_invoice.value);
			form_basket.cancel_number_invoice.value=filterNum(form_basket.cancel_number_invoice.value);
			form_basket.total_invoice.value=filterNum(form_basket.total_invoice.value);
			form_basket.total_kdv_invoice.value=filterNum(form_basket.total_kdv_invoice.value);
			form_basket.total_cancel_invoice.value=filterNum(form_basket.total_cancel_invoice.value);
			
			form_basket.total_expense_number_receipt.value=filterNum(form_basket.total_expense_number_receipt.value);
			form_basket.valid_expense_number_receipt.value=filterNum(form_basket.valid_expense_number_receipt.value);
			form_basket.cancel_expense_number_receipt.value=filterNum(form_basket.cancel_expense_number_receipt.value);
			form_basket.total_expense.value=filterNum(form_basket.total_expense.value);
			form_basket.total_kdv_expense.value=filterNum(form_basket.total_kdv_expense.value);	
			form_basket.total_cancel_expense.value=filterNum(form_basket.total_cancel_expense.value);
			form_basket.total_number_diplomatic_receipt.value=filterNum(form_basket.total_number_diplomatic_receipt.value);
			form_basket.valid_number_diplomatic_receipt.value=filterNum(form_basket.valid_number_diplomatic_receipt.value);
			form_basket.cancel_number_diplomatic_receipt.value=filterNum(form_basket.cancel_number_diplomatic_receipt.value);
			form_basket.total_diplomatic.value=filterNum(form_basket.total_diplomatic.value);
			form_basket.total_cancel_diplomatic.value=filterNum(form_basket.total_cancel_diplomatic.value);
			form_basket.total_error_number_memory.value=filterNum(form_basket.total_error_number_memory.value);	
		</cfif>
		
		return (check_cash_pos() && saveForm());
		return false;
	}
	function kontrol2()
	{
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chk_period(form_basket.invoice_date,"İşlem")) return false;
		form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
		return true;
	}
</script>

