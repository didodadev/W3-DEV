<cfquery name="get_cost" datasource="#dsn#"><!--- Planlanan --->
	SELECT
		SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME) AMOUNT_VALUE,
		SUM(ISNULL(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2,0)) AMOUNT_VALUE_2,
		DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) MONTH_VALUE,
		SETUP_ACTIVITY.ACTIVITY_ID,
		SETUP_ACTIVITY.ACTIVITY_NAME
	FROM
		BUDGET_PLAN,
		BUDGET_PLAN_ROW,
		SETUP_ACTIVITY
	WHERE
		BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
		BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
		BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
		SETUP_ACTIVITY.ACTIVITY_ID = BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID AND
		DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) IN (#month_list#)
		<cfif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
			<cfif len(get_expense_center_.expense_id)>
				AND EXP_INC_CENTER_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
			<cfelse>
				AND 1=0
			</cfif>
		</cfif>
	GROUP BY
		DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE),
		SETUP_ACTIVITY.ACTIVITY_ID,
		SETUP_ACTIVITY.ACTIVITY_NAME
</cfquery>
<cfquery name="get_cost2" datasource="#dsn2#"><!--- Gerçekleşen --->
	SELECT
		SUM(AMOUNT_VALUE) AMOUNT_VALUE,
		SUM(ISNULL(AMOUNT_VALUE_2,0)) AMOUNT_VALUE_2,
		MONTH_VALUE,
		ACTIVITY_NAME,
		ACTIVITY_ID
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
			SETUP_ACTIVITY.ACTIVITY_ID,
			SETUP_ACTIVITY.ACTIVITY_NAME
		FROM
			EXPENSE_ITEMS_ROWS,
			#dsn_alias#.SETUP_ACTIVITY SETUP_ACTIVITY
		WHERE
			EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = SETUP_ACTIVITY.ACTIVITY_ID AND
			EXPENSE_ITEMS_ROWS.IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			TOTAL_AMOUNT > 0 AND
			DATEPART(MM,EXPENSE_ITEMS_ROWS.EXPENSE_DATE) IN (#month_list#)
			<cfif len(attributes.project_id)>
				AND EXPENSE_ITEMS_ROWS.PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
			</cfif>
			<cfif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
				<cfif len(get_expense_center_.expense_id)>
					AND EXPENSE_CENTER_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
				<cfelse>
					AND 1=0
				</cfif>
			</cfif>
	)T1
	GROUP BY
		MONTH_VALUE,
		ACTIVITY_NAME,
		ACTIVITY_ID
