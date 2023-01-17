<cfset attributes.show_employee_name = 0>
<cfset attributes.show_mandate_name = 1>
<cfset attributes.show_detail_button = 1>
<cfset attributes.master_employee_dynamic = session.ep.userid>
<cfsavecontent variable="getlang_title"><cf_get_lang dictionary_id='59872'></cfsavecontent>
<cf_box title="#getlang_title#" closable="0">
    <cfinclude template="../widgets/list/widget.cfm">
    <cfset attributes.add_href = "">
    <cfset attributes.show_employee_name = 1>
    <cfset attributes.show_mandate_name = 0>
    <cfset attributes.show_detail_button = 0>
    <cfset attributes.master_employee_dynamic = "">
    <cfset attributes.mandate_employee_dynamic = session.ep.userid>
    <cfinclude template="../widgets/list/widget.cfm">
</cf_box>



