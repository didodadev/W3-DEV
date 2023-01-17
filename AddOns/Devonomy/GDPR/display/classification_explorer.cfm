<cfsetting showdebugoutput="true"></cfsetting>
<cfscript>
cfparam(name="attributes.step",default="0");
cfparam(name="attributes.datasource",default="#dsn#");
cfparam(name="attributes.classification_type_id",default="1");
cfparam(name="attributes.page",default="1");
cfparam(name="attributes.totalrecords",default="0");
cfparam(name="attributes.maxrows",default="#session.ep.maxrows#");


enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
classitication_comp = createObject("component","addons.devonomy.gdpr.cfc.classification_explorer");
types = enums.get_classification_types();

if(attributes.step eq 2)
	datasources = classitication_comp.get_datasoruces(adminUser:"#attributes.adminUser#",adminPass:"#attributes.adminPass#");
	
</cfscript>

<cfif attributes.step eq 0>
	<cf_box>
		<cfform name="category" action="#request.self#?fuseaction=#url.fuseaction#&event=explorer&data_officer_id=#attributes.data_officer_id#">
			<input type="hidden" name="step" id="step" value="1" />
			<cf_box_search plus="0">
				<div class="form-group large">
					<select id="classification_type_id" name="classification_type_id">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput>
						<cfloop index="st" array="#types#">
							<option VALUE="#st.value#" <cfif attributes.classification_type_id eq st.value>selected</cfif>>#st.name#</option>
						</cfloop>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
<cfelseif attributes.step eq 1>
	<cf_box>
		<cfform name="category" action="#request.self#?fuseaction=#url.fuseaction#&event=explorer&data_officer_id=#attributes.data_officer_id#">
			<input type="hidden" name="step" id="step" value="2" />
			<input type="hidden" name="classification_type_id" id="step" value="<cfoutput>#attributes.classification_type_id#</cfoutput>" />
			<cf_box_search plus="0">
				<div class="form-group">
					<div class="form-group" id="item-adminUser">
						<label class="col col-4 col-xs-12" for="adminUser"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="adminUser" id="adminUser" value="" required="yes" maxlength="50">
						</div>
					</div>
				</div>
				<div class="form-group">
					<div class="form-group" id="item-adminPass">
						<label class="col col-4 col-xs-12" for="adminPass"><cf_get_lang dictionary_id='57552.Şifre'></label>
						<div class="col col-8 col-xs-12">
							<input type="password" name="adminPass" id="adminPass" value="" required="yes" maxlength="50">
						</div>
					</div>
				</div>
			
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
<cfelseif attributes.step eq 2>
	<cf_box>
		<cfform name="category" action="#request.self#?fuseaction=#url.fuseaction#&event=explorer&data_officer_id=#attributes.data_officer_id#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			<input type="hidden" name="step" id="step" value="3" />
			<input type="hidden" name="classification_type_id" id="step" value="<cfoutput>#attributes.classification_type_id#</cfoutput>" />
			<cf_box_search more="0">
				<cfif attributes.classification_type_id eq "1">
				<div class="form-group">
					<select id="datasource" name="datasource">
						<cfoutput>
						<cfloop collection="#datasources#" item="dsn_name">
							<option VALUE="#dsn_name#" <cfif attributes.datasource eq dsn_name>selected</cfif>>#dsn_name#</option>
						</cfloop>
						</cfoutput>
					</select>
				</div>
				<cfelseif attributes.classification_type_id eq "2">
					<div class="form-group large">COLLECTIONLAR</div>
				</cfif>
				<div class="form-group">
					<cf_wrk_search_button button_type=4>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
