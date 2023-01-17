<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined("attributes.is_payment") and attributes.is_payment eq 1>
			<cfquery name="del_pay" datasource="#DSN#">
				DELETE FROM SALARYPARAM_PAY WHERE SPP_ID=#attributes.id#
			</cfquery>
		<cfelseif isdefined("attributes.is_interruption") and attributes.is_interruption eq 1>
			<cfquery name="del_pay" datasource="#DSN#">
				DELETE FROM SALARYPARAM_GET WHERE SPG_ID=#attributes.id#
			</cfquery>
		<cfelseif isdefined("attributes.is_tax_except") and attributes.is_tax_except eq 1>
			<cfquery name="del_pay" datasource="#DSN#">
				DELETE FROM SALARYPARAM_EXCEPT_TAX WHERE TAX_EXCEPTION_ID=#attributes.id#
			</cfquery>
		<cfelseif isdefined("attributes.is_bes") and attributes.is_bes eq 1>
			<cfquery name="del_pay" datasource="#DSN#">
				DELETE FROM SALARYPARAM_BES WHERE SPB_ID=#attributes.id#
			</cfquery>
		<cfelseif isdefined("attributes.is_del_bonus") and attributes.is_del_bonus eq 1>
			<cfquery name="del_bonus" datasource="#dsn#">
				DELETE FROM BONUS_PAYROLL WHERE BONUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bonus_id#">
			</cfquery>
			<cfquery name="del_pay" datasource="#dsn#">
				DELETE FROM SALARYPARAM_PAY WHERE BONUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bonus_id#">
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif  isdefined("attributes.is_del_bonus") and attributes.is_del_bonus eq 1>
		window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_payments</cfoutput>";		
	<cfelse>
		location.href = document.referrer;
	</cfif>
</script>
