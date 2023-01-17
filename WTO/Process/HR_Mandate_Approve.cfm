<!---
VAKALET kaydedildiği zaman IS_APPROVE 1 yapar. TolgaS 23230121
 ---> 
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfquery name="UPD_APPROVE_MANDATE" datasource="#attributes.data_source#">
		UPDATE #caller.dsn_alias#.EMPLOYEE_MANDATE SET 
			IS_APPROVE = 1, 
			IS_ACTIVE = 1 
		WHERE MANDATE_MASTER_ID = #attributes.action_id#
	</cfquery>
</cfif>

