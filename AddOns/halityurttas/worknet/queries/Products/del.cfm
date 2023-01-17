<cfinclude template="../../config.cfm">
<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.products.product") />
<cfset getProductImage = cmp.getProductImage(product_id:attributes.pid)>

<cfloop query="getproductImage">
	<cf_del_server_file output_file="product#dir_seperator##getProductImage.path#" output_server="#getProductImage.path_server_id#">
</cfloop>

<cfset cmpasset = objectResolver.resolveByRequest("#addonNS#.components.Common.asset")>
<cfset getRelationAsset = cmpasset.getRelationAsset
	(action_id:attributes.pid,
	 action_section:"WORKNET_PRODUCT_ID"
    ) />
    
<cfloop query="getRelationAsset">
    <cf_del_server_file output_file="#getRelationAsset.ASSETCAT_PATH##dir_seperator##getRelationAsset.ASSET_FILE_NAME#" output_server="#getRelationAsset.ASSET_FILE_SERVER_ID#">
    <cfif IsNumeric(getRelationAsset.asset_id)>
        <cfset deleteAsset = cmpasset.delAsset(asset_id:getRelationAsset.asset_id)>
    </cfif>
</cfloop>

<cfset deleteImageDb = cmp.delProductImage(product_id:attributes.pid)>
<cfset deleteProduct = cmp.delProduct(product_id:attributes.pid)>
<cflocation url="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['del']['nextEvent']#" addtoken="no">