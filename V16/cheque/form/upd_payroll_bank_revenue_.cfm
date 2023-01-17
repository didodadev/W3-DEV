<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined("attributes.id")>
	<cfset attributes.CHEQUE_PAYROLL_ID = attributes.id>
</cfif>
<cfinclude template="../query/get_money_rate.cfm">
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT
		PAYROLL.*
	FROM
		PAYROLL, 
		CASH_ACTIONS
	WHERE
		CASH_ACTIONS.ACTION_ID= #url.id# AND
		PAYROLL.ACTION_ID = CASH_ACTIONS.PAYROLL_ID AND
		PAYROLL.PAYROLL_TYPE = 92
</cfquery>
<cfquery name="GET_CHEQUE_DETAIL" datasource="#dsn2#">
	SELECT
		CHEQUE.CHEQUE_NO,
		CHEQUE.BANK_NAME,
		CHEQUE.BANK_BRANCH_NAME,
		CHEQUE.CHEQUE_DUEDATE,
		CHEQUE.CHEQUE_VALUE,
		CHEQUE.CURRENCY_ID,
		CHEQUE.OTHER_MONEY_VALUE,
		CHEQUE.OTHER_MONEY	
	FROM
		CHEQUE_HISTORY, 
		CHEQUE
	WHERE 
		CHEQUE_HISTORY.PAYROLL_ID = #attributes.id# AND
		CHEQUE_HISTORY.STATUS = 3 AND
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
</cfquery>
<cf_popup_box title="#getLang('cheque',104)#"><!--- Cikis Bordrosu-Tahsil --->
	<table>
		<cfoutput>
			<tr>
				<td width="60" class="txtbold"><cf_get_lang no='11.Bordro No'></td>
				<td width="100">:<cfif len(get_action_detail.payroll_no)><cfoutput>#get_action_detail.payroll_no#</cfoutput></cfif></td>
				<td width="60" class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
				<td>: <cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput></td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='108.Kasa'></td>
				<td>: <cfset cash_id=get_action_detail.payroll_cash_id>
					<cfinclude template="../query/get_action_cash.cfm">
					#get_action_cash.cash_name#</td>
				<td class="txtbold"><cf_get_lang no='38.Tahsil Eden'></td>
				<td>: <input type="hidden" name="employye_id" id="employye_id" value="#get_action_detail.payroll_rev_member#">#get_emp_info(get_action_detail.payroll_rev_member,0,0)#</td>
			</tr>
		</cfoutput>
		<tr><td>&nbsp;</td></tr> 
		<tr class="txtbold">
			<td><cf_get_lang no='25.Çek No'></td>
			<td><cf_get_lang_main no='109.Banka'></td>
			<td><cf_get_lang_main no='1529.Subesi'></td>
			<td><cf_get_lang_main no='228.Vade'></td>
			<td><cf_get_lang no='77.İşlem Para Br.'></td>
			<td><cf_get_lang no='68.Sistem Para Br.'></td>
		</tr>
		<cfoutput query="GET_CHEQUE_DETAIL">
			<tr>
				<td>#cheque_no#</td>
				<td>#bank_name#</td>
				<td>#bank_branch_name#</td>
				<td>#dateformat(cheque_duedate,dateformat_style)#</td>
				<td>#TLFormat(CHEQUE_VALUE)# #CURRENCY_ID#</td>
				<td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
			</tr>
			<tr valign="top">
				<td colspan="6"><hr></td>
			</tr>
		</cfoutput>
		<tr><td>&nbsp;</td></tr> 
		<tr><td>&nbsp;</td></tr> 
		<cfoutput>
			<tr>
				<td width="75"><strong><cf_get_lang no='38.Tahsil Eden'></strong></td>
				<td>: <cfif isdefined("get_action_detail.payroll_rev_member") and len(get_action_detail.payroll_rev_member)> #get_emp_info(get_action_detail.payroll_rev_member,0,0)#</cfif>
				</td>
			</tr>
			<cfif len(get_action_detail.masraf)><cfset masraf_=get_action_detail.masraf><cfelse><cfset masraf_=0></cfif>
			<tr>
				<td><strong><cf_get_lang_main no='595.Çek'></strong></td>
				<td>: #TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</td>
				<td><strong><cf_get_lang_main no='1518.Masraf'></strong></td>
				<td>: #TLFormat(masraf_)# #get_money_rate.money#</td>
				<td><strong><cf_get_lang_main no='80.Toplam'></strong></td>
				<cfif len(get_action_detail.payroll_total_value)>
					<cfset total_value = get_action_detail.payroll_total_value>
				<cfelse>
					<cfset total_value = 0>
				</cfif>
				<td>: #TLFormat(total_value-masraf_)# #get_money_rate.money#</td>
			</tr>					
		</cfoutput>	
		<tr><td>&nbsp;</td></tr> 
		<tr><td>&nbsp;</td></tr> 
		<tr>
			<td class="txtbold" colspan="6"><cf_get_lang_main no='1536.Bu İşlemi Çek İşlemleri Bölümünde Güncelleyebilirsiniz'></td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cfif len(get_action_detail.record_emp)>
			<cf_record_info query_name="get_action_detail">
		</cfif>
	</cf_popup_box_footer>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
