<cfset delete_data = createObject("component","V16.crm.cfc.visitorbook")>
<cfparam name="attributes.VISIT_ID" >
<cfset delete_data.del_visitor(visit_id: attributes.VISIT_ID)>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=crm.visitorbook</cfoutput>';
</script>	