<cfif (isDefined("attributes.company_id") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isdefined("attributes.employee_id") and len(attributes.employee_id))>
	<cfquery name="get_all_vouchers" datasource="#dsn2#">
		SELECT
			VOUCHER.VOUCHER_STATUS_ID,
			VOUCHER.VOUCHER_ID,
			VOUCHER.VOUCHER_NO,
			VOUCHER.CURRENCY_ID,
			VOUCHER.VOUCHER_DUEDATE,
			VOUCHER.VOUCHER_CODE,
			VOUCHER.OTHER_MONEY_VALUE,
			VOUCHER.DELAY_INTEREST_SYSTEM_VALUE,
			VOUCHER.EARLY_PAYMENT_SYSTEM_VALUE,
			VOUCHER.IS_PAY_TERM,
			VOUCHER.VOUCHER_VALUE,
			VOUCHER_PAYROLL.PAYROLL_NO,
			VOUCHER_PAYROLL.ACTION_ID,
			VOUCHER_PAYROLL.COMPANY_ID,
			VOUCHER_PAYROLL.PAYROLL_ACCOUNT_ID,
			ISNULL(VOUCHER.CASH_ID,VOUCHER_PAYROLL.PAYROLL_CASH_ID) PAYROLL_CASH_ID,
			VOUCHER_PAYROLL.PAYMENT_ORDER_ID,
			VOUCHER_PAYROLL.CONSUMER_ID,
			SP.DELAY_INTEREST_DAY,
			ISNULL(SP.DELAY_INTEREST_RATE,0) DELAY_INTEREST_RATE,
			ISNULL(SP.FIRST_INTEREST_RATE,0) FIRST_INTEREST_RATE,
			SP.IN_ADVANCE,
			SP.DUE_MONTH,
			SP.DUE_DATE_RATE
		FROM
			VOUCHER VOUCHER,
			VOUCHER_PAYROLL VOUCHER_PAYROLL
            	LEFT JOIN #dsn_alias#.SETUP_PAYMETHOD SP ON VOUCHER_PAYROLL.PAYMETHOD_ID = SP.PAYMETHOD_ID
		WHERE
			VOUCHER.VOUCHER_ID IS NOT NULL AND
			VOUCHER.VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID 
			<!---AND  VOUCHER.CURRENCY_ID = '#session.ep.money#'--->
			<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
				AND (VOUCHER_PAYROLL.COMPANY_ID = #attributes.company_id# OR VOUCHER.COMPANY_ID = #attributes.company_id#)
			<cfelseif len(attributes.company) and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
				AND (VOUCHER_PAYROLL.CONSUMER_ID = #attributes.consumer_id# OR VOUCHER.CONSUMER_ID = #attributes.consumer_id#)
			<cfelseif isdefined("attributes.employee_id") and len(attributes.company) and len(attributes.employee_id) and attributes.member_type eq 'employee'>
				AND (VOUCHER_PAYROLL.EMPLOYEE_ID = #attributes.employee_id# OR VOUCHER.EMPLOYEE_ID = #attributes.employee_id#)
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND VOUCHER_PAYROLL.PAYROLL_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
			</cfif>
			<cfif isdefined("attributes.paper_type") and len(attributes.paper_type)>
				AND VOUCHER.IS_PAY_TERM = #attributes.paper_type#
			</cfif>
		ORDER BY
			VOUCHER.VOUCHER_DUEDATE
	</cfquery>
	<cfquery name="get_vouchers" dbtype="query">
		SELECT
			*
		FROM
			get_all_vouchers
		WHERE
			<cfif isdefined("attributes.is_payment") and attributes.is_payment eq 2>
				VOUCHER_STATUS_ID = 3
			<cfelseif isdefined("attributes.is_payment") and attributes.is_payment eq 1> 
				VOUCHER_STATUS_ID IN(1,11,10)
			<cfelse>
				VOUCHER_STATUS_ID IN(1,11,10,3,9)
			</cfif>
		ORDER BY
			VOUCHER_DUEDATE
	</cfquery>
	<cf_box>
    	<cf_seperator title="Kalan Senetler" id="kalan_senetler">
		<cf_grid_list id="kalan_senetler" >
			<thead>
				<tr>
					<th width="30" nowrap><cf_get_lang_main no='75.No'></th>
					<th width="50"><cf_get_lang_main no='1090.Senet No'></th>
					<th width="60"><cf_get_lang dictionary_id="57640.Vade"></th>
					<th width="60"><cf_get_lang dictionary_id="57520.Kasa"></th>
					<th width="60"><cf_get_lang_main no='70.Aşama'></th>
					<th width="80"><cf_get_lang_main no='261.Tutar'></th>
					<th width="80" align="center"><cf_get_lang dictionary_id="51739.Erken Ödeme İndirimi"></th> 
					<th width="90"><cf_get_lang dictionary_id="50139.Kapanan Tutar"></th>
					<th width="80"><cf_get_lang dictionary_id="48769.Kalan Tutar"></th>
					<th width="90" align="center" nowrap><cf_get_lang dictionary_id="50140.Kapanacak Tutar"></th>
					<th width="80"><cf_get_lang no ='166.Gecikme Faizi'></th>
					<th width="80" align="center"><cf_get_lang dictionary_id="50410.Faiz Kapanan Tutar"></th>
					<th width="90" align="center"><cf_get_lang dictionary_id="50140.Faiz Kapanacak Tutar"></th>
					<th align="center" width="25"><input type="checkbox" name="all_voucher" id="all_voucher" value="1" onClick="check_all(this.checked);"></th>
				</tr>
			</thead>
			<tbody>
				<cfset toplam_interest_amount = 0>
				<cfset toplam_kalan = 0>
				<cfset toplam_kalan_br = 0>
				<cfif get_vouchers.recordcount>
					<cfset cash_id_list=''>
					<cfoutput query="get_vouchers">
						<cfif len(payroll_cash_id) and not listfind(cash_id_list,payroll_cash_id)>
							<cfset cash_id_list=listappend(cash_id_list,payroll_cash_id)>
						</cfif>
					</cfoutput>
					<cfif listlen(cash_id_list)>
						<cfset cash_id_list=listsort(cash_id_list,"numeric","ASC",',')>
						<cfquery name="GET_CASH" datasource="#dsn2#">
							SELECT
								CASH_NAME,
								CASH_ID
							FROM 
								CASH 
							WHERE
								CASH_ID IN (#cash_id_list#)
							ORDER BY
								CASH_ID
						</cfquery>
						<cfset main_cash_id_list = listsort(listdeleteduplicates(valuelist(GET_CASH.CASH_ID,',')),'numeric','ASC',',')>
					</cfif>
					<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_vouchers.recordcount#</cfoutput>">
					<cfoutput query="get_vouchers">
						<cfset toplam_kalan_satir = 0>
						<cfset toplam_kalan_br_satir = 0>
						<cfquery name="get_closeds" datasource="#dsn2#">
							SELECT CLOSED_AMOUNT,IS_VOUCHER_DELAY FROM VOUCHER_CLOSED WHERE ACTION_ID = #voucher_id#
						</cfquery>
						<cfquery name="get_voucher_closed" dbtype="query">
							SELECT SUM(CLOSED_AMOUNT) AS CLOSED_AMOUNT FROM get_closeds WHERE IS_VOUCHER_DELAY IS NULL
						</cfquery>
						<cfquery name="get_delay_closed" dbtype="query">
							SELECT SUM(CLOSED_AMOUNT) AS CLOSED_AMOUNT FROM get_closeds WHERE IS_VOUCHER_DELAY IS NOT NULL
						</cfquery>
						<tr>
							<input type="hidden" name="payment_order_id_#currentrow#" id="payment_order_id_#currentrow#" value="#get_vouchers.payment_order_id#">
							<input type="hidden" name="voucher_status_#currentrow#" id="voucher_status_#currentrow#" value="#get_vouchers.voucher_status_id#">
							<input type="hidden" name="voucher_id_#currentrow#" id="voucher_id_#currentrow#" value="#voucher_id#">
							<input type="hidden" name="currency_id_#currentrow#" id="currency_id_#currentrow#" value="#currency_id#">
							<input type="hidden" name="voucher_no_#currentrow#" id="voucher_no_#currentrow#" value="#voucher_no#">
							<input type="hidden" name="due_date_#currentrow#" id="due_date_#currentrow#" value="#dateformat(get_vouchers.voucher_duedate,dateformat_style)#">
							<input type="hidden" name="f_other_money_value_#currentrow#" id="f_other_money_value_#currentrow#" value="#TLFormat(get_vouchers.other_money_value,2)#">
							<input type="hidden" name="f_money_value_#currentrow#" id="f_money_value_#currentrow#" value="#TLFormat(get_vouchers.VOUCHER_VALUE,2)#">
							<cfquery name="get_last_action" datasource="#dsn2#">
								SELECT
									VP.PAYROLL_REVENUE_DATE
								FROM
									VOUCHER_PAYROLL VP,
									VOUCHER_PAYROLL_ACTIONS VPA
								WHERE
									VP.PAYROLL_TYPE = 1057
									AND VP.ACTION_ID = VPA.PAYROLL_ID  
									AND VPA.PAYROLL_ID IN(SELECT PAYROLL_ID FROM VOUCHER_CLOSED WHERE ACTION_ID = #voucher_id#)
								ORDER BY PAYROLL_REVENUE_DATE DESC
							</cfquery>
							<cfquery name="get_last_action_" datasource="#dsn2#" maxrows="1">
								SELECT
									VP.PAYROLL_REVENUE_DATE
								FROM
									VOUCHER_PAYROLL VP,
									VOUCHER_PAYROLL_ACTIONS VPA
								WHERE
									VP.PAYROLL_TYPE = 1057
									AND VP.ACTION_ID = VPA.PAYROLL_ID  
									AND VPA.PAYROLL_ID = (SELECT TOP 1 PAYROLL_ID FROM VOUCHER_CLOSED WHERE ACTION_ID = #voucher_id# ORDER BY CLOSED_ROW_ID DESC)
								ORDER BY PAYROLL_REVENUE_DATE DESC
							</cfquery>
							<cfset first_gun_farki = 0> 
							<cfset last_interest_value = 0>
							<cfif get_last_action.recordcount>
								<cfloop query="get_last_action">
									<cfset first_gun_farki = DateDiff("d",get_vouchers.voucher_duedate,get_last_action.payroll_revenue_date)>
									<cfif first_gun_farki gt get_vouchers.delay_interest_day>
										<cfset last_interest_value = last_interest_value+((get_vouchers.delay_interest_rate*get_vouchers.other_money_value/30)*first_gun_farki)>
									</cfif>
								</cfloop>
							</cfif>
							<cfif get_last_action_.recordcount and DateDiff("d",get_vouchers.voucher_duedate,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')) gt 0 and DateDiff("d",get_vouchers.voucher_duedate,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')) gt get_vouchers.delay_interest_day>
								<cfset gun_farki = DateDiff("d",get_last_action_.payroll_revenue_date,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
							<cfelse>
								<cfset gun_farki = DateDiff("d",get_vouchers.voucher_duedate,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
							</cfif>
							<td>#currentrow#</td>
							<td width="50">
								<cfif len(payment_order_id)>
									<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_voucher&iid=#voucher_id#','longpage');">
										#get_vouchers.voucher_no#
									</a> 
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_vouchers&event=det&ID=#get_vouchers.VOUCHER_ID#','horizantal');" class="tableyazi">#get_vouchers.voucher_no#</a>
								</cfif>
								<cfif len(is_pay_term) and is_pay_term eq 1>-Ödeme Sözü</cfif>
							</td>
							<td width="65">#dateformat(get_vouchers.voucher_duedate,dateformat_style)#</td>
							<td>
								<cfif len(payroll_cash_id)>
									#get_cash.cash_name[listfind(main_cash_id_list,payroll_cash_id,',')]#
								</cfif>
							</td>
							<td width="150">
								<cfset status=get_vouchers.voucher_status_id>
								<cfswitch expression="#status#">
									<cfcase value="1">
										<font color="##003399"><cf_get_lang no='54.Portföyde'></font>
									</cfcase>
									<cfcase value="11">
										<font color="##993300"><cf_get_lang no ='169.Kısmi Tahsil'></font>
									</cfcase>
									<cfcase value="3">
										<cf_get_lang no='56.Tahsil Edildi'>
									</cfcase>
									<cfcase value="9">
										<font color="##006600"><cf_get_lang no='140.İade'></font>
									</cfcase>
									<cfcase value="10">
										<font color="##FF0000"><cf_get_lang no='139.Protestolu'>-<cf_get_lang no='54.Portföyde'></font>
									</cfcase>
								</cfswitch>
							</td>
							<td style="text-align:right;">
								#TLFormat(get_vouchers.VOUCHER_VALUE,2)# #CURRENCY_ID#
							</td>  
							<td style="text-align:right;">
								<cfif get_vouchers.voucher_status_id eq 3>
									<cfif get_vouchers.early_payment_system_value gt 0>
										#TlFormat(get_vouchers.early_payment_system_value,2)#	
										<cfset kalan_tutar = get_vouchers.VOUCHER_VALUE - get_vouchers.early_payment_system_value>
										<input type="hidden" name="payment_discount#currentrow#" id="payment_discount#currentrow#" value="#TlFormat(get_vouchers.early_payment_system_value,2)#">
									<cfelse>
										#TlFormat(0)#			
										<cfset kalan_tutar_value = get_vouchers.VOUCHER_VALUE>			
										<cfset kalan_tutar = get_vouchers.other_money_value>
										<input type="hidden" name="payment_discount#currentrow#" id="payment_discount#currentrow#" value="#TlFormat(0)#">
									</cfif>
								<cfelseif gun_farki lt 0 and -1*gun_farki gt get_vouchers.delay_interest_day and len(get_vouchers.first_interest_rate)>
									<cfset indirim_tutar_value =wrk_round((get_vouchers.first_interest_rate*get_vouchers.VOUCHER_VALUE/30)*(gun_farki)*-1,2)>
									<cfset indirim_tutar =wrk_round((get_vouchers.first_interest_rate*get_vouchers.other_money_value/30)*(gun_farki)*-1,2)>
									#TlFormat(indirim_tutar,2)#
									<cfset kalan_tutar_value = get_vouchers.VOUCHER_VALUE - indirim_tutar>
									<cfset kalan_tutar = get_vouchers.other_money_value - indirim_tutar>
									<input type="hidden" class="moneybox" name="payment_discount#currentrow#" id="payment_discount#currentrow#" value="#TlFormat(indirim_tutar,2)#">
								<cfelse>
									<cfset kalan_tutar_value = get_vouchers.VOUCHER_VALUE>
									<cfset kalan_tutar = get_vouchers.other_money_value>
									#TlFormat(0)#
									<input type="hidden" class="moneybox" name="payment_discount#currentrow#" id="payment_discount#currentrow#" value="#TlFormat(0)#">
								</cfif> 
								#CURRENCY_ID#
								<input type="hidden" class="moneybox" name="currencyid_#currentrow#" id="currencyid_#currentrow#" value="#CURRENCY_ID#">
							</td>
							<td style="text-align:right;">
								<input type="hidden" name="voucher_closed_amount_#currentrow#" id="voucher_closed_amount_#currentrow#" value="<cfif get_voucher_closed.recordcount>#TlFormat(get_voucher_closed.closed_amount,2)#<cfelse>#TlFormat(0)#</cfif>">
								<cfif get_voucher_closed.recordcount>#TlFormat(get_voucher_closed.closed_amount,2)#<cfset closed_=get_voucher_closed.closed_amount><cfelse>#TlFormat(0)#<cfset closed_ =0></cfif>
							</td>
							<td style="text-align:right;">
								<cfset kalan_tutar_new = kalan_tutar_value>
								<cfif get_voucher_closed.recordcount><cfset kalan_tutar_new = kalan_tutar_new - get_voucher_closed.closed_amount></cfif>
								#TLFormat(kalan_tutar_new,2)# #CURRENCY_ID#
								<input type="hidden" name="money_value_#currentrow#" id="money_value_#currentrow#" value="#TLFormat(kalan_tutar_new,2)#">
								<input type="hidden" name="other_money_value_#currentrow#" id="other_money_value_#currentrow#" value="#TLFormat(kalan_tutar,2)#">
							</td>  
							<td style="text-align:right;">
								<cfif voucher_status_id neq 1 and  voucher_status_id neq 11 and  voucher_status_id neq 10>
									<input type="hidden" class="moneybox" name="new_closed_amount_#currentrow#" id="new_closed_amount_#currentrow#" value="#TlFormat(0)#">
									#TlFormat(0)#
								<cfelse>	 
									<input type="text" class="moneybox" name="new_closed_amount_#currentrow#" id="new_closed_amount_#currentrow#" value="#TlFormat(0)#" style="width:90px;" readonly>
								</cfif>
							</td>
							<td style="text-align:right;"> 
								<cfif get_vouchers.voucher_status_id eq 1 or get_vouchers.voucher_status_id eq 11 or get_vouchers.voucher_status_id eq 10>
									<cfset toplam_kalan_br = toplam_kalan_br + (get_vouchers.VOUCHER_VALUE - closed_)>
									<cfset toplam_kalan = toplam_kalan + kalan_tutar_new>
									<cfset toplam_kalan_satir = toplam_kalan_satir + (get_vouchers.other_money_value - closed_)>
									<cfset toplam_kalan_br_satir = toplam_kalan_br_satir + (get_vouchers.VOUCHER_VALUE - closed_)>
								</cfif>
								<cfif get_vouchers.voucher_status_id eq 3>
									<cfif get_vouchers.delay_interest_system_value gt 0>
										<cfset toplam_interest_amount += get_vouchers.delay_interest_system_value>
										#TlFormat(get_vouchers.delay_interest_system_value)#	
										<input type="hidden" name="delay_interest_value_#currentrow#" id="delay_interest_value_#currentrow#" value="#TlFormat(get_vouchers.delay_interest_system_value,2)#">
									<cfelse>
										#TlFormat(0)#
										<input type="hidden" name="delay_interest_value_#currentrow#" id="delay_interest_value_#currentrow#" value="#TlFormat(0)#">
									</cfif>
								<cfelseif (gun_farki gt get_vouchers.delay_interest_day or last_interest_value neq 0) and len(get_vouchers.delay_interest_day) and len(get_vouchers.delay_interest_rate)>
									<cfif get_delay_closed.recordcount>
										<cfif last_interest_value neq 0>
											<cfset toplam_faiz = ((get_vouchers.delay_interest_rate*toplam_kalan_satir/30)*gun_farki) + last_interest_value>
											<cfset toplam_faiz_br = ((get_vouchers.delay_interest_rate*toplam_kalan_br_satir/30)*gun_farki) + last_interest_value>
										<cfelse>
											<cfset toplam_faiz = ((get_vouchers.delay_interest_rate*toplam_kalan_satir/30)*gun_farki) + get_delay_closed.closed_amount>
											<cfset toplam_faiz_br = ((get_vouchers.delay_interest_rate*toplam_kalan_br_satir/30)*gun_farki) + get_delay_closed.closed_amount>
										</cfif>
									<cfelse>
										<cfset toplam_faiz = (get_vouchers.delay_interest_rate*toplam_kalan_satir/30)*gun_farki + last_interest_value>
										<cfset toplam_faiz_br = (get_vouchers.delay_interest_rate*toplam_kalan_br_satir/30)*gun_farki + last_interest_value>
									</cfif>
									<cfif get_delay_closed.recordcount and toplam_faiz lt get_delay_closed.closed_amount>
										<cfset toplam_faiz = get_delay_closed.closed_amount>
									</cfif>
									<cfset toplam_interest_amount += toplam_faiz>
									#TlFormat(toplam_faiz,2)#
									<input type="hidden" name="delay_interest_value_#currentrow#" id="delay_interest_value_#currentrow#" value="#TlFormat(toplam_faiz,2)#">
								<cfelse>
									<cfif get_delay_closed.recordcount>
										<cfset toplam_interest_amount += get_delay_closed.closed_amount>
										#TlFormat(get_delay_closed.closed_amount,2)# 
										<input type="hidden" name="delay_interest_value_#currentrow#" id="delay_interest_value_#currentrow#" value="#TlFormat(get_delay_closed.closed_amount,2)#">
									<cfelse>
										#TlFormat(0)#
										<input type="hidden" name="delay_interest_value_#currentrow#" id="delay_interest_value_#currentrow#" value="#TlFormat(0)#">
									</cfif>
								</cfif>
							</td> 
							<td style="text-align:right;">
								<input type="hidden" name="delay_closed_amount_#currentrow#" id="delay_closed_amount_#currentrow#" value="<cfif get_delay_closed.recordcount>#TlFormat(get_delay_closed.closed_amount,2)#<cfelse>#TlFormat(0)#</cfif>">
								<cfif get_delay_closed.recordcount>#TlFormat(get_delay_closed.closed_amount,2)#<cfelse>#TlFormat(0)#</cfif>
							</td>  
							<td style="text-align:right;">
								<cfif voucher_status_id neq 1 and voucher_status_id neq 11 and voucher_status_id neq 10>
									<input type="hidden" class="moneybox" name="new_delay_closed_amount_#currentrow#" id="new_delay_closed_amount_#currentrow#" value="#TlFormat(0)#">
									#TlFormat(0)#
								<cfelse>	 
									<input type="text" class="moneybox" name="new_delay_closed_amount_#currentrow#" id="new_delay_closed_amount_#currentrow#" value="#TlFormat(0)#" style="width:90px;" readonly>
								</cfif>
							</td>
							<td align="center">
								<cfif not listfind('3,7,4,9',get_vouchers.voucher_status_id,',')>
									<input name="is_pay_#currentrow#" id="is_pay_#currentrow#" type="checkbox" value="" onclick="check_kontrol(this,'#currentrow#');">
								</cfif>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="15"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
					</tr>		 
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
<cfelse>
	<cfset get_vouchers.recordcount =0>
</cfif>
<script language="javascript">
	var control_checked=0;
	row_count=0;
	money_type = '';
	$( document ).ready(function() {
		var currency_type = eval(add_voucher_action.kasa.options[add_voucher_action.kasa.selectedIndex]).value;
		cr_type = currency_type.split(';');
		$('.other_currency_id').html(cr_type[1]);
			if(document.getElementById("temp_currency_id") != null)
				currency_id = document.getElementById("temp_currency_id").value;
			else{
				currency_id = '<cfoutput>#session.ep.money#</cfoutput>';
			}				
			
	});
	function kontrol()
	{
		if((document.add_voucher_action.company.value=="" || document.add_voucher_action.company_id.value=="")&&(document.add_voucher_action.company.value=="" || document.add_voucher_action.consumer_id.value=="")&&(document.add_voucher_action.company.value=="" || document.add_voucher_action.employee_id.value==""))
		{
			alert("<cf_get_lang no ='177.Cari Hesap Seçiniz '>!");
			return false;
		}
		return true;
	}
	function kontrol2()
	{
		if (!chk_process_cat('add_voucher_action')) return false;
		if(!check_display_files('add_voucher_action')) return false;
		if(!chk_period(add_voucher_action.action_date, 'İşlem')) return false;
		if(add_voucher_action.kasa!= undefined && add_voucher_action.cash_amount != undefined && add_voucher_action.cash_amount.value != 0)
		{
			add_voucher_action.cash.value=1;
		}		
		if(add_voucher_action.pos_amount != undefined && add_voucher_action.pos_amount.value != 0)
		{
			add_voucher_action.is_pos.value=1;
		}
		if(add_voucher_action.bank_amount != undefined && add_voucher_action.bank_amount.value != 0)
		{
			add_voucher_action.is_bank.value=1;
		}
		if(add_voucher_action.cash.value == 1 && (add_voucher_action.paper_code.value =='' || add_voucher_action.paper_number.value ==''))
		{
		  alert("<cf_get_lang no ='217.Makbuz No Giriniz'> !");
		  return false;
		}
		if(add_voucher_action.action_date.value == '')
		{
		  alert("<cf_get_lang no ='218.İşlem Tarihi Giriniz'> !");
		  return false;
		}
		if(control_checked==0)
		{
			alert("<cf_get_lang no ='219.Tahsilat İşlemi İçin En Az Bir Senet Seçmelisiniz '>!");
			return false;
		}
		if(filterNum(add_voucher_action.total_interest_amount.value) > 0)
		{
			if(document.add_voucher_action.expense_item_name.value =="" || document.add_voucher_action.expense_item_id.value =="")
			{
				alert("<cf_get_lang dictionary_id="51756.Gecikme Cezası İçin Gelir Kalemi Seçmelisiniz !">");
				return false;
			}
			if(document.add_voucher_action.expense_center.value =="" || document.add_voucher_action.expense_center_id.value =="")
			{
				alert("<cf_get_lang dictionary_id= "51772.Gecikme Cezası İçin Gelir Merkezi Seçmelisiniz !">");
				return false;
			}
		}
		var voucher_list='';//Tam kapanan senetler
		var voucher_list_2='';//Tüm senetler
		var voucher_list_3='';//Yarım kapanan senetler
		for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
		{		
			if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
			{
				if(eval('add_voucher_action.is_pay_'+i).checked)	
				{
					if(list_len(voucher_list_2,',') == 0)
						voucher_list_2+=eval("document.add_voucher_action.voucher_id_" + i+".value");//Üzerinde işlem yapılan tüm senetler
					else
						voucher_list_2+=","+eval("document.add_voucher_action.voucher_id_" + i+".value");
					deger_satir_other = eval('add_voucher_action.f_money_value_'+i).value;//Senetin değeri
					deger_satir_other = filterNum(deger_satir_other);
					deger_satir = eval('add_voucher_action.new_closed_amount_'+i).value;//Yeni kapanan değer
					deger_satir = filterNum(deger_satir);
					deger_satir_kapanan = eval('add_voucher_action.voucher_closed_amount_'+i).value;//Önceki işlemde kapanan değer
					deger_satir_kapanan = filterNum(deger_satir_kapanan);
					deger_satir_delay = eval('add_voucher_action.delay_interest_value_'+i).value;//Faiz değeri
					deger_satir_delay = filterNum(deger_satir_delay);
					deger_satir_voucher = eval('add_voucher_action.new_delay_closed_amount_'+i).value;//Yeni kapanan faiz değeri
					deger_satir_voucher = filterNum(deger_satir_voucher);				
					deger_satir_kapanan_delay = eval('add_voucher_action.delay_closed_amount_'+i).value;//Önceki işlemde kapanan faiz
					deger_satir_kapanan_delay = filterNum(deger_satir_kapanan_delay);
					deger_toplam = parseFloat(deger_satir_other) + parseFloat(deger_satir_delay) ;
					deger_toplam2 = parseFloat(deger_satir) + parseFloat(deger_satir_voucher)+ parseFloat(deger_satir_kapanan) + parseFloat(deger_satir_kapanan_delay);
					deger_toplam2 = wrk_round(deger_toplam2);
					deger_toplam = wrk_round(deger_toplam);
					if (deger_toplam2 == deger_toplam)
					{
						if(list_len(voucher_list,',') == 0)
							voucher_list+=eval("document.add_voucher_action.voucher_id_" + i+".value");//Tamamen kapatılmış olan senetler
						else
							voucher_list+=","+eval("document.add_voucher_action.voucher_id_" + i+".value");
					}
					else
					{
						if(list_len(voucher_list_3,',') == 0)
							voucher_list_3+=eval("document.add_voucher_action.voucher_id_" + i+".value");//Yarım kapatılmış olan senetler
						else
							voucher_list_3+=","+eval("document.add_voucher_action.voucher_id_" + i+".value");
					}
				}
			}
		}
		if(add_voucher_action.cash_amount != undefined)
		{
			add_voucher_action.cash_amount.value=filterNum(add_voucher_action.cash_amount.value);
		}
		if(add_voucher_action.pos_amount != undefined)
		{
			add_voucher_action.pos_amount.value=filterNum(add_voucher_action.pos_amount.value);
			add_voucher_action.com_amount.value=filterNum(add_voucher_action.com_amount.value);
			add_voucher_action.system_com_amount.value=filterNum(add_voucher_action.system_com_amount.value);//komisyon tutarı
			add_voucher_action.system_pos_amount.value=filterNum(add_voucher_action.system_pos_amount.value);//sistem komisyon tutarı
			add_voucher_action.pos_amount_first.value=filterNum(add_voucher_action.pos_amount_first.value);
		}
		if(add_voucher_action.bank_amount != undefined)
		{
			add_voucher_action.bank_amount.value=filterNum(add_voucher_action.bank_amount.value);
			add_voucher_action.system_bank_amount.value=filterNum(add_voucher_action.system_bank_amount.value);
		}
		add_voucher_action.total_interest_amount.value=filterNum(add_voucher_action.total_interest_amount.value);
		add_voucher_action.company_id.value = document.add_voucher_action.company_id.value;
		add_voucher_action.consumer_id.value = document.add_voucher_action.consumer_id.value;
		add_voucher_action.voucher_ids.value = voucher_list;
		add_voucher_action.voucher_ids_2.value = voucher_list_2;
		add_voucher_action.voucher_ids_3.value = voucher_list_3;
		add_voucher_action.action='<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_payment_voucher_revenue</cfoutput>';
		add_voucher_action.submit();
		add_voucher_action.action='';
		return false;
	}
	function kontrol3()
	{
		company_id = document.add_voucher_action.company_id.value;
		consumer_id = document.add_voucher_action.consumer_id.value;
		if(control_checked==0)
		{
			alert("<cf_get_lang no ='220.En Az Bir Senet Seçmelisiniz'> !");
			return false;
		}
		var voucher_list='';
		var total_value=0;
		var total_due_value=0;
		for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
		{		
			if(list_find('1,2,5,6,8,10',eval('add_voucher_action.voucher_status_'+i).value)) 
			{
				if(eval('add_voucher_action.is_pay_'+i).checked)	
				{
					if(list_len(voucher_list,',') == 0)
						voucher_list+=eval("document.add_voucher_action.voucher_id_" + i+".value");
					else
						voucher_list+=","+eval("document.add_voucher_action.voucher_id_" + i+".value");
					total_value = total_value + parseFloat(filterNum(eval("document.add_voucher_action.f_other_money_value_" + i+".value")));	
					total_due_value = total_due_value + (filterNum(eval("document.add_voucher_action.f_other_money_value_" + i+".value"))* datediff(add_voucher_action.action_date.value,eval("document.add_voucher_action.due_date_" + i+".value"),0));
				}
			}
		}
		if(total_value != 0)
			due_day = total_due_value / total_value;
		else
			due_day = 0;
		document.add_voucher_action.total_system_amount.value = commaSplit(filterNum(document.add_voucher_action.total_system_amount.value));
		windowopen('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_add_payment_with_voucher<cfif isdefined("company_id") and len(company_id)>&company_id='+company_id+'<cfelse>&company_id=</cfif><cfif isdefined("consumer_id") and len(consumer_id)>&consumer_id='+consumer_id+'<cfelse>&consumer_id=</cfif>&due_day='+due_day+'&net_total='+total_value+'&voucher_list='+voucher_list+'</cfoutput>','page');
		return false;
	}
	function check_kontrol(nesne,current_row)
	{		
		if(current_row){//Check box işaretli olduğunda 
			tmp_current_id2 = eval("document.add_voucher_action.currencyid_" + current_row).value;
			if(document.add_voucher_action.action_type[0].checked == true)//kasa seçili ise
			{
				c_type_kasa = eval(add_voucher_action.pos.options[add_voucher_action.pos.selectedIndex]).value;
				c_type_kasa = c_type_kasa.split(';')[1];
				c_type = c_type_kasa;// c_type : seçili olan kasa veya bankanın para birimi
				if(c_type == ''){
					alert("<cf_get_lang dictionary_id = '50246.Kasa Seçiniz !'>");
					eval("document.add_voucher_action.is_pay_" + current_row).checked = false;
					return false; 
				}
			}else if(document.add_voucher_action.action_type[1].checked == true)//banka seçili ise
			{
				c_type = document.add_voucher_action.currency_type_bank.value;
			}else if(document.add_voucher_action.action_type[2].checked == true)//pos seçili ise
			{
				c_type_pos = eval(add_voucher_action.pos.options[add_voucher_action.pos.selectedIndex]).value;
				c_type_pos = c_type_pos.split(';')[1];
				c_type = c_type_pos;//ödeme yöntemi para birimi
			}
			if(c_type != tmp_current_id2){//seçilen satırdaki para birimi kasa ile aynı değilse  
				current_control = 1;
				alert("<cf_get_lang dictionary_id = '48711.Kasa ve Hesap Kurları Aynı Değil !'>");
				eval("document.add_voucher_action.is_pay_" + current_row).checked = false;
				return false;
			}else{ 
				
				if(nesne.checked)
					control_checked++;
				else
					control_checked--; 
				total_amount();
			}
		}
		else{
			if(nesne.checked)
				control_checked++;
			else
				control_checked--;
			total_amount();
			if(document.add_voucher_action.action_type[0].checked == true)
			{
				kasa_dovizi_hesapla();
			}else if(document.add_voucher_action.action_type[1].checked == true){
				banka_dovizi_hesapla();
			}else if(document.add_voucher_action.action_type[2].checked == true)
			{
				pos_hesapla();
			}
		}
	}
	
	function total_amount()
	{
		var system_total_amounts = 0;
		var other_total_amounts = 0;
		var total_amounts = 0;
		var total_interest = 0;
		var total_discount = 0;
		for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
		{		
			if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
			{
				if(eval('add_voucher_action.is_pay_'+i).checked)	
				{
					deger_satir_other = eval('add_voucher_action.other_money_value_'+i).value;//Senetin değeri
					deger_satir_other = filterNum(deger_satir_other);
					deger_satir = eval('add_voucher_action.voucher_closed_amount_'+i).value;//Kapatılmış değer
					deger_satir = filterNum(deger_satir);
					sistem_deger_satir = eval('add_voucher_action.f_other_money_value_'+i).value; 
					sistem_deger_satir =  filterNum(sistem_deger_satir);
					deger_satir_other_delay = eval('add_voucher_action.delay_interest_value_'+i).value;//Faiz değeri
					deger_satir_other_delay = filterNum(deger_satir_other_delay);
					deger_satir_delay = eval('add_voucher_action.delay_closed_amount_'+i).value;//Kapanmış faiz
					deger_satir_delay = filterNum(deger_satir_delay);
					deger_satir_discount = eval('add_voucher_action.payment_discount'+i).value;//Erken ödeme indirimi
					deger_satir_discount = filterNum(deger_satir_discount);
					total_interest = total_interest + parseFloat(deger_satir_other_delay)-parseFloat(deger_satir_delay);
					total_discount = total_discount + parseFloat(deger_satir_discount);
					total_amounts = total_amounts + parseFloat(deger_satir_other)-parseFloat(deger_satir);
					f_money_value_ = eval('add_voucher_action.f_money_value_'+i).value;
					other_total_amounts = other_total_amounts + parseFloat(f_money_value_,2);
					system_total_amounts = system_total_amounts + parseFloat(sistem_deger_satir);
					console.log(total_amounts);
					total_amounts = total_amounts + parseFloat(deger_satir_other_delay)-parseFloat(deger_satir_delay);
					eval('add_voucher_action.new_closed_amount_'+i).value =  commaSplit(parseFloat(deger_satir_other)-parseFloat(deger_satir));
					eval('add_voucher_action.new_delay_closed_amount_'+i).value = commaSplit(parseFloat(deger_satir_other_delay)-parseFloat(deger_satir_delay));
				}
				else
				{
					eval('add_voucher_action.new_closed_amount_'+i).value = 0;
					eval('add_voucher_action.new_delay_closed_amount_'+i).value = 0;
				}
			}
		}
		document.add_voucher_action.total_system_amount.value = commaSplit(total_amounts);
		document.add_voucher_action.total_interest_amount.value = commaSplit(total_interest);
		document.add_voucher_action.other_cash_amount.value = other_total_amounts;
		document.add_voucher_action.system_total_amounts.value = system_total_amounts; 
		if(document.add_voucher_action.action_type[0].checked == true)
		{
			document.add_voucher_action.cash_amount.value = commaSplit(total_amounts);
			document.add_voucher_action.system_cash_amount.value = total_amounts;
		}
		else if(document.add_voucher_action.action_type[2].checked == true)
		{
			document.add_voucher_action.pos_amount_first.value = commaSplit(total_amounts);
			document.add_voucher_action.system_pos_amount_first.value = total_amounts;
			pos_hesapla(1);
		}
		else if(document.add_voucher_action.bank_amount != undefined)
		{
			document.add_voucher_action.bank_amount.value = commaSplit(total_amounts);
			document.add_voucher_action.system_bank_amount.value = total_amounts;
		}
	}
	function satir_hesapla(type)
	{
		if(type != undefined)
		{
			toplam = 0;
			for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
			{
				if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
				{
					deger_satir_ = eval('add_voucher_action.new_closed_amount_'+i).value;
					deger_satir_ = filterNum(deger_satir_);
					toplam = toplam +  parseFloat(deger_satir_);
				}
			}
			document.add_voucher_action.total_system_amount.value = commaSplit(toplam);
			if(document.add_voucher_action.action_type[0].checked == true)
			{
				document.add_voucher_action.cash_amount.value = commaSplit(toplam);
				document.add_voucher_action.system_cash_amount.value = toplam;
			}
			else if(document.add_voucher_action.action_type[2].checked == true)
			{
				document.add_voucher_action.pos_amount_first.value = commaSplit(toplam);
				document.add_voucher_action.system_pos_amount_first.value = toplam;
				pos_hesapla(1);
			}
			else if(document.add_voucher_action.bank_amount != undefined)
			{
				document.add_voucher_action.bank_amount.value = commaSplit(toplam);
				document.add_voucher_action.system_bank_amount.value = toplam;
			}
		}
		else
		{
			my_total_amount = document.add_voucher_action.total_system_amount.value;
			console.log(my_total_amount);
			for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
			{
				if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value) && eval("document.add_voucher_action.is_pay_" + i).checked == true) 
				{
					var form_field = eval("document.add_voucher_action.is_pay_" + i);
					form_field.checked = false;
					control_checked--;
				}
			}
			last_value = document.add_voucher_action.total_system_amount.value;
			last_value = filterNum(last_value);
			for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
			{
				if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
				{
					closed_amount_delay = 0;
					closed_amount = 0;
					deger_satir_1 = eval('add_voucher_action.delay_interest_value_'+i).value;
					deger_satir_1 = filterNum(deger_satir_1);
					deger_satir_2 = eval('add_voucher_action.delay_closed_amount_'+i).value;
					deger_satir_2 = filterNum(deger_satir_2);
					deger_satir_voucher_1 = eval('add_voucher_action.other_money_value_'+i).value;
					deger_satir_voucher_1 = filterNum(deger_satir_voucher_1);
					deger_satir_voucher_2 = eval('add_voucher_action.voucher_closed_amount_'+i).value;
					deger_satir_voucher_2 = filterNum(deger_satir_voucher_2);
					deger_satir = parseFloat(deger_satir_1) - parseFloat(deger_satir_2);
					deger_satir_voucher = parseFloat(deger_satir_voucher_1) - parseFloat(deger_satir_voucher_2);
					if(last_value >= deger_satir && deger_satir != 0) 
					{
						last_value = last_value - parseFloat(deger_satir);
						closed_amount_delay = parseFloat(closed_amount_delay) + parseFloat(deger_satir);
						var form_field = eval("document.add_voucher_action.is_pay_" + i);
						form_field.checked = true;
						control_checked++;
					}
					else if (last_value > 0 && deger_satir != 0)
					{
						closed_amount_delay = parseFloat(closed_amount_delay) + parseFloat(last_value);
						last_value = 0;
						var form_field = eval("document.add_voucher_action.is_pay_" + i);
						form_field.checked = true;
						control_checked++;
					}
					if(last_value >= deger_satir_voucher && deger_satir_voucher != 0) 
					{
						last_value = last_value - parseFloat(deger_satir_voucher);
						closed_amount = parseFloat(closed_amount)+ parseFloat(deger_satir_voucher);
						var form_field = eval("document.add_voucher_action.is_pay_" + i);
						form_field.checked = true;
						control_checked++;
					}
					else if (last_value > 0 && deger_satir_voucher != 0)
					{
						closed_amount = parseFloat(closed_amount) + parseFloat(last_value);
						last_value = 0;
						var form_field = eval("document.add_voucher_action.is_pay_" + i);
						form_field.checked = true;
						control_checked++;
					}
					eval('add_voucher_action.new_closed_amount_'+i).value = commaSplit(closed_amount);
					eval('add_voucher_action.new_delay_closed_amount_'+i).value = commaSplit(closed_amount_delay);
				}
			}
		}
	}
	function toplam_tahsilat()
	{	
		tahsilat_tutari=0;
		if(document.add_voucher_action.action_type[0].checked == true && add_voucher_action.cash_amount != undefined && add_voucher_action.cash_amount.value!="")
			tahsilat_tutari = tahsilat_tutari+parseFloat(add_voucher_action.system_cash_amount.value);
		else if(document.add_voucher_action.action_type[2].checked == true && add_voucher_action.pos_amount != undefined && add_voucher_action.pos_amount.value!="")
			tahsilat_tutari = tahsilat_tutari+parseFloat(filterNum(add_voucher_action.system_pos_amount_first.value));
		else if(document.add_voucher_action.action_type[1].checked == true && add_voucher_action.bank_amount != undefined && add_voucher_action.bank_amount.value!="")
			tahsilat_tutari = tahsilat_tutari+parseFloat(add_voucher_action.system_bank_amount.value);
		if(add_voucher_action.total_system_amount != undefined) 
			add_voucher_action.total_system_amount.value=commaSplit(tahsilat_tutari);
		console.log(add_voucher_action.total_system_amount.value);
		satir_hesapla();
	}
	function check_all(deger)
	{
		<cfif get_vouchers.recordcount>
			if(add_voucher_action.all_voucher.checked)
			{
				for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
				{
					if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
					{
						var form_field = eval("document.add_voucher_action.is_pay_" + i);
						form_field.checked = true;
						control_checked++;
						eval('add_voucher_action.is_pay_'+i).focus();
						eval('add_voucher_action.new_closed_amount_'+i).value = eval('add_voucher_action.other_money_value_'+i).value;
						eval('add_voucher_action.new_delay_closed_amount_'+i).value = eval('add_voucher_action.delay_interest_value_'+i).value;
					}
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
				{
					if(list_find('1,11,10',eval('add_voucher_action.voucher_status_'+i).value)) 
					{
						var form_field = eval("document.add_voucher_action.is_pay_" + i);
						form_field.checked = false;
						control_checked--;
						eval('add_voucher_action.is_pay_'+i).focus();
						eval('add_voucher_action.new_closed_amount_'+i).value = 0;
						eval('add_voucher_action.new_delay_closed_amount_'+i).value = 0;
					}
				}			
			}
		</cfif>
		total_amount();
	}
	function kasa_dovizi_hesapla(type_)//ERU20190527 tutardan girilen değerin sistem dövizini hesaplaması için eklendi. Kısmi tahsil işlemi yapılabilmesi için baştan düzenlendi.
	{	
		/* if(check_row == 0 && type_ == 1){
			alert("<cfoutput>#getlang('cheque',220,'En az bir senet seçiniz!')#</cfoutput>!");
			add_voucher_action.cash_amount.value = '';
			return false;
		} */
		var currency_type = eval(add_voucher_action.kasa.options[add_voucher_action.kasa.selectedIndex]).value;
		console.log(currency_type);
		money_type = currency_type.split(';')[1];//money_type : Seçili olan kasanın para birimi
		for (var check_row=1; check_row <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; check_row++)
		{
			if(money_type != eval("document.add_voucher_action.currencyid_" + check_row).value){
				alert("<cf_get_lang dictionary_id = '48711.Kasa ve Hesap Kurları Aynı Değil !'>");
				return false;
			}
		}
		for(s=1;s<=add_voucher_action.kur_say.value;s++)
		{
			if(eval('add_voucher_action.hidden_rd_money_'+s).value == money_type)
			{
				kasa_money_rate2 = eval('add_voucher_action.txt_rate2_' + s).value;
				kasa_money_rate1 = eval('add_voucher_action.txt_rate1_' + s).value;	
			}
		}
		if (add_voucher_action.cash_amount!=undefined && add_voucher_action.cash_amount.value!= "")
		{
			sistem_tutar=(parseFloat(filterNum(add_voucher_action.cash_amount.value))*(parseFloat(filterNum(kasa_money_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>))/parseFloat(filterNum(kasa_money_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>))));
			add_voucher_action.system_cash_amount.value=wrk_round(sistem_tutar);
		}
		if(document.add_voucher_action.system_pos_amount_first != undefined)
		{
			add_voucher_action.pos_amount.value=0;
			add_voucher_action.system_pos_amount.value=0;
			add_voucher_action.pos_amount_first.value=0;
			add_voucher_action.system_pos_amount_first.value=0;
			add_voucher_action.com_amount.value=0;
		}
		if(document.add_voucher_action.bank_amount != undefined)
		{
			add_voucher_action.bank_amount.value=0;
			add_voucher_action.system_bank_amount.value=0;
		}
		document.add_voucher_action.currency_type.value = money_type;	// kasa para birimi	
		toplam_tahsilat();
		if(type_ != undefined)
		{
		var system_total_amounts = 0;
		for (var i=1; i <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; i++)
		{
			if(eval('add_voucher_action.is_pay_'+i).checked)	
			{
				sistem_deger_satir = eval('add_voucher_action.f_other_money_value_'+i).value; 
				sistem_deger_satir =  filterNum(sistem_deger_satir);
				system_total_amounts = system_total_amounts + parseFloat(sistem_deger_satir);
			}
		}
		document.add_voucher_action.system_total_amounts.value = (parseFloat(system_total_amounts)*(parseFloat(filterNum(kasa_money_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>))/parseFloat(filterNum(kasa_money_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>)))); 
	 }
	}
	function banka_dovizi_hesapla(type_)//ERU20190531 tutardan girilen değerin sistem dövizini hesaplaması için eklendi. Kısmi tahsil işlemi yapılabilmesi için baştan düzenlendi.
	{	
		closed_amount_delay = 0;
		var currency_type = eval(add_voucher_action.action_to_account_id.options[add_voucher_action.action_to_account_id.selectedIndex]).value;
		money_type = currency_type.split(';')[1];//banka para birimi
		$('.other_currency_id_cash').html(money_type);
		$('.other_currency_id').html(money_type);
		for (var check_row=1; check_row <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; check_row++)
		{
			if(money_type != eval("document.add_voucher_action.currencyid_" + check_row).value){
				alert("<cf_get_lang dictionary_id = '48711.Kasa ve Hesap Kurları Aynı Değil !'>");
				return false;
			}
		}
		document.add_voucher_action.currency_type_bank.value = money_type;//banka para birimi
		document.add_voucher_action.currency_type.value = money_type;	// kasa para birimi		
		for(s=1;s<=add_voucher_action.kur_say.value;s++)
		{
			if(eval('add_voucher_action.hidden_rd_money_'+s).value == money_type)
			{
				bank_money_rate2 = eval('add_voucher_action.txt_rate2_' + s).value;
				bank_money_rate1 = eval('add_voucher_action.txt_rate1_' + s).value;	
			}
		}
		if (add_voucher_action.bank_amount!=undefined && add_voucher_action.bank_amount.value!= "")
		{
			sistem_tutar=(parseFloat(filterNum(add_voucher_action.bank_amount.value))*parseFloat((filterNum(bank_money_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>))/parseFloat(filterNum(bank_money_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>))));
			add_voucher_action.system_bank_amount.value=commaSplit(sistem_tutar);
		}
		if(document.add_voucher_action.system_pos_amount_first != undefined)
		{
			add_voucher_action.pos_amount.value=0;
			add_voucher_action.system_pos_amount.value=0;
			add_voucher_action.pos_amount_first.value=0;
			add_voucher_action.system_pos_amount_first.value=0;
			add_voucher_action.com_amount.value=0;
			add_voucher_action.system_com_amount.value=0;
		}
		add_voucher_action.cash_amount.value=0;
		add_voucher_action.system_cash_amount.value=0;
	}
	function pos_hesapla(type)//ERU20190715 Kısmi tahsil işlemi yapılabilmesi için baştan düzenlendi.
	{		
		add_voucher_action.cash_amount.value=0;
		add_voucher_action.system_cash_amount.value=0;
		var currency_type = eval(add_voucher_action.pos.options[add_voucher_action.pos.selectedIndex]).value;
		money_type = currency_type.split(';')[1];//pos para birimi
		for (var check_row=1; check_row <= <cfoutput>#get_vouchers.recordcount#</cfoutput>; check_row++)
		{
			if(money_type != eval("document.add_voucher_action.currencyid_" + check_row).value){
				alert("<cf_get_lang dictionary_id = '48711.Kasa ve Hesap Kurları Aynı Değil !'>");
				return false;
			}
		}
		document.add_voucher_action.currency_type.value = money_type;
		document.add_voucher_action.currency_type_pos.value = money_type;
		$('.other_currency_id').html(money_type);
		$('.other_currency_id_cash').html(money_type);
		if(document.add_voucher_action.bank_amount != undefined)
		{
			add_voucher_action.bank_amount.value=0;
			add_voucher_action.system_bank_amount.value=0;
		}
		if(add_voucher_action.pos_amount_first!= undefined)
		{
			if(add_voucher_action.pos_amount_first.value!="")
			{
				pos_money_list=new Array(1);
				<cfoutput query="get_money">
					pos_money_list.push('#get_money.money#');
				</cfoutput>
				//Komisyonlu tutar hesaplamaları..
				for(var jxj=1; jxj<=pos_money_list.length-1; jxj++ )
				{	
					pos_deger = add_voucher_action.pos.value.split(';');
					pos_currency=pos_deger[1];
					payment_rate=pos_deger[2];
					if(pos_money_list[jxj] == pos_currency)
						{
							temp_pos_amount= add_voucher_action.pos_amount_first.value;
							temp_rate2=eval('add_voucher_action.txt_rate2_' + jxj).value;
							temp_rate1=eval('add_voucher_action.txt_rate1_' + jxj).value;
							new_value = filterNum(temp_pos_amount)*(filterNum(temp_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>)/filterNum(temp_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>));						
							add_voucher_action.system_pos_amount_first.value=commaSplit(new_value);
							temp_pos_amount_= add_voucher_action.pos_amount_first.value;
							if(payment_rate != '')
							{
								pos_amount = filterNum(temp_pos_amount_) * (parseFloat(payment_rate)/100);
								add_voucher_action.com_amount.value =commaSplit(pos_amount);//komisyon tutarı
							}
							else
							{
								add_voucher_action.com_amount.value = 0;
								add_voucher_action.system_com_amount.value = 0;	
							}
							add_voucher_action.pos_amount.value = commaSplit(parseFloat(filterNum(add_voucher_action.pos_amount_first.value))+ parseFloat(filterNum(add_voucher_action.com_amount.value)));
							new_value2 =filterNum(add_voucher_action.pos_amount.value)* (filterNum(temp_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>)/filterNum(temp_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>));
							sys_com_value =filterNum(add_voucher_action.com_amount.value)* (filterNum(temp_rate2,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>)/filterNum(temp_rate1,<cfoutput>'#session.ep.our_company_info.rate_round_num#'</cfoutput>));							
							add_voucher_action.system_pos_amount.value =commaSplit(new_value2);
							add_voucher_action.system_com_amount.value =commaSplit(sys_com_value);
						}
				}
			}
			else
				add_voucher_action.system_pos_amount.value=0;
		}
	}
	function kont_action_type(type_)
	{
		if(document.add_voucher_action.cash_amount.value != 0 && type_ == 1)
		{
			amount_info = document.add_voucher_action.cash_amount.value;
			system_amount_info = document.add_voucher_action.system_cash_amount.value;
		}
		else if(document.add_voucher_action.pos_amount_first != undefined && document.add_voucher_action.pos_amount_first.value != 0)
		{
			amount_info = document.add_voucher_action.pos_amount_first.value;
			system_amount_info = document.add_voucher_action.system_pos_amount_first.value;
		}
		else if(document.add_voucher_action.bank_amount != undefined && document.add_voucher_action.bank_amount.value != 0 && type_ == 3)
		{
			amount_info = document.add_voucher_action.bank_amount.value;
			system_amount_info = document.add_voucher_action.system_bank_amount.value;
		}
		else
		{
			amount_info = 0;
			system_amount_info = 0;
		}
		if(document.add_voucher_action.action_type[0].checked == true)
		{
			document.getElementById('cash_td_1').style.display = '';
			document.getElementById('cash_td_2').style.display = '';
			document.add_voucher_action.cash_amount.value = amount_info;
			document.add_voucher_action.system_cash_amount.value = system_amount_info;
			if(document.add_voucher_action.bank_amount != undefined)
			{
				document.getElementById('bank_td_1').style.display = 'none';
				document.getElementById('bank_td_2').style.display = 'none';
				document.add_voucher_action.bank_amount.value = 0;
				document.add_voucher_action.system_bank_amount.value = 0;
			}
			if(document.add_voucher_action.pos_amount_first != undefined)
			{
				document.getElementById('pos_td_1').style.display = 'none';
				document.getElementById('pos_td_2').style.display = 'none';
				document.add_voucher_action.pos_amount_first.value = 0;
				document.add_voucher_action.system_pos_amount_first.value = 0;
			}
			kasa_dovizi_hesapla();
		}
		else if(document.add_voucher_action.action_type[2].checked == true)
		{
			document.getElementById('cash_td_1').style.display = 'none';
			document.getElementById('cash_td_2').style.display = 'none';
			document.add_voucher_action.cash_amount.value = 0;
			document.add_voucher_action.system_cash_amount.value = 0;
			if(document.add_voucher_action.bank_amount != undefined)
			{
				document.getElementById('bank_td_1').style.display = 'none';
				document.getElementById('bank_td_2').style.display = 'none';
				document.add_voucher_action.bank_amount.value = 0;
				document.add_voucher_action.system_bank_amount.value = 0;
			}
			if(document.add_voucher_action.pos_amount_first != undefined)
			{
				document.getElementById('pos_td_1').style.display = '';
				document.getElementById('pos_td_2').style.display = '';
				document.add_voucher_action.pos_amount_first.value = amount_info;
				document.add_voucher_action.system_pos_amount_first.value = system_amount_info;
				pos_hesapla();
			}
		}
		else if(document.add_voucher_action.bank_amount != undefined)
		{
			document.getElementById('bank_td_1').style.display = '';
			document.getElementById('bank_td_2').style.display = '';
			document.getElementById('cash_td_1').style.display = 'none';
			document.getElementById('cash_td_2').style.display = 'none';
			document.add_voucher_action.bank_amount.value = amount_info;
			document.add_voucher_action.system_bank_amount.value = system_amount_info;
			document.add_voucher_action.cash_amount.value = 0;
			document.add_voucher_action.system_cash_amount.value = 0;
			if(document.add_voucher_action.pos_amount_first != undefined)
			{
				document.getElementById('pos_td_1').style.display = 'none';
				document.getElementById('pos_td_2').style.display = 'none';
				document.add_voucher_action.pos_amount_first.value = 0;
				document.add_voucher_action.system_pos_amount_first.value = 0;
			}
			banka_dovizi_hesapla();
		}
	}
</script>
