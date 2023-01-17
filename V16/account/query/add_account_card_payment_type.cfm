<cfif len(attributes.payment_type)>
	<cfscript>
        netbook = createObject("component","V16.e_government.cfc.netbook");
        netbook.dsn = dsn;
        if(isdefined('attributes.is_active')) { is_active = attributes.is_active; } else { is_active = 0; }
        addAccountCardPaymentTypes = netbook.addAccountCardPaymentTypes(
                                        is_active : is_active,
                                        payment_type : attributes.payment_type,
                                        detail : attributes.detail
                                                );
    </cfscript>
</cfif>
<cflocation url="#request.self#?fuseaction=account.form_add_account_card_payment_type" addtoken="no">