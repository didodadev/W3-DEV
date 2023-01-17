<cfquery name="GET_BUDGET_PLAN" datasource="#dsn#">
	SELECT
		ISNULL(INCOME_TOTAL,0) INCOME_TOTAL,
		ISNULL(EXPENSE_TOTAL,0) EXPENSE_TOTAL,
		ISNULL(DIFF_TOTAL,0) DIFF_TOTAL,
		ISNULL(INCOME_TOTAL_2,0) INCOME_TOTAL_2,
		ISNULL(EXPENSE_TOTAL_2,0) EXPENSE_TOTAL_2,
		ISNULL(DIFF_TOTAL_2,0) DIFF_TOTAL_2,
		*
	FROM
		BUDGET_PLAN
	WHERE
		BUDGET_ID = #attributes.budget_id#
	ORDER BY
		BUDGET_PLAN_DATE
</cfquery>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='58200.Gelir/Gider Planı'></cfsavecontent>
<cf_box id="list_budget" title="#title#" closable="0" collapsable="0">
    <table width="100%" name="table1" id="table1">
        <!-- sil -->
        <tr>
            <cfif len(session.ep.money2)>
                <cfset col_span = 11>
            <cfelse>
                <cfset col_span = 8>
            </cfif>
            <td colspan="<cfoutput>#col_span#</cfoutput>" > </td>
        </tr>
    </table>
    <cf_grid_list>
    <cfoutput>
        <thead>
            <!--- <tr>
                <th colspan="11"><cf_get_lang dictionary_id='58200.Gelir/Gider Planı'></th>
            </tr> --->
            <tr>
                <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                <th><cf_get_lang dictionary_id='49175.Planlayan'></th>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <th><cf_get_lang dictionary_id='58677.Gelir'> #session.ep.money#</th>
                <th><cf_get_lang dictionary_id='58678.Gider'> #session.ep.money#</th>
                <th><cf_get_lang dictionary_id='58583.Fark'> #session.ep.money#</th>
                <cfif len(session.ep.money2)>
                    <th><cf_get_lang dictionary_id='58677.Gelir'> #session.ep.money2#</th>
                    <th><cf_get_lang dictionary_id='58678.Gider'> #session.ep.money2#</th>
                    <th><cf_get_lang dictionary_id='58583.Fark'> #session.ep.money2#</th>
                </cfif>
                <th class="header_icn_none" nowrap="nowrap">
                <a href="<cfoutput>#request.self#?fuseaction=budget.list_plan_rows&event=add&budget_id=#attributes.budget_id#</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='49172.Ekle'>"></i></a>
                </th>
            </tr>
        </thead>
            </cfoutput>
            <cfset planner_emp_id_list=''>
            <cfoutput query="GET_BUDGET_PLAN">
                <cfif len(BUDGET_PLANNER_EMP_ID) and not listfind(planner_emp_id_list,BUDGET_PLANNER_EMP_ID)>
                <cfset planner_emp_id_list=listappend(planner_emp_id_list,BUDGET_PLANNER_EMP_ID)>
                </cfif>
            </cfoutput>
            <cfif len(planner_emp_id_list)>
                <cfset planner_emp_id_list=listsort(planner_emp_id_list,"numeric","ASC",",")>
                <cfquery name="get_emp_detail" datasource="#dsn#">
                    SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#planner_emp_id_list#) ORDER BY EMPLOYEE_ID
                </cfquery>
            </cfif>
            <cfif GET_BUDGET_PLAN.recordcount>
                <cfset total1 = 0>
                <cfset total2 = 0>
                <cfset total3 = 0>
                <cfset total4 = 0>
                <cfset total5 = 0>
                <cfset total6 = 0> 
                <cfoutput query="get_budget_plan">
                    <cfset total1 = total1 + INCOME_TOTAL>
                    <cfset total2 = total2 + EXPENSE_TOTAL>
                    <cfset total3 = total3 + DIFF_TOTAL>
                    <cfif len(session.ep.money2)>
                        <cfset total4 = total4 + INCOME_TOTAL_2>
                        <cfset total5 = total5 + EXPENSE_TOTAL_2>
                        <cfset total6 = total6 + DIFF_TOTAL_2>
                    </cfif>
            <tbody>
                <tr id="frm_row">
                    <td>#PAPER_NO#</td>
                    <td>#dateformat(BUDGET_PLAN_DATE,dateformat_style)#</td>
                    <td><cfif listfind(planner_emp_id_list,BUDGET_PLANNER_EMP_ID,',')>#get_emp_detail.EMPLOYEE_NAME[listfind(planner_emp_id_list,BUDGET_PLANNER_EMP_ID,',')]# #get_emp_detail.EMPLOYEE_SURNAME[listfind(planner_emp_id_list,BUDGET_PLANNER_EMP_ID,',')]#</cfif></td>
                    <td>#DETAIL#</td>
                    <td>#TLFormat(INCOME_TOTAL)#</td>
                    <td>#TLFormat(EXPENSE_TOTAL)#</td>
                    <td>#TLFormat(DIFF_TOTAL)#</td>
                    <cfif len(session.ep.money2)>
                    <td>#TLFormat(INCOME_TOTAL_2)#</td>
                    <td>#TLFormat(EXPENSE_TOTAL_2)#</td>
                    <td>#TLFormat(DIFF_TOTAL_2)#</td>
                    </cfif>
                    <td width="20"><a href="#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#BUDGET_PLAN_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                </tr>
            </tbody>
            </cfoutput>
            <cfoutput>
            <tfoot>
                <tr>
                    <td colspan="4" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                    <td>#TLFormat(total1)# #session.ep.money#</td>
                    <td>#TLFormat(total2)# #session.ep.money#</td>
                    <td>#TLFormat(total3)# #session.ep.money#</td>
                    <cfif len(session.ep.money2)>
                        <td>#TLFormat(total4)# #session.ep.money2#</td>
                        <td>#TLFormat(total5)# #session.ep.money2#</td>
                        <td>#TLFormat(total6)# #session.ep.money2#</td>
                    </cfif>
                </tr>
            </tfoot>
            </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="<cfoutput>#col_span#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                </tr>
            </cfif>
    </cf_grid_list>
</cf_box>