<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getCompenentFunction">
		<cfquery name="getAssetCat_" datasource="#dsn#">
			SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE (ASSET_P_CAT.MOTORIZED_VEHICLE<>1) AND (ASSET_P_CAT.IT_ASSET <> 1) ORDER BY ASSETP_CAT
		</cfquery>
		<cfreturn getAssetCat_>
	</cffunction>
</cfcomponent>

