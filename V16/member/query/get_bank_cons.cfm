<cfquery name="GET_BANK_CONS" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		CONSUMER_BANK
	WHERE
		1=1
	<cfif isDefined("url.bid")>
		AND CONSUMER_BANK_ID = #url.bid#
  	<cfelseif isDefined("url.cid")>
		AND CONSUMER_ID = #url.cid#
  	</cfif>
</cfquery>
