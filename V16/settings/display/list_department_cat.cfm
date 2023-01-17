<cfset get_dep_cat = createObject("component","V16.settings.cfc.department_cat").listDepartmentCat()/>
<table>
	<cfif get_dep_cat.recordcount>
		<cfoutput query="get_dep_cat">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><a href="#request.self#?fuseaction=settings.add_department_cat&event=upd&cat_id=#DEPARTMENT_CAT_ID#">#DEPARTMENT_CAT#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>