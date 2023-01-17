<cf_get_lang_set module_name="bank">
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
	<cfset start_row = 1>
	<cfset end_row = 20>
    <cfset page_row = 20>
	<cfset page_count = ceiling(get_bank_orders.recordcount / page_row)>
	<cfif page_count eq 0>
		<cfset page_count = 1>
	</cfif>
	<cfset total_row = 0>	
<style>
	.box_yazi {border : 0px none #e1ddda;border-width : 0px 0px 0px 0px;border-bottom-width : 0px;background-color : transparent;background-color:#FFFFFF;text-align: left;font:Arial, Helvetica, sans-serif;font-size:12px;} 
	table,td{font-size:12px;}
</style>
<cfloop from="1" to="#page_count#" index="x">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0" style="height:290mm;">
	<tr valign="top" align="left">
		<td style="width:10mm;">&nbsp;</td>
		<td align="left">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td style="height:10mm;">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" align="left">
						<cfif len(get_company_logo.asset_file_name3)>
                        	<cf_get_server_file output_file="settings/#get_company_logo.asset_file_name3#" output_server="#get_company_logo.asset_file_name3_server_id#" output_type="5">
						</cfif>
					</td>
				</tr>
                <tr style="height:5mm;"><td>&nbsp;</td></tr>
				<tr>
					<td>
                        <table border="0" width="100%">
                            <tr>
                            	<td style="text-align:right;" class="formbold">
                                    <cfif isdefined("attributes.date1") and len(attributes.date1)>
                                        #attributes.date1#
                                    <cfelse>
                                        #DateFormat(now(),dateformat_style)#	
                                  </cfif>
                                </td>
                            </tr>
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
                                <td colspan="2" class="formbold" style="height:15mm;">
                                    #GET_ACC_INFO.BANK_NAME#<br/>
                                    #GET_ACC_INFO.BANK_BRANCH_NAME# <cf_get_lang_main no="1529.ŞUBESİ">
                                </td>
                            </tr>
                            <tr style="height:5mm;">
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                            <tr style="height:5mm;">
                            	<td colspan="2" class="formbold">#GET_ACC_INFO.BANK_BRANCH_CITY#</td>
                            </tr>
                            <tr style="height:10mm;">
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                            <cfif x eq page_count>
                                <tr>
                                    <td style=" width:170mm;height:12mm;" colspan="2" class="formbold">
                                        <cf_get_lang no="151.Nezdinizde"> #GET_ACC_INFO.ACCOUNT_NO# <cf_get_lang no="152.nolu hesabımızdan aşağıda detayları verilen Havale / EFT / Virman işleminin yapılmasını rica ederiz">.
                                    </td>
                                </tr>
                                <tr><td colspan="2" style="height:10mm;">&nbsp;</td></tr>
                                <tr><td colspan="2" align="left" class="formbold"><cf_get_lang no="153.Saygılarımızla"></td></tr>
                            </cfif>
                            <tr>
                                <td colspan="2" style="height:50mm;">&nbsp;</td>
                            </tr>
                            <tr>
                            	<td colspan="2">
								<table border="0">
									<tr>
										<td style="width:25mm;" class="formbold"><cf_get_lang_main no='1321.ALICI'></td>
										<td>:&nbsp;#get_bank_orders.MEMBER_NAME#</td>
									</tr>
									<tr>
										<td style="width:25mm;" class="formbold"><cf_get_lang_main no='109.BANKA'></td>
										<td>:&nbsp;#get_bank_orders.MEMBER_BANK#</td>
									</tr>
									<tr>
										<td style="width:25mm;" class="formbold"><cf_get_lang_main no='41.ŞUBE'></td>
										<td>:&nbsp;#get_bank_orders.MEMBER_BANK_BRANCH#</td>
									</tr>
									<tr>
										<td style="width:25mm;" class="formbold"><cf_get_lang_main no='1595.IBAN NO'></td>
										<td>:&nbsp;#get_bank_orders.MEMBER_IBAN_CODE#</td>
									</tr>
									<tr>
										<td style="width:25mm;" class="formbold"><cf_get_lang_main no='261.TUTAR'></td>
										<td>:&nbsp;#TLFormat(get_bank_orders.ACTION_VALUE)# #get_bank_orders.ACTION_MONEY#
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
                        </table>
					</td>
				</tr>
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
