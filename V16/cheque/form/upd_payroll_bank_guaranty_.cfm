<cf_get_lang_set module_name="cheque">
<cfset var_="upd_payroll_bank">
<cfset attributes.var_=var_>
<cfscript>structdelete(session,"upd_payroll_bank");</cfscript>
<cfif isdefined("attributes.id")>
	<cfset attributes.CHEQUE_PAYROLL_ID = attributes.id>
</cfif>
<cfinclude template="../query/get_money_rate.cfm">
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT 
		P.*,
		ACC.ACCOUNT_NAME 
	FROM 
		PAYROLL P,
		#dsn3_alias#.ACCOUNTS ACC 
	WHERE 
		P.ACTION_ID=#URL.ID# 
		AND P.PAYROLL_TYPE IN(93,133)
		AND P.PAYROLL_ACCOUNT_ID = ACC.ACCOUNT_ID
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
		CHEQUE_HISTORY.PAYROLL_ID = #attributes.CHEQUE_PAYROLL_ID# AND 
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
</cfquery>
<cf_popup_box title="#getLang('cheque',6)#"><!--- Çıkış Bordrosu Banka --->
	<table>
		<tr height="20"> 
			<td width="60" class="txtbold"><cf_get_lang no='11.Bordro No'></td>
			<td width="100">: <cfif  len(get_action_detail.PAYROLL_NO) ><cfoutput>#get_action_detail.PAYROLL_NO#</cfoutput></cfif></td>
			<td width="60" class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
			<td>: <cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput></td>
		</tr>
		<tr height="20"> 
			<td class="txtbold"><cf_get_lang_main no='240.Hesap'></td>
			<td>:
				<cfoutput>#GET_ACTION_DETAIL.ACCOUNT_NAME#</cfoutput>
			</td>
			<td class="txtbold"><cf_get_lang no='38.Tahsil Eden'></td>
			<td>
				:<input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#get_action_detail.PAYROLL_REV_MEMBER#</cfoutput>" >
				<cfoutput>#get_emp_info(get_action_detail.PAYROLL_REV_MEMBER,0,0)#</cfoutput>
			</td>
		</tr>
		<tr height="20"> 
			<td class="txtbold"><cf_get_lang_main no='108.Kasa'></td>
			<td>:
				<cfset cash_id=get_action_detail.PAYROLL_CASH_ID>
				<cfinclude template="../query/get_action_cash.cfm"> 
				<cfoutput>
					#get_action_cash.CASH_NAME#
				</cfoutput>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr> 
		<tr height="22" class="txtbold">
			<td><cf_get_lang no='25.Çek No'></td>
			<td><cf_get_lang_main no='109.Banka'></td>
			<td><cf_get_lang_main no='1529.Subesi'></td>
			<td><cf_get_lang_main no='228.Vade'></td>
			<td><cf_get_lang no='77.İşlem Para Br.'></td>
			<td><cf_get_lang no='68.Sistem Para Br.'></td>
		</tr>
		<cfoutput query="GET_CHEQUE_DETAIL">
			<tr>
				<td>#CHEQUE_NO#</td>
				<td>#BANK_NAME#</td>
				<td>#BANK_BRANCH_NAME#</td>
				<td>#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
				<td>#TLFormat(CHEQUE_VALUE)# #CURRENCY_ID#</td>
				<td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
			</tr>
			<tr valign="top">
				<td colspan="6"><hr></td>
			</tr>
		</cfoutput>
		<tr><td>&nbsp;</td></tr> 
		<tr><td>&nbsp;</td></tr> 
		<tr>
			<td width="50"><strong><cf_get_lang_main no='1233.Nakit'></strong></td>
			<td width="150">:</td>
			<td width="75"><strong><cf_get_lang no='38.Tahsil Eden'></strong></td>
			<td>:
				<cfif isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
					<cfoutput>#get_emp_info(attributes.EMP_ID,0,0)#</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr>
			<td><strong><cf_get_lang_main no='595.Çek'></strong></td>
			<td>: <cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
			<td><strong><cf_get_lang_main no='80.Toplam'></strong></td>
			<td>: <cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_action_detail">
	</cf_popup_box_footer>
</cf_popup_box>
<br/>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
