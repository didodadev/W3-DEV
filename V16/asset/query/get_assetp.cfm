<cfquery name="GET_ASSETP" datasource="#dsn#">
	SELECT 
		ASSET_P.*,			
		ASSET_P_CAT.ASSETP_CAT,
		ASSET_P_CAT.ASSETP_CATID,
		R.*
	FROM 
		ASSET_P
		LEFT JOIN ASSET_P_RENT R ON R.ASSETP_ID = ASSET_P.ASSETP_ID,
		ASSET_P_CAT
	WHERE
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
		AND
		ASSET_P.ASSETP_ID = #URL.ASSETP_ID#
</cfquery>