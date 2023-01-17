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
<cfif isdefined("get_budget_plan.project_id") and len(get_budget_plan.project_id)>
	<cfquery name="GET_PROJECT" datasource="#dsn#">
		SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#get_budget_plan.project_id#
	</cfquery>
</cfif>
<br/><br/>
<table style="width:200mm;" border="0"  cellpadding="1" cellspacing="1" align="center">
	<tr>
	   <td height="50" class="headbold"><cf_get_lang_main no='788.Gelir/Gider Planı'></td>
	</tr>
</table>
<cfif len(get_budget_plan.budget_id)>
<cfoutput query="get_budget">
<table style="width:200mm;" border="0" cellspacing="1" cellpadding="1" align="center">
	<tr>
 		<td height="20">&nbsp;</td>
    </tr>
	<tr>
		<td valign="top">
		<table width="100%" cellpadding="3" cellspacing="0" border="1">
			<tr height="20">
				<td class="txtbold" width="25"><cf_get_lang_main no='147.Bütçe'></td>
				<td>#budget_name#</td>
				<td class="txtbold"><cf_get_lang_main no='41.Şube'></td>
				<td><cfif len(get_budget_plan.budget_id) and len(get_budget.branch_id)>#get_branch.branch_fullname#<cfelse>&nbsp;</cfif></td>
				<td class="txtbold"><cf_get_lang_main no='4.Proje'></td>
				<td><cfif isdefined("get_budget_plan.project_id") and len(get_budget_plan.project_id)>#get_project.project_head#<cfelse>&nbsp;</cfif></td>
			</tr>
			<tr>
				<td class="txtbold" width="20%"><cf_get_lang_main no='1060.Dönem'></td>
				<td>#period_year#</td>
				<td class="txtbold"><cf_get_lang_main no='160.Departman'></td>
				<td width="20%"><cfif len(get_budget_plan.budget_id) and len(get_budget.department_id)>#get_department.department_head#<cfelse>&nbsp;</cfif></td>
				<td class="txtbold"><cf_get_lang_main no='468.Belge No'></td>
				<td>#get_budget_plan.paper_no#</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang no='81.Planlayan'></td>
				<td><cfif len(get_budget_plan.budget_planner_emp_id)>#get_emp_info(get_budget_plan.budget_planner_emp_id,0,0)#<cfelse>&nbsp;</cfif></td>
				<td class="txtbold"><cf_get_lang_main no='728.İş Grubu'></td>
				<td width="20%" colspan="3"><cfif len(get_budget_plan.budget_id) and len(get_budget.workgroup_id)>#get_workgroup.workgroup_name#<cfelse>&nbsp;</cfif></td>
			</tr>
			<tr height="20">
				<td class="txtbold" width="20%"><cf_get_lang_main no='217.Açıklama'></td>
				<td colspan="7"><cfif len(get_budget_plan.budget_id) and len(get_budget_plan.detail)>#get_budget_plan.detail#<cfelse>&nbsp;</cfif></td>
			</tr> 
	</table>
	</td>
  </tr>
</table>
</cfoutput>
</cfif>
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
<table style="width:201mm;" border="0"  cellpadding="1" cellspacing="1" align="center">		
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
	<tr>
		<td valign="top">
		<table width="100%" cellpadding="3" cellspacing="0" border="1">						
			<tr class="txtbold">
				<td width="65"><cf_get_lang_main no='330.Tarih'></td>
				<td width="350"><cf_get_lang_main no='217.Açıklama'></td>
				<td width="50"><cf_get_lang_main no='823.Masraf/Gelir Merkezi'></td>
				<td width="400"><cf_get_lang_main no='822.BKalemi'></td>
				<td width="350"><cf_get_lang no='90.Aktivite Tipi'></td>
				<td width="150" style="text-align:right;"><cf_get_lang_main no='1265.Gelir'></td>
				<td width="150" style="text-align:right;"><cf_get_lang_main no='1266.Gider'></td>
				<td width="150" style="text-align:right;"><cf_get_lang_main no='1171.Fark'></td>
			</tr>
			<cfoutput query="get_budget_plan_row">
			<tr>
				<td>#dateformat(plan_date,dateformat_style)#</td>
				<td>#detail#</td>
				<td>
				<cfif len(exp_inc_center_id)>
					#get_expense_center.EXPENSE[listfind(expense_list,exp_inc_center_id,',')]#
				<cfelse>
					&nbsp;
				</cfif>
				</td>
				<td width="350">
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
			<tr class="txtbold" height="25">
			<cfoutput>
				<td colspan="5" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
				<td style="text-align:right;" width="150">#TLFormat(gelir_toplam)#&nbsp;#session.ep.money#</td>
				<td style="text-align:right;" width="150">#TLFormat(gider_toplam)#&nbsp;#session.ep.money#</td>
				<td style="text-align:right;" width="150">#TLFormat(fark_toplam)#&nbsp;#session.ep.money#</td>
			</cfoutput>
			</tr>
		</table>
		</td>
	</tr>
</table>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
