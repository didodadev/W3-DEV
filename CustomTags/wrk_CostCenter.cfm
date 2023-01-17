<cfparam name="attributes.width" default="150">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.expense_id_fieldname" default="expense_center_id">
<cfparam name="attributes.expense_name_fieldname" default="expense_center_name">
<cfparam name="attributes.form_name" default="">
<cfparam name="attributes.expense_id_value" default="">
<cfif not fusebox.use_period>
	<cfparam name="attributes.data_source" default="#caller.dsn#">
<cfelse>
	<cfparam name="attributes.data_source" default="#caller.dsn2#">
</cfif>
<cfif len(attributes.expense_id_value)>
	<cfquery name="get_value" datasource="#attributes.data_source#">
		SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID=#attributes.expense_id_value#
	</cfquery>
</cfif>
<cfoutput>
	<input type="hidden" name="#attributes.expense_id_fieldname#" id="#attributes.expense_id_fieldname#" value="#attributes.expense_id_value#" />
	<input type="text" name="#attributes.expense_name_fieldname#" id="#attributes.expense_name_fieldname#" value="<cfif len(attributes.expense_id_value)>#get_value.expense#</cfif>" autocomplete="off" 
	onFocus="AutoComplete_Create('#attributes.expense_name_fieldname#','NAME,EXPENSE','NAME','get_cost_center_autocomplete','','EXPENSE_ID','#attributes.expense_id_fieldname#','#attributes.form_name#')" style="width:#attributes.width#px;">
	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_expense_center&field_name=#attributes.form_name#.#attributes.expense_name_fieldname#&field_id=#attributes.form_name#.#attributes.expense_id_fieldname#&is_invoice=1','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
</cfoutput>
