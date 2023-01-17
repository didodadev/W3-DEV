<cfif not isDefined("url.brid")>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
			*
		FROM 
			COMPANY_PARTNER CP, 
			COMPANY C
		WHERE 
			<cfif isDefined("URL.CPID")>
				CP.COMPANY_ID = #URL.CPID# 
				AND 
				CP.COMPANY_ID=C.COMPANY_ID
			<cfelse>
				CP.PARTNER_ID=#URL.PID# 
				AND
				CP.COMPANY_ID=C.COMPANY_ID
			</cfif>
		ORDER BY 
			CP.COMPANY_PARTNER_NAME
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
			COMPBRANCH_ID = #URL.BRID#
	</cfquery>
</cfif>
