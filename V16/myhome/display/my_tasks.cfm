<!---
File: my_tasks.cfm
Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
Date: 30.09.2020
Controller: -
Description: Görevler Widget - Ekipte ki çalışan sayısındaki görevleri aşamalara,kategorilere ve kişilere göre grafikte gösterir.
---->
<cfset TasksObj = createObject("component","V16.myhome.cfc.my_team")>
<!--- Benim departmanımdaki çalışan sayıları --->
<cfset MyDepartmentTeam = TasksObj.get_position_department(position_code : session.ep.position_code) />
<cfset employee_ids = valuelist(MyDepartmentTeam.employee_id)>
<cfset employee_ids = listappend(employee_ids,#session.ep.userid#)>
<cfset get_stage_tasks = TasksObj.GetStageTasks(employee_ids: employee_ids)>
<cfset get_category_tasks = TasksObj.GetCategoryTasks(employee_ids: employee_ids)>
<cfset get_employee_tasks = TasksObj.GetEmployeeTasks(employee_ids: employee_ids)>
<cfset get_my_tasks = TasksObj.GetMyTasks(employee_ids: employee_ids)>
<div class="ui-dashboard">
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='36202.Stages'>
        </div>
        <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
            <cfoutput query="get_stage_tasks">
                <cfset value = WORK_COUNT>
                <cfset item = STAGE>
                <cfset 'item_#currentrow#'="#value#">
                <cfset 'value_#currentrow#'="#item#"> 
            </cfoutput>
            <script src="JS/Chart.min.js"></script>
            <canvas style="width:100%!important;" id="stageWork"></canvas>
            <script>
                var ctx = document.getElementById('stageWork');
                    var myChart = new Chart(ctx, {
                        type: 'pie',
                        data: {
                            labels: [<cfloop from="1" to="#get_stage_tasks.recordcount#" index="jj">
                                            <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "rapor",
                                backgroundColor: [<cfloop from="1" to="#get_stage_tasks.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_stage_tasks.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
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
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='58137.Kategoriler'>
        </div>
        <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <cfoutput query="get_category_tasks">
                    <cfset value = WORK_COUNT>
                    <cfset item = "#WORK_CAT#">
                    <cfset 'item_#currentrow#'="#value#">
                    <cfset 'value_#currentrow#'="#item#"> 
                </cfoutput>
                <canvas style="width:100%!important;" id="catsWorks"></canvas>
                <script>
                    var ctx = document.getElementById('catsWorks');
                        var myChart = new Chart(ctx, {
                            type: 'pie',
                            data: {
                                labels: [<cfloop from="1" to="#get_category_tasks.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "rapor",
                                    backgroundColor: [<cfloop from="1" to="#get_category_tasks.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_category_tasks.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
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
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='30355.Kişiler'>
        </div>
        <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <cfoutput query="get_employee_tasks">
                    <cfset value = WORK_COUNT>
                    <cfset item = "#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
                    <cfset 'item_#currentrow#'="#value#">
                    <cfset 'value_#currentrow#'="#item#"> 
                </cfoutput>
                <canvas style="width:100%!important;" id="employeesWorks"></canvas>
                <script>
                    var ctx = document.getElementById('employeesWorks');
                        var myChart = new Chart(ctx, {
                            type: 'pie',
                            data: {
                                labels: [<cfloop from="1" to="#get_employee_tasks.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "rapor",
                                    backgroundColor: [<cfloop from="1" to="#get_employee_tasks.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_employee_tasks.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
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
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='57492.Total'>
        </div>
        <div class="ui-dashboard-item-text">
            <cfoutput><a href="#request.self#?fuseaction=report.project_work_board&equipment_id=#employee_ids#&form_varmi=1" target="_blank">#get_my_tasks.WORK_COUNT#</a></cfoutput>
        </div>
    </div>
</div>