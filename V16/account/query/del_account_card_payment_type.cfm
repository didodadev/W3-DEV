<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	del_account_card_payment_type = netbook.delAccountCardPaymentType(
															payment_type_id : attributes.payment_type_id
																			);
</cfscript>
<cflocation url="#request.self#?fuseaction=account.form_add_account_card_payment_type" addtoken="no">