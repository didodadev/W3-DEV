<cfobject name="wash_plan" component="addons.n1-soft.textile.cfc.wash_plan">
    <cfset recordCount=attributes.recordCount>
	
    <cfloop from="1" to="#recordCount#" index="i">
		<cfloop list="#evaluate("attributes.washid#i#")#" index="x">
			<cfloop list="#evaluate("attributes.subject#i#")#" index="y">
				 <cfscript>
					updResult=wash_plan.upd_washtype
					 (
						wash_id:x,
						subject:y
					 );
				 </cfscript>
			 </cfloop>
		 </cfloop>
     </cfloop>
	
<script>
    window.location.href= '<cfoutput>#request.self#?fuseaction=textile.wash_plan&event=upd&plan_id=#attributes.PLAN_ID#</Cfoutput>';
</script>