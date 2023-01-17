<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>");
		window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_bank_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="DEL_BANK_ACTION_MONEY" datasource="#dsn2#"><!--- money kayıtları --->
			DELETE FROM BANK_ACTION_MONEY WHERE ACTION_ID = #attributes.id#
		</cfquery>
		<cfquery name="DEL_ACTION" datasource="#dsn2#"><!--- banka hareketi --->
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.id#
		</cfquery>
		<!--- eskiden kredi kartı ödemelerle olan ilişkiyi tutuyordu ,sonradan kaldırıcam AE20060714--->
		<cfquery name="DEL_CREDIT_CARD_BANK_EXPENSE" datasource="#dsn2#">
			DELETE FROM
				#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS
			WHERE
				BANK_ACTION_ID = #attributes.id# AND
				BANK_ACTION_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfscript>
			butce_sil(action_id:attributes.id,process_type:attributes.old_process_type);
			muhasebe_sil (action_id:attributes.id,process_type:attributes.old_process_type);
		</cfscript>
	</cftransaction>
</cflock>
<script type="text/javascript">

location.href = document.referrer;
	
</script>
