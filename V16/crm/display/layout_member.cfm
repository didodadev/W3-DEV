<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="height:100%;">
<cfif (not fusebox.fuseaction contains "popup") and (not isDefined('attributes.popup_for_files'))> 
		<cfif (session.ep.design_id eq 5) and (session.ep.menu_id)>			
				<cfinclude template="/design/ozel_sub_tr.cfm">		
		<cfelse> 
			<tr>
				<td style="height:25px;"><cfinclude template="member_tr.cfm"></td>
			</tr> 
		</cfif>
</cfif> 
  <tr><td valign="top"><cfoutput><div id="#fusebox.circuit#" style="height:100%;"><!-- sil -->#fusebox.layout#<!-- sil --></div></cfoutput></td></tr>  
</table>
