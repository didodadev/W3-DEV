<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_action_multi" datasource="#dsn2#">
			SELECT 
            	MULTI_ACTION_ID, 
                ACTION_TYPE_ID, 
                ACTION_DATE, 
                TO_CASH_ID, 
                FROM_CASH_ID, 
                UPD_STATUS, 
                RECORD_DATE, 
                RECORD_IP, 
                RECORD_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                UPDATE_EMP 
            FROM 
            	CASH_ACTIONS_MULTI 
            WHERE 
            	MULTI_ACTION_ID = #url.multi_action_id#
		</cfquery>
		<cfif get_action_multi.recordcount>
			<cfquery name="get_all_action" datasource="#dsn2#">
				SELECT ACTION_ID,ACTION_TYPE_ID FROM CASH_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<!--- kayıtların bütçe hareketleri siliniyor --->
			<cfscript>
				for (k = 1; k lte get_all_action.recordcount;k=k+1)
					butce_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
			</cfscript>
			<!--- kayıtlar siliniyor --->
			<cfquery name="del_all_actions" datasource="#dsn2#">
				DELETE FROM CASH_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<cfscript>
				muhasebe_sil(action_id:url.multi_action_id,process_type:url.old_process_type);
			</cfscript>		
			<cfquery name="del_action_money" datasource="#dsn2#">
				DELETE FROM CASH_ACTION_MULTI_MONEY WHERE ACTION_ID=#url.multi_action_id#
			</cfquery>
			<cfquery name="del_from_cash_actions" datasource="#dsn2#">
				DELETE FROM CASH_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #url.multi_action_id#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

