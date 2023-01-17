<cfparam name="attributes.modal_id" default="">

<cfset component = createObject('component','V16.objects.cfc.budget_transactions')>
<cfset get_expense_costs = component.GET_EXPENSE_COST(
	action_id : iIf(isDefined('attributes.action_id'),"attributes.action_id",DE("")),
	action_table : iIf(isDefined('attributes.action_table'),"attributes.action_table",DE("")),
	is_income : iIf(isDefined('attributes.is_income'),"attributes.is_income",DE("")),
	exp_action_type : iIf(isDefined('attributes.exp_action_type'),"attributes.exp_action_type",DE(""))
)>

<cf_box title="#getLang(dictionary_id : 53382)#" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
				<th><cf_get_lang dictionary_id='31173.Harcama Yapan'></th>
				<th><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></th>
				<th><cf_get_lang dictionary_id='58904.Gider/Gelir Kalemi'></th>
				<th> %</th>
				<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_expense_costs.recordCount>
				<cfoutput query="get_expense_costs">
					<tr>
						<td>#DETAIL#</td>
						<td>
							<cfif member_type eq 'partner'>
								#get_par_info(company_partner_id,0,0,1)#
							<cfelseif member_type eq 'consumer'>
								#get_cons_info(company_partner_id,0,1)#
							<cfelseif member_type eq 'employee'>
								#get_emp_info(company_partner_id,0,1)#
							<cfelse>
								#get_emp_info(company_partner_id,1,1)#
							</cfif>	
						</td>
						<td>#dateformat(expense_date,dateformat_style)#</td>
						<td>#EXPENSE_CENTER_NAME#</td>
						<td>#EXPENSE_ITEM_NAME#</td>
						<td class="text-right">#TLFormat(RATE)#</td>
						<td class="text-right">#TLFormat(TOTAL_AMOUNT)#</td>
						<td>#MONEY_CURRENCY_ID#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="8"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>