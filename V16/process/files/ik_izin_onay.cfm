<!---
    Author: Workcube - Esma R. Uysal <esmauysal@workcube.com>
    Date: 15.04.2020
    Description:
	   İzin Talebi IK Onay Sürecine eklenmelidir. IK Onay işlemini yapar.
--->
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE OFFTIME SET VALID = 1,VALID_EMPLOYEE_ID = #session.ep.userid#, VALIDDATE = #now()# WHERE  OFFTIME_ID = #attributes.action_id#
    </cfquery> 
</cfif>