<cfquery name="GET_ZONES_BRANCHES" datasource="#dsn#">
	SELECT 
		ZONE.ZONE_ID, 
		ZONE.ZONE_NAME,
		BRANCH.ZONE_ID,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME
		
	FROM 
		ZONE,
		BRANCH
	WHERE 
		BRANCH.ZONE_ID=ZONE.ZONE_ID
	<cfif isDefined("attributes.ZONE_ID")>
		AND
		ZONE.ZONE_ID = #attributes.ZONE_ID#
	</cfif>
</cfquery>
