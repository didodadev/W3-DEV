<cfquery name="GET_ASSETPS" datasource="#dsn#">
	SELECT 
		ASSET_P.*,
		ASSET_P_CAT.ASSETP_CAT,
		ASSET_P_CAT.ASSETP_CATID
	FROM 
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
	<cfif isDefined("attributes.ASSET_CAT") and len(attributes.ASSET_CAT)>
	   AND
		ASSET_P.ASSETP_CATID = #attributes.ASSET_CAT#
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
	   AND
		ASSET_P.ASSETP LIKE '%#attributes.KEYWORD#%'
	</cfif>
</cfquery>
