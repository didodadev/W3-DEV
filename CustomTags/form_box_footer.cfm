<cfoutput>
<cfif thisTag.executionMode eq "start">
   	<cfset caller.form_box_footer = 1>
	<cfif isdefined("caller.area_form_box_count") and caller.area_form_box_count gt 0>
		</tr>
		</table>
		<cfset caller.area_form_box_count = 0>
	</cfif>
	</td>
	</tr>
	<tr>
		<td style="border-top:1px solid ##C3C3C3;" colspan="2">
	</tr>
	<tr class="footer">
	<td colspan="2">
<cfelse>
	</div>
	</td>
	</tr>
</cfif>
</cfoutput>