<cfelse>
<cfscript>
	attributes.startrow=((attributes.page-1)*attributes.maxrows)+1
	if (isdefined("attributes.form_submitted")){
		if(isdefined("attributes.selected_row")){
			classification_comp = createObject("component","addons.devonomy.gdpr.cfc.classification");
			classification_comp.dsn = dsn;
			myArray=listToArray(attributes.selected_row,",",false,true);

			for(id in myArray) {
				if(evaluate('attributes.classification_type_id_' & id) eq 1){
					//DB
					if(NOT classification_comp.add_classification(
						data_officer_id:'#attributes.data_officer_id#',
						classification_type_id: evaluate('attributes.classification_type_id_' & id),
						data_category_id: evaluate('attributes.data_category_id_' & id),
						db_name: evaluate('attributes.db_name_' & id),
						schema_name:  evaluate('attributes.schema_name_' & id),
						table_name:  evaluate('attributes.table_name_' & id),
						column_name:  evaluate('attributes.column_name_' & id),
						classification_description:  evaluate('attributes.classification_description_' & id)))
					{
						alert("Bazı kayıtlar atılamadı!!");
					}
				} 
				else{
					//File
					if(NOT classification_comp.add_classification(
						data_officer_id:'#attributes.data_officer_id#',
						classification_type_id: evaluate('attributes.classification_type_id_' & id),
						data_category_id: evaluate('attributes.data_category_id_' & id),
						file_path: evaluate('attributes.file_path_' & id),
						classification_description:  evaluate('attributes.classification_description_' & id)))
					{
						alert("Bazı kayıtlar atılamadı!!");
					}
				}
			
			}
		}

		classitication_data = classitication_comp.get_data_classification_for_db(
			fn_dsn: '#attributes.datasource#',
			data_officer_id:'#attributes.data_officer_id#'
		);
		data_category_comp = createObject("component","addons.devonomy.gdpr.cfc.data_category");
		data_category_comp.dsn = dsn;
		data_categories = data_category_comp.get_data_category();

		sensitivity_label_comp = createObject("component","addons.devonomy.gdpr.cfc.sensitivity_label");
		sensitivity_labels = sensitivity_label_comp.get_sensitivity_label();

	}else{
		classitication_data.recordcount = 0;
	}
