<!--- Action file larda sorun oluyordu bloklara ayırmak zorunda kaldık Özden-Sevda --->
<cfquery name="get_process" datasource="#dsn2#">
	SELECT PROCESS_CAT,FIS_NUMBER FROM STOCK_FIS WHERE FIS_ID = #attributes.fis_id#
</cfquery>
<cfif not isdefined("is_transaction")>
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfinclude template="del_invent_stock_fis_ic.cfm">
		</cftransaction>
	</cflock>
<cfelse>
	<cfinclude template="del_invent_stock_fis_ic.cfm">
</cfif>
<cfif not isDefined("related_ship_id")>
	<cf_add_log  log_type="-1" action_id="#attributes.fis_id#" action_name="#attributes.head#"  process_type="#attributes.old_process_type#" paper_no="#get_process.fis_number#">
	<cfif session.ep.our_company_info.is_cost eq 1>
		<cfscript>cost_action(action_type:3,action_id:attributes.fis_id,query_type:3);</cfscript>
		<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=invent.list_actions</cfoutput>";
		</script>
	<cfelse>
		<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_actions</cfoutput>";
		</script>
	</cfif>
</cfif>
