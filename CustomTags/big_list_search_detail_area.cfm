<cfparam name="attributes.float" default="left">
<cfif caller.collapsed eq 1> <!--- Bu kosul big_list_search custom tag'inde atanip XML'leri dikkate almayip direk olarak buranin gizli gelmesini sagliyor... E:Y 20121011 --->
	<cfset attributes.collapsed = 1>
<cfelseif caller.collapsed eq 0>
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
	<cfoutput>
	<!-- sil -->
	<div style="clear:both; text-align:#attributes.float#; float:#attributes.float#; <cfif attributes.collapsed eq 1>display:none;</cfif>" id="#caller.last_table_id#_search_div" class="big_list_search_detail_area">
    	<div align="#attributes.float#">
	</cfoutput>    
<cfelse>
		</div>
	</div>
	<!-- sil -->
</cfif>
