<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getCompenentFunction">
		<cfquery name="getAssetCat_" datasource="#dsn#">
			SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
		</cfquery>
		<cfreturn getAssetCat_>
	</cffunction>
</cfcomponent>

