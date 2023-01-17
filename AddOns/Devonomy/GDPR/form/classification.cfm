<!---
    File: add_classificaiton.cfm
    Author: 
    Date: 
    Controller: 
    Description:
		
--->
<cfscript>
	enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
	classification_types = enums.get_classification_types();
	data_category_comp = createObject("component","addons.devonomy.gdpr.cfc.data_category");
	data_categories = data_category_comp.get_data_category();
	sensitivity_label_comp = createObject("component","addons.devonomy.gdpr.cfc.sensitivity_label");
	sensitivity_labels = sensitivity_label_comp.get_sensitivity_label();
	

	if(Not isDefined("attributes.id")) attributes.id = "";
	if(Not isDefined("attributes.classification_type_id")) attributes.classification_type_id = "";  
	if(Not isDefined("attributes.data_category_id")) attributes.data_category_id = "";
	if(Not isDefined("attributes.sensitivity_label_id")) attributes.sensitivity_label_id = "";
	if(Not isDefined("attributes.db_name")) attributes.db_name = "";
	if(Not isDefined("attributes.schema_name")) attributes.schema_name = "";
	if(Not isDefined("attributes.table_name")) attributes.table_name = "";
	if(Not isDefined("attributes.column_name")) attributes.column_name = "";
	if(Not isDefined("attributes.file_path")) attributes.file_path = "";
	if(Not isDefined("attributes.classification_description")) attributes.classification_description = "";
	if(Not isDefined("attributes.plevne_door")) attributes.plevne_door = 0;
	if(Not isDefined("attributes.key_column")) attributes.key_column = "";
	if(Not isDefined("attributes.data_fuseaction")) attributes.data_fuseaction = "";

	if(attributes.event == "upd"){
		if(len(attributes.id)){
			gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.classification");
			gdpr_comp.dsn = dsn;
			gdpr_data = gdpr_comp.get_classification_byId(classification_id :'#attributes.id#');

			attributes.id = gdpr_data.classification_id;
			attributes.data_officer_id = gdpr_data.data_officer_id;
			attributes.classification_type_id =   gdpr_data.classification_type_id;  
			attributes.data_category_id = gdpr_data.data_category_id;
			attributes.sensitivity_label_id = gdpr_data.sensitivity_label_id;
			attributes.db_name = gdpr_data.db_name;
			attributes.schema_name = gdpr_data.schema_name;
			attributes.table_name = gdpr_data.table_name;
			attributes.column_name = gdpr_data.column_name;
			attributes.file_path = gdpr_data.file_path;
			attributes.classification_description = gdpr_data.classification_description;
			attributes.plevne_door = gdpr_data.plevne_door;
			attributes.key_column = gdpr_data.key_column;
			attributes.data_fuseaction = gdpr_data.fuseaction;
		}else{
			writeOutput("<script>alert('Hata Oluştu');</script>");
			exit;
		}
	}
</cfscript>

