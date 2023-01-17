<link rel="stylesheet" href="/css/assets/template/w3-imp-tool/imp-tool-style.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/w3-imp-tool/imp-tool.min.css" type="text/css">
<script src="/JS/w3-imp-tool/bootstrap.min.js"></script>

<cfset wdo = createObject("component","WDO.modalModuleMenu")>
<cfset steps = createObject("component","WDO.ImplementationSteps")>
<cfset getObjects = WDO.getSolutionImp()>
<cfset getFamily = WDO.getSolutionID(family_id : attributes.family_id)>
<cfset getFamilyWiki = WDO.getFamilyWiki(family_id : attributes.family_id)>
<cfset getSteps = steps.getSteps()>

<cfquery name="getProjectID" datasource="#dsn#">
	SELECT TOP 1 IMPLEMENTATION_PROJECT_ID FROM WRK_LICENSE ORDER BY LICENSE_ID DESC
</cfquery>

<cfquery name="getModulCount" dbtype="query">
    SELECT WRK_MODUL_ID FROM getSteps GROUP BY WRK_MODUL_ID
</cfquery>

<cfquery name="getSolutionCount" dbtype="query">
    SELECT COUNT(WRK_IMPLEMENTATION_STEP_ID) AS STEP_COUNT FROM getSteps WHERE WRK_SOLUTION_ID = #getObjects.WRK_SOLUTION_ID#
</cfquery>
<cfquery name="getSolutionCountTask" dbtype="query">
    SELECT COUNT(WRK_IMPLEMENTATION_TASK_COMPLETE) AS STEP_COMP_COUNT FROM getSteps WHERE WRK_IMPLEMENTATION_TASK_COMPLETE = 1 AND WRK_SOLUTION_ID = #getObjects.WRK_SOLUTION_ID#
</cfquery>

<cfset getFamilies = steps.getFamilies(solution_id : getObjects.WRK_SOLUTION_ID)>

<cfset complated_rate = ( getSolutionCountTask.STEP_COMP_COUNT gt 0 ) ? ( getSolutionCountTask.STEP_COMP_COUNT * 100 ) / getSolutionCount.STEP_COUNT : 0 >

<cfset getModule = steps.getModule(family_id : getObjects.WRK_FAMILY_ID)>
<cfset getModule_id = steps.getModule(family_id : attributes.family_id)>

<cfif len(getModule_id.MODULE_ID) >
    <cfset MidList = valueList(getModule_id.MODULE_ID)>
    <cfset getTask = steps.getTaskDashboard(module_id : MidList)>
</cfif>

<cfset complated_rate_task = ( isdefined("getTask") and getTask.TASK_END_COUNT gt 0 ) ? ( getTask.TASK_END_COUNT * 100 ) / getTask.recordCount : 0 >

