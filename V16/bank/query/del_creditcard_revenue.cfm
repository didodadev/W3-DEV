<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process" datasource="#dsn3#">
	SELECT PROCESS_CAT,PAPER_NO FROM CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #attributes.id#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			cari_sil(action_id:attributes.id,process_type:attributes.old_process_type);
			muhasebe_sil (action_id:attributes.id,process_type:attributes.old_process_type);
		</cfscript>
		<cfquery name="DEL_CC_REVENUE_MONEY" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENT_MONEY WHERE ACTION_ID = #attributes.id#
		</cfquery>
		<cfquery name="DEL_CC_REVENUE_ROWS" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID = #attributes.id#
		</cfquery>
		<cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #attributes.id#
		</cfquery>
		<cfif isDefined("attributes.order_id")><!---Siparişten yapılan tahsilatlar içindir--->
			<cfquery name="UPD_ORDERS_INFO" datasource="#dsn2#">
				UPDATE
					#dsn3_alias#.ORDERS
				SET
					IS_PAID = NULL
				WHERE
					ORDER_ID = #attributes.order_id#
			</cfquery>
		</cfif>
        
        <!---iliskili tahsilat kaydindan is_void parametresi update ediliyor --->
        <cfif isdefined('attributes.relation_creditcard_payment_id') and len(attributes.relation_creditcard_payment_id)>
	        <cfquery name="updCreditCardPaymentVoid" datasource="#dsn2#">
            	UPDATE #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS SET IS_VOID = 0 WHERE CREDITCARD_PAYMENT_ID = #attributes.relation_creditcard_payment_id#
            </cfquery>
        </cfif>
        
		<!--- fiziki poslardan gelen satırlar --->
		<cfquery name="UPD_BANK_POS_ROWS" datasource="#dsn2#">
			UPDATE
				FILE_IMPORT_BANK_POS_ROWS
			SET
				CC_REVENUE_ID = NULL,
				CC_REVENUE_PERIOD_ID = NULL
			WHERE
				CC_REVENUE_ID = #attributes.id# AND
				CC_REVENUE_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfif len(attributes.cari_action_id)>
			<cfquery name="DEL_CARI_ACTION" datasource="#dsn2#">
				DELETE FROM CARI_ACTIONS WHERE ACTION_ID = #attributes.cari_action_id#
			</cfquery>
			<cfquery name="DEL_CARI_ACTION_MONEY" datasource="#dsn2#">
				DELETE FROM CARI_ACTION_MONEY WHERE ACTION_ID = #attributes.cari_action_id#
			</cfquery>
			<cfif attributes.old_process_type eq 241><cfset process_type_info = 41><cfelse><cfset process_type_info = 42></cfif>
			<cfscript>
				cari_sil(action_id:attributes.cari_action_id,process_type:process_type_info);
				muhasebe_sil(action_id:attributes.cari_action_id,process_type:process_type_info);
			</cfscript>
		</cfif>
		<!--- iliskili dekont varsa --->
		<cfquery name="getRelationCariActions" datasource="#dsn2#">
			SELECT ACTION_ID FROM CARI_ACTIONS WHERE RELATION_ACTION_TYPE_ID = 241 AND RELATION_ACTION_ID = #attributes.id#
		</cfquery>
		<cfif getRelationCariActions.recordcount>
			<cfset url.action_id = getRelationCariActions.ACTION_ID>
			<cfset attributes.process_type = 41> 
			<cfinclude template="../../ch/query/del_debit_claim_ic.cfm">
		</cfif>
		<cfif isDefined("attributes.order_id")><!---Siparişten yapılan tahsilatlar içindir--->
			<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.comp#(İliskili oldugu siparis_id:#attributes.order_id#)" process_type="#attributes.old_process_type#"  paper_no="#get_process.paper_no#" data_source="#dsn2#">
		<cfelse>
			<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.comp#"  process_type="#attributes.old_process_type#"  paper_no="#get_process.paper_no#" data_source="#dsn2#">
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue</cfoutput>';
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
