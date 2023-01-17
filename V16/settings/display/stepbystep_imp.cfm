<!--- 
    Oluşturan : İlker Altındal
    Mail : ilkeraltindal@workcube.com
    Tarih : 02092019
    Açıklama : İmplementasyon Adımları Kullanıcı Arayüz Sayfasıdır,
    Dizayn tool üzerinde tanımlanan tüm tasklar bu sayfada görünür ve implementasyon adımları tamamlanır.
--->
<link rel="stylesheet" href="/css/assets/template/w3-imp-tool/imp-tool-style.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/w3-imp-tool/imp-tool.min.css" type="text/css">
<script src="/JS/w3-imp-tool/bootstrap.min.js"></script>

<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset wdo = createObject("component","WDO.modalModuleMenu")>
<cfset steps = createObject("component","WDO.ImplementationSteps")>
<cfset getObjects = WDO.getObjects()>
<cfset getSteps = steps.getSteps()>
<cf_catalystHeader>
    <cfquery name="getModulCount" dbtype="query">
        select WRK_MODUL_ID FROM getSteps GROUP BY WRK_MODUL_ID
    </cfquery>
    <cf_box title="Dashboard">
        <div class="ui-dashboard">
            <div class="ui-dashboard-item">
                <div class="ui-dashboard-item-title">
                    MODULE
                </div>
                <div class="ui-dashboard-item-text">
                    <cfset moduleTaskCount = steps.getModuleTaskCount() >
                    <a href="javascript://"><cfoutput>#getModulCount.recordCount# / #moduleTaskCount.COMPLETED_MODULE_COUNT#</cfoutput></a>
                </div>
            </div>
            <div class="ui-dashboard-item">
                <div class="ui-dashboard-item-title">
                    MODULE COMPLETED %
                </div>
                <div class="ui-dashboard-item-text">
                    <cfset complated_modul_general = ( moduleTaskCount.COMPLETED_MODULE_COUNT gt 0 ) ? ( moduleTaskCount.COMPLETED_MODULE_COUNT * 100 ) / getModulCount.recordCount : 0 >
                    <a href="javascript://"> <cfoutput>#TLFormat(complated_modul_general)# %</cfoutput></a>
                </div>
            </div>
            <div class="ui-dashboard-item">
                <div class="ui-dashboard-item-title">
                    TASKS
                </div>
                <div class="ui-dashboard-item-text">
                    <cfset getTaskCount = steps.getTaskCount()>
                    <a href="javascript://"> <cfoutput>#getTaskCount.TOTAL_TASK# / #getTaskCount.COMPLETED_TASK#</cfoutput></a>
                </div>
            </div>
            <div class="ui-dashboard-item">
                <div class="ui-dashboard-item-title">
                    TASK COMPLETED %
                </div>
                <div class="ui-dashboard-item-text">
                    <cfset complated_rate_general = ( getTaskCount.COMPLETED_TASK gt 0 ) ? ( getTaskCount.COMPLETED_TASK * 100 ) / getTaskCount.TOTAL_TASK : 0 >
                    <a href="javascript://"> <cfoutput>#TLFormat(complated_rate_general)# %</cfoutput></a>
                </div>
            </div>
        </div> 
    </cf_box>
    <cf_box title="Adımlar">
        <cfoutput query="getObjects">  <!--- Solutionlar yazdırılıyor --->

            <cfquery name="getSolutionCount" dbtype="query">
                SELECT COUNT(WRK_IMPLEMENTATION_STEP_ID) AS STEP_COUNT FROM getSteps WHERE WRK_SOLUTION_ID = #WRK_SOLUTION_ID#
            </cfquery>
            <cfquery name="getSolutionCountTask" dbtype="query">
                SELECT COUNT(WRK_IMPLEMENTATION_TASK_COMPLETE) AS STEP_COMP_COUNT FROM getSteps WHERE WRK_IMPLEMENTATION_TASK_COMPLETE = 1 AND WRK_SOLUTION_ID = #WRK_SOLUTION_ID#
            </cfquery>

            <cfset getFamilies = steps.getFamilies(solution_id : WRK_SOLUTION_ID)> <!--- Family dahil edildi. --->

            <cfset complated_rate = ( getSolutionCountTask.STEP_COMP_COUNT gt 0 ) ? ( getSolutionCountTask.STEP_COMP_COUNT * 100 ) / getSolutionCount.STEP_COUNT : 0 >

            <cfif getSolutionCount.STEP_COUNT gt 0 >
            <cf_seperator title=" <i class='fa fa-cube' style='font-size:14px !important;'></i>#solution# : # ( getSolutionCount.STEP_COUNT gt 0 ) ? getSolutionCount.STEP_COUNT : 0# / # ( getSolutionCountTask.STEP_COMP_COUNT gt 0 ) ? getSolutionCountTask.STEP_COMP_COUNT : 0 # - <i class='fa fa-pie-chart' style='font-size:14px !important;'></i>Tamamlanma Oranı : #TLFormat(complated_rate)# %" id="wrkSolution#WRK_SOLUTION_ID#" is_closed="0">
                <div class="col col-12" id="wrkSolution#getObjects.WRK_SOLUTION_ID#">

                    <cfloop query="getFamilies"> <!--- Familyler yazdırılıyor --->
                        <cfset getModule = steps.getModule(family_id : WRK_FAMILY_ID)> <!--- Module dahil edildi. --->

                        <div class="col col-12">
                            <cfloop query="getModule"> <!--- Modüleler yazdırılıyor --->

                                <cfset getTask = steps.getTask(module_id : MODULE_ID)> <!--- Tasklar dahil edildi. --->
                                <cfif getTask.recordCount gt 0 >
                                    <cf_grid_list>
                                        <thead>
                                            <tr>
                                                <cfset complated_rate_task = ( getTask.TASK_END_COUNT gt 0 ) ? ( getTask.TASK_END_COUNT * 100 ) / getTask.recordCount : 0 >
                                                <th colspan="10"><i class="fa fa-yelp"></i> #getFamilies.LANG# - <i class="fa fa-spinner"></i> #getModule.LANG# : # ( getTask.recordCount ) ? getTask.recordCount : 0 # / # ( getTask.recordCount ) ? getTask.TASK_END_COUNT : 0 # - <i class='fa fa-pie-chart'></i> Tamamlanma Oranı : #TLFormat(complated_rate_task)# %</th>
                                            </tr>
                                            <tr>
                                                <th style="width:40px;"></th>
                                                <th style="width:50px;">N/C</th>
                                                <th style="width:400px;">Task</th>
                                                <th style="width:40px;">Help</th>
                                                <th style="width:60px;">Link (WO)</th>
                                                <th style="width:60px;">Dev (WO)</th>
                                                <th>Related WBO</th>
                                                <th style="width:100px;">Type</th>
                                                <th style="width:50px;">Record</th>                                       
                                                <th style="width:35px;">BP</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfif getTask.recordCount gt 0>
                                            <cfloop query="getTask"> <!--- Tasklar yazdırılıyor ---> 
                                                <cfif len(WRK_RELATED_TABLE_NAME) and len(WRK_RELATED_SCHEMA_NAME)>
                                                    <cfif WRK_RELATED_SCHEMA_NAME eq 'dsn'><cfset new_imp_dsn = "#dsn#">
                                                    <cfelseif WRK_RELATED_SCHEMA_NAME eq 'dsn1'><cfset new_imp_dsn = "#dsn1#">
                                                    <cfelseif WRK_RELATED_SCHEMA_NAME eq 'dsn2'><cfset new_imp_dsn = "#dsn2#">
                                                    <cfelseif WRK_RELATED_SCHEMA_NAME eq 'dsn3'><cfset new_imp_dsn = "#dsn3#">
                                                    </cfif>
                                                    <cfset myList = "">
                                                    <cfset myList = listAppend(myList,WRK_CONDITION)>
                                                    <cfset GET_TABLE_COUNT = {recordcount = 0} />
                                                    <cfif trim(WRK_RELATED_TABLE_NAME) eq 'SETUP_PROCESS_CAT'>
                                                        <cfquery name="GET_TABLE_COUNT" datasource="#new_imp_dsn#">
                                                            SELECT SUM(TOTAL_ROW) AS TOTAL
                                                            FROM (
                                                                SELECT COUNT(PROCESS_CAT) AS TOTAL_ROW FROM #WRK_RELATED_TABLE_NAME# AS SPC
                                                                LEFT JOIN SETUP_PROCESS_CAT_FUSENAME AS SPCF ON SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID
                                                                WHERE 
                                                                    1 = 1
                                                                    <cfif len(getTask.WRK_CONDITION)>
                                                                        AND 
                                                                        (
                                                                            <cfset i = 1 >
                                                                            <cfloop list="#myList#" index="value">
                                                                                SPCF.FUSE_NAME LIKE '%#value#%' <cfif listLen( getTask.WRK_CONDITION ) neq i> OR </cfif>
                                                                                <cfset i++ >
                                                                            </cfloop> 
                                                                        )
                                                                    </cfif>
                                                                GROUP BY PROCESS_CAT
                                                            ) AS TOTALS
                                                        </cfquery>
                                                    <cfelseif trim(WRK_RELATED_TABLE_NAME) eq 'PROCESS_TYPE'>
                                                        <cfquery name="GET_TABLE_COUNT" datasource="#new_imp_dsn#">
                                                            SELECT SUM(TOTAL_ROW) AS TOTAL
                                                            FROM (
                                                                SELECT COUNT(PT.PROCESS_ID) AS TOTAL_ROW FROM #WRK_RELATED_TABLE_NAME# AS PT
                                                                LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PT.PROCESS_ID = PTR.PROCESS_ID
                                                                WHERE 
                                                                    IS_ACTIVE = 1
                                                                    <cfif len(getTask.WRK_CONDITION)>
                                                                        AND 
                                                                        (
                                                                            <cfset i = 1 >
                                                                            <cfloop list="#myList#" index="value">
                                                                                PT.FACTION LIKE '%#value#%' <cfif listLen( getTask.WRK_CONDITION ) neq i> OR </cfif>
                                                                                <cfset i++ >
                                                                            </cfloop> 
                                                                        )
                                                                    </cfif>
                                                                GROUP BY PT.PROCESS_ID
                                                            ) AS TOTALS
                                                        </cfquery>
                                                    <cfelseif trim(WRK_RELATED_TABLE_NAME) eq 'SETUP_MONEY'>
                                                        <cfquery name="GET_TABLE_COUNT" datasource="#new_imp_dsn#">
                                                            SELECT COUNT(MONEY) AS TOTAL FROM #WRK_RELATED_TABLE_NAME#
                                                            GROUP BY MONEY
                                                        </cfquery>
                                                    <cfelseif trim(WRK_RELATED_TABLE_NAME) eq 'WRK_OBJECTS'>
                                                        <cfquery name="GET_TABLE_COUNT" datasource="#new_imp_dsn#">
                                                            SELECT
                                                                COUNT(#WRK_RELATED_TABLE_COLUMN#) AS TOTAL
                                                            FROM
                                                                #WRK_RELATED_TABLE_NAME#
                                                            WHERE
                                                                TYPE = 8 AND 
                                                                IS_ACTIVE = 1 AND
                                                                DICTIONARY_ID IS NOT NULL
                                                        </cfquery>
                                                    <cfelseif trim(WRK_RELATED_TABLE_NAME) eq 'REPORTS'>
                                                        <cfquery name="GET_TABLE_COUNT" datasource="#new_imp_dsn#">
                                                            SELECT
                                                                COUNT(#WRK_RELATED_TABLE_COLUMN#) AS TOTAL
                                                            FROM
                                                                #WRK_RELATED_TABLE_NAME#
                                                            WHERE
                                                                REPORT_STATUS = 1
                                                        </cfquery>
                                                    <cfelseif len(WRK_RELATED_TABLE_NAME)>
                                                        <cfquery name="GET_TABLE_COUNT" datasource="#new_imp_dsn#">
                                                            SELECT COUNT(*) AS TOTAL FROM #WRK_RELATED_TABLE_NAME#
                                                            WHERE 1=1
                                                                <cfif len(WRK_RELATED_TABLE_COLUMN) and len(WRK_CONDITION) >
                                                                    <cfset myList = "">
                                                                    <cfset myList = listAppend(myList,WRK_CONDITION)>
                                                                    AND 
                                                                    (
                                                                        <cfset i = 1 >
                                                                        <cfloop list="#myList#" index="value">
                                                                            #WRK_RELATED_TABLE_COLUMN# LIKE '%#value#%' <cfif listLen( getTask.WRK_CONDITION ) neq i> OR </cfif>
                                                                            <cfset i++ >
                                                                        </cfloop> 
                                                                    )
                                                                </cfif>
                                                        </cfquery>
                                                    </cfif>
                                                </cfif>
                                                <tr>
                                                    <td class="iconL">#attributes.startrow+currentrow-1#</td>
                                                    <td>
                                                        <div class="form-group">
                                                            <div class="checkbox checbox-switch">
                                                                <label>
                                                                    <input type="checkbox" id='#WRK_IMPLEMENTATION_STEP_ID#' onclick="updStatus('#WRK_IMPLEMENTATION_STEP_ID#','#WRK_IMPLEMENTATION_TASK_COMPLETE#')" <cfif WRK_IMPLEMENTATION_TASK_COMPLETE eq 1>checked</cfif> />
                                                                    <span></span>
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <cfquery name="get_lang" datasource="#dsn#">
                                                            SELECT S.ITEM_#UCase(session.ep.language)# AS ITEM FROM SETUP_LANGUAGE_#UCase(session.ep.language)# AS S WHERE S.DICTIONARY_ID IN (#getTask.WRK_IMPLEMENTATION_TASK#)
                                                        </cfquery>   
                                                            #valuelist(get_lang.item)#
                                                    </td>
                                                    <td style="vertical-align:middle;"> 
                                                        <cfif len(WRK_OBJECTS)>
                                                            <cfset obj = listGetAt(WRK_OBJECTS,2,'.')>
                                                            <a href="https://wiki.workcube.com?/category_detail?keyword=#WRK_OBJECTS#" target="_blank"><i class="fa fa-question-circle-o"></i></a>
                                                        <cfelse>
                                                            <a href="https://wiki.workcube.com" target="_blank"><i class="fa fa-question-circle-o"></i></a>
                                                        </cfif>
                                                    </td>
                                                    <td style="vertical-align:middle;"><a href="/index.cfm?fuseaction=#WRK_OBJECTS#" target="_blank"><i class="fa fa-link"></i></a></td>
                                                    <td style="vertical-align:middle;"><a href="/index.cfm?fuseaction=dev.wo&event=upd&fuseact=#WRK_OBJECTS#&woid=#WRK_OBJECTS_ID#" target="_blank"><i class="fa fa-cube"></i></a></td>
                                                    <td>
                                                        <cfloop from="1" to="#listlen(wrk_related_objects)#" index="i">
                                                        <cfset tut = #listgetat(WRK_RELATED_OBJECTS,#i#,',')#>
                                                        <a href="/index.cfm?fuseaction=#tut#" target="_blank">#left(tut,len(tut))#</a>
                                                        </cfloop>
                                                    </td>
                                                    <td>
                                                        <cfif WRK_IMPLEMENTATION_TYPE EQ 0> Dictionary
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 1> Extension
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 2> Implementation Step
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 3> Master Data
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 4> Menu
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 5> Module
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 6> Output Template
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 7> Page Designer 
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 8> Param
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 9> Process Cat
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 10> Process Stage
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 11> Process Template
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 12> Wex
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 13> Widget
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 14> Wo
                                                        <cfelseif WRK_IMPLEMENTATION_TYPE EQ 15> Xml Setup
                                                        </cfif>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-pill badge-info">
                                                            <cfif len(WRK_RELATED_TABLE_NAME) and len(WRK_RELATED_SCHEMA_NAME)>
                                                                #GET_TABLE_COUNT.TOTAL#
                                                            <cfelse>
                                                                0
                                                            </cfif>
                                                        </span>
                                                    </td>
                                                    <td><a href="javascript:void(0)"><i class="fa fa-briefcase" data-toggle="modal" data-target="##exampleModalCenter"></i></a></td>
                                                </tr>
                                            </cfloop>
                                            <cfelse>
                                                <tr>
                                                    <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                                                </tr>
                                            </cfif>
                                        </tbody>
                                    </cf_grid_list>
                                </cfif>
                            </cfloop>
                        </div>
                    </cfloop>
                </div>
            </cfif>
        </cfoutput>
    </cf_box>
  
<div class="imp-tool">
    <div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Best Practices</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                            <th>BP Name</th>
                            <th>Number Of Use</th>
                            <th>Help</th>
                            <th></th>
                            </tr>
                        </thead>
                            <tr><td colspan="4"><h6>Henüz bir best practice tanımı yapılmamış.</h6></td></tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Kapat</button>
                    <button type="button" class="btn btn-primary">Yükle</button>
                </div>
            </div>
        </div>
    </div>
</div>
 

<script>
    function updStatus(stepId,compId){
        var statusMsg = confirm('<cf_get_lang dictionary_id = "58587.Devam Etmek İstediniğinize Emin misiniz?">');
            if(statusMsg){
                compId == 0 ? statu = 1 : statu = 0;
                
                $.ajax({
                    type : 'POST',
                    dataType : 'JSON',
                    url : '/V16/settings/cfc/StepByStep.cfc?method=upd_task_step',
                    data : "compId="+statu+"&stepId="+stepId,
                    success:function(msg){
                        if(msg.STATUS){
                            alertObject({type: 'warning',message: '<cf_get_lang dictionary_id = "38004.İşlem Başarılı?">', closeTime: 5000});
                        }
                    }
                });
            }else{
                $("#"+stepId).attr("checked") == undefined ? $("#"+stepId).prop("checked", false) : $("#"+stepId).prop("checked", true);
            } 
    }

</script>
