<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_stage" datasource="#dsn2#">
			SELECT PROCESS_STAGE  FROM SHIP_INTERNAL WHERE DISPATCH_SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL2" datasource="#DSN2#">
			DELETE FROM SHIP_INTERNAL_ROW WHERE DISPATCH_SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL3" datasource="#DSN2#">
			DELETE FROM	SHIP_INTERNAL WHERE DISPATCH_SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL4" datasource="#DSN2#">
			DELETE FROM	SHIP_INTERNAL_MONEY WHERE ACTION_ID = #attributes.UPD_ID#
		</cfquery>
		<cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.upd_id#" process_stage="#get_stage.process_stage#" action_name="#attributes.head#" period_id="#session.ep.period_id#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_purchase</cfoutput>";
</script>

