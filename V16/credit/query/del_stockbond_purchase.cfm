<!--- Menkul Kiymetler Alis ve Satis Silme FBS 20080603 --->
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfscript>
			cari_sil(action_id:attributes.action_id,process_type:attributes.old_process_type);
			muhasebe_sil(action_id:attributes.action_id,process_type:attributes.old_process_type);
			butce_sil(action_id:attributes.action_id,process_type:attributes.old_process_type);
		</cfscript>
		<cfif len(attributes.bank_action_id)>
			<cfquery name="del_bank_actions" datasource="#dsn2#">
				DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.bank_action_id#
			</cfquery>
			<cfif isDefined("attributes.ids") and listlen(attributes.ids) eq 2>
				<cfquery name="del_bank_actions" datasource="#dsn2#">
					DELETE FROM BANK_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(attributes.ids,',')#">
				</cfquery>
			</cfif>
		</cfif>
		<cfif attributes.old_process_type eq 293>
			<cfquery name="del_stockbonds" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.STOCKBONDS WHERE STOCKBOND_ID IN (SELECT STOCKBOND_ID FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE_ROW WHERE SALES_PURCHASE_ID = #attributes.action_id#)
			</cfquery>
		</cfif>
		<cfquery name="del_stockbonds_inout" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.STOCKBONDS_INOUT WHERE ACTION_ID = #attributes.action_id#
		</cfquery>
		<cfquery name="del_stockbonds_salepurchase" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE WHERE ACTION_ID = #attributes.action_id#
		</cfquery>
		<cfquery name="del_stockbonds_salepurchase_row" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE_ROW WHERE SALES_PURCHASE_ID = #attributes.action_id#
		</cfquery>
		<cfquery name="del_stockbonds_salepurchase_money" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE_MONEY WHERE ACTION_ID = #attributes.action_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=credit.list_stockbond_actions';	
</script>
