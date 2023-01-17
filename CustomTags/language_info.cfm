<!---CONTROL_TYPE:1 İSE COMPANY_ID BİLGİSİNE GÖRE 2 İSE PERIOD_ID BİLGİSİNE GÖRE İŞLEM YAPIYOR --->
<cfparam name="attributes.maxlength" default="50">
<cfparam name="attributes.input_type" default="text">
<cfparam name="attributes.class" default="">
<cfset address_ = "&t_name=#attributes.table_name#">
<cfset address_ = "#address_#&c_name=#attributes.column_name#">
<cfset address_ = "#address_#&c_id_value=#attributes.column_id_value#">
<cfset address_ = "#address_#&c_id=#attributes.column_id#">
<cfset address_ = "#address_#&d_alias=#attributes.datasource#">
<cfset address_ = "#address_#&maxlength=#attributes.maxlength#">
<cfset address_ = "#address_#&c_type=#attributes.control_type#">
<cfset address_ = "#address_#&input_type=#attributes.input_type#">

<i class="icon-book btnPointer <cfif len(attributes.class)><cfoutput>#attributes.class#</cfoutput></cfif>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_ajax_list_language_info#address_#</cfoutput>');" title="<cfoutput>#caller.getLang('main',2009)#</cfoutput>"></i>