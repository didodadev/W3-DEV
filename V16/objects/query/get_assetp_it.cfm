<cfquery name="GET_ASSETP_IT" datasource="#dsn#">
  SELECT 
	  * 
  FROM 
	  ASSETP_IT 
  WHERE
	  ASSETP_ID =#URL.ASSETP_ID#
</cfquery>
