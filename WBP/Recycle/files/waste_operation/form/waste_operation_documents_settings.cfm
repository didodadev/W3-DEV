<cfinclude template="../../header.cfm">

<cfquery name = "getDocuments" datasource = "#dsn#">
	SELECT
		*
	FROM
		#dsn_alias#.WASTE_OPERATION_DOCUMENTS
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>

<cfoutput>
	<div class="row">
		<cfform name="documentForm" id="documentForm">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box id="document" title="#getLang('','Atık Belgesi Dokümanları',63476)#">
					<input type="hidden" name="document_count" id="document_count" value="<cfoutput>#getDocuments.recordCount#</cfoutput>">
					<cf_grid_list sort="0">
						<thead>
							<tr>
								<th width="30"><a href="javascript://" onclick="addDocument()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								<th width="300"><cf_get_lang dictionary_id='57486.Kategori'></th>
								<th width="300"><cf_get_lang dictionary_id='42266.Doküman Adı'></th>
								<th width="300"><cf_get_lang dictionary_id='47739.Doküman'> <cf_get_lang dictionary_id='32646.Kodu'></th>
								<th width="300"><cf_get_lang dictionary_id='47739.Doküman'> <cf_get_lang dictionary_id='34970.Modül'></th>
								<th width="300"><cf_get_lang dictionary_id='47739.Doküman'> <cf_get_lang dictionary_id='34970.Modül'> <cf_get_lang dictionary_id='58527.ID'></th>
								<th width="300"><cf_get_lang dictionary_id='47739.Doküman'> <cf_get_lang dictionary_id='39091.Kategorisi'></th>
								<th width="300"><cf_get_lang dictionary_id='47739.Doküman'> <cf_get_lang dictionary_id='57951.Hedef'></th>
								<th width="300"><cf_get_lang dictionary_id='29777.İlişkili Alanlar'></th>
								<th width="30"></th>
							</tr>
						</thead>
						<tbody>
							<cfif getDocuments.recordCount>
								<cfloop query="getDocuments">
									<tr id="document_#currentrow#">
										<td>
											<input type="hidden" name="documentId#currentrow#" id="documentId#currentrow#" value="#DOC_ID#">
											<input type="hidden" class="deleted" name="documentDeleted#currentrow#" id="documentDeleted#currentrow#" value="0">
											<a style="cursor:pointer" onclick="removeItem('document_#currentrow#')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="category#currentrow#" id="category#currentrow#" value="#category#" required>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="name#currentrow#" id="name#currentrow#" value="#doc_name#" required>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="code#currentrow#" id="code#currentrow#" value="#doc_code#" required>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="module#currentrow#" id="module#currentrow#" value="#asset_module#" required>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="module_id#currentrow#" id="module_id#currentrow#" value="#asset_module_id#" required>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="assetcat#currentrow#" id="assetcat#currentrow#" value="#assetcat_id#" required>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="target#currentrow#" id="target#currentrow#" value="#asset_action#" required>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="related_fields#currentrow#" id="related_fields#currentrow#" value="#related_wo_fields#" required>
											</div>
										</td>
										<td class="text-center"><input type="checkbox" name="documentStatus#currentrow#" id="documentStatus#currentrow#" value="1" <cfif doc_status eq 1>checked</cfif>></td>
									</tr>
								</cfloop>
							</cfif>
						</tbody>
					</cf_grid_list>
					<cf_box_footer>
						<cf_workcube_buttons add_function="kontrol()">
					</cf_box_footer>
				</cf_box>
			</div>
		</cfform>
	</div>
</cfoutput>

<script type="text/javascript">
	function addDocument(){
		$("#document_count").val( parseInt($("#document_count").val()) + 1 );
		rowNum = parseInt($("#document_count").val());
		$("<tr>").attr({"id":"document_"+rowNum+""}).html('<td><a style="cursor:pointer" onclick="removeItem(\'document_'+rowNum+'\')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td><td><div class="form-group"><input type="hidden" name="documentId'+rowNum+'" id="documentId'+rowNum+'"><input type="hidden" class="deleted" name="documentDeleted'+rowNum+'" id="documentDeleted'+rowNum+'" value="0"><input type="text" name="category'+rowNum+'" id="category'+rowNum+'"></td><td><input type="text" name="name'+rowNum+'" id="name'+rowNum+'"></td><td><input type="text" name="code'+rowNum+'" id="code'+rowNum+'"></td><td><input type="text" name="module'+rowNum+'" id="module'+rowNum+'"></td><td><input type="text" name="module_id'+rowNum+'" id="module_id'+rowNum+'"></td><td><input type="text" name="assetcat'+rowNum+'" id="assetcat'+rowNum+'"></td><td><input type="text" name="target'+rowNum+'" id="target'+rowNum+'"></td><td><input type="text" name="related_fields'+rowNum+'" id="related_fields'+rowNum+'"></td><td class="text-center"><input type="checkbox" name="docstatus'+rowNum+'" id="docstatus'+rowNum+'" value="1" checked></td>').appendTo($("#body_document tbody"));
	}
	function removeItem(row_id) {
		if(confirm( "<cf_get_lang dictionary_id='62142.Silmek istediğinize emin misiniz?'>" )) $("tr#"+row_id+"").hide().find(".deleted").val(1);
	}
	function kontrol() {
		unformat_fields();
		return true;
	}

	function unformat_fields() {
		return true;
    }

</script>