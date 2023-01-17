<!--- Son işe alınanlar --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career_partner")>

<cfif isdefined("in_out_days")>
	<cfset attributes.in_out_days = in_out_days>
<cfelse>
	<cfset attributes.in_out_days = 15>
</cfif>
<cfset get_in_out_branches = get_components.get_in_out_branches(in_out_days: attributes.in_out_days, branch_id: attributes.branch_id)>

<table class="table table-borderless">
	<tr class="main-bg-color">
		<td><cf_get_lang_main no='164.İşe Alınan'></td>
		<td><cf_get_lang dictionary_id='35449.Departman'></td>
		<td><cf_get_lang dictionary_id='57628.Giriş Tarihi'></td>
	</tr>
	<cfif get_in_out_branches.recordcount>
	<cfoutput query="get_in_out_branches">
	<tr>
		<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_show_cv_page&employee_id=#employee_id#','page')" class="tableyazi">#employee_name# #employee_surname#</a></td>
		<td>#department_head#</td>
		<td>#dateformat(start_date,'dd/mm/yyyy')#</td>
	</tr>
	</cfoutput>
	<cfelse>
	<tr>
		<td colspan="3"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
	</tr>
	</cfif>
</table>