<cf_box>
    <div class="col col-12">
        <div class="portHeadLightTitle" style="padding-bottom:10px;">
            <label style="color:#16A288;font-size: 20px;">
                <cfoutput>#getFamily.solution# - #getFamily.family#</cfoutput>
            </label>
        </div>
        <div class="col col-5 col-sm-10 col-md-6" style="padding-left:0px;padding-bottom: 10px;">
            <div class="col col-4 col-xs-3" style="padding-left:0px;">
                <label><b><cf_get_lang dictionary_id='55452.Modül'></b></label>
                <label><cfoutput>#getModule_id.recordcount#</cfoutput></label>
            </div>
            <div class="col col-4 col-xs-3">
                <label><b><cf_get_lang dictionary_id='65447.Adım'></b></label>
                <label><cfoutput># ( isdefined("getTask") and getTask.recordCount ) ? getTask.recordCount : 0 # / # ( isdefined("getTask") and getTask.recordCount ) ? getTask.TASK_END_COUNT : 0 #</cfoutput></label>
            </div>
            <div class="col col-4 col-xs-6">
                <label><b><cf_get_lang dictionary_id='40550.Tamamlanan'></b></label>
                <label><cfoutput>#TLFormat(complated_rate_task)#%</cfoutput></label>
            </div>
        </div>
    </div>
    
    <cfif session.ep.language eq "eng">
            <cfset lang = "en">
        <cfelse>
            <cfset lang = session.ep.language>
    </cfif>

    <div class="ui-dashboard col col-5 col-sm-9 col-md-6 col-xs-12">
        <cfif len(getFamilyWiki.WIKI)>
            <div class="ui-dashboard-item imp_steps_item">
                <a class="ui-dashboard-item-title" href="https://wiki.workcube.com/<cfoutput>#lang#</cfoutput>/detail/<cfoutput>#getFamilyWiki.WIKI#</cfoutput>" target="_blank"><i class="catalyst-book-open" style="font-size: 20px; color:#579BC1;"></i></a>
                <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='48869.Oku'></label>
            </div>
        </cfif>
        <cfif len(getFamilyWiki.VIDEO)>
            <div class="ui-dashboard-item imp_steps_item">
                <a class="ui-dashboard-item-title" href="<cfoutput>#getFamilyWiki.VIDEO#</cfoutput>" target="_blank"><i class="fa fa-youtube-play" style="font-size: 20px; color:#F50000;"></i></a>
                <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='65448.Seyret'></label>
            </div>
        </cfif>
        <div class="ui-dashboard-item imp_steps_item">
            <a class="ui-dashboard-item-title" href="https://edu.workcube.com" target="_blank"><i class="fa icon-LMS" style="font-size: 20px; color:#00B247;"></i></a>
            <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='65449.Dene'></label>
        </div>
        <div class="ui-dashboard-item imp_steps_item">
            <a class="ui-dashboard-item-title" href="https://wiki.workcube.com//WorkcubeSupport" target="_blank"><i class="fa icon-SUBO" style="font-size: 20px; color:#FAA61A;"></i></a>
            <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='57226.Destek Al'></label>
        </div>
        <div class="ui-dashboard-item imp_steps_item">
            <a class="ui-dashboard-item-title" href="https://alltogether.workcube.com/tr/projectDetail?id=<cfoutput>#getProjectID.IMPLEMENTATION_PROJECT_ID#</cfoutput>" target="_blank"><i class="fa icon-cog" style="font-size: 20px; color:#B7B5B5;"></i></a>
            <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='58020.İşler'></label>
        </div>
    </div>
</cf_box>

