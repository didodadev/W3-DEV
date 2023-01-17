<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="del_credit" datasource="#dsn3#">
			DELETE FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = #attributes.credit_contract_id#
		</cfquery>
		<cfquery name="del_credit" datasource="#dsn3#">
			DELETE FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = #attributes.credit_contract_id#
		</cfquery>
		<cfquery name="del_credit" datasource="#dsn3#">
			DELETE FROM CREDIT_CONTRACT_MONEY WHERE ACTION_ID = #attributes.credit_contract_id#
		</cfquery>	
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=credit.list_credit_contract';	
</script>
