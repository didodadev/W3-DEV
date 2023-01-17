<!--- Standart Butce Plan Detay --->
<cf_get_lang_set module_name="budget"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_BUDGET_PLAN" datasource="#dsn#">
	SELECT * FROM BUDGET_PLAN WHERE BUDGET_PLAN_ID = #attributes.action_id# 
</cfquery>
<cfif len(get_budget_plan.budget_id)>
	<cfquery name="GET_BUDGET" datasource="#dsn#">
		SELECT * FROM BUDGET WHERE BUDGET_ID = #get_budget_plan.budget_id#
	</cfquery>
	<cfif len(get_budget.branch_id)>
		<cfquery name="GET_BRANCH" datasource="#dsn#">
			SELECT BRANCH_FULLNAME FROM BRANCH WHERE BRANCH_ID=#get_budget.branch_id#
		</cfquery>
	</cfif>
	<cfif len(get_budget.department_id)>
		<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
			SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID=#get_budget.department_id#
		</cfquery>
	</cfif>
	<cfif len(get_budget.workgroup_id)>
		<cfquery name="GET_WORKGROUP" datasource="#dsn#">
			SELECT WORKGROUP_NAME FROM WORK_GROUP WHERE WORKGROUP_ID=#get_budget.workgroup_id#
		</cfquery>
	</cfif>
</cfif>
<cfquery name="GET_BUDGET_PLAN_ROW" datasource="#dsn#">
	SELECT * FROM BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID = #attributes.action_id#
</cfquery>
<cfif len(GET_BUDGET_PLAN.PROCESS_TYPE)>
<cfquery name="get_process_type" datasource="#dsn2#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET FROM #dsn3#.SETUP_PROCESS_CAT
</cfquery>
</cfif>
<cfif isdefined("GET_BUDGET_PLAN_ROW.project_id") and len(GET_BUDGET_PLAN_ROW.project_id)>
	<cfquery name="GET_PROJECT" datasource="#dsn#">
		SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#GET_BUDGET_PLAN_ROW.project_id#
	</cfquery>
</cfif>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
	COMPANY_NAME
	FROM 
		OUR_COMPANY 
	WHERE 
		<cfif isdefined("attributes.our_company_id")>
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>
		<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
			COMP_ID = #session.ep.company_id#
		<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
			COMP_ID = #session.pp.company_id#
		<cfelseif isDefined("session.ww.our_company_id")>
			COMP_ID = #session.ww.our_company_id#
		<cfelseif isDefined("session.cp.our_company_id")>
			COMP_ID = #session.cp.our_company_id#
		</cfif> 
		</cfif> 
</cfquery>

