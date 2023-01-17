<cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
<cfset get_service_open = getComponent.GET_SERVICE(service_status:1,process_stage:813)>
<cfset get_service_close = getComponent.GET_SERVICE(service_status:1,process_stage:818)>
<cfquery name="GET_TOTAL_OPEN" dbtype="query">
    SELECT COUNT(SERVICE_ID) SERVICE_COUNT FROM get_service_open
</cfquery>
<cfquery name="GET_TOTAL_CLOSE" dbtype="query">
    SELECT COUNT(SERVICE_ID) SERVICE_COUNT FROM get_service_close
</cfquery>
<cfset open = len(GET_TOTAL_OPEN.SERVICE_COUNT) ? GET_TOTAL_OPEN.SERVICE_COUNT : 0>
<cfset close = len(GET_TOTAL_CLOSE.SERVICE_COUNT) ? GET_TOTAL_CLOSE.SERVICE_COUNT : 0>
<div class="info_card_item">
    <ul>
        <li>
            <div class="info_card_item_name">
                <cf_get_lang dictionary_id='47612.Calls'>
            </div>
        </li>
        <li>
            <div class="info_card_item_rate">
                <cfoutput>#Replace(Replace(Replace(TLFormat((close*100)/(open+close)),'.','*'),',','.','all'),'*',',')#%</cfoutput>
            </div>            
            <i class="far fa-question-circle"></i>
        </li>
    </ul>
    <ul>
        <li>
            <div class="info_card_item_num">
                <cfoutput>#Replace(numberFormat(open,','),',','.','all')#</cfoutput>
            </div>
            <div class="info_card_item_info">
                <cf_get_lang dictionary_id='58717.Açık'>
            </div>        
        </li>
        <li>
            <div class="info_card_item_num">
                <cfoutput>#Replace(numberFormat(close,','),',','.','all')#</cfoutput>
            </div>
            <div class="info_card_item_info">
                <cf_get_lang dictionary_id='61896.?'>
            </div> 
        </li>
    </ul>      
</div>