<cfinclude template="../query/get_discipline_decision.cfm">
<table border="0" width="650" align="center">
<tr valign="middle">
  <td height="35"  align="center" class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id ='53299.Disiplin Kurulu Kararı'> </td>
</tr>
<tr valign="top">
  <td>
      <table  border="0" width="100%">
        <tr>
            <td  colspan="4" class="txtbold">
                <cfset my_comp_branch_id=get_discipline_detail.EVENT_ID>
                <cfinclude template="../query/get_our_comp_and_branch_name.cfm">
                <cfoutput>#get_com_branch.COMPANY_NAME#</cfoutput>  
            </td>
        </tr> 
        <tr>
            <td class="txtbold" colspan="4"><cfoutput>#get_com_branch.BRANCH_NAME#</cfoutput><cf_get_lang dictionary_id='58941.Şubesi'> </td>
        </tr> 
        <tr>
            <td colspan="4"></td>
        </tr> 
        <tr>
            <td width="65" ><cf_get_lang dictionary_id ='53300.Toplantı No'></td>
            <td   colspan="3"><cfoutput>#get_discipline_detail.MEETING_NO#</cfoutput></td>
        </tr> 
        <tr>
            <td width="65" ><cf_get_lang dictionary_id ='53301.Toplantı Tarihi'></td>
            <td  colspan="3"><cfoutput>#get_discipline_detail.MEETING_DATE#</cfoutput></td>
        </tr> 
        <tr>
            <td width="65" ><cf_get_lang dictionary_id ='54142.Toplantıya Katılanlar'> </td>
            <td  colspan="3"></td>
        </tr> 
        <tr>
            <td width="65" ><cf_get_lang dictionary_id ='54143.Görüşülen Dosya No'> </td>
            <td colspan="3"><cfoutput>#get_discipline_detail.FOLDER_NO#</cfoutput></td>
        </tr> 
        <tr>
            <td width="65" ><cf_get_lang dictionary_id ='54144.Adı Geçen Personel'> </td>
            <td colspan="3">
                <cfset EMP_ID=get_discipline_detail.TO_CAUTION>
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
            <td  colspan="4" ><cf_get_lang dictionary_id='29510.Olay'>: </td>
        </tr> 				
        <tr>
            <td width="65" colspan="4" ><cfoutput>#get_discipline_detail.DETAIL#</cfoutput> </td>
        </tr> 
        <tr>
            <td  colspan="4"  align="center" class="txtbold"><cf_get_lang dictionary_id ='54146.KARAR'></td>
        </tr> 									
        <tr>
            <td width="65" ><cf_get_lang dictionary_id ='53303.Karar No'></td>
            <td colspan="3"><cfoutput>#get_discipline_detail.DECISION_NO#</cfoutput></td>
        </tr> 	
        <tr>
            <td width="65" ><cf_get_lang dictionary_id ='53306.Karar Tarihi'></td>
            <td colspan="3"><cfoutput>#get_discipline_detail.DECISION_DATE#</cfoutput></td>
        </tr> 		
        <tr>
            <td width="65" ><cf_get_lang dictionary_id ='53300.Toplantı No'></td>
            <td colspan="3"><cfoutput>#get_discipline_detail.MEETING_NO#</cfoutput></td>
        </tr> 	
        <tr>
            <td width="65" colspan="4" ><cfoutput>#get_discipline_detail.DECISION_DETAIL#</cfoutput>  </td>
        </tr> 			
        <tr>
            <td width="5"></td>
            <td><cf_get_lang dictionary_id ='57658.Üye'></td>					
            <td><cf_get_lang dictionary_id ='57658.Üye'></td>
            <td><cf_get_lang dictionary_id ='53305.Başkan'></td>					
        </tr> 													
        <tr>
            <td width="5"></td>
            <td>
                <cfset EMP_ID=get_discipline_detail.MEMBER1>
                <cfif len(EMP_ID)>
                    <cfinclude template="../query/get_action_emp.cfm">
                    <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                <cfelse>
                    <cfset emp_name="">
                </cfif>		
                <cfoutput>#emp_name#</cfoutput>					
            </td>					
            <td>
                <cfset EMP_ID=get_discipline_detail.MEMBER2>
                <cfif len(EMP_ID)>
                    <cfinclude template="../query/get_action_emp.cfm">
                    <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
                <cfelse>
                    <cfset emp_name="">
                </cfif>		
                <cfoutput>#emp_name#</cfoutput>						
            </td>
            <td>
                <cfset EMP_ID=get_discipline_detail.CHAIRMAN>
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
<script>window.print();</script>

