<!---e.a 19072012 select ifadeleri düzenlendi.--->
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_action_multi" datasource="#dsn2#">
			SELECT MULTI_ACTION_ID,PROCESS_CAT FROM CARI_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.multi_id#
		</cfquery>
		<cfquery name="get_process_type" datasource="#dsn2#">
			SELECT 
				PROCESS_TYPE,
				IS_CARI,
				IS_ACCOUNT,
				ACTION_FILE_NAME,
				ACTION_FILE_FROM_TEMPLATE,
				IS_ACCOUNT_GROUP
			 FROM 
				#dsn3_alias#.SETUP_PROCESS_CAT 
			WHERE 
				PROCESS_CAT_ID = #get_action_multi.process_cat#
		</cfquery>
		<cfif len(get_process_type.action_file_name)>
			<cf_workcube_process_cat 
				process_cat="#get_action_multi.process_cat#"
				action_id = #attributes.multi_id#
				action_page = "#request.self#?fuseaction=#listGetAt(fuseaction,1,'.')#.emptypopup_del_collacted_dekont_multi&multi_id=#attributes.multi_id#"
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>
		<cfif get_action_multi.recordcount>
			<cfquery name="get_all_action" datasource="#dsn2#">
				SELECT ACTION_ID,ACTION_TYPE_ID FROM CARI_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<!--- kayıtların cari hareketleri siliniyor --->
			<cfscript>
				for (k = 1; k lte get_all_action.recordcount;k=k+1)
				{
					cari_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
					butce_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
				}
			</cfscript>
			<!--- kayıtlar siliniyor --->
			<cfquery name="del_all_actions" datasource="#dsn2#">
				DELETE FROM CARI_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<cfscript>
				muhasebe_sil(action_id:attributes.multi_id,process_type:attributes.old_process_type);
			</cfscript>		
			<cfquery name="del_action_money" datasource="#dsn2#">
				DELETE FROM CARI_ACTION_MULTI_MONEY WHERE ACTION_ID=#attributes.multi_id#
			</cfquery>
			<cfquery name="del_from_cash_actions" datasource="#dsn2#">
				DELETE FROM CARI_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.multi_id#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_caris</cfoutput>';
</script>