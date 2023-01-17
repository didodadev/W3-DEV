<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	if(isdefined('attributes.is_active'))is_active = 1;else is_active = 0;
	updAccountCardPaymentTypes = netbook.updAccountCardPaymentTypes(
									is_active : is_active,
                                    payment_type : attributes.payment_type,
									detail : attributes.detail,
									payment_type_id : attributes.payment_type_id
											);
</cfscript>
<cflocation url="#request.self#?fuseaction=account.form_upd_account_card_payment_type&payment_type_id=#attributes.payment_type_id#" addtoken="no">