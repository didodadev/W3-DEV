<!--- Standart Butce Detay  --->
<cf_get_lang_set module_name="budget"><!--- sayfanin en altinda kapanisi var --->
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
  <style>
   .prnt{font-size:14px;}
   .print_title{font-size:18px;}
   table{border-collapse:collapse;border-spacing:0;}
   table tr td{padding:5px 3px;}
   .print_border tr th{border:1px solid ##c0c0c0;padding:3px;color:##000}
   .print_border tr td{border:1px solid ##c0c0c0;}
   .row_border{border-bottom:1px solid ##c0c0c0;}
   table tr td img{max-width:50px;}
  </style>
	<table style="width:210mm">
		<tr>
			<td>
				<table width="100%">
					<tr class="row_border">
						<td style="padding:10px 0 0 0!important">
							<table style="width:100%;">
								<tr>
									<td class="print_title"><cf_get_lang dictionary_id='49123.Bütçe Detay'></td>
									 <td style="text-align:right;">
                   <cfif len(check.asset_file_name2)>
                   <cfset attributes.type = 1>
                     <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                   </cfif>
                 </td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr class="row_border"class="row_border">
		<td>
				<table>
					<tr>
						<td style="width:140x;"><b><cf_get_lang dictionary_id='57559.Bütçe'></b></td>
						<td style="width:170x;"> :#budget_name# </td>
						<td style="width:140px;"><b><cf_get_lang dictionary_id='57453.Şube'></b></td>
						<td  style="width:170px;"><cfif len(get_budget.branch_id)>:#get_branch.branch_fullname#<cfelse>&nbsp;</cfif></td>
					</tr>
					<tr>	
						<td style="width:140px;"><b><cf_get_lang dictionary_id='57416.Proje'></b></td>
						<td style="width:170px;"><cfif len(get_budget.project_id)>:#get_project.project_head#<cfelse>&nbsp;</cfif></td>
						<td style="width:140px;"><b><cf_get_lang dictionary_id='58472.Dönem'></b></td>
						<td style="width:170px;">:#period_year#</td>
					</tr>
					<tr>
						<td style="width:100px;"><b><cf_get_lang dictionary_id='57572.Departman'></b></td>
						<td><cfif len(get_budget.department_id)>:#get_department.department_head#<cfelse>&nbsp;</cfif></td>
						<td style="width:100px;"><b><cf_get_lang dictionary_id='58140.İş Grubu'></b></td>
						<td><cfif len(get_budget.workgroup_id)>:#get_workgroup.workgroup_name#<cfelse>:&nbsp;</cfif></td>
					</tr>
					<tr>
						<td style="width:100px;"><b><cf_get_lang dictionary_id='36199.Açıklama'></b></td>
						<td colspan="5"><cfif len(detail)>:#detail#<cfelse>&nbsp;</cfif></td>
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
	<table style="width:210mm;" border="0"  cellpadding="1" cellspacing="1" >
		<tr><td height="20">&nbsp;</td></tr>
		<tr>
			<td valign="top">
				<table width="100%" cellpadding="3" cellspacing="0" border="1">	
				 	<tr  style="background-color:LightGray;">
						<td nowrap="nowrap" colspan="10" class="prnt"><b><cf_get_lang dictionary_id='58200.Gelir/Gider Planı'></b></td>
					</tr>								
					<tr class="txtbold">
						<td width="65"><b><cf_get_lang dictionary_id='57880.Belge No'></b></td>
						<td width="65"><b><cf_get_lang dictionary_id='57742.Tarih'></b></td>
						<td class="txtbold" width="100"><b><cf_get_lang dictionary_id='31910.Planlayan'></b></td>
						<td style="width:50mm;"><b><cf_get_lang dictionary_id='36199.Açıklama'></b></td>
						<td width="150" style="text-align:right;"><b><cf_get_lang dictionary_id='58677.Gelir'></b></td>
						<td width="150" style="text-align:right;"><b><cf_get_lang dictionary_id='58678.Gider'></b></td>
						<td width="150" style="text-align:right;"><b><cf_get_lang dictionary_id='58583.Fark'></b></td>
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
						<td width="50">#paper_no#</td>
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
						<td colspan="4" style="text-align:right;"><b><cf_get_lang dictionary_id='57492.Toplam'></b></td>
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
	<br></br>
	<table>
	<tr class="fixed">
		<td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
	</tr>
	</table>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
