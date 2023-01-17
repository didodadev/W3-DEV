<!---E.A 17.07.2012 select ifadeleri düzenlenmeli--->
<cfquery name="GET_ASSETP_CATS_RESERVE" datasource="#dsn#">
	SELECT 
		 ASSETP_CATID,
		 ASSETP_CAT	
	 FROM 
	 	ASSET_P_CAT 
	WHERE	
		ASSETP_RESERVE = 1
</cfquery>

