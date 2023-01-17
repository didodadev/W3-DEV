<cfquery name="SETUP_TEMPLATE" datasource="#DSN#">
	SELECT 
		TEMPLATE_CONTENT
	FROM
		TEMPLATE_FORMS
	<cfif isDefined("attributes.template_id") and len(attributes.template_id)>		
	WHERE
		TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.template_id#">
	</cfif>
</cfquery>
