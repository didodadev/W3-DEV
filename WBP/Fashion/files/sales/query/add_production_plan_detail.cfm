<cfobject name="wash_plan" component="WBP.Fashion.files.cfc.wash_plan">
<cfobject name="product_plan" component="WBP.Fashion.files.cfc.product_plan">
    <cfset recordCount=attributes.recordCount>
    <cfloop from="1" to="#recordCount#" index="i">
		 <cfscript>
			updResult=wash_plan.upd_washtype
			 (
				wash_id:'#iif(isdefined("attributes.washid#i#"),"attributes.washid#i#",DE(""))#',
				subject:'#iif(isdefined("attributes.subject#i#"),"attributes.subject#i#",DE(""))#',
				wash_type_id : '#iif(isdefined("attributes.wash_type_id#i#"),"attributes.wash_type_id#i#",DE(""))#'
			 );
		 </cfscript>
     </cfloop>
	 <cfif isDefined("attributes.discount_rate") and len(attributes.discount_rate)>
		<cfset product_plan.update_productplan_prices(attributes.PLAN_ID, attributes.discount_rate, attributes.total_price)>
		</cfif>
<script>
    window.location.href= '<cfoutput>#request.self#?fuseaction=textile.wash_plan&event=upd&plan_id=#attributes.PLAN_ID#</Cfoutput>';
</script>