<cfparam name="attributes.width" default="150">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.workgroup_id_fieldname" default="workgroup_id">
<cfparam name="attributes.workgroup_name_fieldname" default="workgroup_name">
<cfparam name="attributes.form_name" default="">
<cfparam name="attributes.workgroup_id_value" default="">
<cfparam name="attributes.data_source" default="#caller.dsn#">

<cfif len(attributes.workgroup_id_value)>
	<cfquery name="get_value" datasource="#attributes.data_source#">
		SELECT WORKGROUP_NAME FROM WORK_GROUP WHERE WORKGROUP_ID=#attributes.workgroup_id_value#
	</cfquery>
</cfif>

<cfoutput>
	<input type="hidden" name="#attributes.workgroup_id_fieldname#" id="#attributes.workgroup_id_fieldname#" value="#attributes.workgroup_id_value#" />
	<input type="text" name="#attributes.workgroup_name_fieldname#" id="#attributes.workgroup_name_fieldname#" value="<cfif len(attributes.workgroup_id_value)>#get_value.WORKGROUP_NAME#</cfif>" autocomplete="off" 
	onFocus="AutoComplete_Create('#attributes.workgroup_name_fieldname#','NAME,WORKGROUP_NAME','NAME','get_budget_workgroup_autocomplete','','WORKGROUP_ID','#attributes.workgroup_id_fieldname#','#attributes.form_name#')" style="width:#attributes.width#px;">
	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_workgroup&field_name=#attributes.form_name#.#attributes.workgroup_name_fieldname#&field_id=#attributes.form_name#.#attributes.workgroup_id_fieldname#&select_list=2','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
</cfoutput>