<cfoutput query="getModule_id">
    <cf_box title="#getModule_id.LANG#">
        <cfset getTask_id = steps.getTask(module_id : MODULE_ID)>
        <cfset completed_rate_task = ( getTask_id.TASK_END_COUNT gt 0 ) ? ( getTask_id.TASK_END_COUNT * 100 ) / getTask_id.recordCount : 0 >
        <div class="col col-12">
            <div class="blog_item" style="border-bottom: 1px dashed ##DED9D9!important;margin:0!important">
                <div class="blog_item_text" style="padding:0px;">
                    <div class="col col-12" style="padding-bottom: 10px;">
                        <div class="col col-5 col-sm-10 col-md-6">
                            <div class="col col-4">
                                <label><b><cf_get_lang dictionary_id='65447.Adım'></b></label>
                                <label># ( getTask_id.recordCount ) ? getTask_id.recordCount : 0 # / # ( getTask_id.recordCount ) ? getTask_id.TASK_END_COUNT : 0 #</label>
                            </div>
                            <div class="col col-4 col-xs-6">
                                <label><b><cf_get_lang dictionary_id='40550.Tamamlanan'></b></label>
                                <label>#TLFormat(completed_rate_task)#%</label>
                            </div>
                        </div>
                    </div>               
                    <div class="ui-dashboard col col-5 col-sm-9 col-md-6 col-xs-12">
                        <cfif len(getModule_id.WIKI)>
                            <div class="ui-dashboard-item imp_steps_item">
                                <a class="ui-dashboard-item-title" href="https://wiki.workcube.com/#variables.lang#/detail/#getModule_id.WIKI#" target="_blank"><i class="catalyst-book-open" style="font-size: 20px; color:##579BC1;"></i></a>
                                <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='48869.Oku'></label>
                            </div>
                        </cfif>
                        <cfif len(getModule_id.VIDEO)>
                            <div class="ui-dashboard-item imp_steps_item">
                                <a href="#getModule_id.VIDEO#" target="_blank"><i class="fa fa-youtube-play" style="font-size: 20px; color:##F50000;"></i></a>
                                <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='65448.Seyret'></label>
                            </div>
                        </cfif>
                        <div class="ui-dashboard-item imp_steps_item">
                            <a class="ui-dashboard-item-title" href="https://edu.workcube.com" target="_blank"><i class="fa icon-LMS" style="font-size: 20px; color:##00B247;"></i></a>
                            <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='65449.Dene'></label>
                        </div>
                        <div class="ui-dashboard-item imp_steps_item">
                            <a class="ui-dashboard-item-title" href="https://wiki.workcube.com//WorkcubeSupport" target="_blank"><i class="fa icon-SUBO" style="font-size: 20px; color:##FAA61A;"></i></a>
                            <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='57226.Destek Al'></label>
                        </div>
                        <div class="ui-dashboard-item imp_steps_item">
                            <a class="ui-dashboard-item-title" href="https://alltogether.workcube.com/tr/projectDetail?id=#getProjectID.IMPLEMENTATION_PROJECT_ID#" target="_blank"><i class="fa icon-cog" style="font-size: 20px; color:##B7B5B5;"></i></a>
                            <label class="ui-dashboard-item-text imp_text"><cf_get_lang dictionary_id='58020.İşler'></label>
                        </div>   
                    </div>
                </div>
            </div>
            <cfif getTask_id.recordCount gt 0>
                <cfloop query="getTask_id">
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
                                        <cfif len(getTask_id.WRK_CONDITION)>
                                            AND 
                                            (
                                                <cfset i = 1 >
                                                <cfloop list="#myList#" index="value">
                                                    SPCF.FUSE_NAME LIKE '%#value#%' <cfif listLen( getTask_id.WRK_CONDITION ) neq i> OR </cfif>
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
                                        <cfif len(getTask_id.WRK_CONDITION)>
                                            AND 
                                            (
                                                <cfset i = 1 >
                                                <cfloop list="#myList#" index="value">
                                                    PT.FACTION LIKE '%#value#%' <cfif listLen( getTask_id.WRK_CONDITION ) neq i> OR </cfif>
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
                                                #WRK_RELATED_TABLE_COLUMN# LIKE '%#value#%' <cfif listLen( getTask_id.WRK_CONDITION ) gt 0 and listLen( getTask_id.WRK_CONDITION ) neq i> OR </cfif>
                                                <cfset i++ >
                                            </cfloop> 
                                        )
                                    </cfif>
                            </cfquery>
                        </cfif>
                    </cfif>
                    <div class="blog_item" style="border-bottom: 1px dashed ##DED9D9!important;margin:0!important;">
                        <div class="blog_item_text imp_item" style="padding:0px!important;">
                            <div class="imp_blog_item">
                                <div style="display: flex;flex: 1;align-items: center;">
                                    <div>
                                        <span class="badge badge-pill badge-info" style="background-color:rgba(250, 166, 26, 0.65); font-size: 11px;">#currentrow#</span>
                                    </div>
                                    <div style="margin: 5px 0 0 10px!important;">
                                        <cfquery name="get_lang" datasource="#dsn#">
                                            SELECT S.ITEM_#UCase(session.ep.language)# AS ITEM FROM SETUP_LANGUAGE_#UCase(session.ep.language)# AS S WHERE S.DICTIONARY_ID IN (#getTask_id.WRK_IMPLEMENTATION_TASK#)
                                        </cfquery>
                                        <b style="font-size:14px">#valuelist(get_lang.item)#/
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
                                        </b>
                                        <label><a href="/index.cfm?fuseaction=#WRK_OBJECTS#" target="_blank"><i class="fa fa-link" style="color:##579BC1; font-size: 16px"></i></a></label>
                                        <div class="wrk_related_objects">
                                            <cfloop from="1" to="#listlen(wrk_related_objects)#" index="i">
                                                <cfset tut = #listgetat(WRK_RELATED_OBJECTS,#i#,',')#>
                                                <a href="/index.cfm?fuseaction=#tut#" target="_blank" style="font-size:12px; margin-bottom:5px!important;">#left(tut,len(tut))#</a>
                                            </cfloop>
                                        </div>
                                    </div>
                                </div>
                                <div style="display:flex;align-items:center;">
                                    <div>
                                        <a href="javascript:void(0)"><i title="WBP" style="color:##D86B64;font-size: 24px;"class="fa icon-archive" data-toggle="modal" data-target="##exampleModalCenter"></i></a>
                                    </div>
                                    <div style="margin-left: 10px;">
                                        <a href="/index.cfm?fuseaction=dev.wo&event=upd&fuseact=#WRK_OBJECTS#&woid=#WRK_OBJECTS_ID#" target="_blank"><i title="WO" style="color:##FF9B05;font-size: 24px;" class="fa fa-cube"></i></a>
                                    </div>
                                    <div style="margin-left: 10px;">
                                        <cfif len(WRK_OBJECTS)>
                                            <cfset obj = listGetAt(WRK_OBJECTS,2,'.')>
                                            <a href="https://wiki.workcube.com?/category_detail?keyword=#WRK_OBJECTS#" target="_blank"><i title="Wiki" style="color:##E6B772;font-size: 24px!important;" class="fa fa-question-circle-o"></i></a>
                                        <cfelse>
                                            <a href="https://wiki.workcube.com" target="_blank"><i title="Wiki" style="color:##E6B772;font-size: 24px!important;" class="fa fa-question-circle-o"></i></a>
                                        </cfif>
                                    </div>
                                    <div style="margin-left: 10px;">
                                        <span title="Records" class="badge badge-pill badge-info" style="background-color:##66BEF0; font-size: 11px; min-width:30px;">
                                            <cfif len(WRK_RELATED_TABLE_NAME) and len(WRK_RELATED_SCHEMA_NAME)>
                                                #GET_TABLE_COUNT.TOTAL#
                                            <cfelse>
                                                0
                                            </cfif>
                                        </span>
                                    </div>
                                    <div class="form-group" style="margin-left: 10px;">
                                        <div class="checkbox checbox-switch" style="padding-bottom: 7px;">
                                            <label title="Complete">
                                                <input type="checkbox" id='#WRK_IMPLEMENTATION_STEP_ID#' onclick="updStatus('#WRK_IMPLEMENTATION_STEP_ID#','#WRK_IMPLEMENTATION_TASK_COMPLETE#')" <cfif WRK_IMPLEMENTATION_TASK_COMPLETE eq 1>checked</cfif> />
                                                <span></span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>                            
                        </div>
                    </div>
                </cfloop>
            <cfelse>
                <div><label style="font-size:14px; margin-top:10px;"><cf_get_lang dictionary_id='57484.Kayıt Yok'></label></div>
            </cfif>
        </div>
    </cf_box>
</cfoutput>

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
                            alertObject({type: 'warning',message: '<cf_get_lang dictionary_id = "38004.İşlem Başarılı?">', closeTime: 5000, noTop: 1});
                        }
                    }
                });
            }else{
                $("#"+stepId).attr("checked") == undefined ? $("#"+stepId).prop("checked", false) : $("#"+stepId).prop("checked", true);
            } 
    }

</script>