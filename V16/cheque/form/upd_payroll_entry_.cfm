<cf_get_lang_set module_name="cheque">
<cfif isdefined("attributes.ID")>
<cfset attributes.CHEQUE_PAYROLL_ID = attributes.ID>
</cfif>
<cfinclude template="../query/get_money_rate.cfm">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT * FROM PAYROLL WHERE ACTION_ID=#URL.ID# AND PAYROLL_TYPE = 90
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
		PAYROLL_ID = #attributes.CHEQUE_PAYROLL_ID# AND 
		STATUS = 1 AND
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
</cfquery>
<div class="col col-12 col-xs-12">
<cf_box title="#getLang('main',595)# #getLang('cheque',4)#"><!--- Çek Giris Bordrosu --->	
	<cfoutput>
		<cf_box_elements>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-8"><b><cf_get_lang dictionary_id='33983.Bordro'></b></label>
					<label class="col col-8 col-md-6 col-xs-8">: <cfif len(get_action_detail.PAYROLL_NO)>#get_action_detail.PAYROLL_NO#</cfif></label>
					<label class="col col-4 col-md-6 col-xs-8"><b><cf_get_lang dictionary_id='57742.Tarih'></b></label>
					<label class="col col-8 col-md-6 col-xs-8">:
						<cfif get_action_detail.RECORDCOUNT>
							#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#
						</cfif>
					</label>
				</div>
			</div>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-8"><b><cf_get_lang dictionary_id='57520.Kasa'></b></label>
					<label class="col col-8 col-md-6 col-xs-8">:
					<cfset cash_id=get_action_detail.PAYROLL_CASH_ID>
					<cfinclude template="../query/get_action_cash.cfm">
					#get_action_cash.CASH_NAME# 
					</label>
					<label class="col col-4 col-md-6 col-xs-8"><b><cf_get_lang dictionary_id='57574.Firma'></b></label>
					<label class="col col-8 col-md-6 col-xs-8">: #get_par_info(get_action_detail.COMPANY_ID,1,1,0)# </label>
				</div>
			</div>
		</cf_box_elements>
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='32745.Çek No'></th>
					<th><cf_get_lang dictionary_id='57521.Banka'></th>
					<th><cf_get_lang dictionary_id='58941.Subesi'></th>
					<th><cf_get_lang dictionary_id='57640.Vade'></th>
					<th><cf_get_lang dictionary_id='30134.İşlem Para Br.'></th>
					<th><cf_get_lang dictionary_id='58177.Sistem Para Br.'></th>
						<th></th>
						<th></th>
				</tr>
			</thead>
			<tbody>			
				<!--- Burasi cek sayisi kadar artacak..--->
				<cfloop query="GET_CHEQUE_DETAIL">
					<tr>
						<td>#CHEQUE_NO#</td>
						<td>#BANK_NAME#</td>
						<td>#BANK_BRANCH_NAME#</td>
						<td>#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
						<td>#TLFormat(CHEQUE_VALUE)# #CURRENCY_ID#</td>
						<td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
						<td></td>
						<td></td>
					</tr>
					<tr></tr>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<td width="50"><strong><cf_get_lang dictionary_id='58645.Nakit'></strong></td>
					<td width="150">:</td>
					<td width="75"><strong><cf_get_lang dictionary_id='33483.Tahsil Eden'></strong></td>
					<td>:
					<cfif isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
						#get_emp_info(attributes.EMP_ID,0,0)#
					</cfif>
					</td>
					<td><strong><cf_get_lang dictionary_id='58007.Çek'></strong></td>
					<td>: #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</td>
					<td><strong><cf_get_lang dictionary_id='57492.Toplam'></strong></td>
					<td>: #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</td>
				</tr>
			</tfoot>
		</cf_flat_list>
		</cfoutput>
	<cf_box_footer>
		<cfif len(get_action_detail.record_emp)>
			<cf_record_info query_name="get_action_detail">
		</cfif>
	</cf_box_footer>
</cf_box>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<br/>
