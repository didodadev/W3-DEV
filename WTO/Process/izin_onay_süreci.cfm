<!---
    Author: Workcube - Esma R. Uysal <esmauysal@workcube.com>
    Date: 10.03.2020
    Description:
	amir1_asama_id = 1. Amir Onay Süreç ID'sinin verilmesi gerekir
    amir2_asama_id = 2. Amir Onay Süreç ID'sinin verilmesi gerekir
    ikonay_asama_id = IK Onay Süreç ID'sinin verilmesi gerekir
    ikred_asama_id = IK Red ID'sinin verilmesi gerekir
--->
<cfset actionid = attributes.action_id>
<cfset amir1_asama_id = "2303">
<cfset amir2_asama_id = "2296">
<cfset ikonay_asama_id = "2333">
<cfset ikred_asama_id = "2297">
<cfif listfind(amir1_asama_id,attributes.process_stage,',')>
    <cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE OFFTIME SET VALID_1 = 1,VALID_EMPLOYEE_ID_1 = #session.ep.userid#, VALIDDATE_1 = #now()# WHERE  OFFTIME_ID = #actionid#
    </cfquery> 
<cfelseif listfind(amir2_asama_id,attributes.process_stage,',')>
    <cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE OFFTIME SET VALID_2 = 1,VALID_EMPLOYEE_ID_2 = #session.ep.userid#, VALIDDATE_2 = #now()# WHERE  OFFTIME_ID = #actionid#
    </cfquery> 
<cfelseif listfind(ikonay_asama_id,attributes.process_stage,',')>
    <cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE OFFTIME SET VALID = 1,VALID_EMPLOYEE_ID = #session.ep.userid#, VALIDDATE = #now()# WHERE  OFFTIME_ID = #actionid#
    </cfquery> 
<cfelseif listfind(157,attributes.process_stage,',')>
    <cfquery name="upd_refusal" datasource="#caller.dsn#">
        UPDATE OFFTIME SET VALID = 0 ,VALID_EMPLOYEE_ID = #session.ep.userid#,EMP_VALID_DATE = #now()# WHERE OFFTIME_ID = #actionid#
    </cfquery>
</cfif>
	