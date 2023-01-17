<cflock name="#CreateUUID()#" timeout="500">
	<cftransaction>
		<cfscript>
			muhasebe_sil(action_id:form.upd_id, process_type:form.old_process_type);
		</cfscript>
		<!--- seri no kayitlari silinir --->
		<cfscript>
		del_serial_no(
		process_id : form.upd_id,
		process_cat : form.type_id, 
		period_id : session.ep.period_id
		);
		butce_sil(action_id:form.upd_id,is_stock_fis:1,muhasebe_db:dsn2);
		</cfscript>
		<!--- seri no kayitlari silinir --->
		
		<!--- stock fisi ic talep baglantısı siliniyor --->
		<cfquery name="DEL_INTERNALDEMAND_RELATION" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.INTERNALDEMAND_RELATION_ROW WHERE TO_STOCK_FIS_ID=#form.upd_id# AND PERIOD_ID=#session.ep.period_id#
		</cfquery>
		<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#form.type_id# AND UPD_ID=#form.upd_id#
		</cfquery>
		<cfquery name="del_stock_fis_row" datasource="#dsn2#">
			DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #form.upd_id#
		</cfquery>
		<cfquery name="del_stock_fis_row" datasource="#dsn2#">
			DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #form.upd_id#
		</cfquery>
		<cfquery name="DEL_FIS_NUMBER" datasource="#dsn2#">
			DELETE FROM STOCK_FIS WHERE FIS_ID = #form.upd_id#
		</cfquery>
		<!--- toplu fire ve sayım fisi tablosundaki kayıtları güncelliyor özden21072005 --->
		<cfquery name="DEL_FILE_IMPORTS_TOTAL" datasource="#dsn2#"> 
			UPDATE 
				FILE_IMPORTS_TOTAL 
			SET 
				FIS_ID=NULL,
				FIS_PROCESS_TYPE= NULL 
			WHERE 
				FIS_ID=#form.upd_id# and FIS_PROCESS_TYPE=#form.type_id#
		</cfquery>
	<cf_add_log log_type="-1" action_id="#attributes.UPD_ID#" action_name="#attributes.fis_no#" paper_no="#attributes.fis_no#" process_type="#attributes.cat#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
	<cfscript>cost_action(action_type:3,action_id:attributes.UPD_ID,query_type:3);</cfscript>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_purchase&cat=#form.type_id#&rows=20</cfoutput>";
</script>