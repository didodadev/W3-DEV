<table width="100%" border="0" cellspacing="0" cellpadding="0" style="height:100%;">
	<cfif not findnocase('popup',fusebox.fuseaction) and not isdefined("attributes.ajax")> 
		<cfif (session.ep.design_id eq 5) and (session.ep.menu_id)>			
			<cfinclude template="/design/ozel_sub_tr.cfm">		
		<cfelse> 
			<cfif isdefined('use_standalone') and use_standalone eq 0>
				<tr><td style="height:27px;"><cfinclude template="dev_tr.cfm"></td></tr> 
			</cfif>
		</cfif>
	</cfif> 
	<tr><td valign="top"><cfif not isdefined("attributes.ajax")><cfoutput><div id="#fusebox.circuit#" style="height:100%;"><!-- sil -->#fusebox.layout#<!-- sil --></div></cfoutput><cfelse><cfoutput>#fusebox.layout#</cfoutput></cfif></td></tr>
</table>
