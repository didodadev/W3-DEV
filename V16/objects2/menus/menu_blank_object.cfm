<cfif isdefined('attributes.is_menu_blank_height') and len(attributes.is_menu_blank_height)>
	<cfset menu_blank_height_ = #attributes.is_menu_blank_height#>
<cfelse>
	<cfset menu_blank_height_ = ''>
</cfif>
<table height="<cfoutput>#menu_blank_height_#</cfoutput>">
	<tr>
    	<td>&nbsp;</td>
    </tr>
</table>
