<!---
    File: data_inventory.cfm
    Author: 
    Date: 
    Controller: 
    Description:
		
--->
<cfscript>

	if(Not isDefined("attributes.id")) attributes.id =  "";
	if(Not isDefined("attributes.data_officer_id")) attributes.data_officer_id =  "";
	if(Not isDefined("attributes.data_inventory")) attributes.data_inventory =  "";  
	if(Not isDefined("attributes.data_inventory_description")) attributes.data_inventory_description = '';
	if(Not isDefined("attributes.data_inventory_legal_justification")) attributes.data_inventory_legal_justification = '';
	if(Not isDefined("attributes.data_category_id")) attributes.data_category_id = '';
	if(Not isDefined("attributes.data_subject_group_id")) attributes.data_subject_group_id = 0;
	if(Not isDefined("attributes.is_transfer")) attributes.is_transfer = false;
	if(Not isDefined("attributes.is_foreign_transfer")) attributes.is_foreign_transfer = false;
	if(Not isDefined("attributes.storage_type")) attributes.storage_type = '';
	if(Not isDefined("attributes.period")) attributes.period = '';
	if(Not isDefined("attributes.is_active")) attributes.is_active = '';

	//is_foreign_transfer detail 
	if(Not isDefined("attributes.data_inventory_transfer_id")) attributes.data_inventory_transfer_id = '';
	if(Not isDefined("attributes.transfer_detail")) attributes.transfer_detail = '';
	if(Not isDefined("attributes.adequate_protection")) attributes.adequate_protection = false;
	if(Not isDefined("attributes.corporation_desicion")) attributes.corporation_desicion = false;
	if(Not isDefined("attributes.written_commitment")) attributes.written_commitment = false;
	if(Not isDefined("attributes.clear_consent")) attributes.clear_consent = false;
	if(Not isDefined("attributes.other_law")) attributes.other_law = false;

	gdpr_comp = new addons.devonomy.gdpr.cfc.data_inventory(data_officer_id:attributes.data_officer_id);
	enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
	status = enums.get_status(is_form:true);
	storage_types = enums.get_storage_types();
	data_category_comp = createObject("component","addons.devonomy.gdpr.cfc.data_category");
	data_categories = data_category_comp.get_data_category();
	data_subject_group_comp = createObject("component","addons.devonomy.gdpr.cfc.data_subject_group");
	data_subject_groups = data_subject_group_comp.get_data_subject_group();


	if(attributes.event == "upd"){
		if(len(attributes.id)){
			gdpr_comp = new addons.devonomy.gdpr.cfc.data_inventory(data_officer_id:attributes.data_officer_id )
			gdpr_data = gdpr_comp.get_data_inventory_byId(data_inventory_id :'#attributes.id#');

			attributes.id = gdpr_data.data_inventory_id;
			attributes.data_officer_id = gdpr_data.data_officer_id;
			attributes.data_inventory = gdpr_data.data_inventory;  
			attributes.data_inventory_description = gdpr_data.data_inventory_description;
			attributes.data_inventory_legal_justification = gdpr_data.data_inventory_legal_justification;
			attributes.data_category_id = gdpr_data.data_category_id;
			attributes.data_subject_group_id = gdpr_data.data_subject_group_id;
			if(len(gdpr_data.is_transfer))
				attributes.is_transfer = gdpr_data.is_transfer;
			if(len(gdpr_data.is_foreign_transfer))
				attributes.is_foreign_transfer = gdpr_data.is_foreign_transfer;
			attributes.storage_type = gdpr_data.storage_type;
			attributes.period = gdpr_data.period;
			attributes.is_active = gdpr_data.is_active;

			if(attributes.is_foreign_transfer){
				gdpr_transfer_comp = new addons.devonomy.gdpr.cfc.data_inventory_transfer(data_officer_id:attributes.data_officer_id,data_inventory_id:attributes.id )
				gdpr_transfer_data = gdpr_transfer_comp.get_data_inventory_transfer(data_officer_id:attributes.data_officer_id,data_inventory_id:attributes.id);
				
				if(gdpr_transfer_data.recordCount > 0){
					attributes.data_inventory_transfer_id = gdpr_transfer_data.data_inventory_transfer_id;
					attributes.transfer_detail = gdpr_transfer_data.transfer_detail;
					attributes.adequate_protection = gdpr_transfer_data.adequate_protection;
					attributes.corporation_desicion = gdpr_transfer_data.corporation_desicion;
					attributes.written_commitment = gdpr_transfer_data.written_commitment;
					attributes.clear_consent = gdpr_transfer_data.clear_consent;
					attributes.other_law = gdpr_transfer_data.other_law;
				}
			}
			
		}else{
			writeOutput("<script>alert('Hata Oluştu');</script>");
			exit;
		}
	}
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="gdpr_data_inventory" id="gdpr_data_inventory" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=GDPR.welcome&event=upd&data_officer_id=<cfoutput>#attributes.data_officer_id#</cfoutput>&id=<cfoutput>#attributes.id#</cfoutput>">
			<input type="hidden" name="form_submitted" value="1" />
			<input type="hidden" name="data_officer_id" value="<cfoutput>#attributes.data_officer_id#</cfoutput>" />
			<input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>" />
			<input type="hidden" name="data_inventory_transfer_id" value="<cfoutput>#attributes.data_inventory_transfer_id#</cfoutput>" />
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-0" type="column" index="1" sort="true">
					<div class="form-group" id="item-data_inventory">
						<label class="col col-4 col-xs-12" for="data_inventory"><cf_get_lang dictionary_id='61755.Veri Envanteri'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="data_inventory" id="data_inventory" value="<cfoutput>#attributes.data_inventory#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-data_inventory_description">
						<label class="col col-4 col-xs-12" for="data_inventory_description"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="data_inventory_description" id="data_inventory_description"><cfoutput>#attributes.data_inventory_description#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-data_category_id">
						<label class="col col-4 col-xs-12" for="data_category_id"><cf_get_lang dictionary_id='61749.Veri Sorumlusu'></label>
						<div class="col col-8 col-xs-12">
							<select name="data_category_id" id="data_category_id">
								<cfoutput query="data_categories">
									<option VALUE="#DATA_CATEGORY_ID#" <cfif attributes.data_category_id eq DATA_CATEGORY_ID>selected</cfif>>#DATA_CATEGORY#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-storage_type">
						<label class="col col-4 col-xs-12" for="storage_type"><cf_get_lang dictionary_id='61756.Depolama Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="storage_type" id="storage_type">
								<cfoutput>
								<cfloop index="st" array="#storage_types#">
									<option VALUE="#st.value#" <cfif attributes.storage_type eq st.value>selected</cfif>>#st.name#</option>
								</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-period">
						<label class="col col-4 col-xs-12" for="period"><cf_get_lang dictionary_id='30633.Periyod'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="period" id="period" value="<cfoutput>#attributes.period#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-is_transfer">
						<label class="col col-4 col-xs-12" for="is_transfer"><cf_get_lang dictionary_id='58568.Transfer'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_transfer" id="is_transfer" value="true" <cfif attributes.is_transfer>checked</cfif>>
						</div>
					</div>
					<div class="form-group" id="item-is_foreign_transfer">
						<label class="col col-4 col-xs-12" for="is_foreign_transfer"><cf_get_lang dictionary_id='61758.Dışarı Aktarım'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" onclick="initForeignTransfer();" name="is_foreign_transfer" id="is_foreign_transfer" value="true" <cfif attributes.is_foreign_transfer>checked</cfif>>
						</div>
					</div>
					<div id="div_is_foreign_transfer_detail">
						<div class="form-group" id="item-adequate_protection">
							<label class="col col-4 col-xs-12" for="adequate_protection"><cf_get_lang dictionary_id='61760.Yeterli Koruma'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="adequate_protection" id="adequate_protection" value="true" <cfif attributes.adequate_protection>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-corporation_desicion">
							<label class="col col-4 col-xs-12" for="corporation_desicion"><cf_get_lang dictionary_id='61759.Şirket Kararı'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="corporation_desicion" id="corporation_desicion" value="true" <cfif attributes.corporation_desicion>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-written_commitment">
							<label class="col col-4 col-xs-12" for="written_commitment"><cf_get_lang dictionary_id='61761.Yazılı Taahhüt'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="written_commitment" id="written_commitment" value="true" <cfif attributes.written_commitment>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-clear_consent">
							<label class="col col-4 col-xs-12" for="clear_consent"><cf_get_lang dictionary_id='61762.Açık İzin'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="clear_consent" id="clear_consent" value="true" <cfif attributes.clear_consent>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-other_law">
							<label class="col col-4 col-xs-12" for="other_law"><cf_get_lang dictionary_id='61763.Diğer Kanun'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="other_law" id="other_law" value="true" <cfif attributes.other_law>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-transfer_detail">
							<label class="col col-4 col-xs-12" for="transfer_detail"><cf_get_lang dictionary_id='57771.Detay'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="transfer_detail" id="transfer_detail"><cfoutput>#attributes.transfer_detail#</cfoutput></textarea>
							</div>
						</div>
					<br></div>
					<div class="form-group" id="item-data_subject_group_id">
						<label class="col col-4 col-xs-12" for="data_subject_group_id"><cf_get_lang dictionary_id='61737.Veri Konusu Grubu'></label>
						<div class="col col-8 col-xs-12">
							<select name="data_subject_group_id" id="data_subject_group_id">
								<cfoutput query="data_subject_groups">
									<option VALUE="#DATA_SUBJECT_GROUP_ID#" <cfif attributes.data_subject_group_id eq data_subject_groups.DATA_SUBJECT_GROUP_ID>selected</cfif>>#DATA_SUBJECT_GROUP#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-data_inventory_legal_justification">
						<label class="col col-4 col-xs-12" for="data_inventory_description"><cf_get_lang dictionary_id='61757.Hukiki Gerekçe'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="data_inventory_legal_justification" id="data_inventory_legal_justification"><cfoutput>#attributes.data_inventory_legal_justification#</cfoutput></textarea>
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
		if(!$("#data_inventory").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">');
			$("#data_inventory").focus();
			return false;
		}
		return true;
	}
	function initForeignTransfer(){
		if($("#is_foreign_transfer").is(':checked')){
			$("#div_is_foreign_transfer_detail").show();
		}else{
			$("#div_is_foreign_transfer_detail").hide();
		}
		return true;
	}
	
	$( document ).ready(function() {
		initForeignTransfer();
	});
</script>