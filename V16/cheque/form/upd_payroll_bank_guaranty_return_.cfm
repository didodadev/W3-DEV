<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined("attributes.ID")>
	<cfset attributes.CHEQUE_PAYROLL_ID = attributes.ID>
</cfif>
<cfinclude template="../query/get_money_rate.cfm">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT * FROM PAYROLL WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#"> AND PAYROLL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="105">
</cfquery>

<cfquery name="GET_CHEQUE_DETAIL" datasource="#db_adres#">
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
		PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CHEQUE_PAYROLL_ID#"> AND 
		STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
</cfquery>
<cf_popup_box title="#getLang('main',595)# #getLang('cheque',159)#"><!--- Cek Giris Iade Bordrosu-Banka--->
	<table>
		<cfoutput>
			<tr height="20">
				<td width="60" class="txtbold"><cf_get_lang no='11.Bordro'></td>
				<td width="100">: <cfif len(get_action_detail.PAYROLL_NO)>#get_action_detail.PAYROLL_NO#</cfif></td>
				<td width="60" class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
				<td>:
					<cfif get_action_detail.RECORDCOUNT>
						#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#
					</cfif>
				</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='109.Banka'></td>
				<td>:
					<cfset account_id=get_action_detail.PAYROLL_ACCOUNT_ID>
					<cfquery name="get_bank" datasource="#dsn3#">
						SELECT
							ACCOUNT_NAME,
							ACCOUNT_ID
						FROM
							ACCOUNTS
						WHERE
							ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#account_id#">
					</cfquery>
					#get_bank.ACCOUNT_NAME# 
				</td>
				<td class="txtbold"><cf_get_lang_main no='108.Kasa'></td>
				<td>:
				  <cfset cash_id=get_action_detail.PAYROLL_CASH_ID>
				  <cfinclude template="../query/get_action_cash.cfm">
				  #get_action_cash.CASH_NAME# 
				</td>
			</tr>
			<tr>
				<td width="75" class="txtbold"><cf_get_lang_main no='1174.????lem Yapan'></td>
				<td>:
					<cfif isdefined("get_action_detail.PAYROLL_REV_MEMBER") and len(get_action_detail.PAYROLL_REV_MEMBER)>
						#get_emp_info(get_action_detail.PAYROLL_REV_MEMBER,0,0)#
					</cfif>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>			
			<tr height="22" class="txtbold">
				<td><cf_get_lang no='25.??ek No'></td>
				<td><cf_get_lang_main no='109.Banka'></td>
				<td><cf_get_lang_main no='1529.Subesi'></td>
				<td><cf_get_lang_main no='228.Vade'></td>
				<td><cf_get_lang no='77.????lem Para Br.'></td>
				<td><cf_get_lang no='68.Sistem Para Br.'></td>
			</tr>
			<!--- Burasi cek sayisi kadar artacak..--->
			<cfloop query="GET_CHEQUE_DETAIL">
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
			</cfloop>
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
			<td><strong><cf_get_lang_main no='595.??ek'></strong></td>
			<td>: <cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
			<td><strong><cf_get_lang_main no='80.Toplam'></strong></td>
			<td>: <cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
		</tr>
		<tr><td>&nbsp;</td></tr> 
		<tr><td>&nbsp;</td></tr> 										
		<tr>
			<td class="txtbold" colspan="6"><cf_get_lang_main no='1536.Bu ????lemi ??ek ????lemleri B??l??m??nde G??ncelleyebilirsiniz'></td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_action_detail">
	</cf_popup_box_footer>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
