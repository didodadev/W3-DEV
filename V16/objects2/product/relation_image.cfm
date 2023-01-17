<cfif isdefined("attributes.product_id")>
	<cfset attributes.pid = attributes.product_id>
</cfif>
<cfif isdefined("attributes.product_image_width") and len(attributes.product_image_width) and attributes.product_image_width neq 0>
	<cfset product_image_width = #attributes.product_image_width#>
<cfelse>
	<cfset product_image_width = ''>
</cfif>
<cfif isdefined("attributes.product_image_height") and len(attributes.product_image_height) and attributes.product_image_height neq 0>
	<cfset product_image_height = #attributes.product_image_height#>
<cfelse>
	<cfset product_image_height = ''>
</cfif>
<cfif isdefined("attributes.product_image_maxrows") and len(attributes.product_image_maxrows)>
	<cfset product_maxrows = #attributes.product_image_maxrows#>
<cfelse>
	<cfset product_maxrows = 5>
</cfif>
<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#" maxrows="#product_maxrows#">
	SELECT 
		* 
	FROM 
		PRODUCT_IMAGES 
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		<cfif isdefined("attributes.product_image_size") and attributes.product_image_size eq 0>
			AND IMAGE_SIZE = 0
		<cfelseif isdefined("attributes.product_image_size") and attributes.product_image_size eq 1>
			AND IMAGE_SIZE = 1
		<cfelseif isdefined("attributes.product_image_size") and  attributes.product_image_size eq 2>
			AND IMAGE_SIZE = 2
		</cfif>
	ORDER BY 
		UPDATE_DATE
</cfquery>
<cfif GET_PRODUCT_IMAGES.recordcount>
	<cfif attributes.product_image_view eq 1>
		<table width="100%"> 
		<cfoutput query="get_product_images">
			<tr> 
				<cfif isdefined("attributes.product_image_id") and attributes.product_image_id eq 1>
					<td align="center">
						<cfset small_image_server = listgetat(fusebox.server_machine_list,get_product_images.path_server_id,';')>
						<a href="javascript://" onClick="windowopen('#file_web_path#product/#path#','medium');">
							<cfif len(product_image_width) or len(product_image_height)>
                            	<cf_get_server_file output_file="product/#get_product_images.path#" title="#get_product_images.detail#" alt="#get_product_images.detail#" output_server="#path_server_id#" output_type="0" image_width="#product_image_width#" image_height="#product_image_height#"><br />
                            <cfelse>
                            	<cf_get_server_file output_file="product/#get_product_images.path#" title="#get_product_images.detail#" alt="#get_product_images.detail#" output_server="#path_server_id#" output_type="0"><br />
                            </cfif>
						</a>
					</td>
				</cfif>
			 </tr>
			<cfif isdefined("attributes.product_image_name") and attributes.product_image_name eq 1>
				<tr>
					<td align="center">
						<a href="javascript://" onClick="windowopen('#file_web_path#product/#path#','medium');" class="tableyazi">#Detail#</a><br/>
					</td>
				</tr>
			</cfif>
			<cfif get_product_images.recordcount neq currentrow>
				<tr>
					<td colspan="2"><hr style="height:0.3px; color:cccccc"></td>
				</tr>
			</cfif>
		</cfoutput>	 
		</table>
	<cfelse>
		<cfset my_prod_this_row = 0>
		<table width="100%">
			 <cfoutput query="get_product_images">
			 <cfset my_prod_this_row = my_prod_this_row + 1>
			 <cfif my_prod_this_row mod attributes.prod_image_mode eq 1><tr></cfif>
			 <cfset my_prod_width_ = 100/attributes.prod_image_mode>
				<td valign="top" width="#my_prod_width_#%" align="center">
					<cfif isdefined("attributes.product_image_id") and attributes.product_image_id eq 1>
						<cfset small_image_server = listgetat(fusebox.server_machine_list,get_product_images.path_server_id,';')>
						<a href="javascript://" onClick="windowopen('#file_web_path#product/#path#','medium');">
							<cfif len(product_image_width) or len(product_image_height)>
								<cf_get_server_file output_file="product/#get_product_images.path#" title="#get_product_images.detail#" alt="#get_product_images.detail#" output_server="#path_server_id#" output_type="0" image_width="#product_image_width#" image_height="#product_image_height#"><br /><br />
							<cfelse>
								<cf_get_server_file output_file="product/#get_product_images.path#" title="#get_product_images.detail#" alt="#get_product_images.detail#" output_server="#path_server_id#" output_type="0"><br /><br />
							</cfif>
						</a>
					</cfif>
					<cfif isdefined("attributes.product_image_name") and attributes.product_image_name eq 1>
						<a href="javascript://" onClick="windowopen('#file_web_path#product/#path#','medium');" class="tableyazi">#Detail#</a><br/>
					</cfif>
				</td>
			  <cfif my_prod_this_row mod attributes.prod_image_mode eq 0></tr></cfif>
			  </cfoutput>
		</table>
	</cfif>
</cfif>
