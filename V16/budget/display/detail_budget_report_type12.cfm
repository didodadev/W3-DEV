<cfquery name="get_act_types" datasource="#dsn2#">
	SELECT 
		DISTINCT ISNULL(WORKGROUP_ID,0) WORKGROUP_ID
	FROM
		EXPENSE_ITEMS_ROWS
	WHERE
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
</cfquery>
<cfif not listlen(exp_inc_center_list)><cfset exp_inc_center_list = valuelist(get_act_types.WORKGROUP_ID)></cfif>
<cfquery name="GET_WORKGROUP" datasource="#DSN#">
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
		WORKGROUP_ID,
		WORKGROUP_NAME
		<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
			,SETUP_ACTIVITY.ACTIVITY_ID
		</cfif>
	FROM
		WORK_GROUP
		<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
			,SETUP_ACTIVITY
		</cfif>
	WHERE
		STATUS = 1 AND
		IS_BUDGET = 1
		<cfif len(exp_inc_center_list)>
			AND WORKGROUP_ID IN (#exp_inc_center_list#)
		</cfif>
	ORDER BY
		WORKGROUP_NAME
</cfquery>
	<thead>	
		<tr>
			<th width="25" nowrap></th>
			<th nowrap></th>
			<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
				<cfif isdefined("attributes.is_diff")>
					<cfset colspan_info = 14>
				<cfelse>
					<cfset colspan_info = 10>
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.is_diff")>
					<cfset colspan_info = 7>
				<cfelse>
					<cfset colspan_info = 5>
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
				<th colspan="2" align="center" nowrap><cf_get_lang dictionary_id='60912.Gelir-Gider Farkı'></th>
			</cfif>
		</tr>
		<tr class="color-header" height="20">
			<th width="25" nowrap><cf_get_lang dictionary_id='57487.No'></th>
			<th width="150" nowrap><cf_get_lang dictionary_id='58140.İş Grubu'></th>
			<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
				<th><cf_get_lang no='90.Aktivite Tipi'></th>
			</cfif>
			<cfif isdefined("attributes.is_income")>
				
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'> </th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				</cfif>
				<th width="35" nowrap style="text-align:right;">%</th>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<cfif isdefined("attributes.is_diff")>
						<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					</cfif>
					<th width="35" nowrap style="text-align:right;">%</th>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.is_expense")>
				
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th>
				<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<cfif isdefined("attributes.is_diff")>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				</cfif>
				<th width="35" nowrap style="text-align:right;">%</th>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th>
					<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<cfif isdefined("attributes.is_diff")>
						<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58583.Fark'></th>
						<th nowrap><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					</cfif>
					<th width="35" nowrap style="text-align:right;">%</th>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>			
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='58869.Planlanan'></th>
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'></th>
				<th width="35" nowrap style="text-align:right;"><cf_get_lang dictionary_id='58869.Planlanan'> %</th>
				<th width="35" nowrap style="text-align:right;"><cf_get_lang dictionary_id='49176.Gerçekleşen'> %</th>
			</cfif>
			<cfif isdefined("attributes.ei_diff")>				
				<th width="110" align="center" nowrap><cf_get_lang dictionary_id='49176.Gerçekleşen'> </th>
			</cfif>
		</tr>
	</thead>
	<cfparam name="attributes.totalrecords" default='#get_workgroup.recordcount#'>
	<cfif attributes.page neq 1>
		<cfoutput query="get_workgroup" startrow="1" maxrows="#attributes.startrow-1#">
			<cfquery name="GET_EXPENSE_2" datasource="#DSN#">
				SELECT 
					SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME) ROW_TOTAL_INCOME,
					SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE) ROW_TOTAL_EXPENSE,
					SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2) ROW_TOTAL_INCOME_2,
					SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2) ROW_TOTAL_EXPENSE_2
					<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
						<cfif len(get_workgroup.activity_id)>
							,#get_workgroup.activity_id# AS ACTIVITY_TYPE_ID
						<cfelse>
							,NULL AS ACTIVITY_TYPE_ID
						</cfif>
					</cfif>
				FROM
					BUDGET_PLAN,
					BUDGET_PLAN_ROW 
				WHERE 
					BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
					BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
					BUDGET_PLAN_ROW.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#WORKGROUP_ID#"> AND
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
					<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
						<cfif len(get_workgroup.activity_id)>
							AND BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID = #get_workgroup.activity_id#
						<cfelse>
							AND BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID IS NULL
						</cfif>
					</cfif>
			</cfquery>
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
						WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#WORKGROUP_ID#"> AND
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
						<cfif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
							<cfif len(get_expense_center_.expense_id)>
								AND EXPENSE_CENTER_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
							<cfelse>
								AND 1=0
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
							<cfif len(get_workgroup.activity_id)>
								AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #get_workgroup.activity_id#
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
		</cfoutput>	
	</cfif>
	<cfif get_workgroup.recordcount>
    	<tbody>
			<cfoutput query="get_workgroup" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
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
						BUDGET_PLAN.BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">) AND
						BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
						BUDGET_PLAN_ROW.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#WORKGROUP_ID#"> AND
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
				</cfquery>
				<cfquery name="GET_ROWS_2" datasource="#dsn2#">
					SELECT
						SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
						SUM(TOTAL_AMOUNT_2) TOTAL_AMOUNT_2,
						EXPENSE_CENTER_ID,
						IS_INCOME,
						ACTIVITY_TYPE
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
							IS_INCOME,
							ACTIVITY_TYPE
						FROM
							EXPENSE_ITEMS_ROWS
						WHERE
							WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#WORKGROUP_ID#"> AND
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
							<cfif x_authorized_branch eq 1 and isdefined("get_expense_center_")>
								<cfif len(get_expense_center_.expense_id)>
									AND EXPENSE_CENTER_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center_.expense_id,','))#)
								<cfelse>
									AND 1=0
								</cfif>
							</cfif>
					)T1
					GROUP BY
						EXPENSE_CENTER_ID,
						IS_INCOME,
						ACTIVITY_TYPE
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
				<cfscript>
					toplam1 = toplam1 + deger1;
					toplam2 = toplam2 + deger2;
					toplam3 = toplam3 + deger3;
					toplam4 = toplam4 + deger4;
				</cfscript>
				<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
					<cfscript>
						toplam1_2 = toplam1_2 + deger1_2;
						toplam2_2 = toplam2_2 + deger2_2;
						toplam3_2 = toplam3_2 + deger3_2;
						toplam4_2 = toplam4_2 + deger4_2;
					</cfscript>			
				</cfif>
				<tr>
					<td>#currentrow#</td>
					<td nowrap>#WORKGROUP_NAME#</td>
					<cfif isdefined("attributes.is_activity_type") and len(attributes.is_activity_type)>
						<td>
							<cfif len(GET_ROWS_2.ACTIVITY_TYPE)>
								<cfquery name="GET_ACTIVITY_TYPE" datasource="#DSN#">
									SELECT
										ACTIVITY_ID,
										ACTIVITY_NAME
									FROM
										SETUP_ACTIVITY
									WHERE
										ACTIVITY_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ROWS_2.ACTIVITY_TYPE#">
									ORDER BY
										ACTIVITY_NAME
								</cfquery>
								#GET_ACTIVITY_TYPE.ACTIVITY_NAME#
							</cfif>
						</td>
					</cfif>
					<cfif isdefined("attributes.is_income")>
						<td style="text-align:right;" format="numeric">#TlFormat(deger1)#</td>
						<td>&nbsp;#session.ep.money#</td>
						<td style="text-align:right;" format="numeric">#TlFormat(deger4)#</td>
						<td>&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_diff")>
							<td style="text-align:right;" format="numeric">#TlFormat(deger1-deger4)#</td>
							<td>&nbsp;#session.ep.money#</td>
						</cfif>
						<td style="text-align:right;" format="numeric"><cfif deger1 neq 0>#TLFormat((deger4/deger1)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
							<td style="text-align:right;" format="numeric">#TlFormat(deger1_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
							<td style="text-align:right;" format="numeric">#TlFormat(deger4_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
							<cfif isdefined("attributes.is_diff")>
								<td style="text-align:right;" format="numeric">#TlFormat(deger1_2-deger4_2)#</td>
								<td>&nbsp;#session.ep.money2#</td>
							</cfif>
							<td style="text-align:right;" format="numeric"><cfif deger1_2 neq 0>#TLFormat((deger4_2/deger1_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.is_expense")>
					
						<td style="text-align:right;" format="numeric">#TlFormat(deger2)#</td>
						<td>&nbsp;#session.ep.money#</td>
						<td style="text-align:right;" format="numeric">#TlFormat(deger3)# </td>
						<td>&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_diff")>
							<td style="text-align:right;" format="numeric">#TlFormat(deger2-deger3)# </td>
							<td>&nbsp;#session.ep.money#</td>
						</cfif>
						<td style="text-align:right;" format="numeric"><cfif deger2 neq 0>#TLFormat((deger3/deger2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
							<td style="text-align:right;" format="numeric">#TlFormat(deger2_2)#</td>
							<td>&nbsp;#session.ep.money2#</td>
							<td style="text-align:right;" format="numeric">#TlFormat(deger3_2)# </td>
							<td>&nbsp;#session.ep.money2#</td>
							<cfif isdefined("attributes.is_diff")>
								<td style="text-align:right;" format="numeric">#TlFormat(deger2_2-deger3_2)# </td>
								<td>&nbsp;#session.ep.money2#</td>
							</cfif>
							<td style="text-align:right;"><cfif deger2_2 neq 0>#TLFormat((deger3_2/deger2_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>						
						<td style="text-align:right;" format="numeric">#TLFormat(deger1-deger2)#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(deger4-deger3)#</td>		
						<td style="text-align:right;" format="numeric"><cfif deger2 neq 0>#TLFormat(((deger1-deger2)/deger2)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
						<td style="text-align:right;" format="numeric"><cfif deger3 neq 0>#TLFormat(((deger4-deger3)/deger3)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
					</cfif>
					<cfif isdefined("attributes.ei_diff")>
						<td style="text-align:right;" format="numeric">#TLFormat(deger4-deger3)#</td>
					</cfif>
				</tr>
		  </cfoutput>
   		</tbody>	  
   		<tfoot>		  
			<cfoutput>
				<tr>
					<td colspan="2" height="20" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<cfif isdefined("attributes.is_income")>
					
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1)#</td>
						<td class="txtbold">&nbsp;#session.ep.money#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam4)#</td>
						<td class="txtbold">&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_diff")>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1-toplam4)#</td>
							<td class="txtbold">&nbsp;#session.ep.money#</td>
						</cfif>
						<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam1 neq 0>#TLFormat((toplam4/toplam1)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1_2)#</td>
							<td class="txtbold">&nbsp;#session.ep.money2#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam4_2)#</td>
							<td class="txtbold">&nbsp;#session.ep.money2#</td>
							<cfif isdefined("attributes.is_diff")>
								<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1_2-toplam4_2)#</td>
								<td class="txtbold">&nbsp;#session.ep.money2#</td>
							</cfif>
							<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam1_2 neq 0>#TLFormat((toplam4_2/toplam1_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.is_expense")>
						
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam2)#</td>
						<td class="txtbold">&nbsp;#session.ep.money#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam3)#</td>
						<td class="txtbold">&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_diff")>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam2-toplam3)#</td>
							<td class="txtbold">&nbsp;#session.ep.money#</td>
						</cfif>
						<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam2 neq 0>#TLFormat((toplam3/toplam2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						<cfif isdefined("attributes.is_money") and len(session.ep.money2)>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam2_2)#</td>
							<td class="txtbold">&nbsp;#session.ep.money2#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam3_2)#</td>
							<td class="txtbold">&nbsp;#session.ep.money2#</td>
							<cfif isdefined("attributes.is_diff")>
								<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam2_2-toplam3_2)#</td>
								<td class="txtbold">&nbsp;#session.ep.money2#</td>
							</cfif>
							<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam2_2 neq 0>#TLFormat((toplam3_2/toplam2_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.durum") and isdefined("attributes.is_income") and isdefined("attributes.is_expense")>						
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam1-toplam2)#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#TlFormat(toplam4-toplam3)#</td>	
						<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam2 neq 0>#TLFormat(((toplam1-toplam2)/toplam2)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
						<td class="txtbold" style="text-align:right;" format="numeric"><cfif toplam3 neq 0>#TLFormat(((toplam4-toplam3)/toplam3)*100)#<cfelse>#TLFormat(0)#</cfif></td>					
					</cfif>
					<cfif isdefined("attributes.ei_diff")>
						<td style="text-align:right;" format="numeric">#TLFormat(toplam4-toplam3)#</td>
					</cfif>
				</tr>
				<tr height="23">
					<td colspan="36" class="txtbold">
						<cf_get_lang no='70.Planlanan Gelir Gider Farkı'>: %<cfif toplam2 neq 0>#TlFormat(((toplam2-toplam1)/toplam2)*100)#<cfelse>#TlFormat(0)#</cfif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang no='69.Gerçekleşen Gelir Gider Farkı'>: %<cfif toplam3 neq 0>#TlFormat(((toplam3-toplam4)/toplam3)*100)#<cfelse>#TlFormat(0)#</cfif>
					</td>
				</tr>
			</cfoutput>
		</tfoot>	
    <cfelse>
		<tbody>		
			<tr>
				<td colspan="36"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</tbody>	
	</cfif>
