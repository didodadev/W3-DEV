<!---
Description :   
	Document Template 
	Parameters :
	action_type_id  required { 1: employee 2: consumer 3: company  4:partner_id}
	action_id       required (employee_id,consumer_id,company_id,partner_id)
	dsp_account     required  { 1: if account detail indicated  0 : account detail is not indicated} 
	Syntax :
	<cf_display_member  action_type_id='' action_id='' dsp_account=''>
	
	created Arzu BT 20032312
--->
<cfif attributes.action_type_id eq "e">
	<cfset act_type_id = 1>
<cfelseif attributes.action_type_id eq "c">
	<cfset act_type_id = 2>
<cfelseif attributes.action_type_id eq "comp">
	<cfset act_type_id = 3>
<cfelseif attributes.action_type_id eq "p">
	<cfset act_type_id = 4>
</cfif>

<cfset url_str = ''>
<cfif len(attributes.action_type_id)><cfset url_str =url_str&'&act_type_id=#act_type_id#'></cfif>
<cfif len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfif len(attributes.dsp_account)><cfset url_str =url_str&'&dsp_account=#attributes.dsp_account#'></cfif>

<cf_box id="display_member" title="#caller.getLang('main',172)#" closable="0" box_page="#request.self#?fuseaction=objects.ajax_display_member_info&#url_str#"></cf_box> 
