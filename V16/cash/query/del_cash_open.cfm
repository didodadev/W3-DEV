<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="GET_CASH_ID" datasource="#dsn2#">
			SELECT
				CASH_ACTION_TO_CASH_ID,
				CASH_ACTION_FROM_CASH_ID
			FROM
				CASH_ACTIONS
			WHERE
				ACTION_ID=#attributes.id#
		</cfquery>
		<cfquery name="UPD_CASH_STATUS" datasource="#dsn2#">
			UPDATE
				CASH
			SET
				ISOPEN = 0
			WHERE
				CASH_ID = <cfif len (GET_CASH_ID.CASH_ACTION_TO_CASH_ID)>#GET_CASH_ID.CASH_ACTION_TO_CASH_ID#<cfelse>#GET_CASH_ID.CASH_ACTION_FROM_CASH_ID#</cfif>
		</cfquery>
		<cfquery name="DEL_CASH_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM CASH_ACTION_MONEY WHERE ACTION_ID = #attributes.id#
		</cfquery>
		<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID=#attributes.id#
		</cfquery>
  </cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions</cfoutput>';
	</cfif>
</script>

