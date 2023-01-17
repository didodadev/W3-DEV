<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_ACC_ID" datasource="#dsn2#">
			SELECT ISNULL(ACTION_TO_ACCOUNT_ID,ACTION_FROM_ACCOUNT_ID) ACTION_TO_ACCOUNT_ID FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.ID#
		</cfquery>	
		<cfquery name="DEL_BANK_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM BANK_ACTION_MONEY WHERE ACTION_ID = #attributes.ID#
		</cfquery>
		<cfquery name="DEL_FROM_BANK_ACTIONS" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.ID#
		</cfquery>
		<cfquery name="UPD_ACCOUNT_STATUS" datasource="#dsn2#">
			UPDATE
				#dsn3_alias#.ACCOUNTS_OPEN_CONTROL
			SET
				IS_OPEN = 0
			WHERE
				ACCOUNT_ID = #GET_ACC_ID.ACTION_TO_ACCOUNT_ID#
                AND PERIOD_ID = #session.ep.period_id#
		</cfquery>	
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</cfif>
</script>
