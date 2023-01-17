<!---
    Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
    Date: 10.11.2020
    Description:
      Bütçe Aktarım Talebi Onay kontrol süreci....
--->
<cfset demand = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>
<cfset det_demand = demand.det_demand(
                                        demand_id : attributes.action_id
                                     )>

<cfset demand_val = deserializeJSON(det_demand)>
<cfif listfirst(demand_val[1]["TRA_ACCOUNT_CODE"],'.') eq '770' and listfirst(demand_val[1]["ACCOUNT_CODE"],'.') eq '770'>
    <cfif demand_val[1]["DEMAND_EXP_CENTER"] eq demand_val[1]["TRANSFER_EXP_CENTER"]>
        <cfset attributes.stage_id = 165><!--- GMY Onayladı süreci  id si--->
        <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
        <!--- MAİL GÖNDER CFO ve bütçe ekibine --->
    <cfelse>
        <cfset attributes.stage_id = 164><!--- GMY 1 Onayladı süreci  id si--->
        <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
     </cfif>
<cfelse>
    <cfif len(demand_val[1]["TRANSFER_PROJECT_ID"]) and listfind('Lisans,Donanım,Donanım+Lisans,Bina,İştirak,Demirbaş',demand_val[1]["TRA_PROCESS_CAT"])>
        <cfset attributes.stage_id = 165><!--- GM Onayladı süreci  id si--->
        <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
        <!--- mail gönder bütçe ekibine --->
    <cfelse>
        <cfset attributes.stage_id = 165><!--- revize süreci  id si--->
        <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
        <script>
            alert("Lütfen Bilgileri kontrol ediniz.");
        </script>
    </cfif>
</cfif>