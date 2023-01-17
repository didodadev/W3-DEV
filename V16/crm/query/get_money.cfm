<!--- get_money.cfm --->
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
