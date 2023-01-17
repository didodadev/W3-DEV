<cfif not isdefined("caller.lang_array_main")>
	<cfset caller = caller.caller>
</cfif>
<cfoutput>
<cfif thisTag.executionMode eq "start">
<cfif isdefined("caller.tabbed_menu_count")>
	<cfset caller.tabbed_menu_count = caller.tabbed_menu_count + 1>
	<cfset this_tabbed_menu_count = caller.tabbed_menu_count>
<cfelse>
	<cfset caller.tabbed_menu_count = 1>
	<cfset this_tabbed_menu_count = 1>
</cfif>
<cfparam name="attributes.id" default="tabbed_#this_tabbed_menu_count#">
	<ul id="#attributes.id#" class="tabbed_menu">
<cfelse>
    </ul>
	<!--- <div id="tabbed_body_#this_tabbed_menu_count#" class="tabbed_menu_body"></div> --->
	<script>
		<cfif isdefined("caller.tabbed_li_id_#caller.tabbed_menu_count#")>
			<cfset a_ = evaluate("caller.tabbed_li_id_#caller.tabbed_menu_count#")>
			//document.getElementById('tabbed_body_#caller.tabbed_menu_count#').innerHTML = document.getElementById('li_div_#a_#').innerHTML;
		</cfif>
		function change_tabbed_#this_tabbed_menu_count#(li_count)
		{
			//document.getElementById('tabbed_body_#caller.tabbed_menu_count#').innerHTML = document.getElementById('li_div_' + li_count).innerHTML;
			<cfloop from="1" to="#caller.tabbed_menu_li_count#" index="tm">
				document.getElementById('tabbed_li_#tm#').className = '';
				gizle(li_div_#tm#);
				if(li_count == #tm#)
					document.getElementById('tabbed_li_#tm#').className = 'selected';
			</cfloop>
			goster(eval('li_div_' + li_count));
		}
	</script>
</cfif>
</cfoutput>
