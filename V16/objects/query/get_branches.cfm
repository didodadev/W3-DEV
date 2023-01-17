<cfif isDefined("NAMES")>
	<cfquery name="BRANCHES" datasource="#dsn#">
		SELECT 
			BRANCH_ID, 
			BRANCH_NAME 
		FROM 
			BRANCH
		<cfif isDefined("attributes.ZONE_ID")>
			WHERE ZONE_ID=#attributes.ZONE_ID#
		</cfif>
	</cfquery>
<cfelse>
	<cfquery name="BRANCHES" datasource="#dsn#">
		SELECT * FROM BRANCH
		<cfif isDefined("attributes.ZONE_ID")>
			WHERE ZONE_ID=#attributes.ZONE_ID#
		</cfif>
	</cfquery>
</cfif>
