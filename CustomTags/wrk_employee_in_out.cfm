<cfparam name="attributes.width" default="150">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.emp_id_fieldname" default="employee_id">
<cfparam name="attributes.in_out_id_fieldname" default="in_out_id">
<cfparam name="attributes.emp_name_fieldname" default="employee_name">
<cfparam name="attributes.form_name">
<cfparam name="attributes.emp_id_value" default="">
<cfparam name="attributes.in_out_value" default="">
<cfparam name="attributes.call_function" default="">
<cfparam name="attributes.getLang" default="#caller.getLang('Çalışanlar','',58875)#">
<cfparam name="attributes.is_shift" default="0">
<cfparam name="attributes.is_dep_power_control" default="0">
<cfset dsn = caller.dsn>
<div class="input-group">
	<cfoutput>
        <input type="hidden" id="#attributes.emp_id_fieldname#" name="#attributes.emp_id_fieldname#" value="#attributes.emp_id_value#">	
        <input type="hidden" id="#attributes.in_out_id_fieldname#" name="#attributes.in_out_id_fieldname#" value="#attributes.in_out_value#">
        <input type="text" id="#attributes.emp_name_fieldname#" placeholder="#attributes.getLang#" name="#attributes.emp_name_fieldname#" autocomplete="off" 
        onfocus="AutoComplete_Create('#attributes.emp_name_fieldname#','FULLNAME,TC_IDENTY_NO,SOCIALSECURITY_NO,RETIRED_SGDP_NUMBER','FULLNAME','get_in_outs_autocomplete','','FULLNAME,IN_OUT_ID,EMPLOYEE_ID','#attributes.emp_name_fieldname#,#attributes.in_out_id_fieldname#,#attributes.emp_id_fieldname#','#attributes.form_name#','3','300')" value="#caller.get_emp_info(attributes.emp_id_value,0,0)#" <cfif isDefined("attributes.class")>class="#attributes.class#"</cfif> style="width:#attributes.width#px;">	
    </cfoutput>
    <span class="icon-ellipsis btnPointer input-group-addon"  onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=#attributes.form_name#.#attributes.in_out_id_fieldname#&field_emp_id=#attributes.form_name#.#attributes.emp_id_fieldname#&field_emp_name=#attributes.form_name#.#attributes.emp_name_fieldname#&call_function=#attributes.call_function#&is_shift=#attributes.is_shift#&is_dep_power_control=#attributes.is_dep_power_control#</cfoutput>')"></span> 
</div>

