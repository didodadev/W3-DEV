<!--- 26092020 / Emine Yılmaz     
Call Center Widget - aşamalara ve kişilere göre grafik. --->
<cfset CrObj = createObject("component","V16.myhome.cfc.my_team")>
<cfset MyTeam = CrObj.get_position_department(position_code : session.ep.position_code) />
<cfset employee_ids = listappend(valuelist(MyTeam.employee_id),session.ep.userid)>
<cfset get_stage_call_center = CrObj.GetStageCall(employee_ids:employee_ids)>
<cfset get_employee_call = CrObj.GetEmployeeCall(employee_ids:employee_ids)>
<div class="ui-dashboard">
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='36202.Stages'>
        </div>
        <div class="ui-dashboard-item-text">
            <cfif get_stage_call_center.recordcount>
                <cfoutput query="get_stage_call_center">
                    <cfset value = TOTAL>
                    <cfset item = STAGE>
                    <cfset 'item_#currentrow#'="#value#">
                    <cfset 'value_#currentrow#'="#item#"> 
                </cfoutput>
                <canvas id="StageCall"></canvas>
                <script>
                    var ctx = document.getElementById('StageCall');
                        var myChart = new Chart(ctx, {
                            type: 'pie',
                            data: {
                                labels: [<cfloop from="1" to="#get_stage_call_center.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "rapor",
                                    backgroundColor: [<cfloop from="1" to="#get_stage_call_center.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_stage_call_center.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                }]
                            },
                            options: {
                                legend: {
                                    display: false
                                }
                            }
                    });
                </script>
            <cfelse>
                <cf_get_lang dictionary_id='57484.No record'>!
            </cfif>
        </div>
    </div>
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='57492.Total'>
        </div>
        <div class="ui-dashboard-item-text">
            <cfoutput><a href="javascript://" onclick="gotoCallCenter('#valuelist(get_stage_call_center.SERVICE_ID)#')">#get_stage_call_center.recordcount#</a></cfoutput>
        </div>
    </div>
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='49364.Team'>
        </div>
        <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
            <cfif get_employee_call.recordcount>
                <cfoutput query="get_employee_call">
                    <cfset value = TOTAL>
                    <cfset item = "#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
                    <cfset 'item_#currentrow#'="#value#">
                    <cfset 'value_#currentrow#'="#item#"> 
                </cfoutput>
                <canvas id="employeesCall"></canvas>
                <script>
                    var ctx = document.getElementById('employeesCall');
                        var myChart = new Chart(ctx, {
                            type: 'pie',
                            data: {
                                labels: [<cfloop from="1" to="#get_employee_call.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "rapor",
                                    backgroundColor: [<cfloop from="1" to="#get_employee_call.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_employee_call.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                }]
                            },
                            options: {
                                legend: {
                                    display: false
                                }
                            }
                    });
                </script>
            <cfelse>
                <cf_get_lang dictionary_id='57484.No record'>!
            </cfif>
        </div>
    </div>
</div> 
<script>

    function gotoCallCenter( service_id ) {
        window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_service&form_submitted=1&service_id='+ service_id+'','Project');
    }

</script>
            