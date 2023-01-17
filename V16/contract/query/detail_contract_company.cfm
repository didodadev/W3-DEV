<cf_xml_page_edit fuseact="contract.detail_contract_company">
<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
	SELECT
		COMPANY_CREDIT_ID, 
		PROCESS_STAGE, 
		COMPANY_ID, 
		CONSUMER_ID, 
		OPEN_ACCOUNT_RISK_LIMIT, 
		OPEN_ACCOUNT_RISK_LIMIT_OTHER, 
		FORWARD_SALE_LIMIT,
		FORWARD_SALE_LIMIT_OTHER, 
		MONEY, 
		PAYMETHOD_ID, 
		FIRST_PAYMENT_INTEREST, 
		LAST_PAYMENT_INTEREST, 
		PAYMENT_BLOKAJ, 
		PAYMENT_BLOKAJ_TYPE, 
		OUR_COMPANY_ID, 
		BRANCH_ID, 
		SHIP_METHOD_ID, 
		PRICE_CAT, 
		PRICE_CAT_PURCHASE, 
		REVMETHOD_ID, 
		IS_INSTALMENT_INFO, 
		RECORD_DATE, 
		RECORD_EMP, 
		RECORD_IP, 
		RECORD_PAR, 
		UPDATE_DATE, 
		UPDATE_EMP, 
		UPDATE_IP, 
		TRANSPORT_COMP_ID, 
		TRANSPORT_DELIVER_ID, 
		IS_BLACKLIST, 
		BLACKLIST_INFO, 
		BLACKLIST_DATE, 
		CARD_REVMETHOD_ID, 
		CARD_PAYMETHOD_ID, 
		PAYMENT_RATE_TYPE
	FROM
		COMPANY_CREDIT
	WHERE
		<cfif isdefined("attributes.is_upd") and len(attributes.is_upd)>
			COMPANY_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_credit_id#">
		<cfelse>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			<cfelse>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
			</cfif>
			OUR_COMPANY_ID = <cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
							<cfelse>	
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
							</cfif>
		</cfif>
</cfquery>
<cfset our_comp_id_ = GET_CREDIT_LIMIT.OUR_COMPANY_ID>
<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
	SELECT
		COMP_ID,
		COMPANY_NAME
	FROM
		OUR_COMPANY
	WHERE
	  	COMP_ID = <cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
	  				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
	 			<cfelseif isdefined("attributes.is_upd") and len(attributes.is_upd)>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
	  			<cfelse>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				</cfif>
	ORDER BY
		COMPANY_NAME
</cfquery>

<cfsavecontent variable="head">
    <cf_get_lang dictionary_id='33034.Çalışma Koşulları'><cfoutput><cfif len(get_credit_limit.company_id)>: #get_par_info(get_credit_limit.company_id,1,0,0)#<cfelseif len(get_credit_limit.consumer_id)>: #get_cons_info(get_credit_limit.consumer_id,0,0)#</cfif></cfoutput>
</cfsavecontent>
<cfset pageHead = head>

<cf_catalystHeader>
<cfinclude template="../form/member_credit_risc_limit.cfm"><!--- Risk ve kredi limitleri--->
<script type="text/javascript">
function unformat_fields()
{
	my_round = '<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>';
	for(s=1;s<=add_credit.deger_get_money.value;s++)
	{
		$("#value_rate2"+s).val(filterNum($("#value_rate2"+s).val(),my_round));
		$("#txt_rate1_"+s).val(filterNum($("#txt_rate1_"+s).val(),my_round));
	}
	add_credit.open_account_risk_limit.value = filterNum(add_credit.open_account_risk_limit.value);
	add_credit.forward_sale_limit.value = filterNum(add_credit.forward_sale_limit.value);
	add_credit.payment_blokaj.value = filterNum(add_credit.payment_blokaj.value);
	add_credit.first_payment_interest.value = filterNum(add_credit.first_payment_interest.value);
	add_credit.last_payment_interest.value = filterNum(add_credit.last_payment_interest.value);
	add_credit.open_account_risk_limit_other_cash.value = filterNum(add_credit.open_account_risk_limit_other_cash.value);
	add_credit.forward_sale_limit_other_cash.value = filterNum(add_credit.forward_sale_limit_other_cash.value);
	return true;
}	
</script>
