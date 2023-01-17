<cfquery name="get_our_company" datasource="#dsn#">
	SELECT
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.NICK_NAME,
		OUR_COMPANY_INFO.IS_EDEFTER
	FROM
		OUR_COMPANY
			LEFT JOIN OUR_COMPANY_INFO ON OUR_COMPANY_INFO.COMP_ID = OUR_COMPANY.COMP_ID
	WHERE IS_EDEFTER = 1
	ORDER BY
		NICK_NAME
</cfquery>
<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	netbook.dsn2 = dsn2;
	get_account_card_document_type = netbook.getAccountCardDocumentTypes(
		doc_type_id : attributes.document_type_id
	);
	checkIfUsed = netbook.checkDocumentTypeIfUsed(
		doc_type_id : attributes.document_type_id
	);
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='55096.Belge Tipleri'></cfsavecontent>
	<cf_box title="#message#" add_href="#request.self#?fuseaction=account.form_add_account_card_document_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_account_card_document_type.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform action="#request.self#?fuseaction=account.emptypopup_upd_account_card_document_type" method="post" name="account_card_document_type">
				<cfinput type="hidden" name="document_type_id" id="document_type_id" value="#url.document_type_id#">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"> <cf_get_lang dictionary_id="58533.Belge Tipi">*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="Text" <cfif attributes.document_type_id lt 0 or checkIfUsed eq 1>readonly</cfif> name="document_type" id="document_type" value="<cfoutput>#get_account_card_document_type.document_type#</cfoutput>" maxlength="150">
									<span class="input-group-addon">
										<cf_language_info 
										table_name="ACCOUNT_CARD_DOCUMENT_TYPES" 
										column_name="DOCUMENT_TYPE" 
										column_id_value="#url.document_type_id#" 
										maxlength="500" 
										datasource="#dsn#" 
										column_id="DOCUMENT_TYPE_ID" 
										control_type="0">
									</span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
						<div class="form-group">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
								<input <cfif attributes.document_type_id lt 0>disabled</cfif> type="checkbox" name="is_active" id="is_active" value="1" <cfif isdefined("get_account_card_document_type.is_active") and get_account_card_document_type.is_active eq 1>checked</cfif>/><cf_get_lang dictionary_id='57493.Aktif'>
							</div>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
								<input <cfif attributes.document_type_id lt 0>disabled</cfif> type="checkbox" name="is_other" id="is_other" value="1" <cfif get_account_card_document_type.is_other eq 1>checked</cfif> onclick="<cfif get_account_card_document_type.document_type_id lt 0>return false</cfif>"/><cf_get_lang dictionary_id='58156.Diğer'>
							</div>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="3" type="column" sort="true">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="Text" name="detail" id="detail" value="<cfoutput>#get_account_card_document_type.detail#</cfoutput>" maxlength="250">
									<span class="input-group-addon">
										<cf_language_info 
										table_name="ACCOUNT_CARD_DOCUMENT_TYPES" 
										column_name="DETAIL" 
										column_id_value="#url.document_type_id#" 
										maxlength="500" 
										datasource="#dsn#" 
										column_id="DOCUMENT_TYPE_ID" 
										control_type="0">
									</span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="gizli1">
								<select name="our_company_id" id="our_company_id" multiple style="width:150px;height:75px;">
									<cfoutput query="get_our_company">
										<option value="#comp_id#" <cfif listfind(get_account_card_document_type.our_company_id,comp_id)>selected</cfif>>#nick_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="get_account_card_document_type">
						<cfif attributes.document_type_id lt 0 or checkIfUsed eq 1>
							<cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
						<cfelse>
							<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=account.emptypopup_del_account_card_document_type&DOC_TYPE_ID=#attributes.DOCUMENT_TYPE_ID#' add_function="kontrol()">
						</cfif>
				</cf_box_footer>
			</cfform>
		</div>
<script>
	function kontrol()
	{
		if(document.getElementById('document_type').value == '')
		{
			alert('<cf_get_lang dictionary_id='30059.Belge Tipi Girmelisiniz'>!')
			return false;
		}
		if(document.getElementById('document_type').value != '' && document.getElementById('detail').value == '')
		{
			alert('<cf_get_lang dictionary_id='33337.Açıklama Girmelisiniz'>!')
			return false;
		}

	}
</script>
