<cfparam name="attributes.mode" default="4">

		<cfoutput>
			<cfset a=0>
			<cfloop from="1" to="#get_property_var.recordcount#" index="row">
				<cfif get_property_var.property_id[row] neq get_property_var.property_id[row-1]>
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
					<input type="hidden" name="row_kontrol#row#" id="row_kontrol#row#" value="1">
					<input type="hidden" name="property_id#row#" id="property_id#row#" value="#get_property_var.property_id[row]#">
					<select name="variation_id#row#" id="variation_id#row#" style="width:150px;">
						<option value="">#get_property_var.property[row]#</option>
						<cfloop from="#row#" to="#get_property_var.recordcount#" index="str">
							<cfif get_property_var.property_id[row] eq get_property_var.property_id[str]>
								<option value="#get_property_var.property_detail_id[str]#" <cfif isDefined("attributes.variation_id#row#") and Evaluate("attributes.variation_id#row#") eq get_property_var.property_detail_id[str]>selected</cfif>>#get_property_var.property_detail[str]#</option>
							<cfelse>
								<cfbreak>
							</cfif>
						</cfloop>
					</select>
					<cfset a=a+1>
              	</div>  
				</cfif>
			</cfloop>
		</cfoutput>
