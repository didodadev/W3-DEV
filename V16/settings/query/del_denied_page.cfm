<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfif isdefined("attributes.deny_page") and  len(attributes.deny_page)>
		<cfquery name="delete_denied" datasource="#DSN#">
			DELETE FROM EMPLOYEE_POSITIONS_DENIED WHERE DENIED_PAGE = '#attributes.deny_page#'
		</cfquery>
	<cfelseif isdefined("attributes.denied_page_id") and len(attributes.denied_page_id)>
		<cfquery name="delete_denied" datasource="#DSN#">
			DELETE FROM EMPLOYEE_POSITIONS_DENIED WHERE DENIED_PAGE_ID = #attributes.denied_page_id#
		</cfquery>	
	</cfif>
	<cf_add_log  log_type="-1" action_id="#attributes.denied_page_id#" action_name="#attributes.deny_page#">
	</cftransaction>
</cflock>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.denied_pages">
