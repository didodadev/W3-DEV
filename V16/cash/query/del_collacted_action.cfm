<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_action_multi" datasource="#dsn2#">
			SELECT 
            	MULTI_ACTION_ID, 
                ACTION_TYPE_ID, 
                ACTION_DATE, 
                PROCESS_CAT, 
                UPD_STATUS, 
                ACC_DEPARTMENT_ID, 
                RECORD_DATE, 
                RECORD_IP, 
                RECORD_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                UPDATE_EMP 
            FROM 
            	CASH_ACTIONS_MULTI 
            WHERE 
            	MULTI_ACTION_ID = #attributes.multi_id#
		</cfquery>
		<cfif get_action_multi.recordcount>
			<cfquery name="get_all_action" datasource="#dsn2#">
				SELECT ACTION_ID,ACTION_TYPE_ID,PAPER_NO FROM CASH_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<!--- kayıtların cari hareketleri siliniyor --->
			<cfscript>
				for (k = 1; k lte get_all_action.recordcount;k=k+1)
					cari_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
			</cfscript>
			<!--- avans talepleri update ediliyor --->
			<cfquery name="upd_cor_payment" datasource="#dsn2#">
				UPDATE 
					#dsn_alias#.CORRESPONDENCE_PAYMENT
				SET
					ACTION_ID = NULL,
					ACTION_TYPE_ID = NULL,
					ACTION_PERIOD_ID = NULL
				WHERE
					ACTION_ID IN(SELECT ACTION_ID FROM CASH_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#) AND
					ACTION_TYPE_ID = 32 AND
					ACTION_PERIOD_ID = #session.ep.period_id#
			</cfquery>
			<cfquery name="upd_cor_other_payment" datasource="#dsn2#">
				UPDATE 
					#dsn_alias#.SALARYPARAM_GET_REQUESTS
				SET
					ACTION_ID = NULL,
					ACTION_TYPE_ID = NULL
				WHERE
					ACTION_ID IN(SELECT ACTION_ID FROM CASH_ACTIONS WHERE MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_multi.multi_action_id#">)
			</cfquery>
			<!--- kayıtlar siliniyor --->
			<cfquery name="del_all_actions" datasource="#dsn2#">
				DELETE FROM CASH_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<cfscript>
				muhasebe_sil(action_id:attributes.multi_id,process_type:attributes.old_process_type);
			</cfscript>		
			<cfquery name="del_action_money" datasource="#dsn2#">
				DELETE FROM CASH_ACTION_MULTI_MONEY WHERE ACTION_ID=#attributes.multi_id#
			</cfquery>
			<cfquery name="del_from_cash_actions" datasource="#dsn2#">
				DELETE FROM CASH_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.multi_id#
			</cfquery>
			<cfquery name="upd_employee_act" datasource="#dsn2#">
				UPDATE
					#dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS
				SET
					CASH_ACTION_MULTI_ID = NULL,
					CASH_PERIOD_ID = NULL
				WHERE
					CASH_ACTION_MULTI_ID = #attributes.multi_id# AND
					CASH_PERIOD_ID = #session.ep.period_id#
			</cfquery>
        	<cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.multi_id#" action_name= "#get_all_action.PAPER_NO# Silindi" paper_no= "#get_all_action.PAPER_NO#" period_id="#session.ep.period_id#" process_type="#attributes.old_process_type#" data_source="#dsn2#">

		</cfif>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.puantaj_id")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
    	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions</cfoutput>';
    </script>
</cfif>

