<!---
    Author: Workcube - Esma R. Uysal <esmauysal@workcube.com>
    Date: 04.05.2020
    Description:
	   Fazla Mesai IK Red Sürecine eklenmelidir. IK Red işlemini yapar.
--->
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfquery name="upd_valid" datasource="#caller.dsn#">
        UPDATE EMPLOYEES_EXT_WORKTIMES  SET VALID = 0, VALID_EMPLOYEE_ID = #session.ep.userid#, VALIDDATE = #now()# WHERE EWT_ID =  #attributes.action_id#  
    </cfquery> 
</cfif>