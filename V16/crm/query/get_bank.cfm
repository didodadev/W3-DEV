<!--- get_bank.cfm --->
<cfquery name="GET_BANK" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY_BANK
		<cfif isDefined("URL.BID")>
	WHERE 
		COMPANY_BANK_ID = #URL.BID#
		<cfelse>
	WHERE 
		COMPANY_ID = #URL.CPID#
		</cfif>
</cfquery>
