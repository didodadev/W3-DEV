<cfif attributes.type eq "brand"><!--- Ürün kategorilerinden Eklenmişse --->
	<cfset table = "PRODUCT_BRANDS_IMAGES">
    <cfset identity_column = "BRAND_IMAGEID">
<cfelseif attributes.type eq "product"><!--- Ürün den eklenmişse --->
	<cfset table = "PRODUCT_IMAGES">
    <cfset identity_column = "PRODUCT_IMAGEID">
<cfelseif attributes.type eq "sample"><!--- Ürün den eklenmişse --->
	<cfset table = "PRODUCT_SAMPLE_IMAGE">
    <cfset identity_column = "PRODUCT_SAMPLE_IMAGE_ID">
</cfif>
<cf_box id="#getlang('','Sil','57463')#" title="#getLang('','',29408)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfif isDefined("url.imid")>
	<cfif attributes.type eq "brand" or attributes.type eq "product">
		<cfquery name="GET_PRODUCT" datasource="#DSN1#">
			SELECT PATH,PATH_SERVER_ID FROM #table# WHERE #identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.imid#">
		</cfquery>
		<cfif get_product.recordcount>
			<cfif FileExists("#upload_folder#product#dir_seperator##get_product.path#")>
				<cf_del_server_file output_file="product/#get_product.path#" output_server="#get_product.path_server_id#">
			</cfif>
			<cfquery name="DEL_IMAGE" datasource="#DSN1#">
				DELETE FROM #table# WHERE #identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.imid#">
			</cfquery>
		</cfif>
		<cfelseif attributes.type eq "sample" >
			<cfquery name="GET_PRODUCT_SAMPLE" datasource="#DSN3#">
				SELECT PRODUCT_SAMPLE_FILE_NAME,IMAGE_SERVER_ID FROM #table# WHERE #identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.imid#">
			</cfquery>
			<cfif GET_PRODUCT_SAMPLE.recordcount>
				<cfif FileExists("#upload_folder#sample#dir_seperator##GET_PRODUCT_SAMPLE.PRODUCT_SAMPLE_FILE_NAME#")>
					<cf_del_server_file output_file="sample/#GET_PRODUCT_SAMPLE.PRODUCT_SAMPLE_FILE_NAME#" output_server="#GET_PRODUCT_SAMPLE.IMAGE_SERVER_ID#">
				</cfif>
				<cfquery name="DEL_IMAGE" datasource="#DSN3#">
					DELETE FROM #table# WHERE #identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.imid#">
				</cfquery>
			</cfif>
		</cfif>
</cfif>
</cf_box>
<script type="text/javascript">
  closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_imgs_get');
</script>
