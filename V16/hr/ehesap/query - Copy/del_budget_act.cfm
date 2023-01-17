<cflock timeout="20">
	<cftransaction>
		<cfquery name="fis_sil" datasource="#attributes.new_dsn2#">
			DELETE FROM
				EXPENSE_ITEMS_ROWS
			WHERE
				EXPENSE_COST_TYPE = 161
				AND ACTION_ID = #attributes.puantaj_id#
				AND ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
		</cfquery>
		<cfquery name="upd_puantaj" datasource="#attributes.new_dsn2#">
			UPDATE
				#dsn_alias#.EMPLOYEES_PUANTAJ
			SET 
				IS_BUDGET=0
			WHERE
				PUANTAJ_ID=#attributes.puantaj_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.opener.window.close();
	window.close();
</script>

