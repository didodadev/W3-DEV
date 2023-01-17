<cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfif thisTag.executionMode eq "start">
<cfelse>
	<cfsavecontent variable="caller.attributes.basket_footer_#caller.last_basket_id#">
		<cfoutput>#degerim_#</cfoutput>
	</cfsavecontent>
	<cfif isdefined("attributes.height")>
		<cfset 'caller.attributes.basket_footer_height_#caller.last_basket_id#' = attributes.height>
	</cfif>
</cfif>
