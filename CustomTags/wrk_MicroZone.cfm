<cfparam name="attributes.width" default="150">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.ims_code_id_fieldname" default="ims_code_id">
<cfparam name="attributes.ims_code_name_fieldname" default="ims_code_name">
<cfparam name="attributes.form_name" default="">
<cfparam name="attributes.ims_code_id_value" default="">
<cfparam name="attributes.data_source" default="#caller.dsn#">

<cfif len(attributes.ims_code_id_value)>
	<cfquery name="get_value" datasource="#attributes.data_source#">
		SELECT * FROM SETUP_IMS_CODE WHERE IMS_CODE_ID=#attributes.ims_code_id_value#
	</cfquery>
</cfif>

<cfoutput>
	<input type="hidden" name="#attributes.ims_code_id_fieldname#" id="#attributes.ims_code_id_fieldname#" value="#attributes.ims_code_id_value#" />
	<input type="text" name="#attributes.ims_code_name_fieldname#" id="#attributes.ims_code_name_fieldname#" value="<cfif len(attributes.ims_code_id_value)>#get_value.IMS_CODE# #get_value.IMS_CODE_NAME#</cfif>" autocomplete="off" 
	onFocus="AutoComplete_Create('#attributes.ims_code_name_fieldname#','NAME,IMS_CODE,IMS_CODE_NAME','NAME','get_micro_zone_autocomplete','','IMS_CODE_ID','#attributes.ims_code_id_fieldname#','#attributes.form_name#')" <cfif len(attributes.class)>class="<cfoutput>#attributes.class#</cfoutput>"</cfif> style="width:#attributes.width#px;">
	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_ims_code&field_name=#attributes.form_name#.#attributes.ims_code_name_fieldname#&field_id=#attributes.form_name#.#attributes.ims_code_id_fieldname#','list','popup_list_ims_code');" tabindex="7"><img src="/images/plus_thin.gif" border="0" align="absmiddle" id="pos_code_3"></a>				
</cfoutput>






