<cfparam name="attributes.width" default="150">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.shelf_id_fieldname" default="shelf_id">
<cfparam name="attributes.shelf_name_fieldname" default="shelf_name">
<cfparam name="attributes.store_id" default="">
<cfparam name="attributes.form_name" default="">
<cfparam name="attributes.shelf_id_value" default="">
<cfparam name="attributes.shelf_name_value" default="">
<cfoutput>
	<input type="hidden" name="#attributes.shelf_id_fieldname#" id="#attributes.shelf_id_fieldname#" value="#attributes.shelf_id_value#" />
	<input type="text" name="#attributes.shelf_name_fieldname#" id="#attributes.shelf_name_fieldname#" value="#attributes.shelf_name_value#" autocomplete="off" 
	onFocus="AutoComplete_Create('#attributes.shelf_name_fieldname#','NAME,SHELF_NAME,SHELF_CODE','NAME','get_shelf_autocomplete','12','SHELF_ID','#attributes.shelf_id_fieldname#','#attributes.form_name#')" style="width:#attributes.width#px;">
	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_shelves&is_array_type=0&row_id=&form_name=#attributes.form_name#&row_count=1&field_code=#attributes.shelf_name_fieldname#&field_id=#attributes.shelf_id_fieldname#','small','shelf_list_page');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
</cfoutput>

