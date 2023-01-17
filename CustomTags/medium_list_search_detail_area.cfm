<cfif isdefined("caller.collapsed_medium_list") and caller.collapsed_medium_list eq 1> <!--- Bu kosul medium_list_search custom tag'inde atanip XML'leri dikkate almayip direk olarak buranin gizli gelmesini sagliyor... E:Y 20121011 --->
	<cfset attributes.collapsed = 1>
<cfelseif isdefined("caller.collapsed_medium_list") and caller.collapsed_medium_list eq 0>
	<cfset attributes.collapsed = 0>
<cfelse>
	<cfset attributes.collapsed = 1>
    <cfif isdefined("caller.xml_unload_body_#caller.last_table_id#")>
        <cfset attributes.collapsed = evaluate("caller.xml_unload_body_#caller.last_table_id#")>
    <cfelseif isdefined("caller.caller.xml_unload_body_#caller.last_table_id#")>
        <cfset attributes.collapsed = evaluate("caller.caller.xml_unload_body_#caller.last_table_id#")>
    </cfif>
</cfif>
<cfif thisTag.executionMode eq "start">
<script>
$(function(){
	
		var __div = $("div[id='<cfoutput>#caller.last_table_id#_open_area</cfoutput>']");
		 if ( __div) __div.css('display','block');
	
})//ready
</script>
	<!-- sil -->
	<div style=" <cfif attributes.collapsed eq 1>display:none;</cfif>" id="<cfoutput>#caller.last_table_id#_search_div</cfoutput>">
<cfelse>
	</div>
    <!-- sil -->
</cfif>
