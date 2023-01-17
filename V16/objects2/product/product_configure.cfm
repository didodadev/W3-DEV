<cfinclude template="../query/get_product_config.cfm">
<cfif not isdefined("attributes.product_configurator_id")>
	<table style="width:100%; text-align:center">
		<cfform name="product_configuration" action="#request.self#?fuseaction=objects2.product_configure" method="post">
		<input type="hidden" name="submit_type" id="submit_type" value="0">
			<!--- <tr>
				<td colspan="2" class="headbold" height="30"><cf_get_lang no='405.Konfigürasyon Seçenekleri'></td>
			</tr> --->
			<cfoutput query="get_setup_product_configurator"> 
				<tr>
					<td style="vertical-align:top; width:60px;">
						<cf_get_server_file output_file="product/#configurator_image#" output_server="#configurator_server_image_id#" output_type="0" image_link="5" alt="#getLang('main',668)#" title="#getLang('main',668)#">
			    </td>
					<td style="vertical-align:top;">
						<a href="#request.self#?fuseaction=objects2.view_product_configure&submit_type=1&product_configurator_id=#product_configurator_id#" class="formbold">#configurator_name#</a>
						<br/><br/>
						#configurator_detail#
			      <br/><br />
						<a href="#request.self#?fuseaction=objects2.view_product_configure&submit_type=1&product_configurator_id=#product_configurator_id#" class="tableyazi">> <cf_get_lang no='406.Konfigüre etmek için tıklayınız'>.</a>
					</td>
			  	</tr>
			  	<cfif recordcount neq currentrow>
				  	<tr>
						<td colspan="2"><hr></td>
					</tr>
				</cfif>
			</cfoutput> 
		</cfform>
	</table>
<cfelse>
	<cfinclude template="product_configure_step2.cfm">
</cfif>


