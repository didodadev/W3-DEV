<!---
    Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
    Date: 10.11.2020
    Description:
      Bütçe Aktarım Talebi Onay süreçleri değiştir ve mail gönder....
--->
<cfset demand = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>
<cfset det_demand = demand.det_demand(
                                        demand_id : attributes.action_id
                                     )>

<cfset demand_val = deserializeJSON(det_demand)>
<cfif demand_val[1]["DEMAND_STAGE"] eq '165'><!--- GMY 1 Onayladı İSE --->
        <cfset attributes.stage_id = 164><!--- SÜRECİ GMY 2 Onayladı GETİR--->
        <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
<cfelseif demand_val[1]["DEMAND_STAGE"] eq '164'><!--- GMY2 Onayladı İSE --->
    <cfset attributes.stage_id = 166><!--- süreci CFO Onayladı sürecine getir--->
    <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
<cfelseif demand_val[1]["DEMAND_STAGE"] eq '166'><!--- CFO Onayladı İSE --->
    <!--- mail gönder gm ve bütçe ekibine --->
<cfelseif demand_val[1]["DEMAND_STAGE"] eq '166'><!--- GM Onayladı ise--->
    <!--- mail gönder bütçe ekibine --->
</cfif>