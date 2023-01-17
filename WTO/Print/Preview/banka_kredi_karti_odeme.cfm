<!--- Kredi Kartı Odeme  20080205 FB --->
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
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
<cfoutput>
<table style="width:210mm">
	<tr>
		<td>
			<table width="100%">
				<tr class="row_border">
					<td class="print-head">
						<table style="width:100%;">  
							<tr>
								<cfif get_expense.process_type eq 242>
									<td class="print_title"><cf_get_lang dictionary_id='29553.Kredi Kartıyla Ödeme'></td>
								<cfelseif get_expense.process_type eq 246>
									<td class="print_title"><cf_get_lang dictionary_id='29554.Kredi Kartıyla Ödeme İptal'></td>
								<cfelseif get_expense.process_type eq 249>
									<td class="print_title"><cf_get_lang dictionary_id='61771.Kredi Kartıyla Ödeme iade'></td>
								<cfelseif get_expense.process_type eq 244>
									<td class="print_title"><cf_get_lang dictionary_id='29550.Kredi Kartı Borcu Ödeme'></td>
								<cfelseif get_expense.process_type eq 248>
									<td class="print_title"><cf_get_lang dictionary_id='29551.Kredi Kartı borcu Ödeme İptal'></td>
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
						<table>
							<tr>
								<td  style="width:140px"><b><cf_get_lang_main no='1360.İşlem No'></b></td>
								<td >#get_expense.creditcard_expense_id#</td>
							</tr>
							<tr>
								<td  style="width:140px"><b><cf_get_lang dictionary_id='34241.Kodu'></b></td>
								<td >#GET_MEMBER_INFO.MEMBER_CODE#</td>
							</tr>
							
							<tr>
								<td style="width:140px"><b><cf_get_lang dictionary_id='57519.cari hesap'></b></td>
									<td>#GET_MEMBER_INFO.FULLNAME#</td>
							</tr>
							<tr>
								<td style="width:140px"><b><cf_get_lang dictionary_id='57752.Vergi No'></b></td>
								<td>#GET_MEMBER_INFO.TAX_NO#</td>
							</tr>
							<tr>
								<td style="width:140px"><b><cf_get_lang dictionary_id='58762.Vergi D'></b></td>
								<td>#GET_MEMBER_INFO.TAX_OFFICE#</td>
							</tr>
							
							<tr>
								<td style="width:140px"><b><cf_get_lang dictionary_id='58723.Addres'></b></td>
								<td>#GET_MEMBER_INFO.ADDRESS#
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
									<cfif len(GET_MEMBER_INFO.COUNTY)>#GET_COUNTY_HOME.COUNTY_NAME#</cfif>&nbsp;&nbsp;<cfif len(GET_MEMBER_INFO.CITY)>#GET_CITY_HOME.CITY_NAME#</cfif>
									<cfif len(GET_MEMBER_INFO.COUNTRY)>
										<cfquery name="GET_COUNTRY_HOME" datasource="#DSN#">
											SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #GET_MEMBER_INFO.COUNTRY#
										</cfquery>
										#GET_COUNTRY_HOME.COUNTRY_NAME#
									</cfif>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<table>
					<tr>
						<td style="height:35px;"><b><cf_get_lang dictionary_id='57771. DETAY"'></b></td>
					</tr> 
				</table>
				<table class="print_border" style="width:140mm">
					<tr>
						<th><cf_get_lang dictionary_id='57742.tarih.'></th>
						<th><cf_get_lang dictionary_id='29449.banka hesabı'>/<cf_get_lang dictionary_id='58199.kredi kartı '></th>
						<th><cf_get_lang dictionary_id='57673.tutar'></th>
						<th><cf_get_lang dictionary_id='58056.dövizli tutar'></th>
					</tr>
					<tr>
						<td >#DateFormat(get_expense.action_date,dateformat_style)#</td>
						<cfset key_type = '#session.ep.company_id#'>
						<td><!--- #get_expense.detail#-- --->#get_accounts.account_name#/#mid(Decrypt(get_accounts.creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_accounts.creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_accounts.creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_accounts.creditcard_number,key_type,"CFMX_COMPAT","Hex")))#</td>
						<td style="text-align:right;">#TLFormat(get_expense.total_cost_value)#&nbsp;#session.ep.money#</td>
						<td style="text-align:right;">#TLFormat(get_expense.other_cost_value)#&nbsp;#get_expense.other_money#</td>
					</tr>
				</table>
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
</cfoutput>
