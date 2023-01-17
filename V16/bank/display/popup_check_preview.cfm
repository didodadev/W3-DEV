<cfquery name="get_check_preview" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		BANK_ACTIONS AS BA,
		CHEQUE AS C 
	WHERE 
		BA.ACTION_ID = #URL.ID# AND 
		BA.CHEQUE_ID = C.CHEQUE_ID
</cfquery>
<cfoutput query="get_check_preview">
	<cf_popup_box title='#action_type#'>
		<table>
			<cfoutput>
				<tr height="20">
					<td width="100" class="txtbold"><cf_get_lang_main no ='595.Çek'><cf_get_lang_main no='75.No'></td>
					<td width="180">: #CHEQUE_ID# - #CHEQUE_NO# #ACCOUNT_ID#
					<td width="100" class="txtbold"><cf_get_lang_main no ='109.Banka'></td>
					<td>: #get_check_preview.BANK_NAME#</td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang_main no='261.Tutar'></td>
					<td>: #TLFormat(get_check_preview.CHEQUE_VALUE)#&nbsp;#get_check_preview.CURRENCY_ID#</td>
					<td class="txtbold"><cf_get_lang_main no ='41.Şube'></td>
					<td>: #get_check_preview.BANK_BRANCH_NAME#</td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang_main no ='765.Sistem Para Br'></td>
					<td>: #TLFormat(get_check_preview.OTHER_MONEY_VALUE)#&nbsp;#get_check_preview.OTHER_MONEY#</td>
					<td class="txtbold"><cf_get_lang_main no ='766.Hesap No'></td>
					<td>: #get_check_preview.ACCOUNT_NO#</td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang_main no ='767.Diğer para br'></td>
					<td>: <cfif len(get_check_preview.OTHER_MONEY2)></cfif>#TLFormat(get_check_preview.OTHER_MONEY_VALUE2)#&nbsp;#get_check_preview.OTHER_MONEY2#</td>
					<td class="txtbold"><cf_get_lang_main no ='768.Borçlu'></td>
					<td>: #get_check_preview.DEBTOR_NAME#</td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang_main no ='228.Vade'></td>
					<td>: #dateformat(get_check_preview.CHEQUE_DUEDATE,dateformat_style)#</td>
					<td class="txtbold"><cf_get_lang_main no ='1350.Vergi Dairesi'></td>
					<td>: #get_check_preview.TAX_PLACE#</td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang_main no ='769.Ödeme Yeri'></td>
					<td>: #get_check_preview.CHEQUE_CITY#</td>
					<td class="txtbold"><cf_get_lang_main no ='340.Vergi No'></td>
					<td>: #get_check_preview.TAX_NO#</td>
				</tr>
				<tr height="20">
					<td class="txtbold"><cf_get_lang_main no ='377.Özel Kod'></td>
					<td>: #get_check_preview.CHEQUE_CODE#</td>
					<td class="txtbold"><cf_get_lang_main no ='770.Portföy No'></td>
					<td>: #get_check_preview.CHEQUE_PURSE_NO#</td>
				</tr>
			</cfoutput>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
				<td>: #dateformat(action_date,dateformat_style)#</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_check_preview">
			<cf_workcube_buttons is_insert="0" is_cancel="1" cancel_info="#getLang('main',141)#">	
		</cf_popup_box_footer>	
	</cf_popup_box>
</cfoutput>

