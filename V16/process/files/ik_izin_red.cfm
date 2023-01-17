<!---
    Author: Workcube - Esma R. Uysal <esmauysal@workcube.com>
    Date: 15.04.2020
    Description:
	   İzin Talebi IK Red Sürecine eklenmelidir. IK Red işlemini yapar.
--->
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfquery name="upd_refusal" datasource="#caller.dsn#">
        UPDATE OFFTIME SET VALID = 0 ,VALID_EMPLOYEE_ID = #session.ep.userid#,EMP_VALID_DATE = #now()# WHERE OFFTIME_ID = #attributes.action_id#
    </cfquery>
</cfif>