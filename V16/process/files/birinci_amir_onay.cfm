<!---
    Author: Workcube - Esma R. Uysal <esmauysal@workcube.com>
    Date: 15.04.2020
    Description:
	    İzin Talebi 1. Amir Sürecine eklenmelidir. 1. Amir'in Onay işlemini yapar.
--->
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE OFFTIME SET VALID_1 = 1,VALID_EMPLOYEE_ID_1 = #session.ep.userid#, VALIDDATE_1 = #now()# WHERE  OFFTIME_ID = #attributes.action_id#
    </cfquery> 
</cfif>