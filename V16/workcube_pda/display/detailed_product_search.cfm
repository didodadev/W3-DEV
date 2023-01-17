<cfparam name="attributes.mode" default="4">
<table>
	<tr style="height:35px;">
		<td class="headbold" align="center" colspan="4" style="vertical-align:top">Ürün Özelliklerine Göre Detaylı Arama</td>
	</tr>
	<cfoutput>
		<cfset a=0>
		<cfloop from="1" to="#get_property_var.recordcount#" index="row">
			<cfif ((a mod attributes.mode is 0)) or (a eq 0)>
				<tr id="frm_row#row#" style="height:25px; vertical-align:top">
			</cfif>
			<cfif get_property_var.property_id[row] neq get_property_var.property_id[row-1]>
				<td>
					<input type="hidden" name="row_kontrol#row#" id="row_kontrol#row#" value="1">
					<input type="hidden" name="property_id#row#" id="property_id#row#" value="#get_property_var.property_id[row]#">
					<select name="variation_id#row#" id="variation_id#row#">
						<option value="">#get_property_var.property[row]#</option>
						<cfloop from="#row#" to="#get_property_var.recordcount#" index="str">
							<cfif get_property_var.property_id[row] eq get_property_var.property_id[str]>
								<option value="#get_property_var.property_detail_id[str]#" <cfif (isdefined('attributes.list_variation_id') and listfind(attributes.list_variation_id,get_property_var.property_detail_id[str],',')) and (isdefined('attributes.list_property_id') and listfind(attributes.list_property_id,get_property_var.property_id[row],','))>selected</cfif>>&nbsp;&nbsp;&nbsp;#get_property_var.property_detail[str]#</option>
							<cfelse>
								<cfbreak>
							</cfif>
						</cfloop>
					</select>
					<cfset a=a+1>
				</td>
			</cfif>
			<cfif ((a mod attributes.mode eq 0)) or (a eq get_property_var.recordcount)></tr></cfif>
		</cfloop>
	</cfoutput>
</table> 
