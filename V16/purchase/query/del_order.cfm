<cfset my_url_action = 'purchase.list_order'>
<cfset attributes.action_id=attributes.ORDER_ID>
<cfset attributes.action_section="ORDER_ID">
<cfinclude template="../../objects/query/del_assets.cfm">
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<!--- Silme Islemi Yapiliyor --->
		<cfinclude template="del_order_ic.cfm">
	</cftransaction>
</cflock>		
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#my_url_action#</cfoutput>";
</script>
