<cfif isdefined("caller.area_form_box_count")>
	<cfset caller.area_form_box_count = caller.area_form_box_count + 1>
	<cfset this_area_form_box_count = caller.area_form_box_count>
<cfelse>
	<cfset caller.area_form_box_count = 1>
	<cfset this_area_form_box_count = 1>
</cfif>
<cfparam name="attributes.width" default="">
<cfoutput>
	<cfif thisTag.executionMode eq "start">
		<cfif this_area_form_box_count eq 1>
			<table width="100%" cellpadding="0" cellspacing="0" form_box_ic id="form_box_ic">
				<tr>
					<td valign="top" <cfif len(attributes.width)>width="#attributes.width#"</cfif>>
		<cfelse>
			<cfif isdefined("attributes.new_line")>
				</tr>
				</table>
				<table width="100%" cellpadding="0" cellspacing="0" id="form_box_ic">
				<tr>
				<td valign="top" style="border-top:1px solid ##d4d3d3;" <cfif len(attributes.width)>width="#attributes.width#"</cfif>>
			<cfelse>
				<td valign="top" style="border-left:1px solid ##d4d3d3; padding-left:10px;" <cfif len(attributes.width)>width="#attributes.width#"</cfif>>
			</cfif>
		</cfif>
	<cfelse>
		</td>
	</cfif>
</cfoutput>
