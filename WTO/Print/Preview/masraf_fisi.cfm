<!--- Masraf Fişi --->
<cfset attributes.expense_id = attributes.iid>
<cfquery name="get_expense" datasource="#dsn2#">	
	SELECT 
		EIP.PAPER_NO,
		EIP.EMP_ID,
		EIP.ACTION_TYPE,
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
<cfquery name="CHECK" datasource="#DSN#">
    SELECT 
      ASSET_FILE_NAME2,
      ASSET_FILE_NAME2_SERVER_ID,
    COMPANY_NAME
    FROM 
      OUR_COMPANY 
    WHERE 
      <cfif isdefined("attributes.our_company_id")>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
      <cfelse>
        <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
          COMP_ID = #session.ep.company_id#
        <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
          COMP_ID = #session.pp.company_id#
        <cfelseif isDefined("session.ww.our_company_id")>
          COMP_ID = #session.ww.our_company_id#
        <cfelseif isDefined("session.cp.our_company_id")>
          COMP_ID = #session.cp.our_company_id#
        </cfif> 
      </cfif> 
  </cfquery>
<cfset sayfa_sayisi = ceiling(get_expense.recordcount / 30)>

<cfif sayfa_sayisi eq 0>
	<cfset sayfa_sayisi = 1>
</cfif>
<cfset satir_start = 1>
<cfset satir_end = 30>
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfloop from="1" to="#sayfa_sayisi#" index="j">
	<table style="width:210mm">
        <tr>
            <td>
                <table width="100%">
                    <tr class="row_border">
                        <td class="print-head">
                            <table style="width:100%;">  
                                <tr>
									<cfif get_expense.action_type eq 120>
                                   		<td class="print_title"><cf_get_lang dictionary_id='58064.MASRAF FİŞİ'></td>
                                    <cfelseif  get_expense.action_type eq 121>
										<td class="print_title"><cf_get_lang dictionary_id='58065.GELİR FİŞİ'></td>
									<cfelseif get_expense.action_type eq 122>
										<td class="print_title"><cf_get_lang dictionary_id='29644.BAKIM FİŞİ'></td>
                                    </cfif>
                                    <td style="text-align:right;">
                                        <cfif len(check.asset_file_name2)>
                                        <cfset attributes.type = 1>
                                        <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                                        </cfif>
                                    </td>
                                </tr>
							</table> 
						</td>
					</tr>
					<tr class="row_border">
						<td> 
							<table  style="width:140mm">
								<cfoutput>
									<tr>
										<td style="width:100px"><b><cf_get_lang dictionary_id='57800.İşlem Tipi'></b></td></td>
										<cfif len(get_expense.PROCESS_CAT)>
											<cfquery name="get_process_cat" datasource="#dsn3#">
												SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_expense.PROCESS_CAT#
											</cfquery>
											<td>#get_process_cat.process_cat#</td>
										</cfif>
										<td style="width:100px"><b><cf_get_lang dictionary_id='57519.Cari hesap'></b></td>
										<td><cfif len(get_expense.ch_company_id)>#get_par_info(get_expense.ch_company_id,1,0,0)#</cfif></td>
									</tr>
										<tr><td style="width:100px"><b><cf_get_lang dictionary_id='57483.Kayıt'> <cf_get_lang dictionary_id='57487.Numarası'></b></td><td><cfif len(get_expense.paper_no)>#get_expense.PAPER_NO#</cfif></td>
										<td style="width:100px"><b><cf_get_lang dictionary_id='57578.Yetkili'></b></td>
										<td><cfif len(get_expense.ch_partner_id)>#get_par_info(get_expense.ch_partner_id,0,-1,0)#<cfelseif len(get_expense.ch_consumer_id)>#get_cons_info(get_expense.ch_consumer_id,0,0)#<cfelseif len(get_expense.ch_employee_id)>#get_emp_info(get_expense.ch_employee_id,0,0)# - #get_expense.acc_type_name#</cfif></td>
									</tr>
									<tr>
										<td style="width:100px"><b><cf_get_lang dictionary_id='33203.Belge tarihi'></b></td>
										<td >#dateformat(get_expense.expense_date,dateformat_style)#</td>
										<td style="width:100px"><b><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></b></td>
										<td>
											<cfif len(get_expense.paymethod_id)>
												<cfquery name="GET_PAYMETHOD" datasource="#dsn#">
													SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_expense.paymethod_id#
												</cfquery>
												#get_paymethod.paymethod#
											</cfif>
										</td>
									</tr>
								</cfoutput>
							</table>
						</td>
					</tr>
					<table>
						<tr>
							<td style="height:35px;"><b><cf_get_lang dictionary_id='30066.FİŞ'><cf_get_lang dictionary_id='57771. DETAY'></b></td>
						</tr> 
					</table>
					<table  class="print_border"  style="width:180mm">
						<tr>
							<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
							<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
							<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
							<th><cf_get_lang dictionary_id='33167.Aktivite Tipi'></th>
							<th><cf_get_lang dictionary_id='57673.Tutar'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57639.Kdv'>(%) </th>
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
							<td>#DETAIL#</td>
							<td>#EXPENSE#</td>
							<td>#EXPENSE_ITEM_NAME#</td>
							<td><cfif len(activity_type)>#get_activity_types.activity_name[listfind(activity_list,activity_type,',')]#</cfif></td>
							<td style="text-align:right;"> #TLFORMAT(other_money_value)#&nbsp;#MONEY_CURRENCY_ID#</td><!--- #TLFORMAT(AMOUNT)# --->
							<td style="text-align:right;">%#KDV_RATE#</td>
						</tr>
						</cfoutput>
					</table>
					<cfif sayfa_sayisi eq j>  
						<table>
							<tr>
								<td style="height:35px;"><b><cf_get_lang dictionary_id='57771. DETAY'></b></td>
							</tr> 
						</table>
						<table  class="print_border"  style="width:180mm">
							<cfoutput>
								<tr>
									<th><cf_get_lang dictionary_id='57492.Toplam'>  </th>
									<th><cf_get_lang dictionary_id='33213.Toplam Kdv'>  </th>
									<th><cf_get_lang dictionary_id='34019.Kdv li Toplam'>  </th>
									<th><cf_get_lang dictionary_id='58124.Döviz Toplam'>  </th>
									<th><cf_get_lang dictionary_id='57677.Döviz'> <cf_get_lang dictionary_id='57639.Kdv'>  </th><th><cf_get_lang dictionary_id='33215.Döviz Kdv li Toplam'>  </th>
								</tr>
								<tr>
									<td style="text-align:right;">#TLFORMAT(get_expense.TOTAL_AMOUNT)#&nbsp; #get_expense.MONEY_CURRENCY_ID#</td>
									<td style="text-align:right;">#TLFormat(get_expense.KDV_TOTAL)#&nbsp; #get_expense.MONEY_CURRENCY_ID#</td>
									<td style="text-align:right;">#TLFormat(get_expense.TOTAL_AMOUNT_KDVLI)#&nbsp; #get_expense.MONEY_CURRENCY_ID#</td>
									<td style="text-align:right;">#TLFormat(get_expense.OTHER_MONEY_AMOUNT)#&nbsp;#get_expense.OTHER_MONEY#</td>
									<td style="text-align:right;">#TLFormat(get_expense.OTHER_MONEY_KDV)#&nbsp;#get_expense.OTHER_MONEY#</td>
									<td style="text-align:right;">#TLFormat(get_expense.OTHER_MONEY_NET_TOTAL)#&nbsp;#get_expense.OTHER_MONEY#</td>
								</tr>
							</cfoutput>
						</table>
					</cfif>	
					<table>
						</br>
							<tr class="fixed">
							<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
							</tr>
						</br>
					</table>
				</table>
        	</td>
    	</tr>
	</table>
<cfset satir_start = satir_start + 30>
<cfset satir_end = satir_start + 29>
</cfloop>
