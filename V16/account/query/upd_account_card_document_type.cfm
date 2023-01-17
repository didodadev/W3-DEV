<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	if(isdefined('attributes.is_other')) { is_other = attributes.is_other; } else { is_other = 0; }
	if(isdefined('attributes.is_active')) { is_active = attributes.is_active; } else { is_active = 0; }
	if(isdefined('attributes.our_company_id')) { our_company_id = attributes.our_company_id; } else { our_company_id = 'NULL'; }
	updAccountCardDocumentTypes = netbook.updAccountCardDocumentTypes(
									is_active : is_active,
									is_other : is_other,
									document_type : attributes.document_type,
									detail : attributes.detail,
									our_company_id : our_company_id,
									document_type_id : attributes.document_type_id
											);
</cfscript>
<cflocation url="#request.self#?fuseaction=account.form_upd_account_card_document_type&document_type_id=#attributes.document_type_id#" addtoken="no">