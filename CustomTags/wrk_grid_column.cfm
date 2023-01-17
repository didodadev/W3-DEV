<cfparam name="attributes.type" default="string_noCase">
<cfparam name="attributes.is_empty" default="0">
<cfparam name="attributes.header" default="Header">
<cfparam name="attributes.name" default="Name">
<cfparam name="attributes.select" default="Yes">
<cfparam name="attributes.display" default="Yes">
<cfparam name="attributes.width" default="1111">
<cfparam name="attributes.mask" default="?">
<cfparam name="attributes.dataalign" default="left">
<cfparam name="attributes.auto_column" default="0">
<cfparam name="attributes.required" default="false">
<cfparam name="attributes.listsource" default="-">
<cfparam name="attributes.onclick" default="">
<cfparam name="attributes.listsource_text" default="-">
<cfif thisTag.executionMode eq "start">
  <cfif isdefined("caller.grid_name_list")>
	    <cfset caller.onclick = attributes.onclick>
        <cfset caller.grid_name_list = listappend(caller.grid_name_list,attributes.name)>
        <cfset caller.grid_header_list = listappend(caller.grid_header_list,attributes.header)>
        <cfset caller.grid_select_list = listappend(caller.grid_select_list,attributes.select)>
        <cfset caller.grid_type_list = listappend(caller.grid_type_list,attributes.type)>
        <cfset caller.grid_display_list = listappend(caller.grid_display_list,attributes.display)>
	    <cfset caller.grid_width_list = listappend(caller.grid_width_list,attributes.width)>
	    <cfset caller.grid_empty_list = listappend(caller.grid_empty_list,attributes.is_empty)><!---nvarchar kolonları dışında olan inputların yanındaki boş kolon için--->
        <cfif attributes.mask is 'date'>
        	<cfset attributes.mask = 'd/m/Y'>
        </cfif>
        <cfset caller.grid_dataalign_list = listappend(caller.grid_dataalign_list,attributes.dataalign)>
        <cfset caller.grid_mask_list = listappend(caller.grid_mask_list,attributes.mask)>
        <cfset caller.grid_req_list = listappend(caller.grid_req_list,attributes.required)>
        <cfset caller.grid_listsource = listappend(caller.grid_listsource,attributes.listsource)>
        <cfset caller.grid_listsource_text = listappend(caller.grid_listsource_text,attributes.listsource_text)>
    <cfelse>
        <cfset caller.grid_name_list = attributes.name>
        <cfset caller.grid_header_list = attributes.header>
        <cfset caller.grid_select_list = attributes.select>
        <cfset caller.grid_type_list = attributes.type>
        <cfset caller.grid_display_list = attributes.display>
	    <cfset caller.grid_width_list = attributes.width>
	    <cfset caller.onclick = attributes.onclick>
	    <cfset caller.grid_empty_list = attributes.is_empty><!---nvarchar kolonları dışında olan inputların yanındaki boş kolon için--->
        <cfif attributes.mask is 'date'>
        	<cfset attributes.mask = 'd/m/Y'>
        </cfif>
        <cfset caller.grid_dataalign_list = attributes.dataalign>
        <cfset caller.grid_mask_list = attributes.mask>
        <cfset caller.grid_req_list = attributes.required>
        <cfset caller.grid_listsource = attributes.listsource>
        <cfset caller.grid_listsource_text = attributes.listsource_text>
    </cfif>
<cfelse>
</cfif>
