<cfscript>
	CreateCompenent = createObject("component", "V16/project/cfc/projectData");
	get_projects_act = CreateCompenent.get_projects(project_status:1);
    get_projects_psv = CreateCompenent.get_projects(project_status:-1);
</cfscript> 
<cfquery name="GET_TOTAL_ACTIVE" dbtype="query">
    SELECT COUNT(PROJECT_ID) PROJECT_COUNT FROM get_projects_act
</cfquery>
<cfquery name="GET_TOTAL_PASSIVE" dbtype="query">
    SELECT COUNT(PROJECT_ID) PROJECT_COUNT FROM get_projects_psv
</cfquery>
<cfset passive = len(GET_TOTAL_PASSIVE.PROJECT_COUNT) ? GET_TOTAL_PASSIVE.PROJECT_COUNT : 0>
<cfset active = len(GET_TOTAL_ACTIVE.PROJECT_COUNT) ? GET_TOTAL_ACTIVE.PROJECT_COUNT : 0>
<div class="info_card_item">
    <ul>
        <li>
            <div class="info_card_item_name">
                <cf_get_lang dictionary_id='58015.Projects'>
            </div>
        </li>
        <li>
            <div class="info_card_item_rate">
                <cfoutput>#Replace(Replace(Replace(TLFormat((passive*100)/(active+passive)),'.','*'),',','.','all'),'*',',')#%</cfoutput>
             </div>  
            <i class="fas fa-chart-bar"></i>
        </li>
    </ul>
    <ul>
        <li>
            <div class="info_card_item_num">
                <cfoutput>#Replace(numberFormat(active,','),',','.','all')#</cfoutput>
            </div>
            <div class="info_card_item_info">
                <cf_get_lang dictionary_id='57493.Active'>
            </div>        
        </li>
        <li>
            <div class="info_card_item_num">
                <cfoutput>#Replace(numberFormat(passive,','),',','.','all')#</cfoutput>
            </div>
            <div class="info_card_item_info">
                <cf_get_lang dictionary_id='57494.Passive'>
            </div> 
        </li>
    </ul>      
</div>