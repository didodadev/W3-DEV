<cfparam name="attributes.class" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.title_style" default="">
<cfparam name="attributes.right_images" default="">
<cfparam name="attributes.header" default="1">
<cfif not isdefined("caller.lang_array_main")>
	<cfset caller = caller.caller>
</cfif>
<cfoutput>
<cfif thisTag.executionMode eq "start">
    <table cellpadding="0" cellspacing="0" width="100%" height="100%" class="popup_box printThis_box">
		<tbody>
		<cfif isdefined("attributes.upper_file") and len(attributes.upper_file)><tr class="upper_file"><td height="10" colspan="2"><cfinclude template="#attributes.upper_file#"></td></tr></cfif>
        <cfif attributes.header eq 1>
            <tr class="popup_box_header">
                <td height="30"><span class="pageCaption font-green-sharp bold"><cfoutput>#attributes.title#</cfoutput></span></td>
                <td class="popup_butons" nowrap="nowrap"><cfoutput>#attributes.right_images#</cfoutput></td>
            </tr>      
        </cfif>
		<tr>
			<td valign="top" align="center" class="popup_box_body" colspan="2">
<cfelse>
     <cfif not isdefined("caller.popup_box_footer")>
		<cfif isdefined("caller.area_form_box_count")>
			</tr>
			</table>
		</cfif>
		</td>
		</tr>
		<tr class="footer">
			<td colspan="2"></td>
		</tr>
	</cfif>
		</tbody>
    </table>
</cfif>
</cfoutput>