</cfscript>
<cf_box title="Data Classifications Explorer" uidrop="1" hide_table_column="1">
<cfform name="category" action="#request.self#?fuseaction=#url.fuseaction#&event=explorer&data_officer_id=#attributes.data_officer_id#">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
	<input type="hidden" name="step" id="step" value="3" />
	<input type="hidden" name="DATASOURCE" id="DATASOURCE" value="<cfoutput>#ATTRIBUTES.DATASOURCE#</cfoutput>" />
	<input type="hidden" name="classification_type_id" id="step" value="<cfoutput>#attributes.classification_type_id#</cfoutput>" />
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
				<th><cf_get_lang dictionary_id='32828.Anahtar Kelime'></th>
				<th><cf_get_lang dictionary_id='61769.Sınıflandırma Tipi'></th>
				<th><cf_get_lang dictionary_id='61729.Veri Kategorisi'></th>
				<th><cf_get_lang dictionary_id='270.Güvenlik Seviyesi'></th>
				<cfif attributes.classification_type_id eq 1>
					<th><cf_get_lang dictionary_id='42215.Veri Tabanı'></th>
					<th><cf_get_lang dictionary_id='33591.Schema'></th>
					<th><cf_get_lang dictionary_id='38752.Tablo'></th>
					<th><cf_get_lang dictionary_id='43058.Kolon'></th>
				<cfelse>
					<th><cf_get_lang dictionary_id='49955.Dosya Yolu'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
				<!-- sil -->
				<th width="35">
					<input type="checkbox" name="all_check" id="all_check" value="1">
				</th>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif classitication_data.recordcount>
				<!--- <cfset attributes.totalrecords = gdpr_data.query_count>	 --->
				<cfoutput query="classitication_data">
					<tr>
						<cfif CLASSIFICATION_ID gt 0>
							<td width="35">#currentrow#</td>
							<td>#KEYWORD#</td>
							<td>#types[ArrayFind(types, function(struct){ return struct.value == CLASSIFICATION_TYPE_ID;} )]["name"]#</td>
							<td>#data_category#</td>
							<td>#SENSITIVITY_LABEL#</td>
							<cfif attributes.classification_type_id eq 1>
								<td>#DB_NAME#</td>
								<td>#SCHEMA_NAME#</td>
								<td>#TABLE_NAME#</td>
								<td>#COLUMN_NAME#</td>
							<cfelse>
								<td>#FILE_PATH#</td>
							</cfif>
							<td>#CLASSIFICATION_DESCRIPTION#</td>
							<!-- sil -->
							<td><a href="#url.fuseaction# kaydın güncelle&id=#CLASSIFICATION_ID#" target="_blank"><i class="icon-check"></i></a></td>
							<!-- sil -->
						<cfelse> 
							<td width="35">#currentrow#</td>
							<td>#KEYWORD#</td>
							<td>#types[ArrayFind(types, function(struct){ return struct.value == CLASSIFICATION_TYPE_ID;} )]["name"]#</td>
							<td>
								<div class="form-group">
									<select id="DATA_CATEGORY_ID_#currentrow#" name="DATA_CATEGORY_ID_#currentrow#">
										<cfloop query="data_categories">
											<option value="#data_categories.data_category_id#" <cfif classitication_data.DATA_CATEGORY_ID eq data_categories.data_category_id>selected</cfif>>#data_categories.data_category#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<td>
								<div class="form-group">
									<select id="SENSITIVITY_LABEL_ID_#currentrow#" name="SENSITIVITY_LABEL_ID_#currentrow#">
										<cfloop query="sensitivity_labels">
											<option value="#sensitivity_labels.sensitivity_label_id#" <cfif classitication_data.sensitivity_label_id eq sensitivity_labels.sensitivity_label_id>selected</cfif>>#sensitivity_labels.sensitivity_label#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<cfif attributes.classification_type_id eq 1>
								<td>#DB_NAME#</td>
								<td>#SCHEMA_NAME#</td>
								<td>#TABLE_NAME#</td>
								<td>#COLUMN_NAME#</td>
							<cfelse>
								<td>#FILE_PATH#</td>
							</cfif>
							<td><textarea name="CLASSIFICATION_DESCRIPTION_#currentrow#" id="CLASSIFICATION_DESCRIPTION_#currentrow#" maxlength="500">#CLASSIFICATION_DESCRIPTION#</textarea></td>
							<!-- sil -->
							<td>
								<div class="form-group">
									<input type="checkbox" name="selected_row" id="selected_row" value="#currentrow#">
									<input type="hidden" name="CLASSIFICATION_TYPE_ID_#currentrow#" id="CLASSIFICATION_TYPE_ID_#currentrow#" value="#CLASSIFICATION_TYPE_ID#">
									<cfif attributes.classification_type_id eq 1>
										<input type="hidden" name="DB_NAME_#currentrow#" id="DB_NAME_#currentrow#" value="#DB_NAME#">
										<input type="hidden" name="SCHEMA_NAME_#currentrow#" id="SCHEMA_NAME_#currentrow#" value="#SCHEMA_NAME#">
										<input type="hidden" name="TABLE_NAME_#currentrow#" id="TABLE_NAME_#currentrow#" value="#TABLE_NAME#">
										<input type="hidden" name="COLUMN_NAME_#currentrow#" id="COLUMN_NAME_#currentrow#" value="#COLUMN_NAME#">
									<cfelse>
										<input type="hidden" name="FILE_PATH_#currentrow#" id="FILE_PATH_#currentrow#" value="#FILE_PATH#">
									</cfif>
								</div>
							</td>
							<!-- sil -->
						</cfif>
					</tr>
				</cfoutput>
				<tfoot>
					<tr>
						<td colspan="<cfif attributes.classification_type_id eq 1>11<cfelse>8</cfif>">
							<div class="ui-form-list-btn"><cf_workcube_buttons is_upd="0"></div>		
						</td>
					</tr>
				</tfoot>
			<cfelse>
				<tr>
					<td colspan="16">
						<cf_get_lang_main no='72.Kayıt Yok'>
					</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>	
</cfform>
</cf_box>
</cfif>
<!---<cfscript>
	url_str = attributes.fuseaction;
	if(isDefined('attributes.keyword') and len(attributes.keyword))url_str = url_str&"&keyword="&attributes.keyword;
	if(isDefined('attributes.status') and len(attributes.solution))url_str = url_str&"&status="&attributes.status;
	if(isdefined('form_submitted'))url_str = url_str&"&form_submitted=1";
</cfscript>
 <cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#url_str#"> --->