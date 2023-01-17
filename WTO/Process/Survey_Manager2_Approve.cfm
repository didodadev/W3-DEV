<!---
    Author: Workcube - Gülbahar Inan <gulbaharinan@workcube.com>
    Date: 03.07.2020
    Description:
	   Deneme Süresi Değerlendirme  2.Amir Onay Sürecine eklenmelidir. 2.Amir Onay işlemini yapar.
--->
<cfif isdefined("session.ep") and isdefined("caller.attributes.result_id") and len(caller.attributes.result_id)>
    <cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE SURVEY_MAIN_RESULT SET VALID2 = 1,MANAGER2_EMP_ID = #session.ep.userid#,MANAGER3_POS = #session.ep.position_code#, VALID2_DATE = #now()# WHERE  SURVEY_MAIN_RESULT_ID = #caller.attributes.result_id#
    </cfquery> 
</cfif>