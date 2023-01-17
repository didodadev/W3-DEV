


 <cfobject name="fabric_" component="addons.n1-soft.textile.cfc.fabric">
 
 <cfscript>
 getResult=fabric_.delete_fabric(
					stretching_test_id:attributes.stretching_test_id
				);
</cfscript>
		
				<cfloop from="1" to="#attributes.fabric_count#" index="i">
					
					<cfset fabric_width=evaluate("attributes.fabric_width#i#")>
				
					<cfset height_shrinkage=evaluate("attributes.height_shrinkage#i#")>
					<cfset width_shringkage=evaluate("attributes.width_shrinkage#i#")>
					<cfset smooth=evaluate("attributes.smooth#i#")>
					<cfset color=evaluate("attributes.color#i#")>
					<cfset height_color=evaluate("attributes.height_color#i#")>
					<cfset width_color=evaluate("attributes.width_color#i#")>
					<cfif isdefined("attributes.is_shrinkage_request#i#")>
					<cfset is_shrinkage_request=evaluate("attributes.is_shrinkage_request#i#")>
					<cfelse>
						<cfset is_shrinkage_request="">
					</cfif>
					<cfscript>
						addResult=fabric_.add_fabric
						(
							stretching_test_id:attributes.stretching_test_id,
							project_id:attributes.project_id,
							purchasing_id:attributes.purchasing_id,
							height_shrinkage:height_shrinkage,
							width_shringkage:width_shringkage,
							smooth:smooth,
							color:color,
							height_color:height_color,
							width_color:width_color,
							is_shrinkage_request:is_shrinkage_request,
							fabric_width:fabric_width
						);
					</cfscript>
				</cfloop>
<script>
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.stretching_test&event=add&st_id=#attributes.stretching_test_id#</Cfoutput>';
</script>