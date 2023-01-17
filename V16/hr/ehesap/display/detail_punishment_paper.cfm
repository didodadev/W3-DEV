<cfinclude template="../query/get_punishment_paper.cfm">
<table width="650" align="center">
<tr valign="middle">
  <td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id="53456.Ceza Tebliğ Yazısı"></td>
</tr>
<tr valign="top">
  <td>

      <table  border="0">
        <tr>
              <td width="65"><cf_get_lang dictionary_id="57924.Kime"></td>
              <td colspan="3">
                    <cfset EMP_ID=get_punishment_paper.TO_CAUTION>
                    <cfif len(EMP_ID)>
                        <cfinclude template="../query/get_action_emp.cfm">
                        <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                    <cfelse>
                        <cfset emp_name="">
                    </cfif>					  
                  <cfoutput>#emp_name#</cfoutput>
              </td>
        </tr>	
        <tr>
              <td width="65"><cf_get_lang dictionary_id="46789.Kimden"></td>
              <td colspan="3">
                    <cfoutput>#get_punishment_paper.FROM_WHO#</cfoutput>	  
              </td>
        </tr>								  
        <tr>
              <td width="65"><cf_get_lang dictionary_id="57480.Konu"></td>
              <td colspan="3"><cfoutput>#get_punishment_paper.PUNISHMENT_SUBJECT#</cfoutput></td>
        </tr>	
        <tr>
              <td width="65"><cf_get_lang dictionary_id="57742.Tarih"></td>
              <td colspan="3"><cfoutput>#dateformat(get_punishment_paper.PUNISHMENT_DATE,dateformat_style)#</cfoutput></td>
        </tr>							  
        <tr>
          <td  colspan="4">
            <cfoutput>#get_punishment_paper.PUNISHMENT_DETAIL#</cfoutput>
          </td>
        </tr>	
        <tr>
              <td colspan="4">
                    <cfset EMP_ID=get_punishment_paper.MANAGER_ID>
                    <cfif len(EMP_ID)>
                        <cfinclude template="../query/get_action_emp.cfm">
                        <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                    <cfelse>
                        <cfset emp_name="">
                    </cfif>					  
                  <cfoutput>#emp_name#</cfoutput><br/>
              </td>
        </tr>					
      </table>
  </td>
</tr>
</table>
<script>window.print();</script>
