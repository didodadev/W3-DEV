<!--- Banka Talimat Toplu --->
<cf_get_lang_set module_name="objects"><!--- sayfanin en altinda kapanisi var --->
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
	<cfset start_row = 1>
	<cfset end_row = 25>
    <cfset page_row = 25>
	<cfset page_count = ceiling(get_bank_orders.recordcount / page_row)>
	<cfif page_count eq 0>
		<cfset page_count = 1>
	</cfif>
	<cfset total_row = 0>	
<!--- <style>table,td{font-size:12px;font-family:Arial, Helvetica, sans-serif;}</style> --->
	<cfloop from="1" to="#page_count#" index="x">
		<cfoutput>
		<table border="0" cellspacing="0" cellpadding="0" style="width:200mm;height:293mm;">
			<tr valign="top" align="left">
				<td style="width:5mm;">&nbsp;<!--- Soldan bosluk ---></td>
				<td align="left">
					<table border="0" cellpadding="0" cellspacing="0" width="98%">
						<tr>
							<td style="height:10mm;">&nbsp;<!--- Üstten Bosluk ---></td>
						</tr>
						<tr>
							<td valign="top" align="left"><cfif len(get_company_logo.asset_file_name3)><img src="#file_web_path#settings/#get_company_logo.asset_file_name3#"></cfif></td>
						</tr>
						<tr>
							<td>
							<table border="0" width="100%" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;">
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
									<td width="80%">
										#GET_ACC_INFO.BANK_NAME#<br/>
										#GET_ACC_INFO.BANK_BRANCH_NAME#<br/>
										İSTANBUL<br/>
									</td>
									<td width="20%">
									<table style="font-size:12px; font-family:Arial, Helvetica, sans-serif;">
										<tr>
											<td style="text-align:right;"><cf_get_lang_main no='330.Tarih'>:</td>
											<td>
											<cfif isdefined("attributes.date1") and len(attributes.date1)>
												#attributes.date1#
											<cfelse>
												#DateFormat(now(),dateformat_style)#	
											</cfif>
											</td>
										</tr>
										<tr>
											<td style="text-align:right;"><cf_get_lang_main no='75.No'>:</td>
											<td>&nbsp;14-0000</td>
										</tr>
									</table>
									</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr style="font-size:12px; font-family:Arial, Helvetica, sans-serif;">
							<td style="height:15mm;">
								<cf_get_lang no="469.Nezdinizde bulunan"> <strong>#GET_ACC_INFO.ACCOUNT_NO#</strong> <cf_get_lang no="635.No lu hesabımızdan aşağıda banka ve hesap numaraları ile ünvanları belirtilen firmalara"> <br/>
								<cf_get_lang no="753.karşılarında yazılı havale miktarlarının çıkartılarak dekontlarının tarafımıza gönderilmesini rica ederiz">.<br/>
							</td>
						</tr>
						<tr>
							<td style="height:200mm;" valign="top">
							<table border="0" width="100%">
								<tr class="txtbold" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;">
									<td><cf_get_lang_main no='75.SNO'></td>
									<td><cf_get_lang_main no='340.VERGİ NO'></td>
									<td>Lehdarın <cf_get_lang_main no="159.UNVANI"></td>
									<td><cf_get_lang_main no='109.BANKA'> / <cf_get_lang_main no='41.ŞUBE'></td>
									<td><cf_get_lang_main no='766.HESAP NO'></td>
									<td style="text-align:right;"><cf_get_lang no='346.HAVALE'> <cf_get_lang_main no='261.TUTARI'> - #get_bank_orders.ACTION_MONEY#</td>
								</tr>
								<cfif x neq 1>
									<tr style="font-size:9px; font-family:Arial, Helvetica, sans-serif;">
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cf_get_lang_main no='622.Devreden'> <cf_get_lang_main no='80.Toplam'></td>
										<td style="text-align:right;">#TLFormat(total_row)#</td>
									</tr>
								</cfif>
								<cfloop query="get_bank_orders" startrow="#start_row#" endrow="#end_row#">
								<tr style="font-size:9px; font-family:Arial, Helvetica, sans-serif;">
									<td>#currentrow#</td>
									<td>#TAX_NO#</td>
									<td>#MEMBER_NAME#</td>
									<td>#MEMBER_BANK_CODE#&nbsp;#MEMBER_BANK_BRANCH_CODE#&nbsp;<cfif len(MEMBER_BANK)>#MEMBER_BANK#/</cfif>#MEMBER_BANK_BRANCH#</td>
									<td>#MEMBER_ACCOUNT_NO#</td>
									<td style="text-align:right;">#TLFormat(action_value)#</td>
								</tr>
								<cfset total_row = total_row + action_value>
								</cfloop>
								<tr>
									<td colspan="5">&nbsp;</td>
									<td><hr></td>
								</tr>
								<tr style="font-size:9px; font-family:Arial, Helvetica, sans-serif;">
									<td colspan="5">&nbsp;</td>
									<td style="text-align:right;">
										<b>
										<cfif x neq page_count>
											<cf_get_lang_main no='169.Sayfa'> <cf_get_lang_main no='80.Toplam'>
										<cfelse>
											<cf_get_lang_main no='80.Toplam'>
										</cfif>
										:       #TLFormat(total_row)#
										</b>
									</td>
								</tr>
							</table>
							</td>
						</tr>
						<cfif x eq page_count>
							<tr style="font-size:9px; font-family:Arial, Helvetica, sans-serif;">
								<td><cfset mynumber = wrk_round(total_row)>
									<cfset mybirim = get_bank_orders.ACTION_MONEY>
									<strong>YALNIZ</strong> <cf_n2txt number="mynumber" para_birimi="#mybirim#"><strong>#mynumber#</strong>
								</td>
							</tr>
							<tr style="font-size:9px; font-family:Arial, Helvetica, sans-serif;">
								<td style="text-align:right;">Saygılarımızla</td>
							</tr>
						</cfif>
					</table>
				</td>
			</tr>
		</table>
		</cfoutput>
		<cfset start_row = start_row + page_row>
		<cfset end_row = end_row + page_row>
	</cfloop>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
