<cfquery name="GET_BANK_CONS" datasource="#dsn#">
	SELECT 
	* 
	FROM 
		CONSUMER_BANK
  		<cfif isDefined("URL.CID")>
	WHERE
		CONSUMER_ID = #URL.CID#
		<cfelseif isDefined("URL.BID")>
	WHERE 
		CONSUMER_BANK_ID = #URL.BID#
  		</cfif>
</cfquery>
