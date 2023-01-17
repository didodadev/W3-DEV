<cfsetting showdebugoutput="no">
<cfif len(attributes.product_id)>
	<cfquery name="get_spec_image" datasource="#dsn3#" maxrows="1">
		SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID = #attributes.product_id#
	</cfquery>
	<cfif get_spec_image.recordcount>
		<cf_get_server_file output_file="product/#get_spec_image.path#" title="#get_spec_image.detail#" output_server="#get_spec_image.path_server_id#" output_type="0" image_width="150" image_height="150" image_link="0">
	</cfif>
</cfif>
