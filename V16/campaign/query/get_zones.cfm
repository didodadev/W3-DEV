<cfif isDefined("attributes.NAMES")>
	<cfquery name="ZONES" datasource="#DSN#">
		SELECT 
			ZONE_ID,
			ZONE_NAME,
			ADMIN1_POSITION_CODE,
			ADMIN2_POSITION_CODE
		FROM 
			ZONE
		<cfif isDefined("attributes.ZONE_ID")>
			<cfif len(attributes.ZONE_ID)>
		WHERE
			ZONE_ID = #attributes.ZONE_ID#
			AND
			ZONE_STATUS = 1
			</cfif>
		</cfif>
	</cfquery>
<cfelse>
	<cfquery name="ZONES" datasource="#DSN#">
		SELECT 
			* 
		FROM 
			ZONE
		<cfif isDefined("attributes.ZONE_ID")>
			<cfif len(attributes.ZONE_ID)>
		WHERE
			ZONE_ID = #attributes.ZONE_ID#
			AND
			ZONE_STATUS = 1
			</cfif>
		</cfif>
	</cfquery>
</cfif>
