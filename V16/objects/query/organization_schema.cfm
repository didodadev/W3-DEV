<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >  
<cfinclude template="../../objects/display/tree_back.cfm">
<td <cfoutput>#td_back#</cfoutput>> 
      <cfinclude template="tree_org.cfm"></td>
    <td class="headbold" valign="top">
	<iframe src="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_disp_organization_schema&iframe=1" width="100%" height="100%" frameborder="0" scrolling="auto">
</iframe> </td>
</tr>
</table>