</cfquery>
<cfquery name="get_other_exp" datasource="#dsn2#">
	SELECT 
		ACTIVITY_ID,
		ACTIVITY_NAME 
	FROM
		#dsn_alias#.SETUP_ACTIVITY
	WHERE
		ACTIVITY_ID NOT IN(SELECT ACTIVITY_TYPE_ID FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE ACTIVITY_TYPE_ID IS NOT NULL AND DATEPART(MM,PLAN_DATE) IN (#month_list#)) AND 
		ACTIVITY_ID IN(SELECT ACTIVITY_TYPE FROM <cfif not fusebox.use_period>#dsn_alias#.</cfif>EXPENSE_ITEMS_ROWS WHERE ACTIVITY_TYPE IS NOT NULL AND DATEPART(MM,EXPENSE_DATE) IN (#month_list#) AND IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND TOTAL_AMOUNT > 0)
		<cfif attributes.is_all_exp_center eq 2>
			AND 1 = 2
		</cfif>
		<cfif isdefined("attributes.activity_id") and len(attributes.activity_id)>
			AND ACTIVITY_ID IN (#attributes.activity_id#)
		</cfif>
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" dbtype="query">
	SELECT DISTINCT 
		ACTIVITY_ID,
		ACTIVITY_NAME 
	FROM 
		GET_COST
	UNION ALL
	SELECT DISTINCT 
		ACTIVITY_ID,
		ACTIVITY_NAME 
	FROM 
		get_other_exp
</cfquery>
<cfset genel_toplam = 0>
<cfset genel_toplam2 = 0>
<cfset genel_toplam_2 = 0>
<cfset genel_toplam2_2 = 0>
<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
	<cfif isdefined("attributes.is_diff")>
		<cfset colspan_info = 12>
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
		<thead>
			<tr>
				<th style="text-align:left;" colspan="92" class="formbold"><cf_get_lang dictionary_id='58089.Gelirler'></th>
			</tr>
			<tr>
				<th nowrap>&nbsp;</th>
				<th width="1" nowrap></th>
				<cfloop list="#month_list#" index="k">
					<th colspan="#colspan_info#" align="center" class="form-title" nowrap><cfoutput>#listgetat(aylar,k,',')#</cfoutput></th>
					  <cfquery name="GET_COST_#k#" dbtype="query">
						SELECT * FROM GET_COST WHERE MONTH_VALUE = #k# ORDER BY ACTIVITY_ID
					  </cfquery>
					  <cfset 'ay_cat_list_#k#' = ''>
					  <cfset 'toplam_ay_#k#' = 0>
					  <cfset 'toplam_ay_2_#k#' = 0>
					  <cfset ay_que = evaluate('GET_COST_#k#')>
					  <cfif ay_que.recordcount>
						<cfset 'ay_cat_list_#k#' = listsort(valuelist(ay_que.ACTIVITY_ID,','),'numeric','ASC',',')>
					  </cfif>
					  <cfquery name="GET_COST_2_#k#" dbtype="query">
						SELECT * FROM GET_COST2 WHERE MONTH_VALUE = #k# ORDER BY ACTIVITY_ID
					  </cfquery>
					  <cfset 'ay_cat_list2_#k#' = ''>
					  <cfset 'toplam_ay2_#k#' = 0>
					  <cfset 'toplam_ay2_2_#k#' = 0>
					  <cfset ay_que2 = evaluate('GET_COST_2_#k#')>
					  <cfif ay_que2.recordcount>
						<cfset 'ay_cat_list2_#k#' = listsort(valuelist(ay_que2.ACTIVITY_ID,','),'numeric','ASC',',')>
					  </cfif>
					  <th width="1" nowrap></th>
				</cfloop>
				<th align="center" colspan="<cfoutput>#colspan_info#</cfoutput>" class="form-title" nowrap><cf_get_lang dictionary_id='57492.Toplam'></th>
			</tr>
			<tr>
				<th><cf_get_lang dictionary_id ="49184.Aktivite tipi"></th><cfset myCol = myCol + 1>
				<th width="1"></th><cfset myCol = myCol + 1>
				<cfloop list="#month_list#" index="k">
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
					<th width="1"></th><cfset myCol = myCol + 1>
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
		<cfif get_expense_center.recordcount>
			<tbody>
				<cfoutput query="GET_EXPENSE_CENTER">
					<cfset cat_toplam = 0>
					<cfset cat_toplam2 = 0>
					<cfset cat_toplam_2 = 0>
					<cfset cat_toplam2_2 = 0>
					<tr>
						<td nowrap>#GET_EXPENSE_CENTER.ACTIVITY_NAME#</td>
						<td width="1"></td>
						<cfloop list="#month_list#" index="ay_ind">
							<cfset ay_que = evaluate('GET_COST_#ay_ind#')>
							<cfset cat_yeri = listfind(evaluate('ay_cat_list_#ay_ind#'),ACTIVITY_ID,',')>
							<td nowrap style="text-align:right;" format="numeric"><!--- Planlanan sistem dövizi --->
								<cfif cat_yeri><cfset cat_toplam = cat_toplam + ay_que.AMOUNT_VALUE[cat_yeri]><cfset cat_toplam_2 = cat_toplam_2 + ay_que.AMOUNT_VALUE_2[cat_yeri]><cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + ay_que.AMOUNT_VALUE[cat_yeri]><cfset 'toplam_ay_2_#ay_ind#' = evaluate('toplam_ay_2_#ay_ind#') + ay_que.AMOUNT_VALUE_2[cat_yeri]>#TlFormat(ay_que.AMOUNT_VALUE[cat_yeri])# <cfset amount1 = ay_que.AMOUNT_VALUE[cat_yeri]><cfset amount1_2 = ay_que.AMOUNT_VALUE_2[cat_yeri]><cfelse>-<cfset amount1 = 0><cfset amount1_2 = 0></cfif>
							</td>
							<td>&nbsp;#session.ep.money#</td>
							<cfset ay_que2 = evaluate('GET_COST_2_#ay_ind#')>
							<cfset cat_yeri2 = listfind(evaluate('ay_cat_list2_#ay_ind#'),ACTIVITY_ID,',')>
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
							<td width="1" nowrap></td>
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
			<tfoot>	
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td width="1" nowrap></td>
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
						<td width="1" nowrap></td>
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
			</tfoot>	
        <cfelse>
			<tbody>
				<tr>
					<td colspan="<cfoutput>#myCol#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</tbody>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.is_expense")>
		<cfquery name="get_cost" datasource="#dsn#">
			SELECT
				SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE) AMOUNT_VALUE,
				SUM(ISNULL(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2,0)) AS AMOUNT_VALUE_2,
				DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) MONTH_VALUE,
				SETUP_ACTIVITY.ACTIVITY_ID,
				SETUP_ACTIVITY.ACTIVITY_NAME
			FROM
				BUDGET_PLAN,
				BUDGET_PLAN_ROW,
				SETUP_ACTIVITY
			WHERE
				BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
				BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
				BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
				SETUP_ACTIVITY.ACTIVITY_ID = BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID AND
				DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE) IN (#month_list#)
				<cfif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
					<cfif len(get_expense_center_.expense_id)>
						AND EXP_INC_CENTER_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
					<cfelse>
						AND 1=0
					</cfif>
				</cfif>
			GROUP BY
				DATEPART(MM,BUDGET_PLAN_ROW.PLAN_DATE),
				SETUP_ACTIVITY.ACTIVITY_ID,
				SETUP_ACTIVITY.ACTIVITY_NAME
		</cfquery>
		<cfquery name="get_cost2" datasource="#dsn2#"><!--- Gerçekleşen --->
			SELECT
				SUM(AMOUNT_VALUE) AMOUNT_VALUE,
				SUM(ISNULL(AMOUNT_VALUE_2,0)) AMOUNT_VALUE_2,
				MONTH_VALUE,
				ACTIVITY_NAME,
				ACTIVITY_ID
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
					SETUP_ACTIVITY.ACTIVITY_ID,
					SETUP_ACTIVITY.ACTIVITY_NAME
				FROM
					EXPENSE_ITEMS_ROWS,
					#dsn_alias#.SETUP_ACTIVITY SETUP_ACTIVITY
				WHERE
					EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = SETUP_ACTIVITY.ACTIVITY_ID AND
					EXPENSE_ITEMS_ROWS.IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
					TOTAL_AMOUNT > 0 AND
					DATEPART(MM,EXPENSE_ITEMS_ROWS.EXPENSE_DATE) IN (#month_list#)
					<cfif len(attributes.project_id)>
						AND EXPENSE_ITEMS_ROWS.PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
					</cfif>
					<cfif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
						<cfif len(get_expense_center_.expense_id)>
							AND EXPENSE_CENTER_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
						<cfelse>
							AND 1=0
						</cfif>
					</cfif>
			)T1
			GROUP BY
				MONTH_VALUE,
				ACTIVITY_NAME,
				ACTIVITY_ID
		</cfquery>
		<cfquery name="get_other_exp" datasource="#dsn2#">
			SELECT 
				ACTIVITY_ID,
				ACTIVITY_NAME 
			FROM
				#dsn_alias#.SETUP_ACTIVITY
			WHERE
				ACTIVITY_ID NOT IN(SELECT ACTIVITY_TYPE_ID FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE ACTIVITY_TYPE_ID IS NOT NULL AND DATEPART(MM,PLAN_DATE) IN (#month_list#)) AND 
				ACTIVITY_ID IN(SELECT ACTIVITY_TYPE FROM <cfif not fusebox.use_period>#dsn_alias#.</cfif>EXPENSE_ITEMS_ROWS WHERE ACTIVITY_TYPE IS NOT NULL AND DATEPART(MM,EXPENSE_DATE) IN (#month_list#) AND IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND TOTAL_AMOUNT > 0)
				<cfif attributes.is_all_exp_center eq 2>
					AND 1 = 2
				</cfif>
				<cfif isdefined("attributes.activity_id") and len(attributes.activity_id)>
					AND ACTIVITY_ID IN (#attributes.activity_id#)
				</cfif>
		</cfquery>
		<cfquery name="GET_EXPENSE_CENTER" dbtype="query">
			SELECT DISTINCT 
				ACTIVITY_ID,
				ACTIVITY_NAME 
			FROM 
				GET_COST
		UNION ALL
			SELECT DISTINCT 
				ACTIVITY_ID,
				ACTIVITY_NAME 
			FROM 
				get_other_exp
		</cfquery>
		<cfset genel_toplam = 0>
		<cfset genel_toplam2 = 0>
		<cfset genel_toplam_2 = 0>
		<cfset genel_toplam2_2 = 0>
        <thead>
            <tr>
                <th style="text-align:left;" colspan="92" class="formbold"><cf_get_lang no='47.Giderler'></th>
            </tr>
            <tr>
                <th nowrap>&nbsp;</th>
                <th width="1" nowrap></th>
                <cfloop list="#month_list#" index="k">
                    <th align="center" colspan="#colspan_info#" class="form-title" nowrap><cfoutput>#listgetat(aylar,k,',')#</cfoutput></th>
                    <cfquery name="GET_COST_#k#" dbtype="query">
                        SELECT * FROM GET_COST WHERE MONTH_VALUE = #k# ORDER BY ACTIVITY_ID
                    </cfquery>
                    <cfset 'ay_cat_list_#k#' = ''>
                    <cfset 'toplam_ay_#k#' = 0>
                    <cfset 'toplam_ay_2_#k#' = 0>
                    <cfset ay_que = evaluate('GET_COST_#k#')>
                    <cfif ay_que.recordcount>
                      <cfset 'ay_cat_list_#k#' = listsort(valuelist(ay_que.ACTIVITY_ID,','),'numeric','ASC',',')>
                    </cfif>
                    <cfquery name="GET_COST_2_#k#" dbtype="query">
                        SELECT * FROM GET_COST2 WHERE MONTH_VALUE = #k# ORDER BY ACTIVITY_ID
                    </cfquery>
                    <cfset 'ay_cat_list2_#k#' = ''>
                    <cfset 'toplam_ay2_#k#' = 0>
                    <cfset 'toplam_ay2_2_#k#' = 0>
                    <cfset ay_que2 = evaluate('GET_COST_2_#k#')>
                    <cfif ay_que2.recordcount>
                      <cfset 'ay_cat_list2_#k#' = listsort(valuelist(ay_que2.ACTIVITY_ID,','),'numeric','ASC',',')>
                    </cfif>
                    <th width="1" nowrap></th>
                </cfloop>
                <th align="center" colspan="<cfoutput>#colspan_info#</cfoutput>" class="form-title" nowrap><cf_get_lang dictionary_id='57492.Toplam'></th>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id ="49184.Aktivite tipi"></th><cfset myCol2 = myCol2 + 1>
                <th width="1"></th><cfset myCol2 = myCol2 + 1>
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
                    <th width="1"></th><cfset myCol2 = myCol2 + 1>
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
                        <th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th><cfset myCol2 = myCol2 + 1>
                        <th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th><cfset myCol2 = myCol2 + 1>
                    </cfif>
                </cfif>
            </tr>
        </thead>	
		<cfif get_expense_center.recordcount>
			<tbody>
				<cfoutput query="GET_EXPENSE_CENTER">
					<cfset cat_toplam = 0>
					<cfset cat_toplam2 = 0>
					<cfset cat_toplam_2 = 0>
					<cfset cat_toplam2_2 = 0>
					<tr>
						<td nowrap>#GET_EXPENSE_CENTER.ACTIVITY_NAME#</td>
						<td width="1"></td>
						<cfloop list="#month_list#" index="ay_ind">
							<cfset ay_que = evaluate('GET_COST_#ay_ind#')>
							<cfset cat_yeri = listfind(evaluate('ay_cat_list_#ay_ind#'),ACTIVITY_ID,',')>
							<td nowrap style="text-align:right;" format="numeric"><!--- Planlanan Sistem Dövizi --->
								<cfif cat_yeri><cfset cat_toplam = cat_toplam + ay_que.AMOUNT_VALUE[cat_yeri]><cfset cat_toplam_2 = cat_toplam_2 + ay_que.AMOUNT_VALUE_2[cat_yeri]><cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + ay_que.AMOUNT_VALUE[cat_yeri]><cfset 'toplam_ay_2_#ay_ind#' = evaluate('toplam_ay_2_#ay_ind#') + ay_que.AMOUNT_VALUE_2[cat_yeri]>#TlFormat(ay_que.AMOUNT_VALUE[cat_yeri])#<cfset amount1 = ay_que.AMOUNT_VALUE[cat_yeri]><cfset amount1_2 = ay_que.AMOUNT_VALUE_2[cat_yeri]><cfelse>-<cfset amount1 = 0><cfset amount1_2 = 0></cfif>
							</td>
							<td>&nbsp;#session.ep.money#</td>
							<cfset ay_que2 = evaluate('GET_COST_2_#ay_ind#')><!--- Gerçekleşen Sistem Dövizi --->
							<cfset cat_yeri2 = listfind(evaluate('ay_cat_list2_#ay_ind#'),ACTIVITY_ID,',')>
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
							<td width="1" nowrap></td>
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
			<tfoot>
				<tr>
					<td class="txtbold" nowrap><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td width="1" nowrap></td>
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
						<td width="1" nowrap></td>
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
			</tfoot>
		<cfelse>
			<tbody>	
				<tr>
					<td colspan="<cfoutput>#myCol2#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</tbody>
		</cfif>
	</cfif>

