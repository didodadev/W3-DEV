<!---
    File: add_data_category_type.cfm
    Author: 
    Date: 
    Controller: 
    Description:
		
--->
<cfscript>
	enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
	status = enums.get_status(is_form:true);
	type_comp = createObject("component","addons.devonomy.gdpr.cfc.data_category_type");
	types = type_comp.get_data_category_type();
	sensitivity_comp = createObject("component","addons.devonomy.gdpr.cfc.sensitivity_label");
	sensitivities = sensitivity_comp.get_sensitivity_label();

	if(Not isDefined("attributes.id")) attributes.id =  "";
	if(Not isDefined("attributes.data_category")) attributes.data_category =  "";  
	if(Not isDefined("attributes.data_category_description")) attributes.data_category_description = '';
	if(Not isDefined("attributes.sensitivity_label_id")) attributes.sensitivity_label_id = '';
	if(Not isDefined("attributes.is_active")) attributes.is_active = 1;
	if(Not isDefined("attributes.data_category_type_id")) attributes.data_category_type_id = 0;

	if(attributes.event == "upd"){
		if(len(attributes.id)){
			gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_category");
			gdpr_comp.dsn = dsn;
			gdpr_data = gdpr_comp.get_data_category_byId(DATA_CATEGORY_ID :'#attributes.id#');

			attributes.id = gdpr_data.data_category_id;
			attributes.data_category =   gdpr_data.data_category;  
			attributes.data_category_description = gdpr_data.data_category_description;
			attributes.data_category_type_id = gdpr_data.data_category_type_id;
			attributes.sensitivity_label_id = gdpr_data.sensitivity_label_id;
			attributes.is_active = gdpr_data.is_active;
		}else{
			writeOutput("<script>alert('Hata Oluştu');history.back();</script>");
			exit;
		}
	}
</cfscript>

<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="gdpr_data_category" id="gdpr_data_category" method="post" action="#request.self#?fuseaction=GDPR.welcome&event=upd&id=<cfoutput>#attributes.id#</cfoutput>">
			<input type="hidden" name="form_submitted" value="1" />
			<input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>" />
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="form-group" id="item-data_category">
						<label class="col col-4 col-xs-12" for="data_category"><cf_get_lang dictionary_id='61729.Veri Kategorisi'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="data_category" id="data_category" value="<cfoutput>#attributes.data_category#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-data_category_type_id">
						<label class="col col-4 col-xs-12" for="is_active"><cf_get_lang dictionary_id='61728.Veri Kategori Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="data_category_type_id" id="data_category_type_id">
								<cfoutput query="types">
									<option VALUE="#DATA_CATEGORY_TYPE_ID#" <cfif attributes.data_category_type_id eq DATA_CATEGORY_TYPE_ID>selected</cfif>>#DATA_CATEGORY_TYPE#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-sensitivity_label_id">
						<label class="col col-4 col-xs-12" for="sensitivity_label_id"><cf_get_lang dictionary_id='270.Güvenlik Seviyesi'></label>
						<div class="col col-8 col-xs-12">
							<select name="sensitivity_label_id" id="sensitivity_label_id">
								<option value="0">Seçiniz</option>
								<cfoutput query="sensitivities">
									<option VALUE="#SENSITIVITY_LABEL_ID#" <cfif attributes.sensitivity_label_id eq SENSITIVITY_LABEL_ID>selected</cfif>>#SENSITIVITY_LABEL#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-data_category_description">
						<label class="col col-4 col-xs-12" for="data_category_description"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="data_category_description" id="data_category_description"><cfoutput>#attributes.data_category_description#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-is_active">
						<label class="col col-4 col-xs-12" for="is_active"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-xs-12">
							<select name="is_active" id="is_active">
								<cfoutput>
								<cfloop index="st" array="#status#">
									<option VALUE="#st.value#" <cfif attributes.is_active eq st.value>selected</cfif>>#st.name#</option>
								</cfloop>
								</cfoutput>
							</select>
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
						<cf_workcube_buttons is_upd='1' is_delete="0" add_function="controlFormGdpr()"><!---  delete_page_url="#request.self#?fuseaction=gdpr.welcome&event=del&id=#attributes.id#" --->
					<cfelse>
						<cf_workcube_buttons is_upd='0' add_function="controlFormGdpr()">
					</cfif>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
    function controlFormGdpr()
    {
		if(!$("#data_category").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">');
			$("#data_category").focus();
			return false;
		}
		return true;
    }
</script>