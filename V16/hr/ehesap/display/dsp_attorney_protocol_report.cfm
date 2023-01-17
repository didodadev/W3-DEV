<cfquery NAME="GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL" DATASOURCE="#DSN#">
	SELECT 
		EE.*,
		EER.EVENT_TYPE,
		EER.DETAIL,
		EER.WITNESS_1,
		EER.WITNESS_2,
		EER.WITNESS_3,
		EER.TO_CAUTION
	FROM 
		EMPLOYEE_EVENT_ATTORNEY_PROTOCOL EE,
		EMPLOYEES_EVENT_REPORT EER
	WHERE	
		EE.EVENT_ID=#attributes.EVENT_ID#
		AND
		EER.EVENT_ID = EE.EVENT_ID
</cfquery>
<table width="650" border="0" align="center">
  <tr>
    <td height="30" class="txtbold" style="text-align:right;"><cfoutput>#dateformat(get_employee_event_attorney_protocol.protocol_date,dateformat_style)#</cfoutput></td>
  </tr>
  <tr>
    <td  class="formbold">
	<br/>
	<cfoutput>#GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.protocol_head#</cfoutput>
	<br/><br/>	
	</td>
  </tr>
  <tr>
    <td class="txtbold" height="20"><cf_get_lang dictionary_id="29510.Olay"> : <cfoutput>#GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.EVENT_TYPE#</cfoutput></td>
  </tr>
  <tr>
    <td><cfoutput>#GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.DETAIL#</cfoutput></td>
  </tr>
</table>
<br/>
<table width="650" align="center">
  <tr class="formbold" height="30">
    <td width="200"><cf_get_lang dictionary_id="53325.Tanık"> 1</td>
    <td width="200"><cf_get_lang dictionary_id="53325.Tanık"> 2</td>
    <td><cf_get_lang dictionary_id="53325.Tanık"> 3</td>
  </tr>
  <tr>
    <td>
	<cfif len(GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.witness_1)>
		<cfset attributes.employee_id = GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.witness_1>
		<cfinclude template="../query/get_employee.cfm">
		<cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput>
	</cfif>
    <td>
	<cfif len(GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.witness_2)>
		<cfset attributes.employee_id = GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.witness_2>
		<cfinclude template="../query/get_employee.cfm">
		<cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput>
	</cfif>
	</td>
    <td>
	<cfif len(GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.witness_3)>
		<cfset attributes.employee_id = GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.witness_3>
		<cfinclude template="../query/get_employee.cfm">
		<cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput>
	</cfif>
	</td>
  </tr>
</table>
<script>
	window.print();
</script>
