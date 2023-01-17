<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
	SELECT
		SUBSCRIPTION_ID,
		SUBSCRIPTION_NO,
		CONSUMER_ID,
		PARTNER_ID,
		COMPANY_ID,
		SHIP_ADDRESS		
	FROM 
		SUBSCRIPTION_CONTRACT
	WHERE
		SUBSCRIPTION_ID = #attributes.subscription_id#
</cfquery>
<cfif len(get_subscription.partner_id)>
	<cfscript>
		member_id_ = get_subscription.partner_id;
		company_id_ = get_subscription.company_id;
		company_name_ = get_par_info(get_subscription.partner_id,0,1,0);
		member_type_ = 'partner';
		member_name_ = get_par_info(get_subscription.partner_id,0,-1,0);
	</cfscript>
<cfelse>
	<cfscript>
		member_id_ = get_subscription.consumer_id;
		company_id_ = '';
		company_name_ = get_cons_info(get_subscription.consumer_id,2,0);
		member_type_ = 'consumer';
		member_name_ = get_cons_info(get_subscription.consumer_id,0,0);
	</cfscript>
</cfif>
