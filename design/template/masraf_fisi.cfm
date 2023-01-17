<!--- Masraf Fişi --->
<cfset attributes.expense_id = attributes.iid>
<cfquery name="get_expense" datasource="#dsn2#">	
	SELECT 
		EIP.PAPER_NO,
		EIP.EMP_ID,
		EIP.EXPENSE_DATE,
		EIP.TOTAL_AMOUNT,
		EIP.PAPER_TYPE,
		EIP.TOTAL_AMOUNT_KDVLI,
		EIP.KDV_TOTAL,
		EIP.EXPENSE_ID,
		EIP.CH_PARTNER_ID,
		EIP.CH_CONSUMER_ID,
		EIP.CH_COMPANY_ID,
        EIP.CH_EMPLOYEE_ID,
        SAT.ACC_TYPE_NAME,
		EIP.PAYMETHOD_ID,
		EIP.RECORD_EMP,
		EIP.RECORD_DATE,
		EIP.PROCESS_CAT,
		EIR.DETAIL,
		EIR.AMOUNT,
		EIR.KDV_RATE,
		EIR.AMOUNT_KDV,
		EIR.TOTAL_AMOUNT AS KDVLI_TOPLAM,
		EIR.MONEY_CURRENCY_ID,
		EIR.OTHER_MONEY_VALUE,
		ES.EXPENSE,
		EI.EXPENSE_ITEM_NAME,
		EIP.OTHER_MONEY_NET_TOTAL,
		EIP.OTHER_MONEY_KDV,
		EIP.OTHER_MONEY_AMOUNT,
		EIP.OTHER_MONEY,
		EIR.ACTIVITY_TYPE
	FROM
		EXPENSE_ITEM_PLANS EIP
        	LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SAT ON SAT.ACC_TYPE_ID = EIP.ACC_TYPE_ID,
		EXPENSE_ITEMS_ROWS EIR,
		EXPENSE_CENTER ES,
		EXPENSE_ITEMS EI
	WHERE
		EIP.EXPENSE_ID = #attributes.expense_id# AND 
		EIP.EXPENSE_ID = EIR.EXPENSE_ID AND
		EIR.EXPENSE_CENTER_ID = ES.EXPENSE_ID AND
		EIR.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID
 	ORDER BY 
 		EXP_ITEM_ROWS_ID		
</cfquery>
<cfset sayfa_sayisi = ceiling(get_expense.recordcount / 30)>

<cfif sayfa_sayisi eq 0>
	<cfset sayfa_sayisi = 1>
</cfif>

<cfset satir_start = 1>
<cfset satir_end = 30>

