<cfquery name="GET_ASSETP_CATS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		ASSET_P_CAT
	WHERE
		ASSETP_CATID = #GET_ASSETP.ASSETP_CATID#
</cfquery>
