<!---E.A 23072012 select ifadeleri düzenlendi.--->
<cf_get_lang_set module_name="bank">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="get_order" datasource="#db_adres#">
	SELECT 
		BON.BANK_ORDER_TYPE,
        BON.BANK_ORDER_ID,
		BON.ACTION_VALUE,
		BON.ACCOUNT_ID,
		BON.COMPANY_ID,
		BON.CONSUMER_ID,
		BON.ACTION_DATE,
		BON.ACTION_MONEY,
		BON.PAYMENT_DATE,
		BON.RECORD_DATE,
		'' UPDATE_DATE,
		BON.RECORD_EMP,
		BON.RECORD_PAR,
		BON.RECORD_CONS,
		'' UPDATE_EMP,
		'' UPDATE_PAR,
		'' UPDATE_CONS,
		BB.BANK_NAME,
		BB.BANK_BRANCH_NAME,
		A.ACCOUNT_NO
	FROM 
		BANK_ORDERS BON,
		#dsn3_alias#.ACCOUNTS AS A,
		#dsn3_alias#.BANK_BRANCH AS BB
	WHERE 		
		A.ACCOUNT_ID = BON.ACCOUNT_ID AND
		A.ACCOUNT_BRANCH_ID=BB.BANK_BRANCH_ID AND
		<cfif isdefined("attributes.id")>
		BON.BANK_ORDER_ID = #ATTRIBUTES.id#
		<cfelse>
		BON.BANK_ORDER_ID = #ATTRIBUTES.BANK_ORDER_ID#
		</cfif>
</cfquery>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	ACS.ACTION_TYPE = #GET_ORDER.BANK_ORDER_TYPE#
		AND ACS.ACTION_ID =  #GET_ORDER.BANK_ORDER_ID#
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_ORDER.BANK_ORDER_ID#&process_cat=#GET_ORDER.BANK_ORDER_TYPE#</cfoutput>','page');"><img src="/images/extre.gif"  border="0" title="<cfoutput>#getLang('main',2577)#</cfoutput>"></a>
    </cfif>
</cfsavecontent>
<cf_popup_box title="#getLang('bank',171)#" right_images="#right#">
	<table>
		<cfoutput query="get_order">
			<tr height="20">
				<td width="100" class="txtbold"><cf_get_lang dictionary_id="47346.İşlem Adı"> </td>
				<td>: <cfif bank_order_type eq 260><cf_get_lang dictionary_id ="58167.Giden Banka Talimatı"><cfelseif bank_order_type eq 251><cf_get_lang dictionary_id="49544.Gelen Banka Talimatı"></cfif></td>
			</tr>
			<tr height="20">
				<td width="100" class="txtbold"><cf_get_lang dictionary_id = "57519.Cari Hesap"></td>
				<td>: 
					<cfif len(get_order.company_id)>
						#get_par_info(get_order.company_id,1,1,0)#
					<cfelse>
						#get_cons_info(get_order.consumer_id,0,0)#
					</cfif>
				</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang dictionary_id="57521.Banka"> </td>
				<td>: 
					<cfif len(get_order.account_id)>
						<cfquery name="get_account" datasource="#dsn3#">
							SELECT
								ACCOUNT_NAME,
								<cfif session.ep.period_year lt 2009>
									CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS ACCOUNT_CURRENCY_ID
								<cfelse>
									ACCOUNTS.ACCOUNT_CURRENCY_ID
								</cfif>
							FROM
								ACCOUNTS
							WHERE
								ACCOUNT_ID= #get_order.account_id#
						</cfquery>
						<cfoutput>#get_account.ACCOUNT_NAME# - #get_account.account_currency_id#</cfoutput>
					</cfif>
				</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang dictionary_id="57673.Tutar"></td>
				<td>: #TLFormat(get_order.action_value)# #get_order.action_money#</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang dictionary_id="58851.Ödeme Tarihi"></td>
				<td>: #dateformat(get_order.payment_date,dateformat_style)#</td>
			</tr>
			<tr height="20">
				<td valign="top" class="txtbold"><cf_get_lang dictionary_id="57879.İşlem Tarihi"></td>
				<td>: #dateformat(get_order.action_date,dateformat_style)#</td>
			</tr>
		</cfoutput>
	</table>
    <cf_popup_box_footer>
		<cf_record_info query_name="get_order">
		<cfsavecontent variable="info_"><cf_get_lang_main no='141.Kapat'></cfsavecontent>
		<cf_workcube_buttons is_insert="0" is_cancel="1" cancel_info="#info_#">
    </cf_popup_box_footer>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
