<cfset wdo = createObject("component","WDO.modalModuleMenu")>
<cfset steps = createObject("component","WDO.ImplementationSteps")>
<cfset getObjects = WDO.getSolutionImp()>
<cfset getSteps = steps.getSteps()>

<cfparam name="attributes.from_dashboard" default='0'>

<cfquery name="getProjectID" datasource="#dsn#">
	SELECT TOP 1 IMPLEMENTATION_PROJECT_ID FROM WRK_LICENSE ORDER BY LICENSE_ID DESC
</cfquery>

<cfquery name="getModulCount" dbtype="query">
    select WRK_MODUL_ID FROM getSteps GROUP BY WRK_MODUL_ID
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
<cfif len(getModule.MODULE_ID) >
    <cfset MidList = valueList(getModule.MODULE_ID)>
    <cfset getTask = steps.getTaskDashboard(module_id : MidList)>
</cfif>

<cfset complated_rate_task = ( isdefined("getTask") and getTask.TASK_END_COUNT gt 0 ) ? ( getTask.TASK_END_COUNT * 100 ) / getTask.recordCount : 0 >

<cfset pagehead = "Implementasyon / Project ID: #getProjectID.IMPLEMENTATION_PROJECT_ID#">
<cf_catalystHeader>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <!--- Family List --->
    <div class="col col-3 col-xs-12">
        <cf_box title="Business Family">
            <ul class="ui-list">
                <cfoutput query="getObjects">
                    <li>
                        <a href="javascript://" style ="color: ##16A288;"onClick="loadFamily(#getObjects.WRK_FAMILY_ID#);">#getObjects.solution# - #getObjects.family#</a>
                    </li>
                </cfoutput>	
                <!--- <li>
                    <a href="javascript:void(0)">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-018-monitor"></span>
                            Menu
                        </div>
                        <div class="ui-list-right">
                            <i class="fa fa-cube"></i>
                            <i class="fa fa-pencil"></i>
                            <i class="fa fa-chevron-down"></i>
                        </div>
                    </a>
                </li> --->
            </ul>
            <!--- <ul class="submenu">
                <div class="menuDropdownItem lit_list_item">
                    
                </div>
            </ul> --->
        </cf_box>
    </div>
    <!--- Dashboard --->
    <div class="col col-9 col-xs-12">
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

        <div id="ajax_right">
        </div>
    </div>
</div>

<script>
    function loadFamily(family_id){
        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.imp_steps_ajax&family_id=' + family_id,'ajax_right');         
    }
    <cfif (attributes.from_dashboard eq 1)>
        loadFamily(<cfoutput>#attributes.family_id#</cfoutput>);
    </cfif>
</script>

