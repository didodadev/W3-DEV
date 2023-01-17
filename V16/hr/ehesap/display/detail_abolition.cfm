<cfinclude template="../query/get_abolition.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53153.Fesih Yazısı"></cfsavecontent>
<cf_popup_box title="#message#">
	<table>
		<tr>
			<td width="65"><cf_get_lang dictionary_id='53155.Kimden'>:</td>
			<td  colspan="3"><cf_get_lang dictionary_id='53271.İnsan Kaynakları ve İletişim Direktörlüğü'></td>
		</tr> 			  
		<tr>
			<td width="65" ><cf_get_lang dictionary_id='57924.Kime'>:</td>
			<td  colspan="3">
				<cfset EMP_ID=get_abolition.TO_CAUTION>
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
			<td><cf_get_lang dictionary_id='57742.Tarih'></td>
			<td  colspan="3"><cfoutput>#dateformat(get_abolition.ABOLITION_DATE,dateformat_style)#</cfoutput></td>
		</tr> 					
		<tr>
			<td><cf_get_lang dictionary_id='57480.Konu'></td>
			<td colspan="3"><cfoutput>#get_abolition.ABOLITION_SUBJECT#</cfoutput></td>
		</tr> 				
		<tr>
			<td colspan="4" ></td>
		</tr> 				
		<tr>
			<td><cf_get_lang dictionary_id='53156.İlgi'></td>
			<td colspan="3"><cfoutput>#get_abolition.INTEREST#</cfoutput></td>
		</tr> 				
		<tr>
			<td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
			<td colspan="3"><cfoutput>#get_abolition.ABOLITION_DETAIL#</cfoutput></td>
		</tr> 
		<tr>
			<td colspan="4"></td>
		</tr> 				
		<tr>
			<td colspan="3">
				<cfset EMP_ID=get_abolition.MANAGER_ID>
				<cfif len(EMP_ID)>
					<cfinclude template="../query/get_action_emp.cfm">
					<cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
				<cfelse>
					<cfset emp_name="">
				</cfif>
				<cfoutput>#emp_name#<br/>#get_abolition.FROM_WHO#</cfoutput>
			</td>
		</tr> 			
	</table>
</cf_popup_box>
