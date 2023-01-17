<cfset form.process_cat=attributes.process_type>
<cfinclude template="get_process_cat.cfm">
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="del_exchange_stock" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE = #get_process_type.PROCESS_TYPE# AND UPD_ID=#attributes.exchange_id#
		</cfquery>
		<cfquery name="del_exchange_stock" datasource="#dsn2#">
			DELETE FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID=#attributes.exchange_id#
		</cfquery>
	</cftransaction>
</cflock>
<cfif session.ep.our_company_info.is_cost eq 1>
	<cfscript>cost_action(action_type:5,action_id:attributes.exchange_id,query_type:3);</cfscript>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.welcome</cfoutput>";
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.welcome" addtoken="No">
</cfif>
