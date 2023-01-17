<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="form_box_#round(rand()*10000000)#">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.title_style" default="">
<cfparam name="attributes.width" default="99%">
<cfparam name="attributes.right_images" default="">
<cfparam name="attributes.nofooter" default="0">
<cfif not isdefined("caller.lang_array_main")>
	<cfset caller = caller.caller>
</cfif>
<cfoutput>
<cfif thisTag.executionMode eq "start">
   <cfif len(attributes.title)>
   <table cellpadding="0" cellspacing="0" align="center" width="100%<!---<cfoutput>#attributes.width#</cfoutput>--->">
   		<tr>
			<td height="40" class="form_box_header"><cfoutput>#attributes.title#</cfoutput></td>
			<td class="form_box_header"style="text-align:right;" nowrap="nowrap"><cfoutput>#attributes.right_images#</cfoutput></td>
		</tr>
   </table>
   </cfif>
   	<div align="center">
    <table cellpadding="0" cellspacing="0" id="<cfoutput>#attributes.id#</cfoutput>" class="form_box" align="left" width="100%<!---<cfoutput>#attributes.width#</cfoutput>--->">
		<tbody>
		<tr>
			<td valign="top" align="center" class="body" colspan="2">
<cfelse>
	<cfif isdefined("caller.area_form_box_count") and caller.area_form_box_count gt 0>
		</tr>
		</table>
		<cfset caller.area_form_box_count = 0>
	</cfif>
		 <cfif not isdefined("caller.form_box_footer")>
			</td>
			</tr>
			<cfif attributes.nofooter eq 0>
				<tr class="footer">
					<td colspan="2"></td>
				</tr>
			</cfif>
		</cfif>
		</tbody>
    </table>
    </div>
</cfif>
</cfoutput>
