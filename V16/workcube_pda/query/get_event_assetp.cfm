<cfquery name="EVENT_ASSETP" datasource="#dsn#">
	SELECT 
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P_RESERVE.ASSETP_RESID,
		ASSET_P_RESERVE.STARTDATE,
		ASSET_P_RESERVE.FINISHDATE
	FROM 
		ASSET_P,
		ASSET_P_RESERVE
	WHERE
		ASSET_P_RESERVE.EVENT_ID = #attributes.EVENT_ID# AND
		ASSET_P_RESERVE.ASSETP_ID = ASSET_P.ASSETP_ID
</cfquery>
