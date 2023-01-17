<cfset cfc= createObject("component","V16.objects.cfc.get_list_content_relation")>
<cfif isdefined("attributes.cat") and attributes.cat neq "0">
	<cfif listgetat(attributes.cat,1,"-") is "cat">
		<cfset cont_st = "cat">
	<cfelse>
		<cfset cont_st = "ch">
	</cfif>
</cfif>

 <cfset get_content_relation =cfc.GetContentRelation(order_list:attributes.order_list, keyword:attributes.keyword, content_property_id:attributes.content_property_id,language_id:attributes.language_id )> 