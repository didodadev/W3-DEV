<script src="JS/Chart.min.js"></script>
<cfset dashboard_cmp = createObject("component","V16.hr.cfc.hr_dashboard") />
<cfset count_emp_group_dept_branches = dashboard_cmp.COUNT_EMP_GROUP_DEPT_BRANCHES()/>
<cfset branch_id_list = ValueList(count_emp_group_dept_branches.BRANCH_ID)>
<cfset count_dept_group_branches = dashboard_cmp.COUNT_DEPT_GROUP_BRANCHES(branch_id_list : branch_id_list)/>
<cfset count_emp = ValueList(count_emp_group_dept_branches.COUNT_EMP)>
<cfquery name="sum_emp_count" dbtype="query">
    SELECT SUM(COUNT_EMP) AS TOTAL_EMP FROM count_emp_group_dept_branches
</cfquery>
<cfquery name="sum_dept_count" dbtype="query">
    SELECT SUM(COUNT_DEPT) AS TOTAL_DEPT FROM count_dept_group_branches
</cfquery>
<div class="col col-12">
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="29434.Şubeler"></th>
                <th><cf_get_lang dictionary_id="61036.Departman sayısı"></th>
                <th><cf_get_lang dictionary_id="30881.Çalışan Sayısı"></th>
            </tr>
        </thead>
        <tbody>
            <cfif count_dept_group_branches.recordcount>
                <cfoutput query="count_dept_group_branches">
                    <tr>
                        <td>
                            <a href="#request.self#?fuseaction=hr.list_branches&event=upd&id=#BRANCH_ID#" target="_blank">#BRANCH_NAME#</a>
                        </td>
                        <td>#COUNT_DEPT#</td>
                        <td>#listGetAt(count_emp,currentrow)#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="3"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
</div>
<div class="col col-12">
    <div class="col col-6 col-xs-12">
        <cfoutput query="count_dept_group_branches">
            <cfset 'item_#currentrow#' = "#BRANCH_NAME#">
            <cfset 'value_#currentrow#' = "#COUNT_DEPT#">
        </cfoutput>
        <canvas id="dept_group_branches" style="height:100%;"></canvas>
        <script>
            var dept_group_branches = document.getElementById('dept_group_branches');
            var dept_group_branches_pie = new Chart(dept_group_branches, {
                type: 'pie',
                data: {
                        labels: [<cfloop from="1" to="#count_dept_group_branches.recordcount#" index="i">
                            <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                        datasets: [{
                        label: "<cf_get_lang dictionary_id="61036.Departman sayısı">%",
                        backgroundColor: [<cfloop from="1" to="#count_dept_group_branches.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                        data: [<cfloop from="1" to="#count_dept_group_branches.recordcount#" index="x"><cfoutput><cfif sum_dept_count.TOTAL_DEPT neq 0>"#wrk_round((evaluate("value_#x#")*100)/sum_dept_count.TOTAL_DEPT)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                            }]
                        },
                options: {
                    legend: {
                        display: false
                    }
                }
            });
        </script>
    </div>
    <div class="col col-6 col-xs-12">
        <cfoutput query="count_emp_group_dept_branches">
            <cfset 'item_#currentrow#' = "#BRANCH_NAME#">
            <cfset 'value_#currentrow#' = "#COUNT_EMP#">
        </cfoutput>
        <canvas id="emp_group_branches" style="height:100%;"></canvas>
        <script>
            var emp_group_branches = document.getElementById('emp_group_branches');
            var emp_group_branches_pie = new Chart(emp_group_branches, {
                type: 'pie',
                data: {
                        labels: [<cfloop from="1" to="#count_emp_group_dept_branches.recordcount#" index="i">
                            <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                        datasets: [{
                        label: "<cf_get_lang dictionary_id="30881.Çalışan Sayısı">%",
                        backgroundColor: [<cfloop from="1" to="#count_emp_group_dept_branches.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                        data: [<cfloop from="1" to="#count_emp_group_dept_branches.recordcount#" index="x"><cfoutput><cfif sum_emp_count.TOTAL_EMP neq 0>"#wrk_round((evaluate("value_#x#")*100)/sum_emp_count.TOTAL_EMP)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                            }]
                        },
                options: {
                    legend: {
                        display: false
                    }
                }
            });
        </script>
    </div>
</div>