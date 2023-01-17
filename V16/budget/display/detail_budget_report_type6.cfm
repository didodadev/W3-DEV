<cfquery name="get_cost" datasource="#dsn#"><!--- Planlanan --->
	SELECT
		SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME) AMOUNT_VALUE,
		SUM(ISNULL(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2,0)) AMOUNT_VALUE_2,
		DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) MONTH_VALUE,
		EXPENSE_CENTER.EXPENSE,
		EXPENSE_CENTER.EXPENSE_ID,
		EXPENSE_CENTER.EXPENSE_CODE,
		BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID AS ACTIVITY_ID
	FROM
		BUDGET_PLAN,
		BUDGET_PLAN_ROW,
		<cfif fusebox.use_period>#dsn2_alias#.</cfif>EXPENSE_CENTER EXPENSE_CENTER
	WHERE
		BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
		BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
		BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
		EXPENSE_CENTER.EXPENSE_ID = BUDGET_PLAN_ROW.EXP_INC_CENTER_ID AND
		DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) IN (#month_list#) AND
		EXPENSE_CENTER.EXPENSE_ACTIVE = 1
		<cfif session.ep.isBranchAuthorization>
			AND EXPENSE_CENTER.EXPENSE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>
		<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
			AND EXPENSE_CENTER.EXPENSE_ID IN (#attributes.expense_center_id#)
		<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
			<cfif len(get_expense_center_.expense_id)>
				AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
			<cfelse>
				AND 1=0
			</cfif>
		</cfif>
		<cfif isdefined("attributes.plan_process_cat") and len(attributes.plan_process_cat)>
			AND BUDGET_PLAN.PROCESS_CAT IN (#attributes.plan_process_cat#)
		</cfif>
	GROUP BY
		DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE),
		EXPENSE_CENTER.EXPENSE_CODE,
		EXPENSE_CENTER.EXPENSE,
		EXPENSE_CENTER.EXPENSE_ID,
		BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID
</cfquery>
<cfquery name="get_cost2" datasource="#dsn2#"><!--- Gerçekleşen --->
	SELECT
		SUM(AMOUNT_VALUE) AMOUNT_VALUE,
		SUM(ISNULL(AMOUNT_VALUE_2,0)) AMOUNT_VALUE_2,
		MONTH_VALUE,
		EXPENSE,
		EXPENSE_ID,
		EXPENSE_CODE
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
			EXPENSE_CENTER.EXPENSE,
			EXPENSE_CENTER.EXPENSE_ID,
			EXPENSE_CENTER.EXPENSE_CODE
		FROM
			EXPENSE_ITEMS_ROWS,
			<cfif not fusebox.use_period>#dsn_alias#.</cfif>EXPENSE_CENTER EXPENSE_CENTER
		WHERE
			EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID AND
			EXPENSE_ITEMS_ROWS.IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			TOTAL_AMOUNT > 0 AND
			EXPENSE_CENTER.EXPENSE_ACTIVE = 1 AND
			DATEPART(MM,EXPENSE_ITEMS_ROWS.EXPENSE_DATE) IN (#month_list#)
			<cfif len(attributes.project_id)>
				AND EXPENSE_ITEMS_ROWS.PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
			</cfif>
			<cfif session.ep.isBranchAuthorization>
				AND EXPENSE_CENTER.EXPENSE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
			</cfif>
			<cfif isDefined("attributes.process_cat") and len(attributes.process_cat)>
				AND EXPENSE_COST_TYPE IN (#attributes.process_cat#)
			</cfif>
			<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
				AND EXPENSE_CENTER.EXPENSE_ID IN (#attributes.expense_center_id#)
			<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
				<cfif len(get_expense_center_.expense_id)>
					AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
				<cfelse>
					AND 1=0
				</cfif>
			</cfif>
	)T1
	GROUP BY
		MONTH_VALUE,
		EXPENSE,
		EXPENSE_ID,
		EXPENSE_CODE
</cfquery>
<cfquery name="get_other_exp" datasource="#dsn2#">
	SELECT 
		EXPENSE_ID,
		EXPENSE,
		EXPENSE_CODE,
		ACTIVITY_ID
	FROM
		<cfif not fusebox.use_period>#dsn_alias#.</cfif>EXPENSE_CENTER
	WHERE
		EXPENSE_ACTIVE = 1 AND
		EXPENSE_ID NOT IN(SELECT EXP_INC_CENTER_ID FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID IN(SELECT BUDGET_PLAN_ID FROM #dsn_alias#.BUDGET_PLAN WHERE BUDGET_PLAN.PROCESS_TYPE <> 161 AND BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">)) AND EXP_INC_CENTER_ID IS NOT NULL AND DATEPART(MM,PLAN_DATE) IN (#month_list#)) AND 
		EXPENSE_ID IN(SELECT EXPENSE_CENTER_ID FROM <cfif not fusebox.use_period>#dsn_alias#.</cfif>EXPENSE_ITEMS_ROWS WHERE EXPENSE_CENTER_ID IS NOT NULL AND DATEPART(MM,EXPENSE_DATE) IN (#month_list#) AND IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND TOTAL_AMOUNT > 0)
		<cfif attributes.is_all_exp_center eq 2>
			AND 1 = 2
		</cfif>
		<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
			AND EXPENSE_CENTER.EXPENSE_ID IN (#attributes.expense_center_id#)
		<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
			<cfif len(get_expense_center_.expense_id)>
				AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
			<cfelse>
				AND 1=0
			</cfif>
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
	ORDER BY
		EXPENSE
</cfquery>
<cfset genel_toplam = 0>
<cfset genel_toplam2 = 0>
<cfset genel_toplam_2 = 0>
<cfset genel_toplam2_2 = 0>
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
	<tr>
	<cfoutput>
	<thead>
		<tr>
			<th style="text-align:left;" colspan="80" nowrap height="25"><cf_get_lang dictionary_id='58089.Gelirler'></th>
		</tr>
		<tr>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<cfset colspan= 2>
			<cfelse>
				<cfset colspan= 1>
			</cfif>
			<th nowrap colspan="#colspan#">&nbsp;</th>				
			<cfloop list="#month_list#" index="k">
				<th colspan="#colspan_info#" align="center" class="form-title" nowrap><cfoutput>#listgetat(aylar,k,',')#</cfoutput></th>
					<cfquery name="GET_COST_#k#" dbtype="query">
					SELECT * FROM GET_COST WHERE AMOUNT_VALUE != 0 AND AMOUNT_VALUE_2 != 0 AND MONTH_VALUE = #k# ORDER BY EXPENSE_ID
					</cfquery>
					<cfset 'ay_cat_list_#k#' = ''>
					<cfset 'toplam_ay_#k#' = 0>
					<cfset 'toplam_ay_2_#k#' = 0>
					<cfset ay_que = evaluate('GET_COST_#k#')>
					<cfif ay_que.recordcount>
					<cfset 'ay_cat_list_#k#' = listsort(valuelist(ay_que.EXPENSE_ID,','),'numeric','ASC',',')>
					</cfif>
					<cfquery name="GET_COST_2_#k#" dbtype="query">
					SELECT * FROM GET_COST2 WHERE MONTH_VALUE = #k# ORDER BY EXPENSE_ID
					</cfquery>
					<cfset 'ay_cat_list2_#k#' = ''>
					<cfset 'toplam_ay2_#k#' = 0>
					<cfset 'toplam_ay2_2_#k#' = 0>
					<cfset ay_que2 = evaluate('GET_COST_2_#k#')>
					<cfif ay_que2.recordcount>
					<cfset 'ay_cat_list2_#k#' = listsort(valuelist(ay_que2.EXPENSE_ID,','),'numeric','ASC',',')>
					</cfif>
			</cfloop>
			<th align="center" colspan="#colspan_info#" class="form-title" nowrap><cf_get_lang dictionary_id='57492.Toplam'></th>
		</tr>
		<tr>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<th nowrap><cf_get_lang no='4.Gelir Merkezi Kodu'></th><cfset myCol = myCol + 1>
			</cfif>
			<th><cf_get_lang dictionary_id='58172.Gelir Merkezi'></th><cfset myCol = myCol + 1>
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				<th><cf_get_lang dictionary_id ="49184.Aktivite tipi"></th><cfset myCol = myCol + 1>
			</cfif>			
			<cfloop list="#month_list#" index="k">
				<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th> <cfset myCol = myCol + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
				<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol + 1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
				</cfif>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol + 1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
					<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol + 1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
					<cfif isdefined("attributes.is_diff")>
						<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol + 1>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
					</cfif>
				</cfif>
			
			</cfloop>
			<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol + 1>
			<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
			<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol + 1>
			<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
			<cfif isdefined("attributes.is_diff")>
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
			</cfif>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol = myCol + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
				<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol = myCol + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol = myCol + 1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol = myCol + 1>
				</cfif>
			</cfif>
		</tr>
		</thead>
		</cfoutput>
	<cfif get_expense_center.recordcount>
		<tbody>
			<cfoutput query="GET_EXPENSE_CENTER">
				<cfset cat_toplam = 0>
				<cfset cat_toplam2 = 0>
				<cfset cat_toplam_2 = 0>
				<cfset cat_toplam2_2 = 0>
				<tr>
				<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
					<td nowrap>#GET_EXPENSE_CENTER.EXPENSE_CODE#</td>
				</cfif>
				<td nowrap>#GET_EXPENSE_CENTER.EXPENSE#</td>
				<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
					<td>
						<cfif len(ACTIVITY_ID)>
							<cfquery name="GET_ACTIVITY_TYPE" datasource="#DSN#">
								SELECT
									ACTIVITY_ID,
									ACTIVITY_NAME
								FROM
									SETUP_ACTIVITY
								WHERE
									ACTIVITY_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTIVITY_ID#">
								ORDER BY
									ACTIVITY_NAME
							</cfquery>
							#GET_ACTIVITY_TYPE.ACTIVITY_NAME#
						</cfif>
					</td>
				</cfif>
				<cfloop list="#month_list#" index="ay_ind">
					<cfset ay_que = evaluate('GET_COST_#ay_ind#')>
					<cfset cat_yeri = listfind(evaluate('ay_cat_list_#ay_ind#'),EXPENSE_ID,',')>
					<td nowrap style="text-align:right;" format="numeric"><!--- Planlanan sistem dövizi --->
						<cfif cat_yeri><cfset cat_toplam = cat_toplam + ay_que.AMOUNT_VALUE[cat_yeri]><cfset cat_toplam_2 = cat_toplam_2 + ay_que.AMOUNT_VALUE_2[cat_yeri]><cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + ay_que.AMOUNT_VALUE[cat_yeri]><cfset 'toplam_ay_2_#ay_ind#' = evaluate('toplam_ay_2_#ay_ind#') + ay_que.AMOUNT_VALUE_2[cat_yeri]>#TlFormat(ay_que.AMOUNT_VALUE[cat_yeri])#<cfset amount1 = ay_que.AMOUNT_VALUE[cat_yeri]><cfset amount1_2 = ay_que.AMOUNT_VALUE_2[cat_yeri]><cfelse>-<cfset amount1 = 0><cfset amount1_2 = 0></cfif>
					</td>
					<td>&nbsp;#session.ep.money#</td>
					<cfset ay_que2 = evaluate('GET_COST_2_#ay_ind#')>
					<cfset cat_yeri2 = listfind(evaluate('ay_cat_list2_#ay_ind#'),EXPENSE_ID,',')>
					<td nowrap style="text-align:right;" format="numeric"><!--- Gerçekleşen sistem dövizi --->
						<cfif cat_yeri2><cfset cat_toplam2 = cat_toplam2 + ay_que2.AMOUNT_VALUE[cat_yeri2]><cfset cat_toplam2_2 = cat_toplam2_2 + ay_que2.AMOUNT_VALUE_2[cat_yeri2]><cfset 'toplam_ay2_#ay_ind#' = evaluate('toplam_ay2_#ay_ind#') + ay_que2.AMOUNT_VALUE[cat_yeri2]><cfset 'toplam_ay2_2_#ay_ind#' = evaluate('toplam_ay2_2_#ay_ind#') + ay_que2.AMOUNT_VALUE_2[cat_yeri2]>#TlFormat(ay_que2.AMOUNT_VALUE[cat_yeri2])# <cfset amount2 = ay_que2.AMOUNT_VALUE[cat_yeri2]><cfset amount2_2 = ay_que2.AMOUNT_VALUE_2[cat_yeri2]><cfelse>-<cfset amount2 = 0><cfset amount2_2 = 0></cfif>
					</td>
					<td>&nbsp;#session.ep.money#</td>
					<cfif isdefined("attributes.is_diff")>
						<td nowrap style="text-align:right;" format="numeric">#TlFormat(amount1-amount2)#</td>
						<td>&nbsp;#session.ep.money#</td>
					</cfif>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<td nowrap style="text-align:right;" format="numeric"><!--- Planlanan 2.döviz --->
							<cfif cat_yeri>#TlFormat(ay_que.AMOUNT_VALUE_2[cat_yeri])#<cfelse>-</cfif>
						</td>
						<td>&nbsp;#session.ep.money2#</td>
						<td nowrap style="text-align:right;" format="numeric"><!--- Gerçekleşen 2. döviz --->
							<cfif cat_yeri2>#TlFormat(ay_que2.AMOUNT_VALUE_2[cat_yeri2])#<cfelse>-</cfif>
						</td>
						<td>&nbsp;#session.ep.money2#</td>
						<cfif isdefined("attributes.is_diff")>
							<td nowrap style="text-align:right;" format="numeric">#TlFormat(amount1_2-amount2_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
						</cfif>
					</cfif>					
				</cfloop>
				<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam)#</td>
				<td>&nbsp;#session.ep.money#</td>
				<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam2)#</td>
				<td>&nbsp;#session.ep.money#</td>
				<cfif isdefined("attributes.is_diff")>
					<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam-cat_toplam2)#</td>
					<td>&nbsp;#session.ep.money#</td>
				</cfif>			
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam_2)#</td>
					<td>&nbsp;#session.ep.money2#</td>
					<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam2_2)#</td>
					<td>&nbsp;#session.ep.money2#</td>
					<cfif isdefined("attributes.is_diff")>
						<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam_2-cat_toplam2_2)#</td>
						<td>&nbsp;#session.ep.money2#</td>
					</cfif>			
				</cfif>
				</tr>
				<cfset genel_toplam = genel_toplam + cat_toplam> 
				<cfset genel_toplam2 = genel_toplam2 + cat_toplam2>
				<cfset genel_toplam_2 = genel_toplam_2 + cat_toplam_2> 
				<cfset genel_toplam2_2 = genel_toplam2_2 + cat_toplam2_2>
			</cfoutput>
		</tbody>
		<cfoutput>
			<tr>
				<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1 or (isdefined("attributes.is_activity_type") and len(attributes.is_activity_type))>
					<cfset colspan= 3>
				<cfelse>
					<cfset colspan= 1>
				</cfif>
				<td class="txtbold" style="text-align:right;" colspan="<cfoutput>#colspan#</cfoutput>"><cf_get_lang dictionary_id='57492.Toplam'></td>					
				<cfloop list="#month_list#" index="ay_ind">
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay2_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
					<cfif isdefined("attributes.is_diff")>
						<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_#ay_ind#')-evaluate('toplam_ay2_#ay_ind#'))#</cfoutput></td>
						<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
					</cfif>					
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_2_#ay_ind#'))#</cfoutput></td>
						<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
						<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay2_2_#ay_ind#'))#</cfoutput></td>
						<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
						<cfif isdefined("attributes.is_diff")>
							<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_2_#ay_ind#')-evaluate('toplam_ay2_2_#ay_ind#'))#</cfoutput></td>
							<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
						</cfif>					
					</cfif>
				
				</cfloop>
				<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam2)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				<cfif isdefined("attributes.is_diff")>
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam-genel_toplam2)#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				</cfif>					
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam_2)#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam2_2)#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					<cfif isdefined("attributes.is_diff")>
						<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam_2-genel_toplam2_2)#</cfoutput></td>
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
	</tr>
