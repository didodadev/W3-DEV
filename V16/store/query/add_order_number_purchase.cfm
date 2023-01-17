<cfif isdefined("attributes.deliver_dept") and len(attributes.deliver_dept)>
	<cfif len(deliverdate)>
		<cfset str_link = "&deliver_dept=#attributes.deliver_dept#&location_id=0&deliverdate=#dateformat(deliverdate,dateformat_style)#">
	<cfelse>
		<cfset str_link = "&deliver_dept=#attributes.deliver_dept#&location_id=0&deliverdate=">
	</cfif>
<cfelse>
	<cfset str_link = "">
</cfif>
<script type="text/javascript">
	window.opener.location='<cfoutput>#request.self#?fuseaction=store.form_add_order_purchase&order_id=#url.order_id#&id=#url.id##str_link#</cfoutput>';
	window.close();
</script>

