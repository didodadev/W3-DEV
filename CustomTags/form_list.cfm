<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="form_list_#round(rand()*10000000)#">
<cfparam name="attributes.class" default="form_list">
<cfoutput>
	<cfif thisTag.executionMode eq "start">
		<div class="ListContent">
       		<table id="#attributes.id#" class="#attributes.class#" <cfif isdefined("attributes.margin") and len(attributes.margin)> style="margin-left:0px;" </cfif>>
    <cfelse>
       		</table>
		</div>
    </cfif>
</cfoutput>
