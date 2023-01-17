<cfinclude template="../../config.cfm">
<cfset cmp1 = objectResolver.resolveByRequest("#addonNS#.components.common.asset") />
<cfset getRelationAsset = cmp1.getRelationAsset
	(action_id:attributes.demand_id,
	 action_section:"DEMAND_ID"
	) />

<cfloop query="getRelationAsset">
	<cf_del_server_file output_file="#getRelationAsset.ASSETCAT_PATH##dir_seperator##getRelationAsset.ASSET_FILE_NAME#" output_server="#getRelationAsset.ASSET_FILE_SERVER_ID#">
	<cfif IsNumeric(getRelationAsset.asset_id)>
		<cfset deleteAsset = cmp1.delAsset(asset_id:getRelationAsset.asset_id)>
	</cfif>
</cfloop>

<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.demands.demand") />
<cfset delDemand = cmp.delDemand(demand_id:attributes.demand_id)>

<cflocation url="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['del']['nextEvent']#" addtoken="no">