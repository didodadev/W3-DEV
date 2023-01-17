<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="basket_#round(rand()*10000000)#">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.special" default="0">
<cfset degerim_ = thisTag.GeneratedContent>
<cfset caller.last_basket_id = attributes.id>
<cfset thisTag.GeneratedContent =''>
<cfif thisTag.executionMode eq "start">
<cfelse>
	<div basket-content>
		<cfoutput>
			<div class="pod_basket" style="<cfif len(attributes.style)>#attributes.style#</cfif>">
				<div id="#attributes.id#">#degerim_#</div>
				<cfif isdefined("caller.attributes.basket_footer_#attributes.id#")>
					<cfif isdefined("caller.attributes.basket_footer_height_#attributes.id#")>
						<cfset f_height = evaluate("caller.attributes.basket_footer_height_#attributes.id#")>
					<cfelse>
						<cfset f_height = 40>
					</cfif>
					<div id="basket_footer_#attributes.id#">
						<cfoutput>#evaluate("caller.attributes.basket_footer_#attributes.id#")#</cfoutput>
					</div>
				</cfif>
			</div>
		</cfoutput>
	</div>
</cfif>

