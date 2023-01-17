<cfset wdo = createObject("component","WDO.modalModuleMenu")>
<cfset steps = createObject("component","WDO.ImplementationSteps")>
<cfset getObjects = WDO.getSolutionImp()>
<cfset getSteps = steps.getSteps()>

<cfquery name="getModulCount" dbtype="query">
    select WRK_MODUL_ID FROM getSteps GROUP BY WRK_MODUL_ID
</cfquery>

<cfset pagehead = "Implementasyon">
<cf_catalystHeader>

<div class="wrapper">
    <!--- Dashboard --->
    <div style="padding-right:10px;padding-left:10px;">
        <cf_box>
            <div class="col col-12">
                <div class="ui-dashboard-item col col-3 col-md-6 col-sm-6 col-xs-12" style="border:none!important;">
                    <div class="ui-dashboard-item-text">
                        <label style="font-size:18px;">
                            <b>
                                Module:
                            </b> 
                            <cfset moduleTaskCount = steps.getModuleTaskCount() >
                            <cfoutput>#getModulCount.recordCount# / #moduleTaskCount.COMPLETED_MODULE_COUNT#</cfoutput>
                        </label>
                    </div>
                </div>
                <div class="ui-dashboard-item col col-3 col-md-6 col-sm-6 col-xs-12" style="border:none!important;">
                    <div class="ui-dashboard-item-text">
                        <label style="font-size:18px;">
                            <b>
                                Module Completed:
                            </b>
                            <cfset complated_modul_general = ( moduleTaskCount.COMPLETED_MODULE_COUNT gt 0 ) ? ( moduleTaskCount.COMPLETED_MODULE_COUNT * 100 ) / getModulCount.recordCount : 0 >
                            <cfoutput>%#TLFormat(complated_modul_general)#</cfoutput>
                        </label>
                    </div>
                </div>
                <div class="ui-dashboard-item col col-3 col-md-6 col-sm-6 col-xs-12" style="border:none!important;">
                    <div class="ui-dashboard-item-text">
                        <label style="font-size:18px;">
                            <b>
                                Step: 
                            </b>
                            <cfset getTaskCount = steps.getTaskCount()>
                            <cfoutput>#getTaskCount.TOTAL_TASK# / #getTaskCount.COMPLETED_TASK#</cfoutput>
                        </label>
                    </div>
                </div>
                <div class="ui-dashboard-item col col-3 col-md-6 col-sm-6 col-xs-12" style="border:none!important;">
                    <div class="ui-dashboard-item-text">
                        <label style="font-size:18px;">
                            <b>
                                Step Completed:
                            </b>
                            <cfset complated_rate_general = ( getTaskCount.COMPLETED_TASK gt 0 ) ? ( getTaskCount.COMPLETED_TASK * 100 ) / getTaskCount.TOTAL_TASK : 0 >
                            <cfoutput>%#TLFormat(complated_rate_general)#</cfoutput>
                        </label>
                    </div>
                </div>
            </div> 
        </cf_box>
    </div>
    <div class="col col-12">
        <cfoutput query="getObjects">
            <cfquery name="getSolutionCount" dbtype="query">
                SELECT COUNT(WRK_IMPLEMENTATION_STEP_ID) AS STEP_COUNT FROM getSteps WHERE WRK_SOLUTION_ID = #WRK_SOLUTION_ID#
            </cfquery>
            <cfquery name="getSolutionCountTask" dbtype="query">
                SELECT COUNT(WRK_IMPLEMENTATION_TASK_COMPLETE) AS STEP_COMP_COUNT FROM getSteps WHERE WRK_IMPLEMENTATION_TASK_COMPLETE = 1 AND WRK_SOLUTION_ID = #WRK_SOLUTION_ID#
            </cfquery>
    
            <cfset getFamilies = steps.getFamilies(solution_id : getObjects.WRK_SOLUTION_ID)>
    
            <cfset complated_rate = ( getSolutionCountTask.STEP_COMP_COUNT gt 0 ) ? ( getSolutionCountTask.STEP_COMP_COUNT * 100 ) / getSolutionCount.STEP_COUNT : 0 >
    
            <cfset getModule = steps.getModule(family_id : getObjects.WRK_FAMILY_ID)>
            <cfif len(getModule.MODULE_ID) >
                <cfset MidList = valueList(getModule.MODULE_ID)>
                <cfset getTask = steps.getTaskDashboard(module_id : MidList)>
            </cfif>
            <cfif getSolutionCount.STEP_COUNT gt 0 >
                <cfset complated_rate_task = ( isdefined("getTask") and getTask.TASK_END_COUNT gt 0 ) ? ( getTask.TASK_END_COUNT * 100 ) / getTask.recordCount : 0 >
                <!--- Solution Family Cards --->
                <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
                    <cf_box class="lean">
                        <a href="#request.self#?fuseaction=settings.imp_steps&family_id=#getObjects.WRK_FAMILY_ID#&from_dashboard=1" target="_blank" style="color:##16A288;font-size: 20px;">
                            #getObjects.solution# - #getObjects.family#
                        </a>
                        <cfif complated_rate_task eq 100>
                            <div class="ui-dashboard">
                                <div class="ui-dashboard-item imp_item">
                                    <label class="ui-dashboard-item-title imp_color_green">Modül</label>
                                    <label class="ui-dashboard-item-text imp_color_green">#getModule.recordcount#</label>
                                </div>
                                <div class="ui-dashboard-item imp_item">
                                    <label class="ui-dashboard-item-title imp_color_green">Adım</label>
                                    <label class="ui-dashboard-item-text imp_color_green"># ( isdefined("getTask") and getTask.recordCount ) ? getTask.recordCount : 0 # / # ( isdefined("getTask") and getTask.recordCount ) ? getTask.TASK_END_COUNT : 0 #</label>
                                </div>
                                <div class="ui-dashboard-item imp_item">
                                    <label class="ui-dashboard-item-title imp_color_green">Tamamlanan</label>
                                    <label class="ui-dashboard-item-text imp_color_green">#TLFormat(complated_rate_task)#%</label>
                                </div>
                            </div>
                            <cfelseif complated_rate_task eq 0>
                                <div class="ui-dashboard">
                                    <div class="ui-dashboard-item imp_item">
                                        <label class="ui-dashboard-item-title imp_color_red">Modül</label>
                                        <label class="ui-dashboard-item-text imp_color_red">#getModule.recordcount#</label>
                                    </div>
                                    <div class="ui-dashboard-item imp_item">
                                        <label class="ui-dashboard-item-title imp_color_red">Adım</label>
                                        <label class="ui-dashboard-item-text imp_color_red"># ( isdefined("getTask") and getTask.recordCount ) ? getTask.recordCount : 0 # / # ( isdefined("getTask") and getTask.recordCount ) ? getTask.TASK_END_COUNT : 0 #</label>
                                    </div>
                                    <div class="ui-dashboard-item imp_item">
                                        <label class="ui-dashboard-item-title imp_color_red">Tamamlanan</label>
                                        <label class="ui-dashboard-item-text imp_color_red">#TLFormat(complated_rate_task)#%</label>
                                    </div>
                                </div>
                            <cfelse>
                                <div class="ui-dashboard">
                                    <div class="ui-dashboard-item imp_item">
                                        <label class="ui-dashboard-item-title imp_color_blue">Modül</label>
                                        <label class="ui-dashboard-item-text imp_color_blue">#getModule.recordcount#</label>
                                    </div>
                                    <div class="ui-dashboard-item imp_item">
                                        <label class="ui-dashboard-item-title imp_color_blue">Adım</label>
                                        <label class="ui-dashboard-item-text imp_color_blue"># ( isdefined("getTask") and getTask.recordCount ) ? getTask.recordCount : 0 # / # ( isdefined("getTask") and getTask.recordCount ) ? getTask.TASK_END_COUNT : 0 #</label>
                                    </div>
                                    <div class="ui-dashboard-item imp_item">
                                        <label class="ui-dashboard-item-title imp_color_blue">Tamamlanan</label>
                                        <label class="ui-dashboard-item-text imp_color_blue">#TLFormat(complated_rate_task)#%</label>
                                    </div>
                                </div>
                        </cfif>
                    </cf_box>
                </div>
            </cfif>
        </cfoutput>
    </div>
</div>