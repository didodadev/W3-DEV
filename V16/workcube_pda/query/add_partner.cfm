<cfscript> 
    add_partner=CreateObject("component","cfc.addPartner"); 
	add_partner.dsn=dsn;
    max_partner_id = add_partner.addPartner(attributes: attributes);  

</cfscript>

<cflocation url="#request.self#?fuseaction=pda.list_company" addtoken="no">
