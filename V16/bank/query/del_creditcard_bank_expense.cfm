<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_expense_stage" datasource="#dsn3#">
	SELECT PROCESS_CAT,PAPER_NO FROM CREDIT_CARD_BANK_EXPENSE WHERE CREDITCARD_EXPENSE_ID = #attributes.id#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			cari_sil(action_id:attributes.id,process_type:attributes.old_process_type);
			muhasebe_sil (action_id:attributes.id,process_type:attributes.old_process_type);
		</cfscript>
		<cfquery name="DEL_CC_REVENUE_MONEY" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_MONEY WHERE ACTION_ID = #attributes.id#
		</cfquery>
		<cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS WHERE CREDITCARD_EXPENSE_ID = #attributes.id#
		</cfquery>
		<cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE CREDITCARD_EXPENSE_ID = #attributes.id#
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.comp#" process_type="#get_expense_stage.process_cat#" paper_no="#get_expense_stage.paper_no#"  data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
