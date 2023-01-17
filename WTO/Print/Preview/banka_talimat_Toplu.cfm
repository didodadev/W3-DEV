<!--- Banka Talimat Toplu --->
<cf_get_lang_set module_name="objects"><!--- sayfanin en altinda kapanisi var --->
	<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfif not isdefined("attributes.action_id")>
	<cfset attributes.action_id = attributes.checked_value>
</cfif>
<cfif len(attributes.action_id)>
	<cfquery name="get_company_logo" datasource="#dsn#">
		SELECT ASSET_FILE_NAME3 FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfquery name="get_bank_orders" datasource="#dsn2#">
		SELECT
			COMPANY_BANK_CODE MEMBER_BANK_CODE,
			COMPANY_BANK_BRANCH_CODE MEMBER_BANK_BRANCH_CODE,
			COMPANY_ACCOUNT_NO MEMBER_ACCOUNT_NO,
			COMPANY.FULLNAME MEMBER_NAME,
			COMPANY.MEMBER_CODE,
			COMPANY.TAXNO TAX_NO,
			COMPANY_BANK MEMBER_BANK,
			COMPANY_BANK_BRANCH MEMBER_BANK_BRANCH,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY,
			SUM(BANK_ORDERS.ACTION_VALUE) ACTION_VALUE
		FROM
			#dsn_alias#.COMPANY_BANK,
			#dsn_alias#.COMPANY,
			BANK_ORDERS
		WHERE
			COMPANY_BANK.COMPANY_ID = COMPANY.COMPANY_ID AND
			COMPANY_BANK.COMPANY_ACCOUNT_DEFAULT = 1 AND
			COMPANY.COMPANY_ID = BANK_ORDERS.COMPANY_ID
			AND BANK_ORDERS.BANK_ORDER_ID IN(#attributes.action_id#)
		GROUP BY
			COMPANY_BANK_CODE,
			COMPANY_BANK_BRANCH_CODE,
			COMPANY_ACCOUNT_NO,
			COMPANY.FULLNAME,
			COMPANY.MEMBER_CODE,
			COMPANY.TAXNO,
			COMPANY_BANK,
			COMPANY_BANK_BRANCH,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY
	UNION ALL
		SELECT
			CONSUMER_BANK_CODE MEMBER_BANK_CODE,
			CONSUMER_BANK_BRANCH_CODE MEMBER_BANK_BRANCH_CODE,
			CONSUMER_ACCOUNT_NO MEMBER_ACCOUNT_NO,
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
			CONSUMER.MEMBER_CODE,
			CONSUMER.TAX_NO,
			CONSUMER_BANK MEMBER_BANK,
			CONSUMER_BANK_BRANCH MEMBER_BANK_BRANCH,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY,
			SUM(BANK_ORDERS.ACTION_VALUE) ACTION_VALUE
		FROM
			#dsn_alias#.CONSUMER_BANK,
			#dsn_alias#.CONSUMER,
			BANK_ORDERS
		WHERE
			CONSUMER_BANK.CONSUMER_ID = CONSUMER.CONSUMER_ID AND
			CONSUMER_BANK.CONSUMER_ACCOUNT_DEFAULT = 1 AND
			CONSUMER.CONSUMER_ID = BANK_ORDERS.CONSUMER_ID
			AND BANK_ORDERS.BANK_ORDER_ID IN(#attributes.action_id#)
		GROUP BY
			CONSUMER_BANK_CODE,
			CONSUMER_BANK_BRANCH_CODE,
			CONSUMER_ACCOUNT_NO,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER.MEMBER_CODE,
			CONSUMER.TAX_NO,
			CONSUMER_BANK,
			CONSUMER_BANK_BRANCH,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY
	UNION ALL
		SELECT
			'' MEMBER_BANK_CODE,
			'' MEMBER_BANK_BRANCH_CODE,
			'' MEMBER_ACCOUNT_NO,
			COMPANY.FULLNAME MEMBER_NAME,
			COMPANY.MEMBER_CODE,
			COMPANY.TAXNO TAX_NO,
			'' MEMBER_BANK,
			'' MEMBER_BANK_BRANCH,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY,
			SUM(BANK_ORDERS.ACTION_VALUE) ACTION_VALUE
		FROM
			#dsn_alias#.COMPANY,
			BANK_ORDERS
		WHERE
			COMPANY.COMPANY_ID = BANK_ORDERS.COMPANY_ID
			AND BANK_ORDERS.BANK_ORDER_ID IN(#attributes.action_id#)
			AND COMPANY.COMPANY_ID NOT IN(SELECT CB.COMPANY_ID FROM #dsn_alias#.COMPANY_BANK CB WHERE CB.COMPANY_ACCOUNT_DEFAULT = 1)
		GROUP BY
			COMPANY.FULLNAME,
			COMPANY.MEMBER_CODE,
			COMPANY.TAXNO,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY
	UNION ALL
		SELECT
			'' MEMBER_BANK_CODE,
			'' MEMBER_BANK_BRANCH_CODE,
			'' MEMBER_ACCOUNT_NO,
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
			CONSUMER.MEMBER_CODE,
			CONSUMER.TAX_NO,
			'' MEMBER_BANK,
			'' MEMBER_BANK_BRANCH,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY,
			SUM(BANK_ORDERS.ACTION_VALUE) ACTION_VALUE
		FROM
			#dsn_alias#.CONSUMER,
			BANK_ORDERS
		WHERE
			CONSUMER.CONSUMER_ID = BANK_ORDERS.CONSUMER_ID
			AND BANK_ORDERS.BANK_ORDER_ID IN(#attributes.action_id#)
			AND CONSUMER.CONSUMER_ID NOT IN(SELECT CB.CONSUMER_ID FROM #dsn_alias#.CONSUMER_BANK CB WHERE CB.CONSUMER_ACCOUNT_DEFAULT = 1)
		GROUP BY
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER.MEMBER_CODE,
			CONSUMER.TAX_NO,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY
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
	<cfset start_row = 1>
	<cfset end_row = 25>
    <cfset page_row = 25>
	<cfset page_count = ceiling(get_bank_orders.recordcount / page_row)>
	<cfif page_count eq 0>
		<cfset page_count = 1>
	</cfif>
	<cfset total_row = 0>	
	<cfloop from="1" to="#page_count#" index="x">
		<cfoutput>
			<table style="width:210mm">
				<tr>
					<td>
						<table width="100%">
							<tr class="row_border">
								<td class="print-head">
									<table style="width:100%;">  
										<tr>
											<td class="print_title"><cf_get_lang dictionary_id='61774. Toplu Banka talimatları'></b></td>
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
							<table>
								<tr>
									<cfquery name="GET_ACC_INFO" datasource="#dsn3#">
										SELECT 
											* 
										FROM 
											ACCOUNTS,
											BANK_BRANCH 
										WHERE 
											ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND 
											ACCOUNTS.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bank_orders.ACCOUNT_ID#">
									</cfquery>
									<td style="width:120px"><b><cf_get_lang dictionary_id='57521. banka'></b></td>
									<td >#GET_ACC_INFO.BANK_NAME#</td>
								</tr>
								<tr>
									<td style="width:120px"><b><cf_get_lang dictionary_id='57521.BANKA'> / <cf_get_lang_main dictionary_id='57453.ŞUBE'></b></td><td>#GET_ACC_INFO.BANK_BRANCH_NAME#</td>
								</tr>
								<tr>
									<td style="width:120px"><b><cf_get_lang dictionary_id='58132. semt'></b></td>
									<td>#GET_ACC_INFO.BANK_BRANCH_CITY#<td/>
								</tr>
							</table>
							<table>
								<td style="height:10mm;"><b><cf_get_lang dictionary_id="57652.Hesap"><cf_get_lang dictionary_id="57771.Detay"></b></td>
							</table>
							<table class="print_border" style="width:180mm">
								<tr >
									<th><cf_get_lang_main dictionary_id='57487.NO'></th>
									<th><cf_get_lang_main dictionary_id='57752.VERGİ NO'></th>
									<th><cf_get_lang dictionary_id='58733.ALICI'></th>
									<th><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
									<th><cf_get_lang_main dictionary_id='58178.HESAP NO'></th>
									<th style="text-align:right;"><cf_get_lang dictionary_id='42497.HAVALE'> <cf_get_lang_main dictionary_id='54452.TUTARI'> - #get_bank_orders.ACTION_MONEY#</th>
								</tr>
								<cfif x neq 1>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cf_get_lang_main no='622.Devreden'> <cf_get_lang_main no='80.Toplam'></td>
										<td style="text-align:right;">#TLFormat(total_row)#</td>
									</tr>
								</cfif>
								<cfloop query="get_bank_orders" startrow="#start_row#" endrow="#end_row#">
								<tr>
									<td>#currentrow#</td>
									<td>#TAX_NO#</td>
									<td>#MEMBER_NAME#</td>
									
									<td>#GET_ACC_INFO.ACCOUNT_NAME#</td>
									<td>#GET_ACC_INFO.ACCOUNT_NO#</td>
									<td style="text-align:right;">#TLFormat(action_value)#&nbsp;#ACTION_MONEY#</td>
								</tr>
								<cfset total_row = total_row + action_value>
								</cfloop>
								<tr >
									<cfif x neq page_count>
										<th colspan="5" style="text-align:right;"><cf_get_lang_main no='169.Sayfa'> <cf_get_lang_main no='80.Toplam'></th>
									<cfelse>
										<th colspan="5" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></th>
									</cfif>
									<td style="text-align:right;">  #TLFormat(total_row)#&nbsp;#get_bank_orders.ACTION_MONEY#</td>
								</tr>
							</table>
							<table style="width:180mm" >
								<tr >
									<td style="height:20mm;">
										<cf_get_lang dictionary_id="48812.Nezdinizde">&nbsp; <b>#GET_ACC_INFO.ACCOUNT_NO#</b>&nbsp; <cf_get_lang dictionary_id="61775.No lu hesabımızdan aşağıda banka ve hesap numaraları ile ünvanları belirtilen firmalara">
										.<cf_get_lang dictionary_id="32367.Saygılarımızla">...<br/>
									</td>
								</tr>
							</table>
							<table>
								<br>
								<tr class="fixed">
									<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
									</tr>
								</br>
							</table>
						<table>
					</td>
				</tr>
			</table>
		</cfoutput>
		<cfset start_row = start_row + page_row>
		<cfset end_row = end_row + page_row>
	</cfloop>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
