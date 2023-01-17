<!--- get_contract.cfm --->
<cfquery name="GET_CONTRACT" datasource="#dsn3#">
	SELECT 
		*
	FROM
		CONTRACT
	WHERE
		COMPANY LIKE '%,#URL.CPID#%,'
</cfquery>
