<!--- Unıon blogu yazılma amacı il ve ilce bilgilerinin bos olmasi durumu dusunulerek eklendi BK --->
<cfif isdefined("attributes.pid")>
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT 
			B.COMPBRANCH_ID, 
			B.COMPBRANCH__NAME 
		FROM 
			COMPANY_BRANCH B, 
			COMPANY_PARTNER CP
		WHERE 
			CP.COMPANY_ID = B.COMPANY_ID AND
			CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		ORDER BY
			B.COMPBRANCH__NAME 
	</cfquery>
<cfelse>
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT 
			BRANCH_ID, 
			ZONE_ID, 
			BRANCH_NAME
		FROM 
			BRANCH
		<cfif isDefined("URL.ZONE")>
		WHERE 
			ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ZONE#">
		</cfif>
	</cfquery>
</cfif>
