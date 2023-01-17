<cfquery name="GET_PLAN_ROW" datasource="#DSN#">
	SELECT
		SUM(ROW_TOTAL_INCOME) ROW_TOTAL_INCOME,
		SUM(ROW_TOTAL_EXPENSE) ROW_TOTAL_EXPENSE,
		SUM(ROW_TOTAL_INCOME_2) ROW_TOTAL_INCOME_2,
		SUM(ROW_TOTAL_EXPENSE_2) ROW_TOTAL_EXPENSE_2,
		BUDGET_PLAN_ROW.PLAN_DATE
	FROM
		BUDGET_PLAN,
		BUDGET_PLAN_ROW
	WHERE
		BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
		BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
		BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID
		<cfif len(attributes.search_date1)>
			AND BUDGET_PLAN_ROW.PLAN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
		</cfif>
		<cfif len(attributes.search_date2)>
			AND BUDGET_PLAN_ROW.PLAN_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
		</cfif>
		<cfif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
			<cfif len(get_expense_center_.expense_id)>
				AND EXP_INC_CENTER_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
			<cfelse>
				AND 1=0
			</cfif>
		</cfif>
	GROUP BY
		BUDGET_PLAN_ROW.PLAN_DATE
	ORDER BY
		BUDGET_PLAN_ROW.PLAN_DATE
</cfquery>
	<thead>	
		<tr>
			<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<cfif isdefined("attributes.is_income")>
				<th style="text-align:right;"><cf_get_lang dictionary_id='58677.Gelir'></th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
			</cfif>
			<cfif isdefined("attributes.is_expense")>
				<th style="text-align:right;"><cf_get_lang dictionary_id='58678.Gider'></th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
			</cfif>
			<th style="text-align:right;"><cf_get_lang dictionary_id='58583.Fark'></th>
			<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<cfif isdefined("attributes.is_income")>
					<th style="text-align:right;"><cf_get_lang dictionary_id='58677.Gelir'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				</cfif>
				<cfif isdefined("attributes.is_expense")>
					<th style="text-align:right;"><cf_get_lang dictionary_id='58678.Gider'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				</cfif>
				<th style="text-align:right;"><cf_get_lang dictionary_id='58583.Fark'></th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
			</cfif>
		</tr>
	</thead>
	<cfparam name="attributes.totalrecords" default='#GET_PLAN_ROW.recordcount#'>
 	<tbody>
		<cfif GET_PLAN_ROW.recordcount>
			<cfoutput query="GET_PLAN_ROW" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<cfset bakiye = ROW_TOTAL_INCOME-ROW_TOTAL_EXPENSE>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<cfset bakiye2 = ROW_TOTAL_INCOME_2-ROW_TOTAL_EXPENSE_2>
					</cfif>
					<td>#currentrow#</td>
					<td>#dateformat(PLAN_DATE,dateformat_style)#</td>
					<cfif isdefined("attributes.is_income")>
						<td style="text-align:right;" format="numeric">#TLFormat(ROW_TOTAL_INCOME)#</td>
						<td>&nbsp;#session.ep.money#</td>
					</cfif>
					<cfif isdefined("attributes.is_expense")>
						<td style="text-align:right;" format="numeric">#TLFormat(ROW_TOTAL_EXPENSE)#</td>
						<td>&nbsp;#session.ep.money#</td>
					</cfif>
					<td style="text-align:right;" format="numeric">#TLFormat(bakiye)#</td>
					<td style="text-align:right;">#session.ep.money#</td>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<cfif isdefined("attributes.is_income")>
							<td style="text-align:right;" format="numeric">#TLFormat(ROW_TOTAL_INCOME_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
						</cfif>
						<cfif isdefined("attributes.is_expense")>
							<td style="text-align:right;" format="numeric">#TLFormat(ROW_TOTAL_EXPENSE_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
						</cfif>
						<td style="text-align:right;" format="numeric">#TLFormat(bakiye2)#</td>
						<td>&nbsp;#session.ep.money2#</td>
					</cfif>
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row">
				<td height="20" colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
    </tbody>

