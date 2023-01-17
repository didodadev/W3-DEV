<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfset attributes.multi_action_id=attributes.multi_id>
<cfquery name="get_creditcard_payments" datasource="#dsn3#">
	SELECT
    	CREDITCARD_PAYMENT_ID,
        ACTION_TYPE_ID,
        RELATION_CREDITCARD_PAYMENT_ID,
        CARI_ACTION_ID
    FROM 
    	CREDIT_CARD_BANK_PAYMENTS
    WHERE
    	MULTI_ACTION_ID = #attributes.multi_action_id#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfoutput query="get_creditcard_payments">
            <cfquery name="get_process" datasource="#dsn2#">
                SELECT PROCESS_CAT,PAPER_NO FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #get_creditcard_payments.creditcard_payment_id#
            </cfquery>
            <cfscript>
                cari_sil(action_id:get_creditcard_payments.creditcard_payment_id,process_type:get_creditcard_payments.action_type_id);
                muhasebe_sil(action_id:attributes.multi_action_id,process_type:attributes.old_process_type);
            </cfscript>
            <cfquery name="DEL_CC_REVENUE_MONEY" datasource="#dsn2#">
                DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENT_MONEY WHERE ACTION_ID = #get_creditcard_payments.creditcard_payment_id#
            </cfquery>
            <cfquery name="DEL_CC_REVENUE_ROWS" datasource="#dsn2#">
                DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID = #get_creditcard_payments.creditcard_payment_id#
            </cfquery>
            <cfquery name="DEL_CC_REVENUE" datasource="#dsn2#">
                DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #get_creditcard_payments.creditcard_payment_id#
            </cfquery>
            <!---iliskili tahsilat kaydindan is_void parametresi update ediliyor --->
            <cfif isdefined('get_creditcard_payments.relation_creditcard_payment_id') and len(get_creditcard_payments.relation_creditcard_payment_id)>
                <cfquery name="updCreditCardPaymentVoid" datasource="#dsn2#">
                    UPDATE #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS SET IS_VOID = 0 WHERE CREDITCARD_PAYMENT_ID = #get_creditcard_payments.relation_creditcard_payment_id#
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
                    CC_REVENUE_ID = #get_creditcard_payments.creditcard_payment_id# AND
                    CC_REVENUE_PERIOD_ID = #session.ep.period_id#
            </cfquery>
            <cfif len(get_creditcard_payments.cari_action_id)>
                <cfquery name="DEL_CARI_ACTION" datasource="#dsn2#">
                    DELETE FROM CARI_ACTIONS WHERE ACTION_ID = #get_creditcard_payments.cari_action_id#
                </cfquery>
                <cfquery name="DEL_CARI_ACTION_MONEY" datasource="#dsn2#">
                    DELETE FROM CARI_ACTION_MONEY WHERE ACTION_ID = #get_creditcard_payments.cari_action_id#
                </cfquery>
                <cfscript>
                    cari_sil(action_id:get_creditcard_payments.cari_action_id,process_type:41);
                    muhasebe_sil(action_id:get_creditcard_payments.cari_action_id,process_type:41);
                </cfscript>
            </cfif>
            <!--- iliskili dekont varsa --->
            <cfquery name="getRelationCariActions" datasource="#dsn2#">
                SELECT ACTION_ID FROM CARI_ACTIONS WHERE RELATION_ACTION_TYPE_ID = 241 AND RELATION_ACTION_ID = #get_creditcard_payments.creditcard_payment_id#
            </cfquery>
            <cfif getRelationCariActions.recordcount>
                <cfset url.action_id = getRelationCariActions.ACTION_ID>
                <cfset attributes.process_type = 41> 
                <cfinclude template="../../ch/query/del_debit_claim_ic.cfm">
            </cfif>
            <cf_add_log log_type="-1" action_id="#attributes.multi_action_id#" action_name="TOPLU KREDI KARTI TAHSILAT"  process_type="#get_creditcard_payments.action_type_id#"  paper_no="#get_process.paper_no#" data_source="#dsn2#">
    	</cfoutput>
        <!--- toplu kredi karti tahsilat belgesi siliniyor --->
        <cfquery name="del_creditcard_multi" datasource="#dsn2#">
        	DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_MULTI WHERE MULTI_ACTION_ID = #attributes.multi_action_id#
        </cfquery>
        <!--- toplu kredi karti tahsilati belgesine ait para birimleri siliniyor --->
        <cfquery name="del_creditcard_multi" datasource="#dsn2#">
        	DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_MULTI_MONEY WHERE ACTION_ID = #attributes.multi_action_id#
        </cfquery>
    </cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent#</cfoutput>';
</script>