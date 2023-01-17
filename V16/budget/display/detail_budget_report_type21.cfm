<!---aylara göre Masraf Merkezi ve Bütçe Kategorisi Bazında --->
<cfif fusebox.use_period>
	<cfset db_alias_ = dsn2_alias>
<cfelse>
	<cfset db_alias_ = dsn_alias>
</cfif>
<cfquery name="get_cost" datasource="#dsn#"><!--- Planlanan --->
	SELECT
		SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME) AMOUNT_VALUE,
		SUM(ISNULL(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2,0)) AMOUNT_VALUE_2,
		SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE) EXP_AMOUNT_VALUE,
		SUM(ISNULL(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2,0)) EXP_AMOUNT_VALUE_2,
		DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) MONTH_VALUE,
		EXPENSE_CENTER.EXPENSE,
		EXPENSE_CENTER.EXPENSE_ID,
		EXPENSE_CENTER.EXPENSE_CODE,
		EXPENSE_CATEGORY.EXPENSE_CAT_NAME,
		EXPENSE_CATEGORY.EXPENSE_CAT_ID,
		BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID AS ACTIVITY_ID
	FROM
		BUDGET_PLAN,
		BUDGET_PLAN_ROW,
		#db_alias_#.EXPENSE_CENTER EXPENSE_CENTER,
		#db_alias_#.EXPENSE_CATEGORY EXPENSE_CATEGORY
	WHERE
		BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
		BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
		BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
		EXPENSE_CENTER.EXPENSE_ID = BUDGET_PLAN_ROW.EXP_INC_CENTER_ID AND
		BUDGET_PLAN_ROW.BUDGET_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #db_alias_#.EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID) AND
		EXPENSE_CENTER.EXPENSE_ACTIVE = 1 AND
		DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) IN (#month_list#)
		<cfif session.ep.isBranchAuthorization>
			AND EXPENSE_CENTER.EXPENSE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>
		<cfif isdefined("attributes.plan_process_cat") and len(attributes.plan_process_cat)>
			AND BUDGET_PLAN.PROCESS_CAT IN (#attributes.plan_process_cat#)
		</cfif>
		<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
			AND EXPENSE_ID IN (#attributes.expense_center_id#)
		<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
			<cfif len(get_expense_center_.expense_id)>
				AND EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
			<cfelse>
				AND 1=0
			</cfif>
		</cfif>
	GROUP BY
		DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE),
		EXPENSE_CENTER.EXPENSE,
		EXPENSE_CENTER.EXPENSE_ID,
		EXPENSE_CENTER.EXPENSE_CODE,
		EXPENSE_CATEGORY.EXPENSE_CAT_NAME,
		EXPENSE_CATEGORY.EXPENSE_CAT_ID,
		BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID
</cfquery>
<cfquery name="get_cost2" datasource="#dsn2#"><!--- Gerçekleşen --->
	SELECT
		SUM(AMOUNT_VALUE) AMOUNT_VALUE,
		SUM(ISNULL(AMOUNT_VALUE_2,0)) AMOUNT_VALUE_2,
		MONTH_VALUE,
		EXPENSE_ID,
		EXPENSE_CAT_ID,
		IS_INCOME		
	FROM
	(
		SELECT
			<cfif attributes.is_kdv eq 1>
				EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT AMOUNT_VALUE,
				EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE_2 AMOUNT_VALUE_2,
			<cfelse>
				(EXPENSE_ITEMS_ROWS.AMOUNT*ISNULL(QUANTITY,1)) AMOUNT_VALUE,
				CASE WHEN(OTHER_MONEY_VALUE_2 = 0) THEN 0 ELSE (EXPENSE_ITEMS_ROWS.AMOUNT/(TOTAL_AMOUNT/OTHER_MONEY_VALUE_2)*ISNULL(QUANTITY,1)) END AS AMOUNT_VALUE_2,
			</cfif>	
			DATEPART(MM,EXPENSE_ITEMS_ROWS.EXPENSE_DATE) MONTH_VALUE,
			EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID EXPENSE_ID,
			EXPENSE_CATEGORY.EXPENSE_CAT_ID,
			EXPENSE_ITEMS_ROWS.IS_INCOME
		FROM
			EXPENSE_ITEMS_ROWS,
			#db_alias_#.EXPENSE_CATEGORY EXPENSE_CATEGORY
		WHERE
			TOTAL_AMOUNT > 0 AND
			EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #db_alias_#.EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID) AND
			DATEPART(MM,EXPENSE_ITEMS_ROWS.EXPENSE_DATE) IN (#month_list#)
			<cfif len(attributes.project_id)>
				AND EXPENSE_ITEMS_ROWS.PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
			</cfif>
			<cfif isDefined("attributes.process_cat") and len(attributes.process_cat)>
				AND EXPENSE_COST_TYPE IN (#attributes.process_cat#)
			</cfif>
	)T1
	GROUP BY
		MONTH_VALUE,
		EXPENSE_ID,
		EXPENSE_CAT_ID,
		IS_INCOME
</cfquery>
<cfquery name="get_other_exp" datasource="#dsn2#">
	SELECT 
		EXPENSE_ID,
		EXPENSE,
		EXPENSE_CODE,
		ACTIVITY_ID
	FROM
		#db_alias_#.EXPENSE_CENTER
	WHERE
		EXPENSE_ACTIVE = 1 AND
		EXPENSE_ID NOT IN(SELECT EXP_INC_CENTER_ID FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID IN(SELECT BUDGET_PLAN_ID FROM #dsn_alias#.BUDGET_PLAN WHERE BUDGET_PLAN.PROCESS_TYPE <> 161 AND BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">)) AND EXP_INC_CENTER_ID IS NOT NULL AND DATEPART(MM,PLAN_DATE) IN (#month_list#)) AND 
		EXPENSE_ID IN(SELECT EXPENSE_CENTER_ID FROM #db_alias_#.EXPENSE_ITEMS_ROWS WHERE EXPENSE_CENTER_ID IS NOT NULL AND DATEPART(MM,EXPENSE_DATE) IN (#month_list#) AND IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND TOTAL_AMOUNT > 0)
		<cfif attributes.is_all_exp_center eq 2>
			AND 1 = 2
		</cfif>
		<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
			AND EXPENSE_ID IN (#attributes.expense_center_id#)
		<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
			<cfif len(get_expense_center_.expense_id)>
				AND EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
			<cfelse>
				AND 1=0
			</cfif>
		</cfif>
</cfquery>
<cfquery name="get_other_item" datasource="#dsn2#">
	SELECT 
		EXPENSE_CAT_ID,
		EXPENSE_CAT_NAME
	FROM
		#db_alias_#.EXPENSE_CATEGORY,
		#db_alias_#.EXPENSE_ITEMS
	WHERE
		EXPENSE_CATEGORY.EXPENSE_CAT_ID = EXPENSE_ITEMS.EXPENSE_CATEGORY_ID AND
		EXPENSE_ITEM_ID NOT IN(SELECT BUDGET_ITEM_ID FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID IN(SELECT BUDGET_PLAN_ID FROM #dsn_alias#.BUDGET_PLAN WHERE BUDGET_PLAN.PROCESS_TYPE <> 161 AND BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">)) AND BUDGET_ITEM_ID IS NOT NULL AND DATEPART(MM,PLAN_DATE) IN (#month_list#)) AND 
		EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #db_alias_#.EXPENSE_ITEMS_ROWS WHERE EXPENSE_ITEM_ID IS NOT NULL AND DATEPART(MM,EXPENSE_DATE) IN (#month_list#) AND IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND TOTAL_AMOUNT > 0)
		<cfif attributes.is_all_exp_center eq 2>
			AND 1 = 2
		</cfif>
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" dbtype="query">
	SELECT DISTINCT 
		EXPENSE_ID,
		EXPENSE,
		EXPENSE_CODE,
		ACTIVITY_ID
	FROM 
		GET_COST
	<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
		WHERE EXPENSE_ID IN (#attributes.expense_center_id#)
	</cfif>
	UNION ALL
	SELECT DISTINCT 
		EXPENSE_ID,
		EXPENSE,
		EXPENSE_CODE,
		ACTIVITY_ID
	FROM 
		get_other_exp
	<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
		WHERE EXPENSE_ID IN (#attributes.expense_center_id#)
	</cfif>
</cfquery>
<cfif GET_COST.recordcount or get_other_item.recordcount>
	<cfquery name="GET_EXPENSE_CAT" dbtype="query">
		<cfif GET_COST.recordcount>
			SELECT DISTINCT 
				EXPENSE_CAT_ID,
				EXPENSE_CAT_NAME
			FROM 
				GET_COST
			WHERE
				1 = 1
				<cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
					AND EXPENSE_CAT_ID IN (#attributes.expense_cat#)
				</cfif>
		</cfif>
		<cfif GET_COST.recordcount and get_other_item.recordcount>
			UNION ALL
		</cfif>
		<cfif get_other_item.recordcount>
			SELECT DISTINCT 
				EXPENSE_CAT_ID,
				EXPENSE_CAT_NAME
			FROM 
				get_other_item
			WHERE
				1 = 1
				<cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
					AND EXPENSE_CAT_ID IN (#attributes.expense_cat#)
				</cfif>
		</cfif>
	</cfquery>
<cfelse>
	<cfset GET_EXPENSE_CAT.recordcount = 0>
</cfif>
<cfscript>
	for(exp_ind=1; exp_ind lte get_cost.recordcount; exp_ind=exp_ind+1)
	{
		if(isdefined("row_total_income_#get_cost.month_value[exp_ind]#_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#"))
		{
			'row_total_income_#get_cost.month_value[exp_ind]#_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#'=evaluate("row_total_income_#get_cost.month_value[exp_ind]#_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#")+get_cost.amount_value[exp_ind];
			'row_total_income_#get_cost.month_value[exp_ind]#_2_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#'=evaluate("row_total_income_#get_cost.month_value[exp_ind]#_2_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#")+get_cost.amount_value_2[exp_ind];
		}
		else
		{
			'row_total_income_#get_cost.month_value[exp_ind]#_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#'=get_cost.amount_value[exp_ind];
			'row_total_income_#get_cost.month_value[exp_ind]#_2_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#'=get_cost.amount_value_2[exp_ind];
		}
		if(isdefined("row_total_expense_#get_cost.month_value[exp_ind]#_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#"))
		{
			'row_total_expense_#get_cost.month_value[exp_ind]#_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#'=evaluate("row_total_expense_#get_cost.month_value[exp_ind]#_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#")+get_cost.exp_amount_value[exp_ind];
			'row_total_expense_#get_cost.month_value[exp_ind]#_2_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#'=evaluate("row_total_expense_#get_cost.month_value[exp_ind]#_2_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#")+get_cost.exp_amount_value_2[exp_ind];
		}
		else
		{
			'row_total_expense_#get_cost.month_value[exp_ind]#_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#'=get_cost.exp_amount_value[exp_ind];
			'row_total_expense_#get_cost.month_value[exp_ind]#_2_#get_cost.expense_id[exp_ind]#_#get_cost.expense_cat_id[exp_ind]#'=get_cost.exp_amount_value_2[exp_ind];
		}
	}
	for(exp_ind=1; exp_ind lte get_cost2.recordcount; exp_ind=exp_ind+1)
	{
		if(get_cost2.is_income[exp_ind] eq 0)
		{
			if(isdefined("total_exp_#get_cost2.month_value[exp_ind]#_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#"))
			{
				'total_exp_#get_cost2.month_value[exp_ind]#_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#'=evaluate("total_exp_#get_cost2.month_value[exp_ind]#_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#")+get_cost2.amount_value[exp_ind];
				'total_exp_#get_cost2.month_value[exp_ind]#_2_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#'=evaluate("total_exp_#get_cost2.month_value[exp_ind]#_2_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#")+get_cost2.amount_value_2[exp_ind];
			}
			else
			{
				'total_exp_#get_cost2.month_value[exp_ind]#_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#'=get_cost2.amount_value[exp_ind];
				'total_exp_#get_cost2.month_value[exp_ind]#_2_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#'=get_cost2.amount_value_2[exp_ind];
			}
		}
		else
		{
			if(isdefined("total_inc_#get_cost2.month_value[exp_ind]#_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#"))
			{
				'total_inc_#get_cost2.month_value[exp_ind]#_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#'=evaluate("total_inc_#get_cost2.month_value[exp_ind]#_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#")+get_cost2.amount_value[exp_ind];
				'total_inc_#get_cost2.month_value[exp_ind]#_2_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#'=evaluate("total_inc_#get_cost2.month_value[exp_ind]#_2_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#")+get_cost2.amount_value_2[exp_ind];
			}
			else
			{
				'total_inc_#get_cost2.month_value[exp_ind]#_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#'=get_cost2.amount_value[exp_ind];
				'total_inc_#get_cost2.month_value[exp_ind]#_2_#get_cost2.expense_id[exp_ind]#_#get_cost2.expense_cat_id[exp_ind]#'=get_cost2.amount_value_2[exp_ind];
			}
		}
	}
</cfscript>
<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
	<cfif isdefined("attributes.is_diff")>
		<cfset colspan_info = 13>
	<cfelse>
		<cfset colspan_info = 8>
	</cfif>
<cfelse>
	<cfif isdefined("attributes.is_diff")>
		<cfset colspan_info = 6>
	<cfelse>
		<cfset colspan_info = 4>
	</cfif>
</cfif>
<cfset myCol = 0>
<cfset myCol2 = 0>
<cfif isdefined("attributes.is_income")>
	<cfoutput>
		<thead>
			<tr>
				<th style="text-align:left;" colspan="81" nowrap><cf_get_lang dictionary_id='58089.Gelirler'></th>
			</tr>
			<tr>
				<cfset colspan_no_ = 2>
				<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
					<cfset colspan_no_ = colspan_no_ + 1>
				</cfif>
				<th nowrap colspan="#colspan_no_#">&nbsp;</th>
				
				<cfloop list="#month_list#" index="k">
					<th colspan="#colspan_info#" align="center" class="form-title" nowrap><cfoutput>#listgetat(aylar,k,',')#</cfoutput></th>
					
				</cfloop>
				<th align="center" colspan="#colspan_info#" class="form-title" nowrap><cf_get_lang dictionary_id='57492.Toplam'></th>
			</tr>
			<tr>
				<th nowrap><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></th><cfset myCol = myCol+1>
				<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
					<th><cf_get_lang dictionary_id='49184.Aktivite Tipi'></th><cfset myCol = myCol + 1>
				</cfif>
				<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
					<th nowrap><cf_get_lang no='4.Gelir Merkezi Kodu'></th><cfset myCol = myCol+1>
				</cfif>			
				<th><cf_get_lang dictionary_id='58172.Gelir Merkezi'></th><cfset myCol = myCol+1>
			
				<cfloop list="#month_list#" index="k">
					<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol+1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
					<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol+1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
					<cfif isdefined("attributes.is_diff")>
						<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol+1>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
					</cfif>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol+1>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
						<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol+1>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						<cfif isdefined("attributes.is_diff")>
							<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol+1>
							<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
						</cfif>
					</cfif>
					
					<cfset 'toplam_ay_#k#' = 0>
					<cfset 'toplam_ay_2_#k#' = 0>
					<cfset 'toplam_ay2_#k#' = 0>
					<cfset 'toplam_ay2_2_#k#' = 0>
				</cfloop>
				<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol+1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
				<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol+1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
				<cfif isdefined("attributes.is_diff")>
					<th  width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol+1>
					<th  nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
				</cfif>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol+1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
					<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol+1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
					<cfif isdefined("attributes.is_diff")>
						<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol+1>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol+1>
					</cfif>
				</cfif>
			</tr>
		</thead>
	</cfoutput>
	<cfset genel_toplam = 0>
	<cfset genel_toplam2 = 0>
	<cfset genel_toplam_2 = 0>
	<cfset genel_toplam2_2 = 0>
	<cfif get_expense_center.recordcount>
		<tbody>
			<cfoutput query="get_expense_center">
				<cfloop query="get_expense_cat">
					<cfset cat_toplam = 0>
					<cfset cat_toplam2 = 0>
					<cfset cat_toplam_2 = 0>
					<cfset cat_toplam2_2 = 0>
					<tr>
						<td nowrap>#get_expense_cat.EXPENSE_CAT_NAME#</td>
						<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
							<td nowrap>#GET_EXPENSE_CENTER.EXPENSE_CODE#</td>
						</cfif>
						<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
							<td>
								<cfif len(GET_EXPENSE_CENTER.ACTIVITY_ID)>
									<cfquery name="GET_ACTIVITY_TYPE" datasource="#DSN#">
										SELECT
											ACTIVITY_ID,
											ACTIVITY_NAME
										FROM
											SETUP_ACTIVITY
										WHERE
											ACTIVITY_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_EXPENSE_CENTER.ACTIVITY_ID#">
										ORDER BY
											ACTIVITY_NAME
									</cfquery>
									#GET_ACTIVITY_TYPE.ACTIVITY_NAME#
								</cfif>
							</td>
						</cfif>
						<td nowrap>#get_expense_center.expense#</td>
						<cfloop list="#month_list#" index="ay_ind">
							<!--- planlanan gelir --->
							<cfif isdefined("row_total_income_#ay_ind#_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
								<cfset deger1 = evaluate("row_total_income_#ay_ind#_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
								<cfset deger1_2 = evaluate("row_total_income_#ay_ind#_2_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
							<cfelse>
								<cfset deger1 = 0>
								<cfset deger1_2 = 0>
							</cfif>
							<!--- gerçekleşen gelir --->
							<cfif isdefined("total_inc_#ay_ind#_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
								<cfset deger4 = evaluate("total_inc_#ay_ind#_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
								<cfset deger4_2 = evaluate("total_inc_#ay_ind#_2_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
							<cfelse>
								<cfset deger4 = 0>
								<cfset deger4_2 = 0>
							</cfif>
							<cfset cat_toplam = cat_toplam + deger1>
							<cfset cat_toplam_2 = cat_toplam_2 + deger1_2>
							<cfset cat_toplam2 = cat_toplam2 + deger4>
							<cfset cat_toplam2_2 = cat_toplam2_2 + deger4_2>
							<cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + deger1>
							<cfset 'toplam_ay_2_#ay_ind#' = evaluate('toplam_ay_2_#ay_ind#') + deger1_2>
							<cfset 'toplam_ay2_#ay_ind#' = evaluate('toplam_ay2_#ay_ind#') + deger4>
							<cfset 'toplam_ay2_2_#ay_ind#' = evaluate('toplam_ay2_2_#ay_ind#') + deger4_2>
							
							<td  style="text-align:right;" format="numeric">#TlFormat(deger1)#</td>
							<td>&nbsp;#session.ep.money#</td>
							<td  style="text-align:right;" format="numeric">#TlFormat(deger4)#</td>
							<td>&nbsp;#session.ep.money#</td>
							<cfif isdefined("attributes.is_diff")>
								<td  nowrap style="text-align:right;" format="numeric">#TlFormat(deger1-deger4)#</td>
								<td>&nbsp;#session.ep.money#</td>
							</cfif>
							<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
								<td  style="text-align:right;" format="numeric">#TlFormat(deger1_2)#</td>
								<td>&nbsp;#session.ep.money2#</td>
								<td  style="text-align:right;" format="numeric">#TlFormat(deger4_2)#</td>
								<td>&nbsp;#session.ep.money2#</td>
								<cfif isdefined("attributes.is_diff")>
									<td  nowrap style="text-align:right;" format="numeric">#TlFormat(deger1_2-deger4_2)#</td>
									<td>&nbsp;#session.ep.money2#</td>
								</cfif>
							</cfif>
						</cfloop>							
						<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam)#</td>
						<td>&nbsp;#session.ep.money#</td>
						<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam2)#</td>
						<td>&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_diff")>
							<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam-cat_toplam2)#</td>
							<td>&nbsp;#session.ep.money#</td>
						</cfif>
						<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
							<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
							<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam2_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
							<cfif isdefined("attributes.is_diff")>
								<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam_2-cat_toplam2_2)#</td>
								<td>&nbsp;#session.ep.money2#</td>
							</cfif>
						</cfif>
					</tr>								
				<cfset genel_toplam = genel_toplam + cat_toplam> 
				<cfset genel_toplam2 = genel_toplam2 + cat_toplam2>
				<cfset genel_toplam_2 = genel_toplam_2 + cat_toplam_2> 
				<cfset genel_toplam2_2 = genel_toplam2_2 + cat_toplam2_2>
				</cfloop>
			</cfoutput>
		</tbody>
		<cfoutput>
		<tr>
			<cfset colspan_no_ = 3>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<cfset colspan_no_ = colspan_no_ + 1>
			</cfif>
			<td colspan="#colspan_no_#"  nowrap class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
		
			<cfloop list="#month_list#" index="ay_ind">
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_#ay_ind#'))#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay2_#ay_ind#'))#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				<cfif isdefined("attributes.is_diff")>
					<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_#ay_ind#')-evaluate('toplam_ay2_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				</cfif>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_2_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay2_2_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					<cfif isdefined("attributes.is_diff")>
						<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_2_#ay_ind#')-evaluate('toplam_ay2_2_#ay_ind#'))#</cfoutput></td>
						<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					</cfif>
				</cfif>
			
			</cfloop>
			<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam)#</cfoutput></td>
			<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
			<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam2)#</cfoutput></td>
			<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
			<cfif isdefined("attributes.is_diff")>
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam-genel_toplam2)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
			</cfif>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam_2)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam2_2)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
				<cfif isdefined("attributes.is_diff")>
					<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam_2-genel_toplam2_2)#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
				</cfif>
			</cfif>
		</tr>
		</cfoutput>
	<cfelse>
		<tbody>
			<tr>
				<td colspan="<cfoutput>#myCol#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</tbody>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_expense")>
	<cfquery name="get_other_exp" datasource="#dsn2#">
		SELECT 
			EXPENSE_ID,
			EXPENSE,
			EXPENSE_CODE,
			ACTIVITY_ID
		FROM
			#db_alias_#.EXPENSE_CENTER
		WHERE
			EXPENSE_ACTIVE = 1 AND
			EXPENSE_ID NOT IN(SELECT EXP_INC_CENTER_ID FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID IN(SELECT BUDGET_PLAN_ID FROM #dsn_alias#.BUDGET_PLAN WHERE BUDGET_PLAN.PROCESS_TYPE <> 161 AND BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">)) AND EXP_INC_CENTER_ID IS NOT NULL AND DATEPART(MM,PLAN_DATE) IN (#month_list#)) AND 
			EXPENSE_ID IN(SELECT EXPENSE_CENTER_ID FROM #db_alias_#.EXPENSE_ITEMS_ROWS WHERE EXPENSE_CENTER_ID IS NOT NULL AND DATEPART(MM,EXPENSE_DATE) IN (#month_list#) AND IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND TOTAL_AMOUNT > 0)
			<cfif attributes.is_all_exp_center eq 2>
				AND 1 = 2
			</cfif>
			<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
				AND EXPENSE_ID IN (#attributes.expense_center_id#)
			<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
				<cfif len(get_expense_center_.expense_id)>
					AND EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
				<cfelse>
					AND 1=0
				</cfif>
			</cfif>
	</cfquery>
	<cfquery name="get_other_item" datasource="#dsn2#">
		SELECT 
			EXPENSE_CAT_ID,
			EXPENSE_CAT_NAME
		FROM
			#db_alias_#.EXPENSE_CATEGORY,
			#db_alias_#.EXPENSE_ITEMS
		WHERE
			EXPENSE_CATEGORY.EXPENSE_CAT_ID = EXPENSE_ITEMS.EXPENSE_CATEGORY_ID AND
			EXPENSE_ITEM_ID NOT IN(SELECT BUDGET_ITEM_ID FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID IN(SELECT BUDGET_PLAN_ID FROM #dsn_alias#.BUDGET_PLAN WHERE BUDGET_PLAN.PROCESS_TYPE <> 161 AND BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">)) AND BUDGET_ITEM_ID IS NOT NULL AND DATEPART(MM,PLAN_DATE) IN (#month_list#)) AND 
			EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #db_alias_#.EXPENSE_ITEMS_ROWS WHERE EXPENSE_ITEM_ID IS NOT NULL AND DATEPART(MM,EXPENSE_DATE) IN (#month_list#) AND IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND TOTAL_AMOUNT > 0)
			<cfif attributes.is_all_exp_center eq 2>
				AND 1 = 2
			</cfif>
	</cfquery>
	<cfquery name="GET_EXPENSE_CENTER" dbtype="query">
		SELECT DISTINCT 
			EXPENSE_ID,
			EXPENSE,
			EXPENSE_CODE,
			ACTIVITY_ID
		FROM 
			GET_COST
		<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
			WHERE EXPENSE_ID IN (#attributes.expense_center_id#)
		</cfif>
		UNION ALL
		SELECT DISTINCT 
			EXPENSE_ID,
			EXPENSE,
			EXPENSE_CODE,
			ACTIVITY_ID
		FROM 
			get_other_exp
		<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
			WHERE EXPENSE_ID IN (#attributes.expense_center_id#)
		</cfif>
	</cfquery>
	<cfif GET_COST.recordcount or get_other_item.recordcount>
		<cfquery name="GET_EXPENSE_CAT" dbtype="query">
			<cfif GET_COST.recordcount>
				SELECT DISTINCT 
					EXPENSE_CAT_ID,
					EXPENSE_CAT_NAME
				FROM 
					GET_COST
				WHERE
					1 = 1
					<cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
						AND EXPENSE_CAT_ID IN (#attributes.expense_cat#)
					</cfif>
			</cfif>
			<cfif GET_COST.recordcount and get_other_item.recordcount>
				UNION ALL
			</cfif>
			<cfif get_other_item.recordcount>
				SELECT DISTINCT 
					EXPENSE_CAT_ID,
					EXPENSE_CAT_NAME
				FROM 
					get_other_item
				WHERE
					1 = 1
					<cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
						AND EXPENSE_CAT_ID IN (#attributes.expense_cat#)
					</cfif>
			</cfif>
		</cfquery>
	<cfelse>
		<cfset GET_EXPENSE_CAT.recordcount = 0>
	</cfif>
	<cfoutput>
	<thead>
		<tr bgcolor="FFFFFF" height="30">
			<th style="text-align:left;" colspan="81" class="formbold" nowrap><cf_get_lang no='47.Giderler'></th>
		</tr>
		<tr class="color-header">
			<cfset colspan_no_ = 3>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<cfset colspan_no_ = colspan_no_ + 1>
			</cfif>
			<th nowrap colspan="#colspan_no_#">&nbsp;</th>
			
			<cfloop list="#month_list#" index="k">
				<th colspan="#colspan_info#" align="center" class="form-title" nowrap><cfoutput>#listgetat(aylar,k,',')#</cfoutput></th>

			</cfloop>
			<th align="center" colspan="#colspan_info#" class="form-title" nowrap><cf_get_lang dictionary_id='57492.Toplam'></th>
		</tr>
		<tr>
			<th  nowrap><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></th><cfset myCol2 = myCol2+1>
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				<th><cf_get_lang dictionary_id='49184.Aktivite Tipi'></th><cfset myCol = myCol + 1>
			</cfif>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<th  nowrap><cf_get_lang dictionary_id='49109.Masraf Merkezi Kodu'></th><cfset myCol2 = myCol2+1>
			</cfif>
			<th ><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th><cfset myCol2 = myCol2+1>
		
			<cfloop list="#month_list#" index="k">
				<th  align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2+1>
				<th  nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
				<th  align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2+1>
				<th  nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2+1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
				</cfif>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<th  align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2+1>
					<th  nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
					<th  align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2+1>
					<th  nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
					<cfif isdefined("attributes.is_diff")>
						<th  width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2+1>
						<th  nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
					</cfif>
				</cfif>
			
				<cfset 'toplam_ay_#k#' = 0>
				<cfset 'toplam_ay_2_#k#' = 0>
				<cfset 'toplam_ay2_#k#' = 0>
				<cfset 'toplam_ay2_2_#k#' = 0>
			</cfloop>
			<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2+1>
			<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
			<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2+1>
			<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
			<cfif isdefined("attributes.is_diff")>
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2+1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
			</cfif>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2+1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
				<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2+1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2+1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2+1>
				</cfif>
			</cfif>
		</tr>
	</thead>
	</cfoutput>
	<cfset genel_toplam = 0>
	<cfset genel_toplam2 = 0>
	<cfset genel_toplam_2 = 0>
	<cfset genel_toplam2_2 = 0>
	<cfif get_expense_center.recordcount>
		<tbody>
			<cfoutput query="get_expense_center">			
				<cfloop query="get_expense_cat">
					<cfset cat_toplam = 0>
					<cfset cat_toplam2 = 0>
					<cfset cat_toplam_2 = 0>
					<cfset cat_toplam2_2 = 0>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" >
						<td nowrap>#get_expense_cat.expense_cat_name#</td>
						<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
							<td nowrap style="mso-number-format:\@;">#GET_EXPENSE_CENTER.EXPENSE_CODE#</td>
						</cfif>
						<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
							<td>
								<cfif len(GET_EXPENSE_CENTER.ACTIVITY_ID)>
									<cfquery name="GET_ACTIVITY_TYPE" datasource="#DSN#">
										SELECT
											ACTIVITY_ID,
											ACTIVITY_NAME
										FROM
											SETUP_ACTIVITY
										WHERE
											ACTIVITY_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_EXPENSE_CENTER.ACTIVITY_ID#">
										ORDER BY
											ACTIVITY_NAME
									</cfquery>
									#GET_ACTIVITY_TYPE.ACTIVITY_NAME#
								</cfif>
							</td>
						</cfif>
						<td nowrap>#get_expense_center.expense#</td>
						<cfloop list="#month_list#" index="ay_ind">
							<!--- planlanan gider --->
							<cfif isdefined("row_total_expense_#ay_ind#_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
								<cfset deger1 = evaluate("row_total_expense_#ay_ind#_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
								<cfset deger1_2 = evaluate("row_total_expense_#ay_ind#_2_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
							<cfelse>
								<cfset deger1 = 0>
								<cfset deger1_2 = 0>
							</cfif>
							<!--- gerçekleşen gider --->
							<cfif isdefined("total_exp_#ay_ind#_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
								<cfset deger4 = evaluate("total_exp_#ay_ind#_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
								<cfset deger4_2 = evaluate("total_exp_#ay_ind#_2_#get_expense_center.expense_id#_#get_expense_cat.expense_cat_id#")>
							<cfelse>
								<cfset deger4 = 0>
								<cfset deger4_2 = 0>
							</cfif>
							<cfset cat_toplam = cat_toplam + deger1>
							<cfset cat_toplam_2 = cat_toplam_2 + deger1_2>
							<cfset cat_toplam2 = cat_toplam2 + deger4>
							<cfset cat_toplam2_2 = cat_toplam2_2 + deger4_2>
							<cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + deger1>
							<cfset 'toplam_ay_2_#ay_ind#' = evaluate('toplam_ay_2_#ay_ind#') + deger1_2>
							<cfset 'toplam_ay2_#ay_ind#' = evaluate('toplam_ay2_#ay_ind#') + deger4>
							<cfset 'toplam_ay2_2_#ay_ind#' = evaluate('toplam_ay2_2_#ay_ind#') + deger4_2>
							
							<td  style="text-align:right;" format="numeric">#TlFormat(deger1)#</td>
							<td>&nbsp;#session.ep.money#</td>
							<td  style="text-align:right;" format="numeric">#TlFormat(deger4)#</td>
							<td>&nbsp;#session.ep.money#</td>
							<cfif isdefined("attributes.is_diff")>
								<td  nowrap style="text-align:right;" format="numeric">#TlFormat(deger1-deger4)#</td>
								<td>&nbsp;#session.ep.money#</td>
							</cfif>
							<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				
								<td  style="text-align:right;" format="numeric">#TlFormat(deger1_2)#</td>
								<td>&nbsp;#session.ep.money2#</td>
								<td  style="text-align:right;" format="numeric">#TlFormat(deger4_2)#</td>
								<td>&nbsp;#session.ep.money2#</td>
								<cfif isdefined("attributes.is_diff")>
									<td  nowrap style="text-align:right;" format="numeric">#TlFormat(deger1_2-deger4_2)#</td>
									<td>&nbsp;#session.ep.money2#</td>
								</cfif>
							</cfif>
						</cfloop>
					
						<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam)#</td>
						<td>&nbsp;#session.ep.money#</td>
						<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam2)#</td>
						<td>&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_diff")>
							<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam-cat_toplam2)#</td>
							<td>&nbsp;#session.ep.money#</td>
						</cfif>
						<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
							<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
							<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam2_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
							<cfif isdefined("attributes.is_diff")>
								<td  nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam_2-cat_toplam2_2)#</td>
								<td>&nbsp;#session.ep.money2#</td>
							</cfif>
						</cfif>
					</tr>					
					<cfset genel_toplam = genel_toplam + cat_toplam> 
					<cfset genel_toplam2 = genel_toplam2 + cat_toplam2>
					<cfset genel_toplam_2 = genel_toplam_2 + cat_toplam_2> 
					<cfset genel_toplam2_2 = genel_toplam2_2 + cat_toplam2_2>
				</cfloop>		
			</cfoutput>
		</tbody>
		<cfoutput>
		<tr>
			<cfset colspan_no_ = 3>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<cfset colspan_no_ = colspan_no_ + 1>
			</cfif>
			<td colspan="#colspan_no_#"  nowrap class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
			
			<cfloop list="#month_list#" index="ay_ind">
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_#ay_ind#'))#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay2_#ay_ind#'))#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				<cfif isdefined("attributes.is_diff")>
					<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_#ay_ind#')-evaluate('toplam_ay2_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				</cfif>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_2_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay2_2_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					<cfif isdefined("attributes.is_diff")>
						<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_2_#ay_ind#')-evaluate('toplam_ay2_2_#ay_ind#'))#</cfoutput></td>
						<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					</cfif>
				</cfif>
				
			</cfloop>
			<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam)#</cfoutput></td>
			<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
			<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam2)#</cfoutput></td>
			<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
			<cfif isdefined("attributes.is_diff")>
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam-genel_toplam2)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
			</cfif>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam_2)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
				<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam2_2)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
				<cfif isdefined("attributes.is_diff")>
					<td  nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam_2-genel_toplam2_2)#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
				</cfif>
			</cfif>
		</tr>
		</cfoutput>
	<cfelse>
		<tbody>
			<tr >
				<td colspan="<cfoutput>#myCol2#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</tbody>
	</cfif>
</cfif>
