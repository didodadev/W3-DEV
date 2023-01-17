<cfif isDefined("NAMES")>
	<cfquery name="BRANCHES" datasource="#DSN#">
		SELECT 
			BRANCH_ID, 
			BRANCH_NAME,
			ADMIN1_POSITION_CODE,
			ADMIN2_POSITION_CODE
		FROM 
			BRANCH
		<cfif isDefined("attributes.ZONE_ID")>
			<cfif len(attributes.ZONE_ID)>
			WHERE 
				ZONE_ID=#attributes.ZONE_ID#
				AND
				BRANCH_STATUS = 1
			</cfif>
		<cfelseif isDefined("attributes.BRANCH_ID")>
			<cfif LEN(attributes.BRANCH_ID)>
			WHERE 
				BRANCH_ID=#attributes.BRANCH_ID#
				AND
				BRANCH_STATUS = 1
			</cfif>
		</cfif>
	</cfquery>
<cfelse>
	<cfquery name="BRANCHES" datasource="#DSN#">
		SELECT * FROM BRANCH
		<cfif isDefined("attributes.ZONE_ID")>
			<cfif LEN(attributes.ZONE_ID)>
			WHERE 
				ZONE_ID=#attributes.ZONE_ID#
				AND
				BRANCH_STATUS = 1
			</cfif>
		<cfelseif isDefined("attributes.BRANCH_ID")>
			<cfif LEN(attributes.BRANCH_ID)>
			WHERE 
				BRANCH_ID=#attributes.BRANCH_ID#
				AND
				BRANCH_STATUS = 1
			</cfif>
		</cfif>
	</cfquery>
</cfif>
