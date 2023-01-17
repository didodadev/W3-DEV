<!---Select ifadeleri düzenlendi e.a 23.07.2012--->
<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		history.back();	
	</script>
	<cfabort>
</cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_action_multi" datasource="#dsn2#">
			SELECT MULTI_ACTION_ID FROM BANK_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.multi_id#
		</cfquery>
		<cfif get_action_multi.recordcount>
			<cfquery name="get_process_type" datasource="#dsn2#">
				SELECT TOP 1
					MULTI_TYPE
				FROM 
					#dsn3_alias#.SETUP_PROCESS_CAT 
				WHERE 
					PROCESS_TYPE = #attributes.old_process_type#
			</cfquery>
			<cfset attributes.old_process_multi_type = get_process_type.MULTI_TYPE>
			<cfquery name="CONTROL_BANK_ORDER" datasource="#dsn2#">
				SELECT BANK_ORDER_ID FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #attributes.multi_id#
			</cfquery>
			<cfif control_bank_order.recordcount>
				<cfoutput query="CONTROL_BANK_ORDER">
                	<cfif len(CONTROL_BANK_ORDER.bank_order_id)>
                        <cfquery name="BANK_ORDER_PROCESS_TYPE" datasource="#dsn2#">
                            SELECT 
                                SPR.PROCESS_TYPE,
                                SPR.IS_CARI,
                                BANK_ORDERS.BANK_ORDER_TYPE,
                                BANK_ORDERS.BANK_ORDER_TYPE_ID
                            FROM 
                                #dsn3_alias#.SETUP_PROCESS_CAT AS SPR,
                                BANK_ORDERS 
                            WHERE 
                                SPR.PROCESS_CAT_ID = BANK_ORDERS.BANK_ORDER_TYPE_ID
                                AND SPR.PROCESS_TYPE=BANK_ORDERS.BANK_ORDER_TYPE
                                AND BANK_ORDERS.BANK_ORDER_ID = #CONTROL_BANK_ORDER.bank_order_id#
                        </cfquery>
                        <cfif BANK_ORDER_PROCESS_TYPE.IS_CARI>
                            <cfquery name="upd_cari_action" datasource="#dsn2#">
                                UPDATE 
                                    CARI_ROWS
                                SET 
                                    IS_PROCESSED=0
                                WHERE 
                                    ACTION_ID = #CONTROL_BANK_ORDER.bank_order_id# AND
                                    ACTION_TYPE_ID = #BANK_ORDER_PROCESS_TYPE.BANK_ORDER_TYPE#
                            </cfquery>
                        </cfif>
                        <cfquery name="UPD_BANK_ORDERS" datasource="#dsn2#">
                            UPDATE BANK_ORDERS SET IS_PAID=0 WHERE BANK_ORDER_ID = #CONTROL_BANK_ORDER.bank_order_id#
                        </cfquery>
                    </cfif>
				</cfoutput>
			</cfif>
			<cfquery name="get_all_action" datasource="#dsn2#">
				SELECT ACTION_ID,ACTION_TYPE_ID FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<!--- havale kayıtlarının cari ve bütçe hareketleri siliniyor --->
			<cfscript>
				for (k = 1; k lte get_all_action.recordcount;k=k+1)
				{
					cari_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
					butce_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);
				}
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
					ACTION_ID IN(SELECT ACTION_ID FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#) AND
					ACTION_TYPE_ID = 25 AND
					ACTION_PERIOD_ID = #session.ep.period_id#
			</cfquery>
			<!--- Taksitli avans --->
			<cfquery name="upd_cor_other_payment" datasource="#dsn2#">
				UPDATE 
					#dsn_alias#.SALARYPARAM_GET_REQUESTS
				SET
					ACTION_ID = <cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">,
					ACTION_TYPE_ID = <cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">
				WHERE
					ACTION_ID IN(SELECT ACTION_ID FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_multi.multi_action_id#">)
			</cfquery>
			<!--- havale kayıtları siliniyor --->
			<cfquery name="del_all_actions" datasource="#dsn2#">
				DELETE FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #get_action_multi.multi_action_id#
			</cfquery>
			<cfscript>
				muhasebe_sil(action_id:attributes.multi_id,process_type:attributes.old_process_multi_type);
			</cfscript>		
			<cfquery name="del_action_money" datasource="#dsn2#">
				DELETE FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID=#attributes.multi_id#
			</cfquery>
			<cfquery name="del_from_bank_actions" datasource="#dsn2#">
				DELETE FROM BANK_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.multi_id#
			</cfquery>
			<cfquery name="upd_employee_act" datasource="#dsn2#">
				UPDATE
					#dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS
				SET
					BANK_ACTION_MULTI_ID = NULL,
					BANK_PERIOD_ID = NULL
				WHERE
					BANK_ACTION_MULTI_ID = #attributes.multi_id# AND
					BANK_PERIOD_ID = #session.ep.period_id#
			</cfquery>
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
    	window.location.href="<cfoutput>#request.self#?fuseaction=bank.list_bank_actions</cfoutput>";
	</script>
</cfif>