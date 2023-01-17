<cfquery name="GET_ASSETP_NAME" datasource="#dsn#">
	  SELECT 
		  ASSETP
	  FROM 
		  ASSET_P 
	  WHERE 
		  ASSETP_ID = #ATTRIBUTES.ASSETP_ID#
</cfquery>
