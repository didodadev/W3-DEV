<!--- kredi ödeme ve tahsilat ortak silme sayfasıdır --->
<cfset temp_dsn = '#attributes.temp_dsn#'>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfscript>
			cari_sil(action_id:attributes.credit_contract_payment_id,process_type:attributes.old_process_type,cari_db:temp_dsn);
			muhasebe_sil (action_id:attributes.credit_contract_payment_id,process_type:attributes.old_process_type,muhasebe_db:temp_dsn);
			butce_sil(action_id:attributes.credit_contract_payment_id,process_type:attributes.old_process_type,muhasebe_db:temp_dsn);
		</cfscript>
		<cfquery name="DEL_BANK_ACTION" datasource="#temp_dsn#">
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.bank_action_id#
		</cfquery>
		<cfquery name="DEL_CREDIT_CONTRACT_PAYMENT_MONEY" datasource="#temp_dsn#">
			DELETE FROM
				CREDIT_CONTRACT_PAYMENT_INCOME_MONEY
			WHERE
				ACTION_ID = #attributes.credit_contract_payment_id#
		</cfquery>
		<cfquery name="DEL_CREDIT_CONTRACT_PAYMENT_TAX" datasource="#temp_dsn#">
			DELETE FROM
				CREDIT_CONTRACT_PAYMENT_INCOME_TAX
			WHERE
				CREDIT_CONTRACT_PAYMENT_ID = #attributes.credit_contract_payment_id#
		</cfquery>
		<cfquery name="GET_ROW_ID" datasource="#temp_dsn#">
			SELECT CREDIT_CONTRACT_ROW_ID FROM CREDIT_CONTRACT_PAYMENT_INCOME WHERE	CREDIT_CONTRACT_PAYMENT_ID = #attributes.credit_contract_payment_id#
		</cfquery>
		<cfif len(GET_ROW_ID.CREDIT_CONTRACT_ROW_ID)>
			<cfquery name="UPD_CONTRACT_ROW" datasource="#temp_dsn#">
				UPDATE
					#dsn3_alias#.CREDIT_CONTRACT_ROW
				SET
					IS_PAID_ROW = 0
				WHERE
					CREDIT_CONTRACT_ROW_ID = #GET_ROW_ID.CREDIT_CONTRACT_ROW_ID#
			</cfquery>
		</cfif>
		<cfquery name="DEL_COUNTER" datasource="#temp_dsn#">
			DELETE FROM
				CREDIT_CONTRACT_PAYMENT_INCOME
			WHERE
				CREDIT_CONTRACT_PAYMENT_ID = #attributes.credit_contract_payment_id#
		</cfquery>
		<cfquery name="DEL_CC_ROW" datasource="#temp_dsn#">
			DELETE FROM 
				#dsn3_alias#.CREDIT_CONTRACT_ROW
			WHERE
				IS_PAID = 1 AND
				ACTION_ID = #attributes.credit_contract_payment_id#	AND
				OUR_COMPANY_ID = #attributes.company_id# AND
				PERIOD_ID = #attributes.period_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
