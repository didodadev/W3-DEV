<!---
    File: allowance_expense.cfm
    Controller: AllowenceExpenseController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        Myhome harcama talebi listeleme sayfasıdır.
--->
<cfsavecontent variable = "title">
    <cf_get_lang dictionary_id = "59433.Harcırah taleplerim">
</cfsavecontent>
<cfset expense_component = createObject("component","V16.myhome.cfc.allowance_expense")>
<cfset fuseaction = listFirst(attributes.fuseaction,".")>
<cfset GET_EXPENSE =  expense_component.GET_EXPENSE(employee_id : session.ep.userid,expense_type : 1)>
<cf_box id="list_worknet_list" closable="0" collapsable="1" title="#title#" add_href="#request.self#?fuseaction=#fuseaction#.allowance_expense&event=add" > 
    <cf_ajax_list>
        <div id="Note_list">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id = "57880.Belge No"></th>
                    <th><cf_get_lang dictionary_id = "57742.Tarih"></th>
                    <th><cf_get_lang dictionary_id = "58859.Süreç"></th>
                    <th><cf_get_lang dictionary_id = "56975.KDV'li tutar"></th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query = "GET_EXPENSE">
                    <tr>
                        <td>
                            #PAPER_NO#
                        </td>
                        <td>
                            #dateFormat(EXPENSE_DATE,dateformat_style)#
                        </td>
                        <td>
                            #STAGE#
                        </td>
                        <td>
                            #TLFormat(OTHER_MONEY_NET_TOTAL)# #OTHER_MONEY#
                        </td>
                        <td style="text-align:center">
                            <cfsavecontent  variable="upd_title">
                                <cf_get_lang dictionary_id = "57464.Güncelle">
                            </cfsavecontent>
                            <a href="javascript://" onclick="open_update_page('#contentEncryptingandDecodingAES(isEncode:1,content:EXPENSE_ID,accountKey:'wrk')#')" title ="#upd_title#"><span class="icn-md icon-update" style="color :##808080 !important"></span></a>
                        </td>
                    </tr>
                </cfoutput>
            </tbody>
        </div>
    <cf_ajax_list>
</cf_box>
<script>
    function open_update_page (flexible_id){
        window.open("<cfoutput>#request.self#?fuseaction=#fuseaction#.allowance_expense&event=upd&request_id=</cfoutput>"+flexible_id, '_blank');
    }
</script>