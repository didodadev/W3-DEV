<!--- 
    Author: MELEK KOCABEY
    Date: 22.01.2021
    Desc: Get teams project and projects count,project stages count
    widget Name: MyProjects
--->
<cfset my_team = createObject("component","V16.myhome.cfc.my_team") />
<cfset get_projects = my_team.get_projects()/>

<cfif get_projects.recordcount>
    <cfquery name = "get_pro_1" datasource="#dsn#" dbtype="query">
        SELECT
            STAGE, SUM(PROJECT_STAGE_COUNT) AS PROJECT_STAGE_COUNT
        FROM GET_PROJECTS
        GROUP BY STAGE,PROJECT_STAGE_COUNT
    </cfquery>
    <cfquery name = "get_pro_2" datasource="#dsn#" dbtype="query">
        SELECT
           SUM(MAIN_PROJECTCAT_ID_COUNT) AS MAIN_PROJECTCAT_ID_COUNT,MAIN_PROCESS_CAT
        FROM GET_PROJECTS
        GROUP BY MAIN_PROCESS_CAT,MAIN_PROJECTCAT_ID_COUNT
    </cfquery>
    <div class="ui-dashboard">
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='36202.Stages'>
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <cfoutput query="get_pro_1">
                    <cfset value = PROJECT_STAGE_COUNT>
                    <cfset item = STAGE>
                    <cfset 'item_#currentrow#'="#value#">
                    <cfset 'value_#currentrow#'="#item#"> 
                </cfoutput>
                <script src="JS/Chart.min.js"></script>
                <canvas style="width:100%!important;" id="stageProjects"></canvas>
                <script>
                    var ctx = document.getElementById('stageProjects');
                        var myChart = new Chart(ctx, {
                            type: 'pie',
                            data: {
                                labels: [<cfloop from="1" to="#get_pro_1.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "rapor",
                                    backgroundColor: [<cfloop from="1" to="#get_pro_1.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_pro_1.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
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
                <cfoutput> <a href="javascript://" onclick="gotoProject('#valuelist(get_projects.PROJECT_ID)#')">#get_projects.recordcount#</a></cfoutput>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                <cf_get_lang dictionary_id='58137.Kategoriler'>
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                    <cfoutput query="get_pro_2">
                        <cfset value = MAIN_PROJECTCAT_ID_COUNT>
                        <cfset item = MAIN_PROCESS_CAT>
                        <cfset 'item_#currentrow#'="#value#">
                        <cfset 'value_#currentrow#'="#item#"> 
                    </cfoutput>
                    <canvas style="width:100%!important;" id="catProjects"></canvas>
                    <script>
                        var ctx = document.getElementById('catProjects');
                            var myChart = new Chart(ctx, {
                                type: 'pie',
                                data: {
                                    labels: [<cfloop from="1" to="#get_pro_2.recordcount#" index="jj">
                                                    <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "rapor",
                                        backgroundColor: [<cfloop from="1" to="#get_pro_2.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#get_pro_2.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
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
    </div>
</cfif>

<script>

    function gotoProject( project_id ) {
        window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=project.projects&is_form_submitted=1&project_id='+ project_id+'','Project');
    }

</script>