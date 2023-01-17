<cffunction name="GET_CAMP_NAME">
	<cfargument name="camp_id" type="numeric">
	<cfif not len(camp_id)>
		<cfreturn "">
	</cfif>
	<cfquery name="GET_CAMP" datasource="#DSN3#">
		SELECT
			CAMP_HEAD
		FROM
			CAMPAIGNS 
		WHERE
			CAMP_ID = #camp_id#
	</cfquery>
	<cfif get_camp.recordcount>
		<cfreturn get_camp.camp_head>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>
