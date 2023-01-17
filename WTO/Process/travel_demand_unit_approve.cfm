<!---
    Author: Workcube - Gülbahar Inan <gulbaharinan@workcube.com>
    Date: 19.08.2020
    Description:
      Seyahat Talebi Formu Birim Onayı (Direktör Onayı-action file) sürecine eklenmelidir.
--->
<cfif isdefined("session.ep") and isdefined("caller.attributes.travel_demand_id") and len(caller.attributes.travel_demand_id)>
    <cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE EMPLOYEES_TRAVEL_DEMAND SET MANAGER2_VALID = 1, MANAGER2_EMP_ID = #session.ep.userid#,MANAGER2_POS_CODE = #session.ep.position_code#, MANAGER2_VALID_DATE = #now()# WHERE  TRAVEL_DEMAND_ID = #caller.attributes.travel_demand_id#
    </cfquery> 
</cfif>