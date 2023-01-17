<!---e.a select ifadeleri düzenlendi.23.07.2012--->
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_action_multi" datasource="#dsn2#">
			SELECT MULTI_ACTION_ID FROM BANK_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #url.multi_action_id#
		</cfquery>
		<cfif get_action_multi.recordcount>
			<cfquery name="get_all_action" datasource="#dsn2#">
				SELECT ACTION_ID,ACTION_TYPE_ID FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<!--- kayıtların bütçe hareketleri siliniyor --->
			<cfscript>
				for (k = 1; k lte get_all_action.recordcount;k=k+1)
					butce_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
			</cfscript>
			<!--- kayıtlar siliniyor --->
			<cfquery name="del_all_actions" datasource="#dsn2#">
				DELETE FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<cfscript>
				muhasebe_sil(action_id:url.multi_action_id,process_type:url.old_process_type);
			</cfscript>		
			<cfquery name="del_action_money" datasource="#dsn2#">
				DELETE FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID=#url.multi_action_id#
			</cfquery>
			<cfquery name="del_from_acc_actions" datasource="#dsn2#">
				DELETE FROM BANK_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #url.multi_action_id#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href = document.referrer;
</script>

