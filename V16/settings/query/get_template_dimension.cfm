<cfquery name="GET_TEMPLATE_DIMENSION" datasource="#DSN#">
	SELECT
		 *
	FROM
		 SETUP_TEMPLATE_DIMENSION
	<cfif isDefined("attributes.type")>
		WHERE
			 TEMPLATE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type#">
	</cfif>	 
</cfquery>
