    Author: Workcube - Esma R. Uysal <esmauysal@workcube.com>
    Date: 12.08.2020
    Description:
	    Fazla Mesai 1. Amir Onay.
--->
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE EMPLOYEES_EXT_WORKTIMES SET VALID_2 = 1,VALID_EMPLOYEE_ID_2 = #session.ep.userid#, VALIDDATE_2 = #now()# WHERE  EWT_ID = #attributes.action_id#
    </cfquery> 
</cfif>