<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="gdpr_classification" id="gdpr_classification" method="post" action="<cfoutput>#request.self#</cfoutput>?data_fuseaction=GDPR.data_classification&event=upd&id=<cfoutput>#attributes.id#</cfoutput>">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>" />
			<input type="hidden" name="data_officer_id" id="id" value="<cfoutput>#attributes.data_officer_id#</cfoutput>" />
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-0" type="column" index="1" sort="true">
					<div class="form-group" id="item-classification_type_id">
						<label class="col col-4 col-xs-12" for="classification_type_id"><cf_get_lang dictionary_id='51270.Arama Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="classification_type_id" id="classification_type_id"<!---  onchange="updateFormFields(this);" --->>
								<cfoutput>
								<cfloop index="kst" array="#classification_types#">
									<option VALUE="#kst.value#" <cfif attributes.classification_type_id eq kst.value>selected</cfif>>#kst.name#</option>
								</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-data_category_id">
						<label class="col col-4 col-xs-12" for="data_category_id"><cf_get_lang dictionary_id='61729.Veri Kategorisi'></label>
						<div class="col col-8 col-xs-12">
							<select name="data_category_id" id="data_category_id">
								<cfoutput query="data_categories">
									<option VALUE="#DATA_CATEGORY_ID#" <cfif attributes.data_category_id eq DATA_CATEGORY_ID>selected</cfif>>#DATA_CATEGORY#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-sensitivity_label_id">
						<label class="col col-4 col-xs-12" for="sensitivity_label_id"><cf_get_lang dictionary_id='270.Güvenlik Seviyesi'></label>
						<div class="col col-8 col-xs-12">
							<select name="sensitivity_label_id" id="sensitivity_label_id">
								<cfoutput query="sensitivity_labels">
									<option VALUE="#SENSITIVITY_LABEL_ID#" <cfif attributes.sensitivity_label_id eq SENSITIVITY_LABEL_ID>selected</cfif>>#SENSITIVITY_LABEL#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-db_name">
						<label class="col col-4 col-xs-12" for="db_name"><cf_get_lang dictionary_id='42215.Veri Tabanı'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="db_name" id="db_name" value="<cfoutput>#attributes.db_name#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-schema_name">
						<label class="col col-4 col-xs-12" for="schema_name"><cf_get_lang dictionary_id='33591.Schema'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="schema_name" id="schema_name" value="<cfoutput>#attributes.schema_name#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-table_name">
						<label class="col col-4 col-xs-12" for="table_name"><cf_get_lang dictionary_id='38752.Tablo'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="table_name" id="table_name" value="<cfoutput>#attributes.table_name#</cfoutput>">
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-0" type="column" index="2" sort="true">
					<div class="form-group" id="item-column_name">
						<label class="col col-4 col-xs-12" for="column_name"><cf_get_lang dictionary_id='43058.Kolon'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="column_name" id="column_name" value="<cfoutput>#attributes.column_name#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-key_column">
						<label class="col col-4 col-xs-12" for="column_name"><cf_get_lang dictionary_id='48918.Anahtar'><cf_get_lang dictionary_id='43058.Kolon'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="key_column" id="key_column" value="<cfoutput>#attributes.key_column#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-plevne_door">
						<label class="col col-4 col-xs-12" for="plevne_door"><cf_get_lang dictionary_id='61764.WAS Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="plevne_door" id="plevne_door">
								<option value="0">Seçiniz</option>
								<option value="1" <cfif attributes.plevne_door eq 1>selected</cfif>>1</option>
								<option value="2" <cfif attributes.plevne_door eq 2>selected</cfif>>2</option>
								<option value="3" <cfif attributes.plevne_door eq 3>selected</cfif>>3</option>
								<option value="4" <cfif attributes.plevne_door eq 4>selected</cfif>>4</option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-data_fuseaction">
						<label class="col col-4 col-xs-12" for="column_name"><cf_get_lang dictionary_id='52734.WO'>-<cf_get_lang dictionary_id='36185.Fuseaction'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="data_fuseaction" id="data_fuseaction" value="<cfoutput>#attributes.data_fuseaction#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-file_path">
						<label class="col col-4 col-xs-12" for="file_path"><cf_get_lang dictionary_id='49955.Dosya Yolu'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="file_path" id="file_path" value="<cfoutput>#attributes.file_path#</cfoutput>">
						</div>
					</div>
					
					<div class="form-group" id="item-classification_description">
						<label class="col col-4 col-xs-12" for="classification_description"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="classification_description" id="classification_description"><cfoutput>#attributes.classification_description#</cfoutput></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6">
					<cfif isDefined("gdpr_data") and gdpr_data.RecordCount gt 0>
						<cf_record_info query_name="gdpr_data">
					</cfif>
				</div>
				<div class="col col-6">
					<cfif attributes.event EQ "upd">
						<cf_workcube_buttons is_upd='1' is_del="1" add_function="controlFormGdpr()" delete_page_url="#request.self#?fuseaction=gdpr.data_classification&event=del&id=#attributes.id#&data_officer_id=#attributes.data_officer_id#">
					<cfelse>
						<cf_workcube_buttons is_upd='0' add_function="controlFormGdpr()">
					</cfif>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function updateFormFields(obj){
	alert(obj);
}
    function controlFormGdpr()
    {
		if(!$("#column_name").val().length && !$("#file_path").val().length)
		{
			alert('<cf_get_lang dictionary_id='58194.Zorunlu Alan'>');
			$("#column_name").focus();
			return false;
		}
		return true;
    }
</script>