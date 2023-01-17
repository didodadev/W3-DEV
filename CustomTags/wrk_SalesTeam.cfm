<cfparam name="attributes.width" default="150">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.team_id_fieldname" default="team_id">
<cfparam name="attributes.team_name_fieldname" default="team_name">
<cfparam name="attributes.form_name" default="">
<cfparam name="attributes.team_id_value" default="">
<cfparam name="attributes.data_source" default="#caller.dsn#">

<cfif len(attributes.team_id_value)>
	<cfquery name="get_value" datasource="#attributes.data_source#">
		SELECT TEAM_NAME FROM SALES_ZONES_TEAM WHERE TEAM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id_value#">
	</cfquery>
</cfif>

<cfoutput>
	<input type="hidden" name="#attributes.team_id_fieldname#" id="#attributes.team_id_fieldname#" value="#attributes.team_id_value#" />
	<input type="text" name="#attributes.team_name_fieldname#" id="#attributes.team_name_fieldname#" value="<cfif len(attributes.team_id_value)>#get_value.team_name#</cfif>" autocomplete="off" 
	onFocus="AutoComplete_Create('#attributes.team_name_fieldname#','NAME,TEAM_NAME','NAME','get_sales_team_autocomplete','','TEAM_ID','#attributes.team_id_fieldname#','#attributes.form_name#')" style="width:#attributes.width#px;">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zones_team&field_sz_team_id=#attributes.form_name#.#attributes.team_id_fieldname#&field_sz_team_name=#attributes.form_name#.#attributes.team_name_fieldname#','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
</cfoutput>





