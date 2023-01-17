<CFX_james_connection HOST        = "workcube" 
					  PORT        = "4555" 
					  USERNAME    = "root" 
					  PASSWORD    = "root"
					  COMMAND     = "deluser"
					  NEWUSERNAME = "#attributes.ACCOUNT#"
					  ERROR       = "ERROR">
<cfif Len(ERROR)>
	<cfoutput>#ERROR#</cfoutput><cfabort>
</cfif>

<cfquery name="MYACCOUNT" datasource="#DSN#">
  DELETE FROM COMPANY_ACCOUNTS WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>

<script type="text/javascript">
	window.close();
</script>
