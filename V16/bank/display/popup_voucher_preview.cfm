<cf_get_lang_set module_name="bank">
<cfquery name="get_voucher_preview" datasource="#dsn2#">
	SELECT 
		ACTION_TYPE,
		BA.ACTION_DATE,
		BA.ACTION_VALUE,
		BA.ACTION_CURRENCY_ID,
		C.OTHER_MONEY,
		C.OTHER_MONEY_VALUE,
		ACTION_FROM_ACCOUNT_ID,
		ACTION_TO_ACCOUNT_ID,
		VOUCHER_NO,
		BA.RECORD_EMP,
		BA.RECORD_DATE,
		'' UPDATE_EMP,
		'' UPDATE_DATE
	FROM 
		BANK_ACTIONS BA, 
		VOUCHER C 
	WHERE 
		BA.ACTION_ID = #URL.ID# AND 
		BA.VOUCHER_ID = C.VOUCHER_ID
</cfquery>
<cfoutput query="get_voucher_preview">
	<cf_popup_box title='#action_type#'>
		<table>
			<tr height="20">
				<td width="100" class="txtbold"><cf_get_lang no='25.Tarih'></td>
				<td>: #dateformat(action_date,dateformat_style)#</td>
			</tr>
			<!--- hangi kasadan --->
			<!--- hangi firmaya --->
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='109.Banka'></td>
				<td>
				<cfif len(action_from_account_id) or len(action_to_account_id)>
					<cfquery name="GET_BANK_NAME" datasource="#DSN3#">
						SELECT 
							* 
						FROM 
							ACCOUNTS
						WHERE
							<cfif len(ACTION_FROM_ACCOUNT_ID)>
								ACCOUNT_ID = #ACTION_FROM_ACCOUNT_ID#
							<cfelse>
								ACCOUNT_ID = #ACTION_TO_ACCOUNT_ID#
							</cfif>
					</cfquery>
					: #GET_BANK_NAME.ACCOUNT_NAME# 
				</cfif>
				</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no ='1090.Senet No'></td>
				<td>: #VOUCHER_NO#</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang no ='165.İşlem Para Br'></td>
				<td>: #TLFormat(ACTION_VALUE)# #ACTION_CURRENCY_ID#</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no ='765.Sistem Para Br'></td>
				<td>: #TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_voucher_preview">
			<cf_workcube_buttons is_insert="0" is_cancel="1" cancel_info="#getLang('main',141)#">	
		</cf_popup_box_footer>	
	</cf_popup_box>
</cfoutput>
