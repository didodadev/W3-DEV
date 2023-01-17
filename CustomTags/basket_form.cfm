<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="basket_form_#round(rand()*10000000)#">
<cfparam name="attributes.style" default="">
<cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfoutput>
<cfif thisTag.executionMode eq "start">
	<div class="sepetim_form_table_div" basket_header <cfif len(attributes.style)>style="#attributes.style#"</cfif> id="#attributes.id#_main_div">
    	<div class="sepetim_form_table" id="#attributes.id#">
<cfelse>
			#degerim_#<!-- sil -->
		</div>
	</div>
</cfif>
</cfoutput>
