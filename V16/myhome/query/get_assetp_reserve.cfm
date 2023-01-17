<cfquery name="GET_ASSETP_RESERVE" datasource="#dsn#">
	SELECT 
		ASSET_P.ASSETP_ID,
		ASSET_P_RESERVE.ASSETP_ID,
		ASSET_P_RESERVE.ASSETP_RESID,
		ASSET_P_RESERVE.EVENT_ID,
		ASSET_P_RESERVE.STARTDATE,
		ASSET_P_RESERVE.FINISHDATE,
		ASSET_P_RESERVE.UPDATE_EMP
	FROM 
		ASSET_P,
		ASSET_P_RESERVE
	WHERE
		<cfif isDefined("attributes.ASSETP_RESID")>
		ASSET_P_RESERVE.ASSETP_RESID = #attributes.ASSETP_RESID#
		AND
		</cfif>
		ASSET_P.ASSETP_ID = #attributes.ASSETP_ID#
		AND
		ASSET_P.ASSETP_ID = ASSET_P_RESERVE.ASSETP_ID
</cfquery>
