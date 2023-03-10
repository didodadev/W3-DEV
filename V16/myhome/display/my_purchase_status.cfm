<!--- 24012021 / Botan Kayğan
      Satınalma Widget
--->
<cfset cmp = createObject("component","V16.myhome.cfc.my_team")>
<cfset MyDepartmentTeam = cmp.get_position_department(position_code : session.ep.position_code) />
<cfset employee_ids = valuelist(MyDepartmentTeam.employee_id)>
<cfset employee_ids = listAppend(employee_ids,session.ep.userid) />
<!--- Satınalma Teklifleri --->
<cfset GET_ACTIVE_OFFERS = cmp.GET_ACTIVE_OFFERS(employee_ids : employee_ids)>
<cfset offer_count = 0>
<cfset offer_value = 0>
<cfif GET_ACTIVE_OFFERS.recordcount>
    <cfset offer_count = GET_ACTIVE_OFFERS.COUNT_RECORD>
    <cfset offer_value = GET_ACTIVE_OFFERS.SUM_RECORD>
</cfif>

<!--- Satınalma Talepleri --->
<cfset GET_ACTIVE_PURCHASEDEMANDS = cmp.GET_ACTIVE_PURCHASEDEMANDS(employee_ids : employee_ids)>

<!--- Satınalma Siparişleri --->
<cfset GET_ACTIVE_ORDERS = cmp.GET_ACTIVE_ORDERS(employee_ids : employee_ids)>

<!--- İç Talepleri --->
<cfset GET_ACTIVE_INTERNALDEMANDS = cmp.GET_ACTIVE_INTERNALDEMANDS(employee_ids : employee_ids)>

<div class="ui-dashboard">
    <div class="ui-dashboard-item ui-dashboard-item__type2">
        <table class="ui-table-list ui-form">
            <tbody>
                <cfoutput>
                    <tr>
                        <td><cf_get_lang dictionary_id='30782.İç Talepler'></td>
                        <td style="text-align:right">#GET_ACTIVE_INTERNALDEMANDS.COUNT_RECORD# <cf_get_lang dictionary_id='58082.Adet'></td>
                        <td style="text-align:right">#TLFormat(GET_ACTIVE_INTERNALDEMANDS.SUM_RECORD)# #session.ep.money#</td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='33263.Satınalma Talepleri'></td>
                        <td style="text-align:right">#GET_ACTIVE_PURCHASEDEMANDS.COUNT_RECORD# <cf_get_lang dictionary_id='58082.Adet'></td>
                        <td style="text-align:right">#TLFormat(GET_ACTIVE_PURCHASEDEMANDS.SUM_RECORD)# #session.ep.money#</td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='30048.Satınalma Teklifleri'></td>
                        <td style="text-align:right">#offer_count# <cf_get_lang dictionary_id='58082.Adet'></td>
                        <td style="text-align:right">#TLFormat(offer_value)# #session.ep.money#</td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='30008.Satınalma Siparişleri'></td>
                        <td style="text-align:right">#GET_ACTIVE_ORDERS.COUNT_RECORD# <cf_get_lang dictionary_id='58082.Adet'></td>
                        <td style="text-align:right">#TLFormat(GET_ACTIVE_ORDERS.SUM_RECORD)# #session.ep.money#</td>
                    </tr>
                </cfoutput>
            </tbody>    
        </table>
    </div>        
</div>