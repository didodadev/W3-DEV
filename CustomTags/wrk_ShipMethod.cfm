<cfparam name="attributes.width" default="150">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.ship_method_id_fieldname" default="ship_method_id">
<cfparam name="attributes.ship_method_name_fieldname" default="ship_method_name">
<cfparam name="attributes.form_name" default="">
<cfparam name="attributes.ship_method_id_value" default="">
<cfparam name="attributes.data_source" default="#caller.dsn#">

<cfif len(attributes.ship_method_id_value)>
	<cfquery name="get_value" datasource="#attributes.data_source#">
		SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID=#attributes.ship_method_id_value#
	</cfquery>
</cfif>

<cfoutput>
	<input type="hidden" name="#attributes.ship_method_id_fieldname#" id="#attributes.ship_method_id_fieldname#" value="#attributes.ship_method_id_value#" />
	<input type="text" name="#attributes.ship_method_name_fieldname#" id="#attributes.ship_method_name_fieldname#" value="<cfif len(attributes.ship_method_id_value)>#get_value.SHIP_METHOD#</cfif>" autocomplete="off" 
	onFocus="AutoComplete_Create('#attributes.ship_method_name_fieldname#','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','#attributes.ship_method_id_fieldname#','#attributes.form_name#')" style="width:#attributes.width#px;">
	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_ship_methods&field_id=#attributes.form_name#.#attributes.ship_method_id_fieldname#&field_name=#attributes.form_name#.#attributes.ship_method_name_fieldname#','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
</cfoutput>

