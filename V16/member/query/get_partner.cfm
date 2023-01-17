<cfif not isDefined("url.brid")>
    <cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
			*
		FROM
			COMPANY_PARTNER CP, 
			COMPANY C
		WHERE 
		<cfif isDefined("attributes.partner_status") and Len(attributes.partner_status)>
			CP.COMPANY_PARTNER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_status#"> AND
		</cfif>
		<cfif isdefined("is_only_active_partners") and is_only_active_partners eq 1>
			CP.COMPANY_PARTNER_STATUS = 1 AND
		</cfif>
		<cfif isDefined("url.cpid")>
			CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cpid#"> AND 
			CP.COMPANY_ID = C.COMPANY_ID
		<cfelseif isDefined("url.pid")>
			CP.PARTNER_ID = #url.pid# AND
			CP.COMPANY_ID = C.COMPANY_ID
		</cfif>
		ORDER BY 
			CP.COMPANY_PARTNER_NAME
	</cfquery>
<cfelse>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME,
			PARTNER_ID,
			IMCAT_ID,
			IM,
			IMCAT2_ID,
			IM2
		FROM 
			COMPANY_PARTNER 
		WHERE 
			COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.brid#">
	</cfquery>
</cfif>
