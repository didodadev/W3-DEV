<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	del_account_card_document_type = netbook.delAccountCardDocumentType(
															doc_type_id : attributes.doc_type_id
																			);
</cfscript>
<cflocation url="#request.self#?fuseaction=account.form_add_account_card_document_type" addtoken="no">