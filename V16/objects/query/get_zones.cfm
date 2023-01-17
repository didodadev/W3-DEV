<cfif isDefined("attributes.NAMES")>
	<cfquery name="ZONES" datasource="#dsn#">
		SELECT ZONE_ID,ZONE_NAME FROM ZONE
	</cfquery>
<cfelse>
	<cfquery name="ZONES" datasource="#dsn#">
		SELECT * FROM ZONE
	</cfquery>
</cfif>
