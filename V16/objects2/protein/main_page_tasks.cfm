<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset get_works_passive = getComponent.DET_WORK(work_status:0)>
<cfset get_works_active = getComponent.DET_WORK(work_status:1)>
<cfquery name="GET_TOTAL_ACTIVE" dbtype="query">
    SELECT COUNT(WORK_ID) WORK_COUNT FROM get_works_active
</cfquery>
<cfquery name="GET_TOTAL_PASSIVE" dbtype="query">
    SELECT COUNT(WORK_ID) WORK_COUNT FROM get_works_passive
</cfquery>
<cfset passive = len(GET_TOTAL_PASSIVE.WORK_COUNT) ? GET_TOTAL_PASSIVE.WORK_COUNT : 0>
<cfset active = len(GET_TOTAL_ACTIVE.WORK_COUNT) ? GET_TOTAL_ACTIVE.WORK_COUNT : 0>
<div class="info_card_item">
    <ul>
        <li>
            <div class="info_card_item_name">
                <cf_get_lang dictionary_id='52687.Tasks'>
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