<cfquery name="BRANCHES" datasource="#DSN#">
	SELECT 
		<cfif isDefined("NAMES")>
		BRANCH_ID, 
		BRANCH_NAME,
		ADMIN1_POSITION_CODE,
		ADMIN2_POSITION_CODE
		<cfelse>
		*
		</cfif>
	FROM 
		BRANCH
	WHERE
		BRANCH_STATUS = 1
	<cfif not session.ep.ehesap>
		AND
		BRANCH.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE = #SESSION.EP.POSITION_CODE#
							)
	</cfif>
	<cfif isDefined("attributes.ZONE_ID") and len(attributes.ZONE_ID)>
		AND
		ZONE_ID=#attributes.ZONE_ID#
	<cfelseif isDefined("attributes.BRANCH_ID") and LEN(attributes.BRANCH_ID)>
		AND
		BRANCH_ID=#attributes.BRANCH_ID#
	</cfif>
</cfquery>
