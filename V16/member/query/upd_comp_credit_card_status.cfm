<cfsetting showdebugoutput="no">
<cfquery name="get_subscription_cc_id" datasource="#dsn3#">
	SELECT TOP 1 MEMBER_CC_ID FROM SUBSCRIPTION_CONTRACT WHERE MEMBER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cc_id#"> AND IS_ACTIVE = 1 AND CANCEL_TYPE_ID IS NULL
</cfquery>
<cfif get_subscription_cc_id.recordcount eq 0>
	<cfif isdefined('attributes.c_id') and attributes.is_member eq 1>
		<cfquery name="upd_credit_card_status" datasource="#dsn#">
			UPDATE COMPANY_CC SET IS_DEFAULT = #attributes.is_default# WHERE COMPANY_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cc_id#">
		</cfquery>
	<cfelseif isdefined('attributes.c_id') and attributes.is_member eq 0>
		<cfquery name="upd_credit_card_status" datasource="#dsn#">
			UPDATE CONSUMER_CC SET IS_DEFAULT = #attributes.is_default# WHERE CONSUMER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cc_id#">
		</cfquery>
	</cfif>
	<script type="text/javascript">
		wrk_opener_reload();	
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='606.Kredi Kartı İle İlişkili Sistem Var'>!");
		wrk_opener_reload();	
		window.close();
	</script>
</cfif>

