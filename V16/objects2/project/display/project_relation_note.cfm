<cfif isDefined('attributes.is_butons')>
	<cf_get_workcube_note company_id="#session.pp.our_company_id#" is_delete="0" style="1" action_section='PROJECT_ID' action_id='#attributes.project_id#' is_butons='#attributes.is_butons#'>
<cfelse>
	<cf_get_workcube_note company_id="#session.pp.our_company_id#" is_delete="0" style="1" action_section='PROJECT_ID' action_id='#attributes.project_id#'>
</cfif>
