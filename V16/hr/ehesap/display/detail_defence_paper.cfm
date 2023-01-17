<cfinclude template="../query/get_defence_detail.cfm">
<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
<tr valign="middle">
  <td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id="53295.Savunma Talep Yazısı"> </td>
</tr>
<tr valign="top">
  <td>
      <table  border="0">
        <tr>
          <td colspan="2">
                <cfset EMP_ID=get_defence.TO_CAUTION>
                <cfif len(EMP_ID)>
                    <cfinclude template="../query/get_action_emp.cfm">
                    <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                <cfelse>
                    <cfset emp_name="">
                </cfif>
                <cf_get_lang dictionary_id="58780.Sayın">: <cfoutput>#emp_name#</cfoutput>
        </td>
        <tr>
          <td  colspan="2">
            <cfoutput>#get_defence.DETAIL#</cfoutput>
          </td>
        </tr>	
        <tr>
          <td  colspan="2">
            <cf_get_lang dictionary_id="41544.Yukarıda belirtilen konu ile ilgili savunmanızı yazmanızı rica ederim">.<br/>
            <cfoutput>#dateformat(get_defence.PAPER_DATE,dateformat_style)#</cfoutput>
          </td>
        </tr>	
                        
        <tr>
          <td  colspan="2">
                <cfset EMP_ID=get_defence.WRITER_ID>
                <cfif len(EMP_ID)>
                    <cfinclude template="../query/get_action_emp.cfm">
                    <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                <cfelse>
                    <cfset emp_name="">
                </cfif>
                <cfoutput>#emp_name#</cfoutput>
          </td>
        </tr>					
      </table>
  </td>
</tr>
</table>
<script>
	window.print();
</script>