<cfloop from="1" to="#sayfa_sayisi#" index="j">
<table border="0" cellspacing="0" cellpadding="0" style="width:210mm;height:279.3mm;">
    <tr>
        <td style="width:9mm"></td>
        <td valign="top">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table border="0" cellspacing="0" cellpadding="0">
					<cfoutput>
					<tr>
						<td colspan="2" style="height:35mm;"></td>
					</tr>
					<tr>
						<td valign="top" style="width:162mm;height:48mm;">
						<table style="width:110mm;" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top" style="width:85mm;height:35mm;">
									<b><cf_get_lang dictionary_id='57800.İşlem Tipi'>:</b>&nbsp;&nbsp;&nbsp;
									<cfif len(get_expense.PROCESS_CAT)>
										<cfquery name="get_process_cat" datasource="#dsn3#">
											SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_expense.PROCESS_CAT#
										</cfquery>
										#get_process_cat.process_cat#
									</cfif><br/>
									<b><cf_get_lang dictionary_id='58873.Satıcı'>:</b>&nbsp;&nbsp;&nbsp;
									<cfif len(get_expense.ch_company_id)>#get_par_info(get_expense.ch_company_id,1,0,0)#</cfif><br/>
									<b><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>:</b>&nbsp;&nbsp;&nbsp;
									<cfif len(get_expense.paymethod_id)>
										<cfquery name="GET_PAYMETHOD" datasource="#dsn#">
											SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_expense.paymethod_id#
										</cfquery>
										#get_paymethod.paymethod#
									</cfif><br/>
									<b><cf_get_lang dictionary_id='57578.Yetkili'>:</b>&nbsp;&nbsp;&nbsp;
									<cfif len(get_expense.ch_partner_id)>#get_par_info(get_expense.ch_partner_id,0,-1,0)#<cfelseif len(get_expense.ch_consumer_id)>#get_cons_info(get_expense.ch_consumer_id,0,0)#<cfelseif len(get_expense.ch_employee_id)>#get_emp_info(get_expense.ch_employee_id,0,0)# - #get_expense.acc_type_name#</cfif><br/>
									<b><cf_get_lang dictionary_id='57483.Kayıt'>:</b>&nbsp;&nbsp;&nbsp;<cfif len(get_expense.record_date)>#dateformat(get_expense.record_date,dateformat_style)#</cfif><br/>
									<b><cf_get_lang dictionary_id='57483.Kayıt'> <cf_get_lang dictionary_id='57487.Numarası'>:</b>&nbsp;&nbsp;&nbsp;<cfif len(get_expense.paper_no)>#get_expense.PAPER_NO#</cfif>
								</td>
							</tr>
						</table>
						</td>
						<td valign="top">
						<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td style="height:10mm;">&nbsp;</td>
						</tr>
						<tr>
							<td style="height:7mm;">#dateformat(get_expense.expense_date,dateformat_style)#</td>
						</tr>
						</table>
						</td>
					</tr>
					</cfoutput>
				</table>
				</td>
			</tr>
			<tr>
				<td style="height:128mm" valign="top">
					<table>
						<tr>
							<td class="txtbold" style="width:50mm;"><cf_get_lang dictionary_id='57629.Açıklama'></td>
							<td class="txtbold" style="width:25mm;"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></td>
							<td class="txtbold" style="width:25mm;"><cf_get_lang dictionary_id='58551.Gider Kalemi'></td>
							<td class="txtbold" style="width:25mm;"><cf_get_lang dictionary_id='33167.Aktivite Tipi'></td>
							<td class="txtbold" align="center"><cf_get_lang dictionary_id='57673.Tutar'></td>
							<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57639.Kdv'> %</td>
						</tr>
						<cfset activity_list ="">
						<cfoutput query="get_expense" startrow="#satir_start#" maxrows="#satir_end#">
							<cfif len(activity_type) and not listfind(activity_list,activity_type)>
								<cfset activity_list = listappend(activity_list,activity_type,',')>
							</cfif>
						</cfoutput>
						<cfset activity_list=listsort(activity_list,'numeric','ASC',',')>
						<cfif len(activity_list)>
							<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
								SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_ID IN (#activity_list#) ORDER BY ACTIVITY_ID
							</cfquery>
							<cfset activity_list = listsort(listdeleteduplicates(valuelist(GET_ACTIVITY_TYPES.ACTIVITY_ID,',')),'numeric','ASC',',')>
						</cfif>
						<cfoutput query="get_expense" startrow="#satir_start#" maxrows="#satir_end#">
						<tr>
							<td style="width:50mm;">#DETAIL#</td>
							<td style="width:25mm;">#EXPENSE#</td>
							<td style="width:25mm;">#EXPENSE_ITEM_NAME#</td>
							<td style="width:25mm;"><cfif len(activity_type)>#get_activity_types.activity_name[listfind(activity_list,activity_type,',')]#</cfif></td>
							<td style="text-align:right;"> #TLFORMAT(other_money_value)#  &nbsp; #MONEY_CURRENCY_ID#</td><!--- #TLFORMAT(AMOUNT)# --->
							<td style="text-align:right;">#KDV_RATE#</td>
						</tr>
						</cfoutput>
					</table>
				</td>
			</tr>
			<cfif sayfa_sayisi eq j>  
			<tr>
				<td valign="top" style="text-align:right;">
					<table>
						<cfoutput>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'> : </td>
							<td>#TLFORMAT(get_expense.TOTAL_AMOUNT)#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='33213.Toplam Kdv'> : </td>
							<td>&nbsp;&nbsp;#TLFormat(get_expense.KDV_TOTAL)#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='34019.Kdv li Toplam'> : </td>
							<td>&nbsp;&nbsp;#TLFormat(get_expense.TOTAL_AMOUNT_KDVLI)#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='58124.Döviz Toplam'> : </td>
							<td>&nbsp;&nbsp;#TLFormat(get_expense.OTHER_MONEY_AMOUNT)#&nbsp;#get_expense.OTHER_MONEY#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57677.Döviz'> <cf_get_lang dictionary_id='57639.Kdv'> : </td>
							<td>&nbsp;&nbsp;#TLFormat(get_expense.OTHER_MONEY_KDV)#&nbsp;#get_expense.OTHER_MONEY#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='33215.Döviz Kdv li Toplam'> : </td>
							<td>&nbsp;&nbsp;#TLFormat(get_expense.OTHER_MONEY_NET_TOTAL)#&nbsp;#get_expense.OTHER_MONEY#</td>
						</tr>
						</cfoutput>
					</table>
				</td>
			</tr>
			</cfif>	
		</table>
        </td>
    </tr>
</table>
<cfset satir_start = satir_start + 30>
<cfset satir_end = satir_start + 29>
</cfloop>
