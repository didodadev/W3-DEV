<!---
    Author: Workcube - Gülbahar Inan <gulbaharinan@workcube.com>
    Date: 03.07.2020
    Description:
	   Deneme Süresi Değerlendirme 1.Amir Onay Sürecine eklenmelidir. 1.Amir Onay işlemini yapar.
--->
<cfif isdefined("session.ep") and isdefined("caller.attributes.result_id") and len(caller.attributes.result_id)>
    <cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE SURVEY_MAIN_RESULT SET VALID1 = 1,MANAGER1_EMP_ID = #session.ep.userid#,MANAGER1_POS = #session.ep.position_code#, VALID1_DATE = #now()# WHERE  SURVEY_MAIN_RESULT_ID = #caller.attributes.result_id#
    </cfquery> 
    
</cfif>