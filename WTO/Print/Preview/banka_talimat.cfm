<cf_get_lang_set module_name="bank">
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<!--- Banka Talimatı --->
<cfif len(attributes.action_id)>
	<cfquery name="get_company_logo" datasource="#dsn#">
		SELECT 
        	ASSET_FILE_NAME3,
            ASSET_FILE_NAME3_SERVER_ID,
            ADDRESS 
        FROM 
        	OUR_COMPANY 
        WHERE 
        	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
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
			COMPANY_IBAN_CODE MEMBER_IBAN_CODE,
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
			COMPANY_IBAN_CODE,
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
			CONSUMER_IBAN_CODE MEMBER_IBAN_CODE,
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
			CONSUMER_IBAN_CODE,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY
	UNION ALL
		SELECT
			EMP_BANK_ID MEMBER_BANK_CODE,
			BANK_BRANCH_CODE MEMBER_BANK_BRANCH_CODE,
			BANK_ACCOUNT_NO MEMBER_ACCOUNT_NO,
			EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME MEMBER_NAME,
			EMPLOYEES.MEMBER_CODE,
			'' TAX_NO,
			BANK_NAME MEMBER_BANK,
			BANK_BRANCH_NAME MEMBER_BANK_BRANCH,
			IBAN_NO MEMBER_IBAN_CODE,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY,
			SUM(BANK_ORDERS.ACTION_VALUE) ACTION_VALUE
		FROM
			#dsn_alias#.EMPLOYEES_BANK_ACCOUNTS,
			#dsn_alias#.EMPLOYEES,
			BANK_ORDERS
		WHERE
			EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			EMPLOYEES_BANK_ACCOUNTS.DEFAULT_ACCOUNT = 1 AND
			EMPLOYEES.EMPLOYEE_ID = BANK_ORDERS.EMPLOYEE_ID
			AND BANK_ORDERS.BANK_ORDER_ID IN(#attributes.action_id#)
		GROUP BY
			EMP_BANK_ID,
			BANK_BRANCH_CODE,
			BANK_ACCOUNT_NO,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEES.MEMBER_CODE,
			BANK_NAME,
			BANK_BRANCH_NAME,
			IBAN_NO,
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
            '' MEMBER_IBAN_CODE,
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
            '' MEMBER_IBAN_CODE,
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
	UNION ALL
		SELECT
			'' MEMBER_BANK_CODE,
			'' MEMBER_BANK_BRANCH_CODE,
			'' MEMBER_ACCOUNT_NO,
			EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME MEMBER_NAME,
			EMPLOYEES.MEMBER_CODE,
            '' ,
			'' MEMBER_BANK,
			'' MEMBER_BANK_BRANCH,
            '' MEMBER_IBAN_CODE,
			BANK_ORDERS.ACCOUNT_ID,
			BANK_ORDERS.ACTION_MONEY,
			SUM(BANK_ORDERS.ACTION_VALUE) ACTION_VALUE
		FROM
			#dsn_alias#.EMPLOYEES,
			BANK_ORDERS
		WHERE
			EMPLOYEES.EMPLOYEE_ID = BANK_ORDERS.EMPLOYEE_ID
			AND BANK_ORDERS.BANK_ORDER_ID IN(#attributes.action_id#)
		GROUP BY
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEES.MEMBER_CODE,
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
	<cfset start_row = 1>
	<cfset end_row = 20>
    <cfset page_row = 20>
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
											<td class="print_title"><cf_get_lang dictionary_id='48821.Banka talimatları'></b></td>
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
									<table >
										<tr>
											<td style="width:100px"><b><cf_get_lang dictionary_id='58733.ALICI'></b></td>
											<td>#get_bank_orders.MEMBER_NAME#</td>
										</tr>
										<tr>
											<td style="width:100px"><b><cf_get_lang dictionary_id='57521.BANKA'></b></td>
											<td>#GET_ACC_INFO.BANK_NAME#</td>
										</tr>
										<tr >
										<tr>
											<td style="width:100px"><b><cf_get_lang dictionary_id='57453.ŞUBE'></b></td>
											<td>#GET_ACC_INFO.BANK_BRANCH_NAME#<cf_get_lang dictionary_id="58941.ŞUBESİ"></td>
										</tr>
											<td style="width:100px"><b><cf_get_lang dictionary_id='58132. semt'></b></td>
											<td>#GET_ACC_INFO.BANK_BRANCH_CITY#</td>
										</tr>
										
										<tr>
											<td style="width:100px"><b><cf_get_lang dictionary_id='54332.IBAN NO'></b></td>
											<td>#GET_ACC_INFO.account_owner_customer_no#</td>
										</tr>
										<tr>
											<td style="width:100px"><b><cf_get_lang dictionary_id='57673.TUTAR'></b></td>
											<td>#TLFormat(get_bank_orders.ACTION_VALUE)# #get_bank_orders.ACTION_MONEY#
											<cfset mynumber= wrk_round(get_bank_orders.ACTION_VALUE)>
												<cfset birim = get_bank_orders.ACTION_MONEY>
												<cfif mynumber neq 0>
													<strong></strong><cf_n2txt number="mynumber" para_birimi="#birim#"><cfoutput>(#mynumber#)</cfoutput>
												<cfelse>
													<cfoutput>(#mynumber#)</cfoutput>
												</cfif>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<table>
								<cfif x eq page_count>
									<tr >
										<td>
											<cf_get_lang dictionary_id="48812.Nezdinizde">&nbsp;<b> #GET_ACC_INFO.ACCOUNT_NO#</b>&nbsp; <cf_get_lang dictionary_id="61773.nolu hesabımızdan aşağıda detayları verilen Havale / EFT / Virman işleminin yapılmasını rica ederiz">.
										</td>
									</tr>
									<tr>	
										<td style="height:35px;" ><cf_get_lang dictionary_id="32367.Saygılarımızla">...
									</tr>
								</cfif>
									<tr class="fixed">
									<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
									</tr>
							</table>
						</table>
					</td>
				</tr>
			</table>
		</cfoutput>
		<cfset start_row = start_row + page_row>
		<cfset end_row = end_row + page_row>
	</cfloop>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
