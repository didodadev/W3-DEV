<cfparam name="attributes.name" default=""><cfparam name="attributes.open" default=1><cfif thisTag.executionMode eq "start">	<div class="catalyst-seperator"><label onclick="slideBoxToggle(this)"><i class="icon-angle-down"></i><cfoutput>#attributes.name#</cfoutput></label></div>	<div style="display:<cfif attributes.open eq 0>none<cfelse>block</cfif>;"><cfelse>	</div></cfif>