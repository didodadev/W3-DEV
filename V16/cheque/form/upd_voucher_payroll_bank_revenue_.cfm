<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined("attributes.id")>
  <cfset attributes.VOUCHER_PAYROLL_ID = attributes.id>
</cfif>
<cfinclude template="../query/get_money_rate.cfm">
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT
		VOUCHER_PAYROLL.*
	FROM
		VOUCHER_PAYROLL, 
		CASH_ACTIONS
	WHERE
		CASH_ACTIONS.ACTION_ID = #url.id# AND
		VOUCHER_PAYROLL.ACTION_ID = CASH_ACTIONS.PAYROLL_ID AND
		VOUCHER_PAYROLL.PAYROLL_TYPE = 104
</cfquery>
<cfquery name="GET_VOUCHER_DETAIL" datasource="#dsn2#">
	SELECT
		VOUCHER.VOUCHER_NO,
		VOUCHER.VOUCHER_DUEDATE,
		VOUCHER.VOUCHER_VALUE,
		VOUCHER.CURRENCY_ID,
		VOUCHER_HISTORY.OTHER_MONEY_VALUE,
		VOUCHER_HISTORY.OTHER_MONEY	
	FROM
		VOUCHER_HISTORY, 
		VOUCHER
	WHERE 
		VOUCHER_HISTORY.PAYROLL_ID = #get_action_detail.action_id# AND
		VOUCHER_HISTORY.STATUS = 3 AND
		VOUCHER.VOUCHER_ID = VOUCHER_HISTORY.VOUCHER_ID
</cfquery>
<cf_popup_box title="#getLang('cheque',108)#">
	<table>
		<cfoutput>
			<tr height="20">
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
				<td width="100" class="txtbold"><cf_get_lang no='38.Tahsil Eden'></td>
				<td>: <input type="hidden" name="employye_id" id="employye_id" value="#get_action_detail.payroll_rev_member#">#get_emp_info(get_action_detail.payroll_rev_member,0,0)#</td>
			</tr>
		</cfoutput>
	</table>
	<br />
	<table width="98%">
		<tr height="22" class="txtbold">
			<td><cf_get_lang_main no="1090.Senet No"></td>
			<td><cf_get_lang_main no='228.Vade'></td>
			<td><cf_get_lang no='77.İşlem Para Br.'></td>
			<td><cf_get_lang no='68.Sistem Para Br.'></td>
		</tr>
		<cfoutput query="GET_VOUCHER_DETAIL">
			<tr>
				<td>#VOUCHER_no#</td>
				<td>#dateformat(VOUCHER_duedate,dateformat_style)#</td>
				<td>#TLFormat(VOUCHER_VALUE)# #CURRENCY_ID#</td>
				<td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
			</tr>
			<tr valign="top">
				<td colspan="6"><hr></td>
			</tr>
		</cfoutput>
	</table>
	<br/>
	<table>
		<cfoutput>
			<tr>
				<td width="50"><strong><cf_get_lang_main no='1233.Nakit'></strong></td>
				<td width="150">:</td>
				<td width="75"><strong><cf_get_lang no='38.Tahsil Eden'></strong></td>
				<td>: <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)> #get_emp_info(attributes.emp_id,0,0)#</cfif>
				</td>
			</tr>
			<tr>
				<td><strong><cf_get_lang_main no='595.Çek'></strong></td>
				<td>: #TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</td>
				<td><strong><cf_get_lang_main no='80.Toplam'></strong></td>
				<td>: #TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</td>
			</tr>					
		</cfoutput>	
	</table>
	<br/>
	<table>					
		<tr>
		  <td class="txtbold"><cf_get_lang no="34.Bu İşlemi Senet İşlemleri Bölümünde Güncelleyebilirsiniz"></td>
		</tr>
	</table>
	<br />
	<cf_popup_box_footer>
		<cf_record_info query_name="get_action_detail">
	</cf_popup_box_footer>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
