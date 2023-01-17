<!--- 26092020 / Emine Yılmaz     
Servis Başvuruları Widget - aşamalara ve kişilere göre grafik. --->
<cfset CrObj = createObject("component","V16.myhome.cfc.my_team")>
<cfset MyTeam = CrObj.get_position_department(position_code : session.ep.position_code) />
<cfset employee_ids = listappend(valuelist(MyTeam.employee_id),session.ep.userid)>
<cfset get_stage_service = CrObj.GetStageService(employee_ids : employee_ids)>
<cfset get_employee_service = CrObj.GetEmployeeService(employee_ids : employee_ids)>
<div class="ui-dashboard">
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='36202.Stages'>
        </div>
        <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
            <cfif get_stage_service.recordcount>
                <cfoutput query="get_stage_service">
                    <cfset value = TOTAL>
                    <cfset item = STAGE>
                    <cfset 'item_#currentrow#'="#value#">
                    <cfset 'value_#currentrow#'="#item#"> 
                </cfoutput>
                <canvas style="width:100%!important;" id="Stage"></canvas>
                <script>
                    var ctx = document.getElementById('Stage');
                        var myChart = new Chart(ctx, {
                            type: 'pie',
                            data: {
                                labels: [<cfloop from="1" to="#get_stage_service.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "rapor",
                                    backgroundColor: [<cfloop from="1" to="#get_stage_service.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_stage_service.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
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
            <cfoutput><a href="javascript://" onclick="gotoService('#valuelist(get_stage_service.SERVICE_ID)#')">#get_stage_service.recordcount#</a></cfoutput>
        </div>
    </div>
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='49364.Team'>
        </div>
        <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
            <cfif get_employee_service.recordcount>
                <cfoutput query="get_employee_service">
                    <cfset value = TOTAL>
                    <cfset item = "#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
                    <cfset 'item_#currentrow#'="#value#">
                    <cfset 'value_#currentrow#'="#item#"> 
                </cfoutput>
                <canvas style="width:100%!important;" id="employees"></canvas>
                <script>
                    var ctx = document.getElementById('employees');
                        var myChart = new Chart(ctx, {
                            type: 'pie',
                            data: {
                                labels: [<cfloop from="1" to="#get_employee_service.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "rapor",
                                    backgroundColor: [<cfloop from="1" to="#get_employee_service.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_employee_service.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
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

    function gotoService( service_id ) {
        window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=service.list_service&form_submitted=1&service_id='+ service_id+'','Project');
    }

</script>