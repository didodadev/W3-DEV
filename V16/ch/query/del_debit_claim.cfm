<cfquery name="GET_CC_PAYM" datasource="#dsn2#">
	SELECT CREDITCARD_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CARI_ACTION_ID = #attributes.action_id# AND ACTION_PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfif GET_CC_PAYM.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='73.Lütfen İlişkili Kredi Kartı Tahsilatını Siliniz'>!");
		history.back();	
	</script>
</cfif>
<cfquery name="get_process" datasource="#dsn2#">
	SELECT PAPER_NO,PROCESS_CAT FROM CARI_ACTIONS WHERE ACTION_ID = #attributes.action_id#
</cfquery>
<cfif isdefined("attributes.payment_id") and len(attributes.payment_id)>
	<cfset action_name_ = "Odeme ID:#attributes.payment_id#">
<cfelse>
	<cfset action_name_ = "Dekont ID:#attributes.action_id#">
</cfif>
<cfif not isdefined("is_transaction")>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfinclude template="del_debit_claim_ic.cfm">
			<cf_add_log log_type="-1" action_id="#attributes.action_id#" action_name="#action_name_#"  process_type="#attributes.old_process_type#" paper_no="#get_process.paper_no#" data_source="#dsn2#">
		</cftransaction>
	</cflock>
<cfelse>
	<cfinclude template="del_debit_claim_ic.cfm">
	<cf_add_log log_type="-1" action_id="#url.action_id#" action_name="#action_name_#" process_type="#attributes.old_process_type#" paper_no="#get_process.paper_no#" data_source="#dsn2#">
</cfif>
<cfif not isDefined("is_from_premium")>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_caris</cfoutput>';
	</script>
</cfif>
