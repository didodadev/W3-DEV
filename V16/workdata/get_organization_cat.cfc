<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
		<cfquery name="get_organization" datasource="#dsn#">
			SELECT
				ORGANIZATION_CAT_ID,
				ORGANIZATION_CAT_NAME,
				DETAIL
			FROM
				ORGANIZATION_CAT
		   ORDER BY 
		   		ORGANIZATION_CAT_NAME
		</cfquery>
		<cfreturn get_organization>
	</cffunction>
</cfcomponent>

