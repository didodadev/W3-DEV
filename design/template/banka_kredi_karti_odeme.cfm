adsadadasdsdasdsadasds<!--- Kredi Kartı Odeme  20080205 FB --->
<cfquery name="get_expense" datasource="#dsn3#">
	SELECT * FROM CREDIT_CARD_BANK_EXPENSE WHERE CREDITCARD_EXPENSE_ID = #attributes.action_id#
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		ACCOUNTS.ACCOUNT_CURRENCY_ID,
		CREDIT_CARD.CREDITCARD_ID,
		CREDIT_CARD.CREDITCARD_NUMBER
	FROM
		ACCOUNTS,
		CREDIT_CARD
	WHERE
		CREDIT_CARD.CREDITCARD_ID = #get_expense.CREDITCARD_ID# AND
		ACCOUNTS.ACCOUNT_ID = CREDIT_CARD.ACCOUNT_ID AND
		ACCOUNTS.ACCOUNT_ID = #get_expense.account_id#
		<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
			AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
		</cfif>
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME,
		CREDIT_CARD.CREDITCARD_ID
</cfquery>
<cfif len(get_expense.ACTION_TO_COMPANY_ID)>
	<cfquery name="GET_MEMBER_INFO" datasource="#dsn#">
		SELECT
			MEMBER_CODE,
			FULLNAME,
			COMPANY_ADDRESS ADDRESS,
			COUNTY,
			CITY,
			COUNTRY,
			SEMT,
			TAXOFFICE TAX_OFFICE,
			TAXNO TAX_NO
		FROM
			COMPANY
		WHERE 
			COMPANY_ID = #get_expense.ACTION_TO_COMPANY_ID#
	</cfquery>
<cfelse>
	<cfquery name="GET_MEMBER_INFO" datasource="#dsn#">
		SELECT 
			MEMBER_CODE,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			HOMEADDRESS ADDRESS,
			HOME_CITY_ID CITY,
			HOME_COUNTY_ID COUNTY,
			HOME_COUNTRY_ID COUNTRY,
			HOMESEMT SEMT,
			TAX_OFFICE,
			TAX_NO
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = #get_expense.CONS_ID#
	</cfquery>
</cfif>
<style type="text/css">
<!--
.style1 {font-size: 2}
-->
</style>

<br/>
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td style="width:10mm;">&nbsp;</td>
		<td style="width:115mm;">
		<table border="0">
			<tr>
				<td align="center">
				<table>
					<tr>
						<td align="center" colspan="2" class="headbold">
							<cfif get_expense.process_type eq 242><cf_get_lang_main no='1756.Kredi Kartıyla Ödeme'>
							<cfelseif get_expense.process_type eq 246><cf_get_lang_main no='1757.Kredi Kartıyla Ödeme İptal'></cfif>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table border="0" style="width:115mm;">
					<tr style="height:6mm;">
						<td style="width:18mm;"><font size="2"><strong>C/H <cf_get_lang no="256.Kodu"></strong></font></td>
						<td style="width:40mm;">: <font size="2">#GET_MEMBER_INFO.MEMBER_CODE#</font></td>
						<td align="left" nowrap><font size="2"><strong><cf_get_lang_main no='1360.İşlem No'></strong></font></td>
						<td style="width:20mm;">: <font size="2">#get_expense.creditcard_expense_id#</font></td>
					</tr>
					<tr>
						<td><font size="2"><strong><cf_get_lang_main no="159.Ünvanı"></strong></font></td>
						<td>: <font size="2"><strong><cfif len(get_expense.ACTION_TO_COMPANY_ID)>#GET_MEMBER_INFO.FULLNAME#<cfelse>#GET_MEMBER_INFO.CONSUMER_NAME# #GET_MEMBER_INFO.CONSUMER_SURNAME#</cfif></strong></font></td>
						<td align="left"><font size="2"><strong><cf_get_lang_main no='330.Tarih'></strong></font></td>
						<td style="width:20mm;">: <font size="2">#DateFormat(get_expense.action_date,dateformat_style)#</font></td>
					</tr>
					<tr>
						<td><font size="2"><strong><cf_get_lang_main no='1311.Adres'></strong></font></td>
						<td>: <font size="2">#GET_MEMBER_INFO.ADDRESS#</font></td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>: 
							<cfif len(GET_MEMBER_INFO.COUNTY)>
								<cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
									SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #GET_MEMBER_INFO.COUNTY#
								</cfquery>
							</cfif>
							<cfif len(GET_MEMBER_INFO.CITY)>
								<cfquery name="GET_CITY_HOME" datasource="#DSN#">
									SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #GET_MEMBER_INFO.CITY#
								</cfquery>				  
							</cfif>
							<font size="2"><cfif len(GET_MEMBER_INFO.COUNTY)>#GET_COUNTY_HOME.COUNTY_NAME#</cfif>&nbsp;&nbsp;<cfif len(GET_MEMBER_INFO.CITY)>#GET_CITY_HOME.CITY_NAME#</cfif></font>
						</td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td></td>
						<td>: 
							<cfif len(GET_MEMBER_INFO.COUNTRY)>
								<cfquery name="GET_COUNTRY_HOME" datasource="#DSN#">
									SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #GET_MEMBER_INFO.COUNTRY#
								</cfquery>
								<font size="2">#GET_COUNTRY_HOME.COUNTRY_NAME#</font>
							</cfif>
						</td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td><font size="2"><strong><cf_get_lang_main no='1350.Vergi D'></strong></font></td>
						<td>: <font size="2">#GET_MEMBER_INFO.TAX_OFFICE#</font></td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td><font size="2"><strong><cf_get_lang_main no='340.Vergi No'></strong></font></td>
						<td>: <font size="2">#GET_MEMBER_INFO.TAX_NO#</font></td>
						<td colspan="2"></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table border="0" style="width:115mm;">
					<tr align="center" height="30" class="formbold">
						<td style="width:80mm;"><font size="2"><cf_get_lang_main no='217.Açıklama'></font></td>
						<td style="text-align:right;"><font size="2"><cf_get_lang no="283.Meblağ"></font></td>
					</tr>
					<tr height="30" class="formbold">
						<cfset key_type = '#session.ep.company_id#'>
						<td><font size="2"><!--- #get_expense.detail#-- --->#get_accounts.account_name#/#mid(Decrypt(get_accounts.creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_accounts.creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_accounts.creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_accounts.creditcard_number,key_type,"CFMX_COMPAT","Hex")))#</font></td>
						<td style="text-align:right;"><font size="2">#TLFormat(get_expense.total_cost_value)#</font></td>
					</tr>
					<tr height="30" class="formbold">
						<td style="text-align:right;"><font size="2"><cf_get_lang_main no='80.TOPLAM'></font></td>
						<td style="text-align:right;"><font size="2">#TLFormat(get_expense.total_cost_value)#</font></td>
					</tr>
					<tr>
						<td colspan="2" valign="top">
						<br/>
						<table border="0">
							<!--- 
							<tr>
								<td><font size="2">Yukarda açıklaması yapılan toplam #TLFormat(get_expense.total_cost_value)# #session.ep.money#<br/>cari hesabınıza <cfif get_expense.process_type eq 242>Borç<cfelseif get_expense.process_type eq 246>Alacak</cfif> kaydedilmiştir.</font></td>
							</tr> --->
							<tr><td><br/><b><font size="2">#session.ep.company#</font></b></td></tr>
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
