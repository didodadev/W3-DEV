<!--mail için hazır şablonu getiriyor-->
<cfquery name="GET_TEMPLATE_FORMS" datasource="#dsn#">
	SELECT * FROM TEMPLATE_FORMS
	<cfif isDefined("attributes.TEMPLATE_ID")>		
	WHERE
		TEMPLATE_ID = #attributes.TEMPLATE_ID#
	</cfif>			
</cfquery>

