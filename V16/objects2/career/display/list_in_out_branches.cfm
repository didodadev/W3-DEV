<!--- Son işe alınanlar şube --->
<!--- TODO: Link düzenlenecek --->
<cfif isdefined("in_out_days")>
	<cfset attributes.in_out_days = in_out_days>
<cfelse>
	<cfset attributes.in_out_days = 15>
</cfif>

<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career_partner")>
<cfset get_in_out_branches = get_components.get_in_out_branches(in_out_days: attributes.in_out_days)>

<table width="100%">
	<tr>
		<td>
		<cfoutput query="get_in_out_branches">
			&nbsp;<img src="../objects2/image/arrow_green.gif" align="baseline" border="0" alt="<cf_get_lang_main no='41.Şube'> <cf_get_lang_main no='485.Adı'>" title="<cf_get_lang_main no='41.Şube'> <cf_get_lang_main no='485.Adı'>" />
			<a href="#attributes.update_path_url#?branch_id=#branch_id#" class="tableyazi">#BRANCH_NAME#</a>
			<br/>
		</cfoutput>
		</td>
	</tr>
</table>
