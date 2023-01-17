<cfquery name="KASA" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		CASH
	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
	WHERE
		BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
	</cfif>  
	ORDER BY CASH_NAME
</cfquery>
