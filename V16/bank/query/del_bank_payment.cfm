<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="DEL_ACTION" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.id#
		</cfquery>
		<cfquery name="DEL_CREDIT_CARD_ROWS" datasource="#dsn2#">
			UPDATE
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
			SET
				BANK_ACTION_ID = NULL,
				BANK_ACTION_PERIOD_ID = NULL
			WHERE
				BANK_ACTION_ID = #attributes.id# AND
				BANK_ACTION_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfscript>
			butce_sil(action_id:attributes.id,process_type:attributes.old_process_type);
			muhasebe_sil (action_id:attributes.id,process_type:attributes.old_process_type);
		</cfscript>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
		location.href =document.referrer;
	<cfelseif not isDefined('attributes.draggable') or attributes.draggable eq 0>
		wrk_opener_reload();
		window.close();	
	</cfif>

</script>
