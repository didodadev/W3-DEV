<cfquery name="CONTROL_SHIP" datasource="#dsn2#">
	SELECT SHIP_ID FROM SHIP WHERE SHIP_ID=#attributes.UPD_ID# AND SHIP_TYPE=811
</cfquery>
<cfif CONTROL_SHIP.recordcount>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
				DELETE FROM STOCKS_ROW 
				WHERE
					UPD_ID=#attributes.UPD_ID# AND
					PROCESS_TYPE=811
			</cfquery>
			<!--- seri no kayitlari silinir --->
			<cfscript>
				del_serial_no(
					process_id : attributes.UPD_ID,
					process_cat : 811, 
					period_id : session.ep.period_id
					);
			</cfscript>
			<!--- seri no kayitlari silinir --->
			<cfquery name="GET_INVOICE_11" datasource="#dsn2#">
				SELECT INVOICE_COST_ID FROM INVOICE_COST WHERE SHIP_ID = #attributes.UPD_ID#
			</cfquery>
			<cfquery name="DEL_INVOICE_11" datasource="#dsn2#">
				DELETE FROM INVOICE_COST WHERE SHIP_ID = #attributes.UPD_ID#
			</cfquery>
			<cfquery name="DEL_SHIP_MONEY" datasource="#DSN2#">
				DELETE FROM	SHIP_MONEY WHERE ACTION_ID = #attributes.UPD_ID#
			</cfquery>
			<cfquery name="DEL_INVOICE_SHIPS" datasource="#DSN2#">
				DELETE FROM INVOICE_SHIPS WHERE SHIP_ID=#attributes.UPD_ID# AND IMPORT_INVOICE_ID IS NOT NULL
			</cfquery>
			<cfquery name="DEL_SHIP_ROW" datasource="#DSN2#">
				DELETE FROM SHIP_ROW WHERE SHIP_ID=#attributes.UPD_ID#
			</cfquery>
			<cfquery name="DEL_SHIP" datasource="#DSN2#">
				DELETE FROM	SHIP WHERE SHIP_ID=#attributes.UPD_ID#
			</cfquery>
			<!--- sevkiyat planinda irsaliye iliskisini silmek icin eklendi fbs 20091210 --->
			<cfquery name="ship_result_control" datasource="#dsn2#">
				SELECT SHIP_ID,SR.SHIP_RESULT_ID FROM SHIP_RESULT SR, SHIP_RESULT_ROW SRR WHERE SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID AND SR.IS_ORDER_TERMS = 1 AND SRR.SHIP_ID = #attributes.UPD_ID#
			</cfquery>
			<cfif ship_result_control.recordcount>
				<cfquery name="Upd_Ship_Result_Row" datasource="#dsn2#">
					UPDATE SHIP_RESULT_ROW SET SHIP_ID = NULL, SHIP_NUMBER = NULL WHERE SHIP_ID = #attributes.UPD_ID#
				</cfquery>
				<cfquery name="Upd_Ship_Result_Row_Component" datasource="#dsn2#">
					UPDATE SHIP_RESULT_ROW_COMPONENT SET SHIP_RESULT_ROW_AMOUNT = 0 WHERE SHIP_RESULT_ID = #ship_result_control.ship_result_id#
				</cfquery>
			</cfif>
			<!--- //sevkiyat planinda irsaliye iliskisini silmek icin eklendi fbs 20091210 --->
			<cfscript>
				muhasebe_sil(action_id:attributes.UPD_ID, process_type:form.old_process_type);
				if(GET_INVOICE_11.recordcount)
					muhasebe_sil(action_id:GET_INVOICE_11.INVOICE_COST_ID, process_type:8110);
			</cfscript>
			<cf_add_log  log_type="-1" action_id="#attributes.upd_id#" action_name="#attributes.ship_number#" paper_no="#attributes.ship_number#" process_type="#attributes.cat#" data_source="#dsn2#">
		</cftransaction>
	</cflock>
	<cfif session.ep.our_company_info.is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
		<cfscript>cost_action(action_type:2,action_id:attributes.UPD_ID,query_type:3);</cfscript>
		<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_purchase</cfoutput>";
		</script>
	<cfelse>
		<cflocation url="#request.self#?fuseaction=stock.list_purchase" addtoken="no">
	</cfif>
<cfelse>
	<br/><br/><br/><b>İthal Mal Girişi İrsaliyesi Yok!!</b>
	<cfexit method="exittemplate">
</cfif>

