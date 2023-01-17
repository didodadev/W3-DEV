<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getCompenentFunction">
		<cfargument  name="it_asset" default=""><!---it_asset 0  ve 1 olma durumuna göre varlıkların gelmesi için --->
		<cfargument  name="is_motorized" default="">
		<cfquery name="getAssetCat_" datasource="#dsn#">
			SELECT 
				ASSETP_CATID, 
				ASSETP_CAT 
			FROM 
				ASSET_P_CAT 
			WHERE 
				<cfif isdefined("arguments.it_asset") and len(arguments.it_asset) and arguments.it_asset eq 1>
					IT_ASSET = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				<cfelse> 
					IT_ASSET = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				</cfif>
				<cfif isdefined("arguments.is_motorized") and len(arguments.is_motorized) and arguments.is_motorized eq 1>
					AND MOTORIZED_VEHICLE = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
				<cfelse> 
					AND MOTORIZED_VEHICLE = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				</cfif>
			ORDER BY 
				ASSETP_CAT
		</cfquery>
		<cfreturn getAssetCat_>
	</cffunction>
</cfcomponent>

