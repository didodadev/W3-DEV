<cfquery name="GET_IT_ASSET_CAT_CLASS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		ASSET_P_CAT
	WHERE
		IT_ASSET = 1 AND
		ASSETP_CATID = #GET_IT_ASSETS.ASSETP_CATID#
</cfquery>
