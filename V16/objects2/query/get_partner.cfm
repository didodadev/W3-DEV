<cfif not isDefined("url.brid")>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT 
		*
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE
		CP.COMPANY_ID = C.COMPANY_ID AND
	<cfif isDefined("URL.CPID")>
		CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cpid#">
	<cfelseif isDefined("URL.PID")>
		CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.pid#">
	<cfelse>
		CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfif>
	</cfquery>
<cfelse>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME,
			PARTNER_ID 
		FROM 
			COMPANY_PARTNER 
		WHERE 
			COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.brid#">
	</cfquery>
</cfif>
