<!---
    Author: Workcube - Esma R. Uysal <esmauysal@workcube.com>
    Date: 12.08.2020
    Description:
	   Fazla Mesai Red İşlemi.
--->
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfquery name="upd_refusal" datasource="#caller.dsn#">
        UPDATE EMPLOYEES_EXT_WORKTIMES SET VALID = 1, VALID_EMPLOYEE_ID = #session.ep.userid#, VALIDDATE = #now()# WHERE EWT_ID = #attributes.action_id#
    </cfquery>
</cfif>