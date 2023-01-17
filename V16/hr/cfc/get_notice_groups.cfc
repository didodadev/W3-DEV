<cfcomponent>
	<cffunction name="get_notice_group" access="public" returntype="query">
		<cfquery name="get_notice_group_" datasource="#this.dsn#">
			SELECT
				NOTICE_CAT_ID,
				NOTICE
			FROM
				SETUP_NOTICE_GROUP
			ORDER BY
				NOTICE
		</cfquery>
		<cfreturn get_notice_group_>
	</cffunction>
</cfcomponent>
