<!--- Standart Butce Detay  --->
<cf_get_lang_set module_name="budget"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_BUDGET" datasource="#dsn#">
	SELECT * FROM BUDGET WHERE BUDGET_ID = #attributes.action_id#
</cfquery>
<cfquery name="GET_BUDGET_PLAN" datasource="#dsn#">
	SELECT * FROM BUDGET_PLAN WHERE BUDGET_ID = #attributes.action_id#
</cfquery>
<cfif len(get_budget.branch_id)>
	<cfquery name="GET_BRANCH" datasource="#dsn#">
		SELECT BRANCH_FULLNAME FROM BRANCH WHERE BRANCH_ID = #get_budget.branch_id#
	</cfquery>
</cfif>
<cfif len(get_budget.department_id)>
	<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
		SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_budget.department_id#
	</cfquery>
</cfif>
<cfif len(get_budget.workgroup_id)>
	<cfquery name="GET_WORKGROUP" datasource="#dsn#">
		SELECT WORKGROUP_NAME FROM WORK_GROUP WHERE WORKGROUP_ID = #get_budget.workgroup_id#
	</cfquery>
</cfif>
<cfif len(get_budget.project_id)>
<cfquery name="GET_PROJECT" datasource="#dsn#">
	SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_budget.project_id#
</cfquery>
</cfif>
<br/><br/>
<cfoutput query="get_budget">
<table style="width:200mm;" border="0"  cellpadding="1" cellspacing="1" align="center">
	<tr>
	   <td height="50" class="headbold"><cf_get_lang_main no='147.Bütçe'>:&nbsp;#budget_name#</td>
	</tr>
</table>
<table style="width:200mm;" border="0"  cellpadding="1" cellspacing="1"  align="center">
	<tr><td height="20">&nbsp;</td></tr>
	<tr>
		<td valign="top">
            <table width="100%" cellpadding="3" cellspacing="0" border="1">	
                <tr height="20">
                    <td class="txtbold" width="25"><cf_get_lang_main no='147.Bütçe'></td>
                    <td>#budget_name#</td>
                    <td class="txtbold"><cf_get_lang_main no='41.Şube'></td>
                    <td><cfif len(get_budget.branch_id)>#get_branch.branch_fullname#<cfelse>&nbsp;</cfif></td>
                    <td class="txtbold"><cf_get_lang_main no='4.Proje'></td>
                    <td><cfif len(get_budget.project_id)>#get_project.project_head#<cfelse>&nbsp;</cfif></td>
                </tr>
                <tr>
                    <td class="txtbold" width="20%"><cf_get_lang_main no='1060.Dönem'></td>
                    <td>#period_year#</td>
                    <td class="txtbold"><cf_get_lang_main no='160.Departman'></td>
                    <td width="20%"><cfif len(get_budget.department_id)>#get_department.department_head#<cfelse>&nbsp;</cfif></td>
                    <td class="txtbold"><cf_get_lang_main no='728.İş Grubu'></td>
                    <td width="20%"><cfif len(get_budget.workgroup_id)>#get_workgroup.workgroup_name#<cfelse>&nbsp;</cfif></td>
                </tr>
                <tr height="20">
                    <td class="txtbold" width="20%"><cf_get_lang_main no='217.Açıklama'></td>
                    <td colspan="5"><cfif len(detail)>#detail#<cfelse>&nbsp;</cfif></td>
                </tr>
            </table>
		</td>
	</tr>
</table>
</cfoutput>
<!--- Bütçe Satırları--->
<cfset gelir_toplam=0>
<cfset gider_toplam=0>
<cfset fark_toplam=0>
<cfif get_budget_plan.recordcount>
<table style="width:200mm;" border="0"  cellpadding="1" cellspacing="1"  align="center">
	<tr><td height="20">&nbsp;</td></tr>
	<tr>
		<td valign="top">
		<table width="100%" cellpadding="3" cellspacing="0" border="1">	
		<tr>
			<td nowrap="nowrap" colspan="10" class="txtbold"><cf_get_lang_main no='788.Gelir/Gider Planı'></td>
		</tr>								
		<tr class="txtbold">
			<td class="txtbold"><cf_get_lang_main no='468.Belge No'></td>
			<td width="65"><cf_get_lang_main no='330.Tarih'></td>
			<td class="txtbold" width="100"><cf_get_lang no='81.Planlayan'></td>
			<td style="width:50mm;"><cf_get_lang_main no='217.Açıklama'></td>
			<td width="150" style="text-align:right;"><cf_get_lang_main no='1265.Gelir'></td>
			<td width="150" style="text-align:right;"><cf_get_lang_main no='1266.Gider'></td>
			<td width="150" style="text-align:right;"><cf_get_lang_main no='1171.Fark'></td>
		</tr>
		<cfif get_budget_plan.recordcount>
		<cfset employee_list=''>
		<cfoutput query="get_budget_plan">
			<cfif len(budget_planner_emp_id) and not listfind(employee_list,budget_planner_emp_id)>
				<cfset employee_list=listappend(employee_list,budget_planner_emp_id)>
			</cfif>
	    </cfoutput>
		<cfif len(employee_list)>
		<cfset employee_list = listsort(employee_list,"numeric","ASC",",")>
		<cfquery name="GET_EMP" datasource="#DSN#">
			SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#employee_list#) ORDER BY EMPLOYEE_ID
		</cfquery>
		</cfif>
		</cfif>
		<cfoutput query="get_budget_plan">
		<tr>
			<td>#paper_no#</td>
			<td>#dateformat(budget_plan_date,dateformat_style)#</td>
			<td>
			<cfif len(budget_planner_emp_id)>
				#get_emp.EMPLOYEE_NAME[listfind(employee_list,budget_planner_emp_id,',')]#  #get_emp.EMPLOYEE_SURNAME[listfind(employee_list,budget_planner_emp_id,',')]# 
			<cfelse>
				&nbsp;
			</cfif>
			</td>
			<td><cfif len(detail)>#detail#<cfelse>&nbsp;</cfif></td>
			<td style="text-align:right;">#TLFormat(INCOME_TOTAL)#&nbsp;#session.ep.money#</td>
			<td style="text-align:right;">#TLFormat(EXPENSE_TOTAL)#&nbsp;#session.ep.money#</td>
			<td style="text-align:right;">#TLFormat(DIFF_TOTAL)#&nbsp;#session.ep.money#</td>
			<cfset gelir_toplam=gelir_toplam+INCOME_TOTAL>
			<cfset gider_toplam=gider_toplam+EXPENSE_TOTAL>
			<cfset fark_toplam=fark_toplam+DIFF_TOTAL>
		</tr>	
		</cfoutput>
		<tr class="txtbold" height="25">
			<td colspan="4" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
			<cfoutput>
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
