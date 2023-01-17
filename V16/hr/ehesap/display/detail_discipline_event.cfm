<cfsetting showdebugoutput="no">
<cfinclude template="../../../objects/display/view_company_logo.cfm">
<cfinclude template="../query/get_discipline_event.cfm">
<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
	<tr>
		<td>
		<table cellspacing="1" cellpadding="2" border="0"  height="100%" width="100%">
		   <tr>
			   <td height="35">
			   <table cellpadding="0" cellspacing="0" width="100%">
					<tr  valign="middle">
						 <td height="35" class="headbold" align="center"><cf_get_lang dictionary_id="57591.Olay tutanağı"></td> 
					</tr>
				</table>
				</td>
			</tr>
			<tr valign="top">
				<td>
				<table  border="0" width="98%" bordercolor="000000" cellspacing="0" align="center">
					<tr>
						<td width="1">&nbsp;</td>
						<td width="70" class="txtbold"><cf_get_lang dictionary_id="53088.Olay Türü"></td>
						<td colspan="2"><cfoutput>#get_event.EVENT_TYPE#</cfoutput></td>
					</tr>			  
					<tr>
						<td>&nbsp;</td>
						<td class="txtbold"><cf_get_lang dictionary_id="57574.Şirket"></td>
						<td colspan="2"><cfset my_comp_branch_id=get_event.EVENT_ID>
							<cfinclude template="../query/get_our_comp_and_branch_name.cfm">
							<cfoutput>#get_com_branch.NICK_NAME#</cfoutput>
						</td>	
					 </tr>
					 <tr>
					 	<td>&nbsp;</td>
						<td valign="top" class="txtbold"><cf_get_lang dictionary_id="59067.Açıklama"></td>
						<td colspan="2"><cfoutput>#get_event.DETAIL#</cfoutput><br/><br/></td>
					</tr>
				</table><br/>
				<table  border="0" width="98%" align="center">
					<tr>
						<td width="1%">&nbsp;</td>
						<td width="30%" class="txtbold"><cf_get_lang dictionary_id="53325.TANIK"></td>
						<td width="30%" class="txtbold"><cf_get_lang dictionary_id="53325.TANIK"></td>
						<td width="37%" class="txtbold"><cf_get_lang dictionary_id="53325.TANIK"></td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><cfset EMP_ID=get_event.WITNESS_1>
							<cfif len(EMP_ID)>
								<cfinclude template="../query/get_action_emp.cfm">
								<cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
							<cfelse>
								<cfset emp_name="">
							</cfif> 				  
							<cfoutput>#emp_name#</cfoutput>
						</td>
						<td><cfset EMP_ID=get_event.WITNESS_2>
							<cfif len(EMP_ID)>
								<cfinclude template="../query/get_action_emp.cfm">
								<cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
							<cfelse>
								<cfset emp_name="">
							</cfif> 				  
							<cfoutput>#emp_name#</cfoutput>
						</td>
						<td><cfset EMP_ID=get_event.WITNESS_3>
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
				<table border="0" width="98%" height="68%" align="center">
					<tr>
						<td width="100" valign="bottom"><cfinclude template="../../../objects/display/view_company_info_company.cfm"></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
 <script type="text/javascript">
 	function waitfor(){
		window.close();
	}
	setTimeout("waitfor()",3000);
	window.print();
</script>
