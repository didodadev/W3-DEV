<!--- 
    File: settings/display/dataservice_history.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-04-02
    Description: Workcube Data Service History
        
    History:
        
    To Do:
 --->
 <cfset dataservices_cmp = createObject("component","WEX.dataservices.cfc.data_services") />
<cf_box title="#getLang('','Data Service Tarihçe',62500)#" resize="1" closable="1" draggable="1" id="draft_budget" popup_box="1">
    <cfset get_dataservices = dataservices_cmp.getDataServiceHistory(wex_id: attributes.wex_id)>
    <cf_grid_list>
        <thead>
            <tr>
                <th width="35"><cf_get_lang dictionary_id='57487.No'></th>
                <th>HEAD</th>
                <th>RECEIVED DATE</th>
                <th>RECORD DATE</th>
                <th>RECORD EMPLOYEE</th>
                <th>UPDATE DATE</th>
                <th>UPDATE EMPLOYEE</th>
                <th>MAIN VERSION</th>
                <th>OBJECT VERSION</th>
            </tr>
        </thead>
        <tbody>
        <cfoutput query="get_dataservices">
            <tr>
                <td>#currentrow#</td>
                <td class="text-center">#head#</th>
                <td class="text-center">#dateformat(PUBLISHING_DATE,dateformat_style)#</td>
                <td class="text-center">#dateformat(RECORD_DATE,dateformat_style)#</td>
                <td class="text-center">#get_emp_info(record_emp,0,1)#</td>
                <td class="text-center">#dateformat(UPDATE_DATE,dateformat_style)#</td>
                <td class="text-center">#get_emp_info(RECORD_EMP,0,1)#</td>
                <td class="text-center">#main_version#</td>
                <td class="text-center">#version#</td>
            </tr>
        </cfoutput>
        </tbody>
    </cf_grid_list>
</cf_box>