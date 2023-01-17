<cfif not(isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.employee))>
<cfquery name="GET_ACTIVITY_SUMMARY_DAILY" datasource="#dsn2#">
	SELECT
			SUM(GET_PURCHASES) GET_PURCHASES,
			SUM(GET_PURCHASES2) GET_PURCHASES2,
			SUM(GET_PURCHASE_DIFF) GET_PURCHASE_DIFF,
			SUM(GET_PURCHASE_DIFF2) GET_PURCHASE_DIFF2,
			SUM(GET_PURCHASE_RETURN) GET_PURCHASE_RETURN,
			SUM(GET_PURCHASE_RETURN2) GET_PURCHASE_RETURN2,
			SUM(GET_EXPENSE) GET_EXPENSE,
			SUM(GET_EXPENSE2) GET_EXPENSE2,
			SUM(GET_SALES) GET_SALES,
			SUM(GET_SALES2) GET_SALES2,
			SUM(GET_SALES_DIFF) GET_SALES_DIFF,
			SUM(GET_SALES_DIFF2) GET_SALES_DIFF2,
			SUM(GET_SALES_RETURN) GET_SALES_RETURN,
			SUM(GET_SALES_RETURN2) GET_SALES_RETURN2,
			SUM(GET_INCOME) GET_INCOME,
			SUM(GET_INCOME2) GET_INCOME2,
			SUM(GET_CASH) GET_CASH,
			SUM(GET_CASH2) GET_CASH2,
			SUM(GET_CHEQUE) GET_CHEQUE,
			SUM(GET_CHEQUE2)GET_CHEQUE2,
			SUM(GET_CHEQUE_RETURN) GET_CHEQUE_RETURN,
			SUM(GET_CHEQUE2_RETURN) GET_CHEQUE_RETURN2,
			SUM(GET_VOUCHER) GET_VOUCHER,
			SUM(GET_VOUCHER2)GET_VOUCHER2,
			SUM(GET_VOUCHER_RETURN) GET_VOUCHER_RETURN,
			SUM(GET_VOUCHER2_RETURN) GET_VOUCHER_RETURN2,
			SUM(GET_REVENUE) GET_REVENUE,
			SUM(GET_REVENUE2)GET_REVENUE2,
			SUM(GET_CREDIT_REVENUE) GET_CREDIT_REVENUE,
			SUM(GET_CREDIT_REVENUE2)GET_CREDIT_REVENUE2,
			SUM(GET_PAYM) GET_PAYM,
			SUM(GET_PAYM2)GET_PAYM2,
			SUM(GET_CHEQUE_P) GET_CHEQUE_P,
			SUM(GET_CHEQUE_P2) GET_CHEQUE_P2,
			SUM(GET_CHEQUE_P_RETURN) GET_CHEQUE_P_RETURN,
			SUM(GET_CHEQUE_P2_RETURN) GET_CHEQUE_P_RETURN2,
			SUM(GET_VOUCHER_P) GET_VOUCHER_P,
			SUM(GET_VOUCHER_P2) GET_VOUCHER_P2,
			SUM(GET_VOUCHER_P_RETURN) GET_VOUCHER_P_RETURN,
			SUM(GET_VOUCHER_P2_RETURN) GET_VOUCHER_P_RETURN2,
			SUM(GET_PAYMENTS) GET_PAYMENTS,
			SUM(GET_PAYMENTS2) GET_PAYMENTS2,
			SUM(GET_CREDIT_PAYMENTS) GET_CREDIT_PAYMENTS,
			SUM(GET_CREDIT_PAYMENTS2) GET_CREDIT_PAYMENTS2
		<cfif len(attributes.company_id) and len(attributes.member_name)>
			,COMPANY_ID
		<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
			,CONSUMER_ID
		</cfif>
	FROM
		<cfif len(attributes.company_id) and len(attributes.member_name)>
			ACTIVITY_SUMMARY_DAILY_FOR_COMPANY WITH (NOLOCK)
		<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
			ACTIVITY_SUMMARY_DAILY_FOR_CONSUMER WITH (NOLOCK)
		<cfelseif len(attributes.branch_id)>
			ACTIVITY_SUMMARY_DAILY WITH (NOLOCK)
		</cfif>
	WHERE
		1=1
		<cfif len(attributes.company_id) and len(attributes.member_name)>
			AND COMPANY_ID = #attributes.company_id#
		<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
			AND CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif len(attributes.branch_id)>
			AND (
				FROM_BRANCH_ID IN(#attributes.branch_id#) OR
				TO_BRANCH_ID IN(#attributes.branch_id#)
			)
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdate(attributes.start_date)>
			AND ACTION_DATE >= #attributes.start_date#
		<cfelseif isdate(attributes.finish_date)>
			AND ACTION_DATE <= #attributes.finish_date#
		</cfif>
	<cfif (len(attributes.company_id) and len(attributes.member_name)) or (len(attributes.consumer_id) and len(attributes.member_name))>
		GROUP BY 
			<cfif len(attributes.company_id) and len(attributes.member_name)>
				COMPANY_ID
			<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
				CONSUMER_ID
			</cfif>
	</cfif>
</cfquery>
<cfscript>
brut_alis_toplam_money2 = 0;
brut_alis_toplam = 0;
net_alis_toplam = 0;
net_alis_toplam_money2 = 0;
brut_satis_toplam_money2 = 0;
brut_satis_toplam = 0;
net_satis_toplam = 0;
net_satis_toplam_money2 = 0;
tahsilat_toplam = 0;
tahsilat_toplam_money2 = 0;
odeme_toplam = 0;
odeme_toplam_money2 = 0;
</cfscript>
<cfoutput>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='57921.Cari Faaliyet Özeti'></cfsavecontent>
<cf_seperator title="#head#" id="cari1">
<div id="cari1" style="padding: 10px; display: block;float: left; width: 100%">
	<!--- alislar --->
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang no ='1100.Alışlar'></th>
					<th style="text-align:right;">#session.ep.money#</th>
					<th style="text-align:right;">#session.ep.money2#</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<cf_get_lang no ='1100.Alışlar'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang_main no ='902.Satıştan İadeler'> (+)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1101.Fiyat ve Vade Farkları'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1102.Brüt Alış'>
					</td>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES)><cfset brut_alis_toplam = brut_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)><cfset brut_alis_toplam = brut_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF)><cfset brut_alis_toplam = brut_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF></cfif>

					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2)><cfset brut_alis_toplam_money2 = brut_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)><cfset brut_alis_toplam_money2 = brut_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2)><cfset brut_alis_toplam_money2 = brut_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2></cfif>
					<td style="text-align:right;">#TLFormat(brut_alis_toplam)# #session.ep.money#</td>
					<td style="text-align:right;">#TLFormat(brut_alis_toplam_money2)# #session.ep.money2#</td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1103.Alıştan İadeler'> (-)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
					<cf_get_lang no ='1104.Masraf Fişi ve Dekont'>	
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang no ='1105.Net Alış'> </td>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)><cfset net_alis_toplam = net_alis_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE></cfif>

					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE2></cfif>
					<td style="text-align:right;">#TLFormat(net_alis_toplam)# #session.ep.money#</td>
					<td style="text-align:right;">#TLFormat(net_alis_toplam_money2)# #session.ep.money2#</td>
				</tr>
			</tbody>
		</cf_grid_list>
	</div>
	<!--- satislar--->
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang no ='824.Satışlar'></th>
					<th style="text-align:right;">#session.ep.money#</th>
					<th style="text-align:right;">#session.ep.money2#</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<cf_get_lang no ='824.Satışlar'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1103.Alıştan İadeler'>(+)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1101.Fiyat ve Vade Farkları'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1106.Brüt Satış'>
					</td>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES)><cfset brut_satis_toplam = brut_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)><cfset brut_satis_toplam = brut_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF)><cfset brut_satis_toplam = brut_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF></cfif>

					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2)><cfset brut_satis_toplam_money2 = brut_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)><cfset brut_satis_toplam_money2 = brut_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2)><cfset brut_satis_toplam_money2 = brut_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2></cfif>
					<td style="text-align:right;">#TLFormat(brut_satis_toplam)# #session.ep.money#</td>
					<td style="text-align:right;">#TLFormat(brut_satis_toplam_money2)# #session.ep.money2#</td>
				</tr>
				<tr>
					<td>
						<cf_get_lang_main no='902.Satıştan İadeler '>(-)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1118.Gelir Fişi ve Dekont'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang no ='1107.Net Satış'></td>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES)><cfset net_satis_toplam = net_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)><cfset net_satis_toplam = net_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF)><cfset net_satis_toplam = net_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)><cfset net_satis_toplam = net_satis_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME)><cfset net_satis_toplam = net_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME></cfif>

					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME2></cfif>
					<td style="text-align:right;">#TLFormat(net_satis_toplam)# #session.ep.money#</td>
					<td style="text-align:right;">#TLFormat(net_satis_toplam_money2)# #session.ep.money2#</td>
				</tr>
			</tbody>
		</cf_grid_list>
	</div>
	
	<!--- tahsilatlar--->
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang no ='1108.Tahsilatlar'></th>
					<th style="text-align:right;">#session.ep.money#</th>
					<th style="text-align:right;">#session.ep.money2#</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
					<cf_get_lang_main no='1233.Nakit'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1110.Çek Tahsilat'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1111.Çek İade Çıkış'>(-)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1112.Çek İade Giriş'>(+)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1113.Senet Tahsilat'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1114.Senet İade Çıkış'>(-)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1115.Senet İade Giriş'>(+)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
					<cf_get_lang_main no ='427.Kredi Tahsilatı'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang_main no ='109.Banka'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no ='80.Toplam'></td>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CASH></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)><cfset tahsilat_toplam = tahsilat_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)><cfset tahsilat_toplam = tahsilat_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE></cfif>
	
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CASH2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE2></cfif>
					<td style="text-align:right;">#TLFormat(tahsilat_toplam)# #session.ep.money#</td>
					<td style="text-align:right;">#TLFormat(tahsilat_toplam_money2)# #session.ep.money2#</td>
				</tr>
			</tbody>
		</cf_grid_list>
	</div>
		
	
	<!--- odemeler--->
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang_main no='1246.Ödemeler'></th>
					<th style="text-align:right;">#session.ep.money#</th>
					<th style="text-align:right;">#session.ep.money2#</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<cf_get_lang_main no='1233.Nakit'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1119.Çek Ödeme'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1112.Çek İade Giriş'> (-)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1111.Çek İade Çıkış'> (+)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1120.Senet Ödeme'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1115.Senet İade Giriş'> (-)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang no ='1114.Senet İade Çıkış'> (+)
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN2)# #session.ep.money2#</cfif></td>
				</tr>			
				<tr>
					<td>
						<cf_get_lang_main no ='426.Kredi Ödemesi'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td>
						<cf_get_lang_main no ='109.Banka'>
					</td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS)# #session.ep.money#</cfif></td>
					<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS2)# #session.ep.money2#</cfif></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no ='80.Toplam'></td>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)><cfset odeme_toplam = odeme_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)><cfset odeme_toplam = odeme_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS></cfif>
	
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN2)><cfset odeme_toplam_money2 = odeme_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN2)><cfset odeme_toplam_money2 = odeme_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS2></cfif>
					<td align="right" style="text-align:right;">#TLFormat(odeme_toplam)# #session.ep.money#</td>
					<td align="right" style="text-align:right;">#TLFormat(odeme_toplam_money2)# #session.ep.money2#</td>
				</tr>
			</tbody>
		</cf_grid_list>
	</div>

	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">

		<cfif isdefined("attributes.graph_type") and len(attributes.graph_type)>
			<cfset graph_type = attributes.graph_type>
		<cfelse>
			<cfset graph_type = 'bar'>
		</cfif>
		<cfsavecontent variable="message"><cf_get_lang no ='840.Toplam Satış'></cfsavecontent>
		<cfset value="#net_satis_toplam#">
		<cfsavecontent variable="message"><cf_get_lang no ='1172.Toplam Alış'></cfsavecontent>
		<cfset value="#net_alis_toplam#">
		<cfsavecontent variable="message"><cf_get_lang no ='1173.Toplam Tahsilat'></cfsavecontent>
		<cfset value="#tahsilat_toplam#">
		<cfsavecontent variable="message"><cf_get_lang no ='1174.Toplam Ödeme'></cfsavecontent>
		<cfset value="#odeme_toplam#">

		<script src="JS/Chart.min.js"></script>
		<canvas id="myChart" <cfif #graph_type# eq 'bar'>style="max-width:1000px;max-height:1000px;margin-top:0;"<cfelse>style="max-width:500px;max-height:500px;margin-top:0;"</cfif>></canvas>
		<script>
			var ctx = document.getElementById("myChart");
			var myChart = new Chart(ctx, {
				type: '<cfoutput>#graph_type#</cfoutput>',
				data: {
					labels: ["<cf_get_lang no ='840.Toplam Satış'>","<cf_get_lang no ='1172.Toplam Alış'>","<cf_get_lang no ='1173.Toplam Tahsilat'>","<cf_get_lang no ='1174.Toplam Ödeme'>"],
					datasets: [{
						label: ['<cf_get_lang_main no='509.Cari Faaliyet Özeti'>'],
						data: [<cfoutput>#net_satis_toplam#</cfoutput>,<cfoutput>#net_alis_toplam#</cfoutput>,<cfoutput>#tahsilat_toplam#</cfoutput>,<cfoutput>#odeme_toplam#</cfoutput>],
						backgroundColor: [<cfloop from="1" to="5" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
						borderWidth: 1
					} 
					]
				},
				options: {
					legend: {
						display: false
					}
				}
			});
		</script>
	</div>
</div>
</cfoutput>
</cfif>
