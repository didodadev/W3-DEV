<cfif isdefined("attributes.pid")>
	<cfquery name="GET_BRANCH" datasource="#dsn#">
		SELECT 
			B.COMPBRANCH_ID, 
			B.ZONE_ID, 
			B.COMPBRANCH__NAME, 
			B.COMPBRANCH_STATUS, 
			B.COMPBRANCH__NICKNAME
		FROM 
			COMPANY_BRANCH B, 
			COMPANY_PARTNER CP
		WHERE 
			CP.COMPANY_ID = B.COMPANY_ID 
			AND
			CP.PARTNER_ID = #attributes.PID#			
		ORDER BY
			B.COMPBRANCH__NAME 
	</cfquery>
<cfelse>
	<cfquery name="GET_BRANCH" datasource="#dsn#">
		SELECT 
			BRANCH_ID, 
			ZONE_ID, 
			BRANCH_NAME
		FROM 
			BRANCH
		<cfif isDefined("URL.ZONE")>
		WHERE 
			ZONE_ID=#URL.ZONE#
		</cfif>
	</cfquery>
</cfif>
