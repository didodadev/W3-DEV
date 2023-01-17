<cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfparam name="attributes.selected" default="0">
<cfoutput>
<cfif thisTag.executionMode eq "start">
<cfif isdefined("caller.tabbed_menu_li_count")>
	<cfset caller.tabbed_menu_li_count = caller.tabbed_menu_li_count + 1>
	<cfset this_tabbed_menu_li_count = caller.tabbed_menu_li_count>
<cfelse>
	<cfset caller.tabbed_menu_li_count = 1>
	<cfset this_tabbed_menu_li_count = 1>
</cfif>
<cfparam name="attributes.id" default="tabbed_li_#this_tabbed_menu_li_count#">
	<li style="display:inline; cursor:pointer;" id="#attributes.id#" <cfif attributes.selected eq 1>class="selected"</cfif>><a href="javascript://" onclick="change_tabbed_#caller.tabbed_menu_count#(#this_tabbed_menu_li_count#);">#attributes.title#</a>
<cfelse>
	</li>
	<div id="li_div_#this_tabbed_menu_li_count#" style="display:<cfif attributes.selected eq 0>none;</cfif>" class="tabbed_menu_body">
		#degerim_#
	</div>
	<cfif attributes.selected eq 1>
		<cfset 'caller.tabbed_li_id_#caller.tabbed_menu_count#' = this_tabbed_menu_li_count>
	</cfif>
</cfif>
</cfoutput>
