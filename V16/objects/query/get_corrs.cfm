<cfquery name="SETUP_TEMPLATE" datasource="#dsn#">
	SELECT * FROM TEMPLATE_FORMS
	<cfif isDefined("attributes.template_id") and len(attributes.template_id)>		
	WHERE
		TEMPLATE_ID = #attributes.template_id#
	</cfif>
</cfquery>
