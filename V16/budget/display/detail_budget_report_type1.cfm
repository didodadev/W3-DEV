<cfif isDefined("attributes.zero_data")>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
			WITH SETUP_ACTIVITY AS (
				SELECT
					ACTIVITY_ID
				FROM
					#dsn#.SETUP_ACTIVITY
				
				UNION ALL

				SELECT NULL
			)
		</cfif>
		SELECT 
			BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
			EXPENSE_ID,
			EXPENSE_CODE,
			EXPENSE
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				,BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID AS ACTIVITY_ID
			</cfif>
		FROM #dsn#.BUDGET_PLAN
			,#dsn#.BUDGET_PLAN_ROW
			, EXPENSE_CENTER
		WHERE 
			BUDGET_PLAN.BUDGET_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">)  
			AND BUDGET_PLAN.PROCESS_TYPE <> 161 
			AND BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID
			AND ROW_TOTAL_EXPENSE != 0 
			AND ROW_TOTAL_EXPENSE_2 != 0
			AND BUDGET_PLAN_ROW.EXP_INC_CENTER_ID = EXPENSE_CENTER.EXPENSE_ID
			AND EXPENSE_CENTER.EXPENSE_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
			<cfif len(exp_inc_center_list)>AND EXPENSE_CENTER.EXPENSE_ID IN (#exp_inc_center_list#)</cfif>
			<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
				AND EXPENSE_CENTER.EXPENSE_ID IN (#attributes.expense_center_id#)
			<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
				<cfif len(get_expense_center_.expense_id)>
					AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
				<cfelse>
					AND 1=0
				</cfif>
			</cfif>
			<cfif session.ep.isBranchAuthorization>
				AND EXPENSE_CENTER.EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
		GROUP BY 
			BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
			EXPENSE_ID,
			EXPENSE_CODE,
			EXPENSE
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				,BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID
			</cfif>
		UNION 
		SELECT 
			EXPENSE_CENTER_ID,
			EXPENSE_ID,
			EXPENSE_CODE,
			EXPENSE
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				,ACTIVITY_ID
			</cfif>
		FROM (
			SELECT EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT TOTAL_AMOUNT
				,EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2
				,EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
				,EXPENSE_CENTER.EXPENSE_ID
				,EXPENSE_CENTER.EXPENSE_CODE
				,EXPENSE_CENTER.EXPENSE
				<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
					,SETUP_ACTIVITY.ACTIVITY_ID AS ACTIVITY_ID
				</cfif>				
			FROM 
				EXPENSE_ITEMS_ROWS
				,EXPENSE_CENTER
				<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
					,SETUP_ACTIVITY
				</cfif>
			WHERE 
				TOTAL_AMOUNT > 0
				AND OTHER_MONEY_VALUE_2 > 0
				AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID = EXPENSE_CENTER.EXPENSE_ID
				AND EXPENSE_CENTER.EXPENSE_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
				<cfif isdefined("attributes.is_income") and isdefined("attributes.is_expense")>
					AND EXPENSE_ITEMS_ROWS.IS_INCOME IN (1,0)
				<cfelseif  isdefined("attributes.is_income")>
					AND EXPENSE_ITEMS_ROWS.IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> 
				<cfelseif  isdefined("attributes.is_expense")>
					AND EXPENSE_ITEMS_ROWS.IS_INCOME = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> 
				</cfif>
				<cfif len(exp_inc_center_list)>AND EXPENSE_CENTER.EXPENSE_ID IN (#exp_inc_center_list#)</cfif>
			<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
				AND EXPENSE_CENTER.EXPENSE_ID IN (#attributes.expense_center_id#)
			<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
				<cfif len(get_expense_center_.expense_id)>
					AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
				<cfelse>
					AND 1=0
				</cfif>
			</cfif>
			<cfif session.ep.isBranchAuthorization>
				AND EXPENSE_CENTER.EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			) T1
		WHERE TOTAL_AMOUNT != 0
				AND TOTAL_AMOUNT_2 != 0
		GROUP BY 
			EXPENSE_CENTER_ID,
			EXPENSE_ID,
			EXPENSE_CODE,
			EXPENSE
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				,ACTIVITY_ID
			</cfif>
	</cfquery>
<cfelse>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
			WITH SETUP_ACTIVITY AS (
				SELECT
					ACTIVITY_ID
				FROM
					#dsn#.SETUP_ACTIVITY
				
				UNION ALL

				SELECT NULL
			)
		</cfif>
		SELECT
			EXPENSE_ID,
			EXPENSE,
			EXPENSE_CODE
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				,SETUP_ACTIVITY.ACTIVITY_ID
			</cfif>
		FROM
			EXPENSE_CENTER
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				,SETUP_ACTIVITY
			</cfif>
		WHERE
			EXPENSE_ID IS NOT NULL AND
			EXPENSE_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
			<cfif len(exp_inc_center_list)>AND EXPENSE_ID IN (#exp_inc_center_list#)</cfif>
			<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
				AND EXPENSE_ID IN (#attributes.expense_center_id#)
			<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
				<cfif len(get_expense_center_.expense_id)>
					AND EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
				<cfelse>
					AND 1=0
				</cfif>
			</cfif>
			<cfif session.ep.isBranchAuthorization>
				AND EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
		ORDER BY EXPENSE_CODE
	</cfquery>
</cfif>
<cfset sub_colspan = 2>
	<thead>	
		<tr>
			<th width="25" nowrap></th>
			<th nowrap></th>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<th nowrap></th>
			</cfif>
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				<th nowrap></th>
			</cfif>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<cfif isdefined("attributes.is_diff")>
					<cfset colspan_info = 17>
				<cfelse>
					<cfset colspan_info = 12>
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.is_diff")>
					<cfset colspan_info = 10>
				<cfelse>
					<cfset colspan_info = 7>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.is_income")>
				<th colspan="<cfoutput>#colspan_info#</cfoutput>" align="center" nowrap><cf_get_lang dictionary_id='58677.Gelir'></th>
			</cfif>
			<cfif isdefined("attributes.is_expense")>
				<th colspan="<cfoutput>#colspan_info#</cfoutput>" align="center" nowrap><cf_get_lang dictionary_id='58678.Gider'></th>
			</cfif>
			<cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>				
				<th colspan="4" align="center" nowrap><cf_get_lang dictionary_id='57756.Durum'></th>
			</cfif>
			<cfif isdefined("attributes.ei_diff")>				
				<th colspan="5" align="center" nowrap><cf_get_lang dictionary_id='60912.Gelir-Gider Farkı'></th>
			</cfif>
		</tr>
		<tr>
			<th width="25" nowrap><cf_get_lang dictionary_id='57487.No'></th>
			<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
				<th nowrap><cf_get_lang dictionary_id='49109.Masraf Merkezi Kodu'></th>
				<cfset sub_colspan = sub_colspan + 1>
			</cfif>
			<th><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></th>
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				<th><cf_get_lang dictionary_id ="49184.Aktivite tipi"></th>
			</cfif>
			<cfif isdefined("attributes.is_income")>
			
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<th><cf_get_lang dictionary_id='58048.Rezerve Edilen'></th>
				<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<th colspan="2" width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'> </th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<cfset sub_colspan = sub_colspan + 4>
				</cfif>
				<th width="35" nowrap >%</th>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th><cf_get_lang dictionary_id='58048.Rezerve Edilen'></th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<cfif isdefined("attributes.is_diff")>
						<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						<cfset sub_colspan = sub_colspan + 4>
					</cfif>
					<th width="35" nowrap >%</th>
					<cfset sub_colspan = sub_colspan + 7>
				</cfif>
				<cfset sub_colspan = sub_colspan + 8>
			</cfif>
			<cfif isdefined("attributes.is_expense")>
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<th><cf_get_lang dictionary_id='58048.Rezerve Edilen'></th>
				<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<th colspan="2" width="110" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<cfset sub_colspan = sub_colspan + 4>
				</cfif>
				<th width="35" nowrap >%</th>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th><cf_get_lang dictionary_id='58048.Rezerve Edilen'></th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<cfif isdefined("attributes.is_diff")>
						<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						<cfset sub_colspan = sub_colspan + 4>
					</cfif>
					<th width="35" nowrap >%</th>
					<cfset sub_colspan = sub_colspan + 7>
				</cfif>
				<cfset sub_colspan = sub_colspan + 8>
			</cfif>
			<cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th>
				<th width="35" nowrap ><cf_get_lang dictionary_id='58869.Planlanan'> %</th>
				<th width="35" nowrap ><cf_get_lang dictionary_id='49176.Gerçekleşen'> %</th>
				<cfset sub_colspan = sub_colspan + 7>
			</cfif>
			<cfif isdefined("attributes.ei_diff")>				
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'> </th>
			</cfif>
		</tr>
 	</thead>
	<cfparam name="attributes.totalrecords" default='#GET_EXPENSE_CENTER.recordcount#'>
	<cfif attributes.page neq 1>
		<cfoutput query="get_expense_center" startrow="1" maxrows="#attributes.startrow-1#">
			<cfquery name="GET_EXPENSE_2" datasource="#DSN#">
				SELECT 
					SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME) ROW_TOTAL_INCOME,
					SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE) ROW_TOTAL_EXPENSE,
					SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2) ROW_TOTAL_INCOME_2,
					SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2) ROW_TOTAL_EXPENSE_2
				FROM
					BUDGET_PLAN,
					BUDGET_PLAN_ROW 
				WHERE 
					BUDGET_PLAN.BUDGET_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
					BUDGET_PLAN_ROW.EXP_INC_CENTER_ID IN (#expense_id#) AND
					BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
					BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID 
					<cfif len(attributes.search_date1)>
						AND BUDGET_PLAN_ROW.PLAN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
					</cfif>
					<cfif len(attributes.search_date2)>
						AND BUDGET_PLAN_ROW.PLAN_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
					</cfif>
					<cfif isdefined("attributes.plan_process_cat") and len(attributes.plan_process_cat)>
						AND BUDGET_PLAN.PROCESS_CAT IN (#attributes.plan_process_cat#)
					</cfif>
			</cfquery>
			<cfquery name="GET_ROWS_2" datasource="#dsn2#">
				SELECT
					SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
					SUM(TOTAL_AMOUNT_2) TOTAL_AMOUNT_2,
					EXPENSE_CENTER_ID,
					IS_INCOME
				FROM
				(
					SELECT 
						<cfif attributes.is_kdv eq 1>
							TOTAL_AMOUNT TOTAL_AMOUNT,
							OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
						<cfelse>
							(AMOUNT*ISNULL(QUANTITY,1)) TOTAL_AMOUNT,
							CASE WHEN(OTHER_MONEY_VALUE_2 = 0) THEN 0 ELSE (AMOUNT/(TOTAL_AMOUNT/OTHER_MONEY_VALUE_2)*ISNULL(QUANTITY,1)) END AS TOTAL_AMOUNT_2,
						</cfif>
						EXPENSE_CENTER_ID,
						IS_INCOME
					FROM
						EXPENSE_ITEMS_ROWS
					WHERE
						EXPENSE_CENTER_ID IN (#expense_id#) AND
						TOTAL_AMOUNT > 0					
					<cfif len(attributes.search_date1)>
						AND EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
					</cfif>
					<cfif len(attributes.search_date2)>
						AND EXPENSE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
					</cfif>
					<cfif len(attributes.project_id)>
						AND PROJECT_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
					</cfif>
					<cfif isDefined("attributes.process_cat") and len(attributes.process_cat)>
						AND EXPENSE_COST_TYPE IN (#attributes.process_cat#)
					</cfif>
				)T1
				GROUP BY
					EXPENSE_CENTER_ID,
					IS_INCOME
			</cfquery>
			<cfquery name="GET_ROWS_3" datasource="#dsn2#">
				SELECT
					SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
					SUM(TOTAL_AMOUNT_2) TOTAL_AMOUNT_2,
					EXPENSE_CENTER_ID,
					IS_INCOME
				FROM
				(
					SELECT 
						<cfif attributes.is_kdv eq 1>
							TOTAL_AMOUNT TOTAL_AMOUNT,
							OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
						<cfelse>
							(AMOUNT*ISNULL(QUANTITY,1)) TOTAL_AMOUNT,
							CASE WHEN(OTHER_MONEY_VALUE_2 = 0) THEN 0 ELSE (AMOUNT/(TOTAL_AMOUNT/OTHER_MONEY_VALUE_2)*ISNULL(QUANTITY,1)) END AS TOTAL_AMOUNT_2,
						</cfif>
						EXPENSE_CENTER_ID,
						IS_INCOME
					FROM
						EXPENSE_RESERVED_ROWS
					WHERE
						EXPENSE_CENTER_ID IN (#expense_id#) AND
						TOTAL_AMOUNT > 0					
					<cfif len(attributes.search_date1)>
						AND EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
					</cfif>
					<cfif len(attributes.search_date2)>
						AND EXPENSE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
					</cfif>
					<cfif len(attributes.project_id)>
						AND PROJECT_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
					</cfif>
				)T1
				GROUP BY
					EXPENSE_CENTER_ID,
					IS_INCOME
			</cfquery>
			<cfif len(GET_EXPENSE_2.ROW_TOTAL_INCOME)>
				<cfset toplam1 = toplam1 + GET_EXPENSE_2.ROW_TOTAL_INCOME>
			</cfif>
			<cfif len(GET_EXPENSE_2.ROW_TOTAL_EXPENSE)>
				<cfset toplam2 = toplam2 + GET_EXPENSE_2.ROW_TOTAL_EXPENSE>
			</cfif>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<cfif len(GET_EXPENSE_2.ROW_TOTAL_INCOME_2)>
					<cfset toplam1_2 = toplam1_2 + GET_EXPENSE_2.ROW_TOTAL_INCOME_2>
				</cfif>
				<cfif len(GET_EXPENSE_2.ROW_TOTAL_EXPENSE_2)>
					<cfset toplam2_2 = toplam2_2 + GET_EXPENSE_2.ROW_TOTAL_EXPENSE_2>
				</cfif>
			</cfif>
			<cfloop query="get_rows_2">
				<cfif is_income eq 0>
					<cfset toplam3 = toplam3 + get_rows_2.total_amount>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<cfset toplam3_2 = toplam3_2 + get_rows_2.total_amount_2>
					</cfif>
				<cfelse>
					<cfset toplam4 = toplam4 + get_rows_2.total_amount>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<cfset toplam4_2 = toplam4_2 + get_rows_2.total_amount_2>
					</cfif>
				</cfif>
			</cfloop>
			<cfloop query="get_rows_3">
				<cfif is_income eq 0>
					<cfset toplam_rez_3 = toplam_rez_3 + get_rows_2.total_amount>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<cfset toplam_rez_3_2 = toplam_rez_3_2 + get_rows_2.total_amount_2>
					</cfif>
				<cfelse>
					<cfset toplam_rez_4 = toplam_rez_4 + get_rows_2.total_amount>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<cfset toplam_rez_4_2 = toplam_rez_4_2 + get_rows_2.total_amount_2>
					</cfif>
				</cfif>
			</cfloop>
		</cfoutput>	
	</cfif>								                                                            
	<cfif get_expense_center.recordcount>
		<cfset row=0>
		<tbody>  
			<cfoutput query="get_expense_center" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfquery name="GET_EXPENSE_2" datasource="#DSN#">
					SELECT 
						SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME) ROW_TOTAL_INCOME,
						SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE) ROW_TOTAL_EXPENSE,
						SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2) ROW_TOTAL_INCOME_2,
						SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2) ROW_TOTAL_EXPENSE_2
						<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
							<cfif len(get_expense_center.activity_id)>
								,#get_expense_center.activity_id# AS ACTIVITY_TYPE_ID
							<cfelse>
								,NULL AS ACTIVITY_TYPE_ID
							</cfif>
						</cfif>
					FROM
						BUDGET_PLAN,
						BUDGET_PLAN_ROW 
					WHERE 
						BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
						BUDGET_PLAN_ROW.EXP_INC_CENTER_ID IN (#expense_id#) AND
						BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
						BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID 
					<cfif len(attributes.search_date1)>
						AND BUDGET_PLAN_ROW.PLAN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
					</cfif>
					<cfif len(attributes.search_date2)>
						AND BUDGET_PLAN_ROW.PLAN_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
					</cfif>
					<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
						<cfif len(get_expense_center.activity_id)>
							AND BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID = #get_expense_center.activity_id#
						<cfelse>
							AND BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID IS NULL
						</cfif>
					</cfif>
					<cfif isdefined("attributes.plan_process_cat") and len(attributes.plan_process_cat)>
						AND BUDGET_PLAN.PROCESS_CAT IN (#attributes.plan_process_cat#)
					</cfif>
				</cfquery>
				<cfloop query="GET_EXPENSE_2">
					<cfset row = row + 1>
					<cfquery name="GET_ROWS_2" datasource="#dsn2#">
						SELECT
							SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
							SUM(TOTAL_AMOUNT_2) TOTAL_AMOUNT_2,
							EXPENSE_CENTER_ID,
							IS_INCOME
							<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
								,ACTIVITY_TYPE
							</cfif>
						FROM
						(
							SELECT 
								<cfif attributes.is_kdv eq 1>
									TOTAL_AMOUNT TOTAL_AMOUNT,
									OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
								<cfelse>
									(AMOUNT*ISNULL(QUANTITY,1)) TOTAL_AMOUNT,
									CASE WHEN(OTHER_MONEY_VALUE_2 = 0) THEN 0 ELSE (AMOUNT/(TOTAL_AMOUNT/OTHER_MONEY_VALUE_2)*ISNULL(QUANTITY,1)) END AS TOTAL_AMOUNT_2,
								</cfif>
								EXPENSE_CENTER_ID,
								IS_INCOME
								<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
								,ACTIVITY_TYPE
								</cfif>
							FROM
								EXPENSE_ITEMS_ROWS
							WHERE
								EXPENSE_CENTER_ID IN (#get_expense_center.expense_id#) AND
								TOTAL_AMOUNT > 0					
							<cfif len(attributes.search_date1)>
								AND EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
							</cfif>
							<cfif len(attributes.search_date2)>
								AND EXPENSE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
							</cfif>
							<cfif len(attributes.project_id)>
								AND PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
							</cfif>
							<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
								AND EXPENSE_COST_TYPE IN (#attributes.process_cat#)
							</cfif>
							<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
								<cfif len(get_expense_center.activity_id)>
									AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #get_expense_center.activity_id#
								<cfelse>
									AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE IS NULL
								</cfif>
							</cfif>
						)T1
						GROUP BY
							EXPENSE_CENTER_ID,
							IS_INCOME
							<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
								,ACTIVITY_TYPE
							</cfif>
					</cfquery>
					<cfquery name="GET_ROWS_3" datasource="#dsn2#">
						SELECT
							SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
							SUM(TOTAL_AMOUNT_2) TOTAL_AMOUNT_2,
							EXPENSE_CENTER_ID,
							IS_INCOME
							<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
								,ACTIVITY_TYPE
							</cfif>
						FROM
						(
							SELECT 
								<cfif attributes.is_kdv eq 1>
									TOTAL_AMOUNT TOTAL_AMOUNT,
									OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
								<cfelse>
									(AMOUNT*ISNULL(QUANTITY,1)) TOTAL_AMOUNT,
									CASE WHEN(OTHER_MONEY_VALUE_2 = 0) THEN 0 ELSE (AMOUNT/(TOTAL_AMOUNT/OTHER_MONEY_VALUE_2)*ISNULL(QUANTITY,1)) END AS TOTAL_AMOUNT_2,
								</cfif>
								EXPENSE_CENTER_ID,
								IS_INCOME
								<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
								,ACTIVITY_TYPE
								</cfif>
							FROM
								EXPENSE_RESERVED_ROWS
							WHERE
								EXPENSE_CENTER_ID IN (#get_expense_center.expense_id#) AND
								TOTAL_AMOUNT > 0					
							<cfif len(attributes.search_date1)>
								AND EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
							</cfif>
							<cfif len(attributes.search_date2)>
								AND EXPENSE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
							</cfif>
							<cfif len(attributes.project_id)>
								AND PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)
							</cfif>
							<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
								AND EXPENSE_COST_TYPE IN (#attributes.process_cat#)
							</cfif>
							<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
								<cfif len(get_expense_center.activity_id)>
									AND EXPENSE_RESERVED_ROWS.ACTIVITY_TYPE = #get_expense_center.activity_id#
								<cfelse>
									AND EXPENSE_RESERVED_ROWS.ACTIVITY_TYPE IS NULL
								</cfif>
							</cfif>
						)T1
						GROUP BY
							EXPENSE_CENTER_ID,
							IS_INCOME
							<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
								,ACTIVITY_TYPE
							</cfif>
					</cfquery>
					<cfscript>
						deger1 = 0;
						deger2 = 0;
						deger3 = 0;
						deger4 = 0;
						deger1_2 = 0;
						deger2_2 = 0;
						deger3_2 = 0;
						deger4_2 = 0;
						deger_rez_3 =0;
						deger_rez_4 = 0;
						deger_rez_3_2 = 0;
						deger_rez_4_2 = 0;
					</cfscript>
					<cfif len(GET_EXPENSE_2.ROW_TOTAL_INCOME)>
						<cfset deger1 = GET_EXPENSE_2.ROW_TOTAL_INCOME>
					</cfif>
					<cfif len(GET_EXPENSE_2.ROW_TOTAL_EXPENSE)>
						<cfset deger2 = GET_EXPENSE_2.ROW_TOTAL_EXPENSE>
					</cfif>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<cfif len(GET_EXPENSE_2.ROW_TOTAL_INCOME_2)>
							<cfset deger1_2 = GET_EXPENSE_2.ROW_TOTAL_INCOME_2>
						</cfif>
						<cfif len(GET_EXPENSE_2.ROW_TOTAL_EXPENSE_2)>
							<cfset deger2_2 = GET_EXPENSE_2.ROW_TOTAL_EXPENSE_2>
						</cfif>
					</cfif>
					<cfloop query="get_rows_2">
						<cfif is_income eq 0>
							<cfset deger3 = deger3 + get_rows_2.total_amount>
							<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
								<cfset deger3_2 = deger3_2 + get_rows_2.total_amount_2>
							</cfif>
						<cfelse>
							<cfset deger4 = deger4 + get_rows_2.total_amount>
							<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
								<cfset deger4_2 = deger4_2 + get_rows_2.total_amount_2>
							</cfif>
						</cfif>
					</cfloop>
					<cfloop query="get_rows_3">
						<cfif is_income eq 0>
							<cfset deger_rez_3 = deger_rez_3 + get_rows_3.total_amount>
							<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
								<cfset deger_rez_3_2 = deger_rez_3_2 + get_rows_3.total_amount_2>
							</cfif>
						<cfelse>
							<cfset deger_rez_4 = deger_rez_4 + get_rows_3.total_amount>
							<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
								<cfset deger_rez_4_2 = deger_rez_4_2 + get_rows_3.total_amount_2>
							</cfif>
						</cfif>
					</cfloop>
					<cfscript>
						toplam1 = toplam1 + deger1;
						toplam2 = toplam2 + deger2;
						toplam3 = toplam3 + deger3;
						toplam4 = toplam4 + deger4;
						toplam_rez_3 = toplam_rez_3 + deger_rez_3;
						toplam_rez_4 = toplam_rez_4 + deger_rez_4;
					</cfscript>
					<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
						<cfscript>
							toplam1_2 = toplam1_2 + deger1_2;
							toplam2_2 = toplam2_2 + deger2_2;
							toplam3_2 = toplam3_2 + deger3_2;
							toplam4_2 = toplam4_2 + deger4_2;
							toplam_rez_3_2 = toplam_rez_3_2 + deger_rez_3_2;
							toplam_rez_4_2 = toplam_rez_4_2 + deger_rez_4_2;
						</cfscript>			
					</cfif>
						<tr>
							<td>#row#</td>
							<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1>
								<td nowrap style="mso-number-format:\@;">#get_expense_center.expense_code#</td>
							</cfif>
							<td>#get_expense_center.expense#</td>
							<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
								<td>
									<cfif len(GET_EXPENSE_2.ACTIVITY_TYPE_ID)>
										<cfquery name="GET_ACTIVITY_TYPE" datasource="#DSN#">
											SELECT
												ACTIVITY_ID,
												ACTIVITY_NAME
											FROM
												SETUP_ACTIVITY
											WHERE
												ACTIVITY_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_EXPENSE_2.ACTIVITY_TYPE_ID#">
											ORDER BY
												ACTIVITY_NAME
										</cfquery>
										#GET_ACTIVITY_TYPE.ACTIVITY_NAME#
									</cfif>						
								</td>
							</cfif>
							<cfif isdefined("attributes.is_income")>						
								<td  style="text-align:right;" format="numeric">#TlFormat(deger1)#</td>
								<td>#session.ep.money#</td>
								<td  style="text-align:right;" format="numeric">#TlFormat(deger_rez_4)#</td>
								<td>#session.ep.money#</td>
								<td  style="text-align:right;" format="numeric">#TlFormat(deger4)#</td>
								<td width="5" align="center">
									<a href="#request.self#?fuseaction=budget.budget_income_summery&form_submitted=1<cfif len(attributes.project_id)>&project_id=#attributes.project_id#</cfif><cfif len(attributes.search_date1) and len(attributes.search_date2)>&search_date1=#dateformat(attributes.search_date1,dateformat_style)#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#</cfif>&expense_center_id=#get_expense_center.expense_id#<cfif len(attributes.process_cat)>&process_cat=#attributes.process_cat#</cfif>" class="tableyazi" target="blank_"><i class="icon-ellipsis"></i></a>																							
								</td>
								<td>#session.ep.money#</td>
								<cfif isdefined("attributes.is_diff")>
									<td  style="text-align:right;" format="numeric">#TlFormat(deger1-deger4)#</td>
									<td>#session.ep.money#</td>
								</cfif>
								<td  style="text-align:right;" format="numeric"><cfif deger1 neq 0>#TLFormat((deger4/deger1)*100)#<cfelse>#TLFormat(0)#</cfif></td>
								<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
									<td  style="text-align:right;" format="numeric">#TlFormat(deger1_2)#</td>
									<td>#session.ep.money2#</td>
									<td  style="text-align:right;" format="numeric">#TlFormat(deger_rez_4_2)#</td>
									<td>#session.ep.money2#</td>
									<td  style="text-align:right;" format="numeric">#TlFormat(deger4_2)#</td>
									<td>#session.ep.money2#</td>
									<cfif isdefined("attributes.is_diff")>
										<td  style="text-align:right;" format="numeric">#TlFormat(deger1_2-deger4_2)#</td>
										<td>#session.ep.money2#</td>
									</cfif>
									<td  style="text-align:right;" format="numeric"><cfif deger1_2 neq 0>#TLFormat((deger4_2/deger1_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
								</cfif>
							</cfif>
							<cfif isdefined("attributes.is_expense")>						
								<td  style="text-align:right;" format="numeric">#TlFormat(deger2)#</td>
								<td>#session.ep.money#</td>
								<td  style="text-align:right;" format="numeric">#TlFormat(deger_rez_3)# </td>
								<td>#session.ep.money#</td>
								<td  style="text-align:right;" format="numeric">#TlFormat(deger3)# </td>
								<td width="5" align="center">
									<a href="#request.self#?fuseaction=cost.list_expense_management&form_exist=1<cfif len(attributes.project_id)>&project_id=#attributes.project_id#</cfif><cfif len(attributes.search_date1) and len(attributes.search_date2)>&search_date1=#dateformat(attributes.search_date1,dateformat_style)#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#</cfif>&expense_center_id=#get_expense_center.expense_id#" class="tableyazi" target="blank_"><i class="icon-ellipsis"></i></a>																							
								</td>
								<td>#session.ep.money#</td>
								<cfif isdefined("attributes.is_diff")>
									<td  style="text-align:right;" format="numeric">#TlFormat(deger2-deger3)# </td>
									<td>#session.ep.money#</td>
								</cfif>
								<td  style="text-align:right;" format="numeric"><cfif deger2 neq 0>#TLFormat((deger3/deger2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
								<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
									<td  style="text-align:right;" format="numeric">#TlFormat(deger2_2)#</td>
									<td>#session.ep.money2#</td>
									<td  style="text-align:right;" format="numeric">#TlFormat(deger_rez_3_2)#</td>
									<td>#session.ep.money2#</td>
									<td  style="text-align:right;" format="numeric">#TlFormat(deger3_2)#</td>
									<td>#session.ep.money2#</td>
									<cfif isdefined("attributes.is_diff")>
										<td  style="text-align:right;" format="numeric">#TlFormat(deger2_2-deger3_2)# </td>
										<td>#session.ep.money2#</td>
									</cfif>
									<td  style="text-align:right;" format="numeric"><cfif deger2_2 neq 0>#TLFormat((deger3_2/deger2_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
								</cfif>
							</cfif>
							<cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>							
								<td  style="text-align:right;" format="numeric">#TLFormat(deger1-deger2)#</td>
								<td  style="text-align:right;" format="numeric">#TLFormat(deger4-deger3)#</td>		
								<td  style="text-align:right;" format="numeric"><cfif deger2 neq 0>#TLFormat(((deger1-deger2)/deger2)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
								<td  style="text-align:right;" format="numeric"><cfif deger3 neq 0>#TLFormat(((deger4-deger3)/deger3)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
							</cfif>
							<cfif isdefined("attributes.ei_diff")>
								<td  style="text-align:right;" format="numeric">#TLFormat(deger4-deger3)#</td>
							</cfif>
						</tr>
				</cfloop>

			</cfoutput>
		</tbody>
		<tfoot>  
			<cfoutput>
				<tr>
					<cfif isdefined('is_show_exp_center_code') and is_show_exp_center_code eq 1 or (isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)) >
						<cfset colspan= 3>
					<cfelse>
						<cfset colspan= 2>
					</cfif>
					<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
						<cfset colspan = colspan + 1>
					</cfif>
					<td colspan="#colspan#" style="text-align:center;" class="txtbold" ><cf_get_lang dictionary_id='57492.Toplam'></td>
					<cfif isdefined("attributes.is_income")>
					
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1)#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam_rez_4)#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam4)#</td>
						<td></td>
						<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money#</td>
						<cfif isdefined("attributes.is_diff")>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1-toplam4)#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money#</td>
						</cfif>
						<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam1 neq 0>#TLFormat((toplam4/toplam1)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1_2)#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money2#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam_rez_4_2)#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money2#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam4_2)#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money2#</td>
							<cfif isdefined("attributes.is_diff")>
								<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1_2-toplam4_2)#</td>
								<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money2#</td>
							</cfif>
							<td class="txtbold"   format="numeric"><cfif toplam1_2 neq 0>#TLFormat((toplam4_2/toplam1_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.is_expense")>
						
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam2)#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam_rez_3)#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam3)#</td>
						<td></td>
						<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money#</td>
						<cfif isdefined("attributes.is_diff")>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam2-toplam3)#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#session.ep.money#</td>
						</cfif>
						<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam2 neq 0>#TLFormat((toplam3/toplam2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
							<td class="txtbold"  style="text-align:right;" format="numeric">#TlFormat(toplam2_2)#</td>
							<td class="txtbold">#session.ep.money2#</td>
							<td class="txtbold"  style="text-align:right;" format="numeric">#TlFormat(toplam_rez_3_2)#</td>
							<td class="txtbold">#session.ep.money2#</td>
							<td class="txtbold"  style="text-align:right;" format="numeric">#TlFormat(toplam3_2)#</td>
							<td class="txtbold">#session.ep.money2#</td>
							<cfif isdefined("attributes.is_diff")>
								<td class="txtbold"  style="text-align:right;" format="numeric">#TlFormat(toplam2_2-toplam3_2)#</td>
								<td class="txtbold">#session.ep.money2#</td>
							</cfif>
							<td class="txtbold"  style="text-align:right;" format="numeric"><cfif toplam2_2 neq 0>#TLFormat((toplam3_2/toplam2_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>
						
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1-toplam2)#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam4-toplam3)#</td>	
						<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam2 neq 0>#TLFormat(((toplam1-toplam2)/toplam2)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
						<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam3 neq 0>#TLFormat(((toplam4-toplam3)/toplam3)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
					</cfif>
					<cfif isdefined("attributes.ei_diff")>
						<td  style="text-align:right;" format="numeric">#TLFormat(toplam4-toplam3)#</td>
					</cfif>
				</tr>
				<tr>
					<td colspan="#sub_colspan#" class="txtbold">
						<cf_get_lang dictionary_id='49164.Planlanan Gelir Gider Farkı'>: %<cfif toplam2 neq 0>#TlFormat(((toplam2-toplam1)/toplam2)*100)#<cfelse>#TlFormat(0)#</cfif><cf_get_lang dictionary_id='49163.Gerçekleşen Gelir Gider Farkı'>: %<cfif toplam3 neq 0>#TlFormat(((toplam3-toplam4)/toplam3)*100)#<cfelse>#TlFormat(0)#</cfif>
					</td>
				</tr>
			</cfoutput>
		</tfoot>  
	<cfelse>
		<tbody> 
			<tr>
				<cfoutput><td colspan="#sub_colspan#"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></cfoutput>
			</tr>    
		</tbody>
	</cfif>
