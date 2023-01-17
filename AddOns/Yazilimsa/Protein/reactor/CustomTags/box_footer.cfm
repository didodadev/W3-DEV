<!--- <cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfif thisTag.executionMode eq "start">
<cfelse>
	<cfsavecontent variable="caller.attributes.box_footer_#caller.last_box_id#">
		<cfoutput>#degerim_#</cfoutput>
	</cfsavecontent>
</cfif> --->

<cfoutput>
	<cfif thisTag.executionMode eq "start">
		<cfset caller.popup_box_footer = 1>	
		<div class="ui-form-list-btn">
    <cfelse>
		</div>
	</cfif>
</cfoutput>