</cfif>
<cfif isdefined("attributes.is_expense")>
	<tr>
	<cfquery name="get_cost" datasource="#dsn#"><!--- Planlanan --->
		SELECT
			SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE) AS AMOUNT_VALUE,
			SUM(ISNULL(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2,0)) AS AMOUNT_VALUE_2,
			DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) AS MONTH_VALUE,
			EXPENSE_CENTER.EXPENSE,
			EXPENSE_CENTER.EXPENSE_ID,
			EXPENSE_CENTER.EXPENSE_CODE,
			BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID AS ACTIVITY_ID
		FROM
			BUDGET_PLAN,
			BUDGET_PLAN_ROW,
			<cfif fusebox.use_period>#dsn2_alias#.</cfif>EXPENSE_CENTER AS EXPENSE_CENTER
		WHERE
			BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
			BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
			BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
			EXPENSE_CENTER.EXPENSE_ID = BUDGET_PLAN_ROW.EXP_INC_CENTER_ID AND
			DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) IN (#month_list#) AND
			EXPENSE_CENTER.EXPENSE_ACTIVE = 1
			<cfif session.ep.isBranchAuthorization>
				AND EXPENSE_CENTER.EXPENSE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
			</cfif>
			<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
				AND EXPENSE_CENTER.EXPENSE_ID IN (#attributes.expense_center_id#)
			<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
				<cfif len(get_expense_center_.expense_id)>
					AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
				<cfelse>
					AND 1=0
				</cfif>
			</cfif>
			<cfif isdefined("attributes.plan_process_cat") and len(attributes.plan_process_cat)>
				AND BUDGET_PLAN.PROCESS_CAT IN (#attributes.plan_process_cat#)
			</cfif>
		GROUP BY
			DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE),
			EXPENSE_CENTER.EXPENSE,
			EXPENSE_CENTER.EXPENSE_ID,
			EXPENSE_CENTER.EXPENSE_CODE,
			BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID
	</cfquery>
	<cfquery name="get_cost2" datasource="#dsn2#"><!--- Gerçekleşen --->
		SELECT
			SUM(AMOUNT_VALUE) AMOUNT_VALUE,
			SUM(ISNULL(AMOUNT_VALUE_2,0)) AMOUNT_VALUE_2,
			MONTH_VALUE,
			EXPENSE,
			EXPENSE_ID,
			EXPENSE_CODE
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
				EXPENSE_CENTER.EXPENSE,
				EXPENSE_CENTER.EXPENSE_ID,
				EXPENSE_CENTER.EXPENSE_CODE
			FROM
				EXPENSE_ITEMS_ROWS,
				<cfif not fusebox.use_period>#dsn_alias#.</cfif>EXPENSE_CENTER EXPENSE_CENTER
			WHERE
				EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID AND
				EXPENSE_ITEMS_ROWS.IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
				TOTAL_AMOUNT > 0 AND
				DATEPART(MM,EXPENSE_ITEMS_ROWS.EXPENSE_DATE) IN (#month_list#) AND
				EXPENSE_CENTER.EXPENSE_ACTIVE = 1	
				<cfif session.ep.isBranchAuthorization>
					AND EXPENSE_CENTER.EXPENSE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
				</cfif>
				<cfif isDefined("attributes.process_cat") and len(attributes.process_cat)>
					AND EXPENSE_COST_TYPE IN (#attributes.process_cat#)
				</cfif>
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
					AND EXPENSE_CENTER.EXPENSE_ID IN (#attributes.expense_center_id#)
				<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
					<cfif len(get_expense_center_.expense_id)>
						AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
					<cfelse>
						AND 1=0
					</cfif>
				</cfif>
		)T1
		GROUP BY
			MONTH_VALUE,
			EXPENSE,
			EXPENSE_ID,
			EXPENSE_CODE
	</cfquery>
	<cfquery name="get_other_exp" datasource="#dsn2#">
		SELECT 
			EXPENSE_ID,
			EXPENSE,
			EXPENSE_CODE,
			ACTIVITY_ID
		FROM
			<cfif not fusebox.use_period>#dsn_alias#.</cfif>EXPENSE_CENTER
		WHERE
			EXPENSE_CENTER.EXPENSE_ACTIVE = 1 AND
			EXPENSE_ID NOT IN(SELECT EXP_INC_CENTER_ID FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID IN(SELECT BUDGET_PLAN_ID FROM #dsn_alias#.BUDGET_PLAN WHERE BUDGET_PLAN.PROCESS_TYPE <> 161 AND BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">)) AND EXP_INC_CENTER_ID IS NOT NULL AND DATEPART(MM,PLAN_DATE) IN (#month_list#)) AND 
			EXPENSE_ID IN(SELECT EXPENSE_CENTER_ID FROM <cfif not fusebox.use_period>#dsn_alias#.</cfif>EXPENSE_ITEMS_ROWS WHERE EXPENSE_CENTER_ID IS NOT NULL AND DATEPART(MM,EXPENSE_DATE) IN (#month_list#) AND IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND TOTAL_AMOUNT > 0)
			<cfif attributes.is_all_exp_center eq 2>
				AND 1 = 2
			</cfif>
			<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
				AND EXPENSE_CENTER.EXPENSE_ID IN (#attributes.expense_center_id#)
			<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
				<cfif len(get_expense_center_.expense_id)>
					AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
				<cfelse>
					AND 1=0
				</cfif>
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
				EXPENSE ,
				EXPENSE_CODE,
				ACTIVITY_ID
			FROM 
				get_other_exp
		<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
			WHERE EXPENSE_ID IN (#attributes.expense_center_id#)
		</cfif>
		ORDER BY
			EXPENSE
	</cfquery>
	<cfset genel_toplam = 0>
	<cfset genel_toplam2 = 0>
	<cfset genel_toplam_2 = 0>
	<cfset genel_toplam2_2 = 0>
<cfoutput>
	<thead>
		<tr>
			<th style="text-align:left;" colspan="80" nowrap><cf_get_lang no='47.Giderler'></th>
		</tr>
		<tr>
				<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<cfset colspan= 2>
				<cfelse>
				<cfset colspan= 1>
				</cfif>
			<th nowrap colspan="#colspan#">&nbsp;</th>			
			<cfloop list="#month_list#" index="k">
				<th align="center" colspan="#colspan_info#" class="form-title" nowrap><cfoutput>#listgetat(aylar,k,',')#</cfoutput></th>
				<cfquery name="GET_COST_#k#" dbtype="query">
					SELECT * FROM GET_COST WHERE MONTH_VALUE = #k# ORDER BY EXPENSE_ID
				</cfquery>
				<cfset 'ay_cat_list_#k#' = ''>
				<cfset 'toplam_ay_#k#' = 0>
				<cfset 'toplam_ay_2_#k#' = 0>
				<cfset ay_que = evaluate('GET_COST_#k#')>
				<cfif ay_que.recordcount>
					<cfset 'ay_cat_list_#k#' = listsort(valuelist(ay_que.EXPENSE_ID,','),'numeric','ASC',',')>
				</cfif>
				<cfquery name="GET_COST_2_#k#" dbtype="query">
					SELECT * FROM GET_COST2 WHERE MONTH_VALUE = #k# ORDER BY EXPENSE_ID
				</cfquery>
				<cfset 'ay_cat_list2_#k#' = ''>
				<cfset 'toplam_ay2_#k#' = 0>
				<cfset 'toplam_ay2_2_#k#' = 0>
				<cfset ay_que2 = evaluate('GET_COST_2_#k#')>
				<cfif ay_que2.recordcount>
					<cfset 'ay_cat_list2_#k#' = listsort(valuelist(ay_que2.EXPENSE_ID,','),'numeric','ASC',',')>
				</cfif>
				
			</cfloop>
			<th align="center" colspan="#colspan_info#" nowrap><cf_get_lang dictionary_id='57492.Toplam'></th>
		</tr>
		<tr>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<th nowrap><cf_get_lang dictionary_id='49109.Masraf Merkezi Kodu'></th><cfset myCol2 = myCol2 + 1>
			</cfif>
			<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th><cfset myCol2 = myCol2 + 1>
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				<th><cf_get_lang dictionary_id ="49184.Aktivite tipi"></th><cfset myCol2 = myCol2 + 1>
			</cfif>
			<cfloop list="#month_list#" index="k">
				<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2 + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
				<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2 + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2 + 1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
				</cfif>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2 + 1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
					<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2 + 1>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
					<cfif isdefined("attributes.is_diff")>
						<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2 + 1>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
					</cfif>
				</cfif>					
			</cfloop>
			<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2 + 1>
			<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
			<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2 + 1>
			<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
			<cfif isdefined("attributes.is_diff")>
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2 + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
			</cfif>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th><cfset myCol2 = myCol2 + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
				<th align="center"><cf_get_lang dictionary_id='49176.Gerçekleşen'></th><cfset myCol2 = myCol2 + 1>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
				</cfif>
			</cfif>
		</tr>
	</thead>
</cfoutput>
	<cfif get_expense_center.recordcount>
		<tbody>
			<cfoutput query="GET_EXPENSE_CENTER">
				<cfset cat_toplam = 0>
				<cfset cat_toplam2 = 0>
				<cfset cat_toplam_2 = 0>
				<cfset cat_toplam2_2 = 0>
				<tr>
					<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
						<td nowrap>#GET_EXPENSE_CENTER.EXPENSE_CODE#</td>
					</cfif>
					<td nowrap>#GET_EXPENSE_CENTER.EXPENSE#</td>
					<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
						<td>
							<cfif len(ACTIVITY_ID)>
								<cfquery name="GET_ACTIVITY_TYPE" datasource="#DSN#">
									SELECT
										ACTIVITY_ID,
										ACTIVITY_NAME
									FROM
										SETUP_ACTIVITY
									WHERE
										ACTIVITY_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTIVITY_ID#">
									ORDER BY
										ACTIVITY_NAME
								</cfquery>
								#GET_ACTIVITY_TYPE.ACTIVITY_NAME#
							</cfif>
						</td>
					</cfif>
					<cfloop list="#month_list#" index="ay_ind">
						<cfset ay_que = evaluate('GET_COST_#ay_ind#')>
						<cfset cat_yeri = listfind(evaluate('ay_cat_list_#ay_ind#'),EXPENSE_ID,',')>
						<td nowrap style="text-align:right;" format="numeric"><!--- Planlanan Sistem Dövizi --->
							<cfif cat_yeri><cfset cat_toplam = cat_toplam + ay_que.AMOUNT_VALUE[cat_yeri]><cfset cat_toplam_2 = cat_toplam_2 + ay_que.AMOUNT_VALUE_2[cat_yeri]><cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + ay_que.AMOUNT_VALUE[cat_yeri]><cfset 'toplam_ay_2_#ay_ind#' = evaluate('toplam_ay_2_#ay_ind#') + ay_que.AMOUNT_VALUE_2[cat_yeri]>#TlFormat(ay_que.AMOUNT_VALUE[cat_yeri])#<cfset amount1 = ay_que.AMOUNT_VALUE[cat_yeri]><cfset amount1_2 = ay_que.AMOUNT_VALUE_2[cat_yeri]><cfelse>-<cfset amount1 = 0><cfset amount1_2 = 0></cfif>
						</td>
						<td>&nbsp;#session.ep.money#</td>
						<cfset ay_que2 = evaluate('GET_COST_2_#ay_ind#')><!--- Gerçekleşen Sistem Dövizi --->
						<cfset cat_yeri2 = listfind(evaluate('ay_cat_list2_#ay_ind#'),EXPENSE_ID,',')>
						<td nowrap style="text-align:right;" format="numeric"><!--- Gerçekleşen Sistem Dövizi --->
							<cfif cat_yeri2><cfset cat_toplam2 = cat_toplam2 + ay_que2.AMOUNT_VALUE[cat_yeri2]><cfset cat_toplam2_2 = cat_toplam2_2 + ay_que2.AMOUNT_VALUE_2[cat_yeri2]><cfset 'toplam_ay2_#ay_ind#' = evaluate('toplam_ay2_#ay_ind#') + ay_que2.AMOUNT_VALUE[cat_yeri2]><cfset 'toplam_ay2_2_#ay_ind#' = evaluate('toplam_ay2_2_#ay_ind#') + ay_que2.AMOUNT_VALUE_2[cat_yeri2]>#TlFormat(ay_que2.AMOUNT_VALUE[cat_yeri2])#<cfset amount2 = ay_que2.AMOUNT_VALUE[cat_yeri2]><cfset amount2_2 = ay_que2.AMOUNT_VALUE_2[cat_yeri2]><cfelse>-<cfset amount2 = 0><cfset amount2_2 = 0></cfif>
						</td>
						<td>&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_diff")>
							<td nowrap style="text-align:right;" format="numeric">#TlFormat(amount1-amount2)#</td>
							<td>&nbsp;#session.ep.money#</td>
						</cfif>
						<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
							<td nowrap style="text-align:right;" format="numeric"><!--- Planlanan 2.döviz --->
								<cfif cat_yeri>#TlFormat(ay_que.AMOUNT_VALUE_2[cat_yeri])#<cfelse>-</cfif>
							</td>
							<td>&nbsp;#session.ep.money2#</td>
							<td nowrap style="text-align:right;" format="numeric"><!--- Gerçekleşen 2. döviz --->
								<cfif cat_yeri2>#TlFormat(ay_que2.AMOUNT_VALUE_2[cat_yeri2])#<cfelse>-</cfif>
							</td>
							<td>&nbsp;#session.ep.money2#</td>
							<cfif isdefined("attributes.is_diff")>
								<td nowrap style="text-align:right;" format="numeric">#TlFormat(amount1_2-amount2_2)#</td>
								<td>&nbsp;#session.ep.money2#</td>
							</cfif>
						</cfif>
					
					</cfloop>
					<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam)#</td>
					<td>&nbsp;#session.ep.money#</td>
					<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam2)#</td>
					<td>&nbsp;#session.ep.money#</td>
					<cfif isdefined("attributes.is_diff")>
						<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam-cat_toplam2)#</td>
						<td>&nbsp;#session.ep.money#</td>
					</cfif>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam_2)#</td>
						<td>&nbsp;#session.ep.money2#</td>
						<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam2_2)#</td>
						<td>&nbsp;#session.ep.money2#</td>
						<cfif isdefined("attributes.is_diff")>
							<td nowrap style="text-align:right;" format="numeric">#TlFormat(cat_toplam_2-cat_toplam2_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
						</cfif>
					</cfif>
				</tr>
				<cfset genel_toplam = genel_toplam + cat_toplam> 
				<cfset genel_toplam2 = genel_toplam2 + cat_toplam2>
				<cfset genel_toplam_2 = genel_toplam_2 + cat_toplam_2> 
				<cfset genel_toplam2_2 = genel_toplam2_2 + cat_toplam2_2>
			</cfoutput>
		</tbody>
		<tbody>
			<tr>
				<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
					<cfset colspan= 3>
				<cfelse>
					<cfset colspan= 1>
				</cfif>
				<td nowrap class="txtbold" style="text-align:right;" colspan="<cfoutput>#colspan#</cfoutput>"><cf_get_lang dictionary_id='57492.Toplam'></td>
			
				<cfloop list="#month_list#" index="ay_ind">
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay2_#ay_ind#'))#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
					<cfif isdefined("attributes.is_diff")>
						<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_#ay_ind#')-evaluate('toplam_ay2_#ay_ind#'))#</cfoutput></td>
						<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
					</cfif>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_2_#ay_ind#'))#</cfoutput></td>
						<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
						<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay2_2_#ay_ind#'))#</cfoutput></td>
						<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
						<cfif isdefined("attributes.is_diff")>
							<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(evaluate('toplam_ay_2_#ay_ind#')-evaluate('toplam_ay2_2_#ay_ind#'))#</cfoutput></td>
							<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
						</cfif>
					</cfif>
			
				</cfloop>
				<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam2)#</cfoutput></td>
				<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				<cfif isdefined("attributes.is_diff")>
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam-genel_toplam2)#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				</cfif>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam_2)#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam2_2)#</cfoutput></td>
					<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					<cfif isdefined("attributes.is_diff")>
						<td nowrap class="txtbold" style="text-align:right;" format="numeric"><cfoutput>#TlFormat(genel_toplam_2-genel_toplam2_2)#</cfoutput></td>
						<td class="txtbold">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></td>
					</cfif>
				</cfif>
			</tr>
		</tbody>
	<cfelse>
		<tbody>
			<tr>
				<td colspan="<cfoutput>#myCol2#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</tbody>
	</cfif>
		</tr>
</cfif>