<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<table style="width:210mm">
	<tr>
		<td>
			<table width="100%">
				<tr class="row_border">
					<td class="print-head">
						<table style="width:100%;">
							<tr>
								<cfif GET_BUDGET_PLAN.PROCESS_TYPE eq 1601>
								<td class="print_title"><cf_get_lang dictionary_id="61810.bütçe transfer fişi "></td>
								<cfelseif GET_BUDGET_PLAN.PROCESS_TYPE eq 160>
									<td class="print_title"><cf_get_lang dictionary_id="29947.bütçe planlama fişi "></td>
								<cfelseif GET_BUDGET_PLAN.PROCESS_TYPE eq 161>
									<td class="print_title"><cf_get_lang dictionary_id="29650.tahakkuk fişi "></td>
								<cfelseif GET_BUDGET_PLAN.PROCESS_TYPE eq 162>
									<td class="print_title"><cf_get_lang dictionary_id="60995.bütçe tarnsfer "></td></td>
								</cfif>
									<td style="text-align:right;">
										<cfif len(check.asset_file_name2)>
										<cfset attributes.type = 1>
											<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
										</cfif>
									</td>
								</td>
							</tr> 
						</table>
					</td>
				</tr>
				<tr class="row_border">
					<td>
				<cfoutput query="get_budget">
					<table >
						<tr><td style="width:140px"><b><cf_get_lang_main no='468.Belge No'></b></td>
							<td style="width:150px">#get_budget_plan.paper_no#</td>
							<td style="width:140px"><b><cf_get_lang_main no='41.Şube'></b></td>
							<td style="width:150px"><cfif len(get_budget_plan.budget_id) and len(get_budget.branch_id)>#get_branch.branch_fullname#<cfelse>&nbsp;</cfif></td>
						</tr>
						<tr>
							<td style="width:140px"><b><cf_get_lang_main no='147.Bütçe'></b></td>
							<td style="width:150px">#get_budget.budget_name#</td>
							<td style="width:140px"><b><cf_get_lang_main no='160.Departman'></b></td>
							<td style="width:150px"> <cfif len(get_budget_plan.budget_id) and len(get_budget.department_id)>#get_department.department_head#<cfelse>&nbsp;</cfif></td>
						</tr>
						<tr>
							<td style="width:140px"><b><cf_get_lang_main no='1060.Dönem'></b></td>
							<td style="width:150px">#period_year#</td>
							<td style="width:140px"><b><cf_get_lang no='81.Planlayan'></b></td>
							<td style="width:150px"><cfif len(get_budget_plan.budget_planner_emp_id)>#get_emp_info(get_budget_plan.budget_planner_emp_id,0,0)#<cfelse>&nbsp;</cfif></td>
						</tr>
					</table>
					<table style="height:10mm;">
						<tr>
							<td style="width:140px"><b><cf_get_lang_main no='217.Açıklama'></b></td>
							<td style="width:150px"><cfif len(get_budget_plan.budget_id) and len(get_budget_plan.detail)>#get_budget_plan.detail#<cfelse>&nbsp;</cfif></td>
						</tr> 
					</table>
				</cfoutput>
			</td>
		</tr>
				<!--- Bütçe Planın Satırları--->
				<cfset gelir_toplam=0>
				<cfset gider_toplam=0>
				<cfset fark_toplam=0>
				<cfif get_budget_plan_row.recordcount>
					<cfset expense_list=''>
					<cfset budget_item_list=''>
					<cfset activity_list=''>
					<cfoutput query="get_budget_plan_row">
						<cfif len(exp_inc_center_id) and not listfind(expense_list,exp_inc_center_id)>
							<cfset expense_list=listappend(expense_list,exp_inc_center_id)>
						</cfif>
						<cfif len(budget_item_id) and not listfind(budget_item_list,budget_item_id)>
							<cfset budget_item_list=listappend(budget_item_list,budget_item_id)>
						</cfif>
						<cfif len(activity_type_id) and not listfind(activity_list,activity_type_id)>
							<cfset activity_list=listappend(activity_list,activity_type_id)>
						</cfif>
					</cfoutput>
					<cfif len(expense_list)>
						<cfset expense_list = listsort(expense_list,"numeric","ASC",",")>
						<cfquery name="GET_EXPENSE_CENTER" datasource="#DSN2#">
							SELECT EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN(#expense_list#) ORDER BY EXPENSE_ID
						</cfquery>
					</cfif>
					<cfif len(budget_item_list)>
						<cfset budget_item_list = listsort(budget_item_list,"numeric","ASC",",")>
						<cfquery name="GET_EXPENSE_ITEM" datasource="#DSN2#">
							SELECT EXPENSE_ITEM_NAME,EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN(#budget_item_list#) ORDER BY EXPENSE_ITEM_ID
						</cfquery>
					</cfif>
					<cfif len(activity_list)>
						<cfset activity_list = listsort(activity_list,"numeric","ASC",",")>
						<cfquery name="GET_ACTIVITY" datasource="#DSN#">
							SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_ID IN(#activity_list#) ORDER BY ACTIVITY_ID
						</cfquery>
					</cfif>
					<table>
                        <td style="height:10mm;"><b><cf_get_lang dictionary_id="57771. Detay"></b></td>
                    </table>
					<table class="print_border" style="width:210mm">						
						<tr>
							<th><cf_get_lang_main no='330.Tarih'></th>
							<th><cf_get_lang_main no='217.Açıklama'></th>
							<th><cf_get_lang_main no='823.Masraf/Gelir Merkezi'></th>
							<th><cf_get_lang_main no='822.BKalemi'></th>
							<th><cf_get_lang no='90.Aktivite Tipi'></th>
							<th style="text-align:right;"><cf_get_lang_main no='1265.Gelir'></th>
							<th style="text-align:right;"><cf_get_lang_main no='1266.Gider'></th>
							<th style="text-align:right;"><cf_get_lang_main no='1171.Fark'></th>
						</tr>
						<cfoutput query="get_budget_plan_row">
						<tr>
							<td>#dateformat(get_budget_plan_row.plan_date,dateformat_style)#</td>
							<td>#get_budget_plan_row.detail#</td>
							<td>
							<cfif len(exp_inc_center_id)>
								#get_expense_center.EXPENSE[listfind(expense_list,exp_inc_center_id,',')]#
							<cfelse>
								&nbsp;
							</cfif>
							</td>
							<td >
							<cfif len(budget_item_id)>
								#get_expense_item.EXPENSE_ITEM_NAME[listfind(budget_item_list,budget_item_id,',')]#
							<cfelse>
								&nbsp;
							</cfif>
							</td>
							<td>
							<cfif len(activity_type_id)>
								#get_activity.ACTIVITY_NAME[listfind(activity_list,activity_type_id,',')]#
							<cfelse>
								&nbsp;
							</cfif>
							</td>
							<td style="text-align:right;">#TLFormat(ROW_TOTAL_INCOME)#&nbsp;#session.ep.money#</td>
							<td style="text-align:right;">#TLFormat(ROW_TOTAL_EXPENSE)#&nbsp;#session.ep.money#</td>
							<td style="text-align:right;">#TLFormat(ROW_TOTAL_DIFF)#&nbsp;#session.ep.money#</td>
							<cfset gelir_toplam=gelir_toplam+ROW_TOTAL_INCOME>
							<cfset gider_toplam=gider_toplam+ROW_TOTAL_EXPENSE>
							<cfset fark_toplam=fark_toplam+ROW_TOTAL_DIFF>
						</tr>	
						</cfoutput>
						<tr  >
						<cfoutput>
							<th colspan="5" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></th>
							<td style="text-align:right;" >#TLFormat(gelir_toplam)#&nbsp;#session.ep.money#</td>
							<td style="text-align:right;" >#TLFormat(gider_toplam)#&nbsp;#session.ep.money#</td>
							<td style="text-align:right;" >#TLFormat(fark_toplam)#&nbsp;#session.ep.money#</td>
						</cfoutput>
						</tr>
					</table>
				</cfif>
				<table>
					</br>
						<tr class="fixed">
							<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
						</tr>
					</br>
				</table>
			</table>
		</td>
	</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
