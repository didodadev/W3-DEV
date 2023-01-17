<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	del_accountants = netbook.delAccountants();
</cfscript>
<cfloop from="1" to="#attributes.record_num#" index="i">
    <cf_date tarih='attributes.contract_start#i#'>
	<cfscript>
		if(evaluate('attributes.row_kontrol#i#') == 1) {
			addAccountant = netbook.addAccountant(
			consumer_id : val(attributes["consumer_id#i#"]),
			company_id : val(attributes["company_id#i#"]),
			partner_id : val(attributes["partner_id#i#"]),
			contract_date : attributes["contract_start#i#"],
			contract_no : attributes["contract_no#i#"],
			description : attributes["description#i#"]
			);
		}
    </cfscript>
</cfloop>
<cflocation url="#request.self#?fuseaction=account.form_netbook_accountants" addtoken="No">