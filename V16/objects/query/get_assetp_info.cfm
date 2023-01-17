<cfquery name="GET_ASSET" datasource="#dsn#">
	  SELECT 
		  * 
	  FROM 
		  ASSET_P 
	  WHERE 
		  ASSETP_ID =#URL.ASSETP_ID#
</cfquery>
