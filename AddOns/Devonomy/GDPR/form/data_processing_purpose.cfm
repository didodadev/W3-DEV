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

	if(Not isDefined("attributes.id")) attributes.id =  "";
	if(Not isDefined("attributes.data_processing_purpose")) attributes.data_processing_purpose =  "";  
	if(Not isDefined("attributes.data_processing_purpose_description")) attributes.data_processing_purpose_description = '';
	if(Not isDefined("attributes.is_active")) attributes.is_active = 1;

	if(attributes.event == "upd"){
		if(len(attributes.id)){
			gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_processing_purpose");
			gdpr_data = gdpr_comp.get_data_processing_purpose_byId(DATA_PROCESSING_PURPOSE_ID :'#attributes.id#');

			attributes.id = gdpr_data.data_processing_purpose_id;
			attributes.data_processing_purpose =   gdpr_data.data_processing_purpose;  
			attributes.data_processing_purpose_description = gdpr_data.data_processing_purpose_description;
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
		<cfform name="gdpr_data_processing_purpose" id="gdpr_data_processing_purpose" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=GDPR.welcome&event=upd&id=<cfoutput>#attributes.id#</cfoutput>">
			<input type="hidden" name="form_submitted" value="1" />
			<input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>" />
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
					<div class="form-group" id="item-data_processing_purpose">
						<label class="col col-4 col-xs-12" for="data_processing_purpose"><cf_get_lang dictionary_id='61739.Veri İşleme Amacı'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="data_processing_purpose" id="data_processing_purpose" value="<cfoutput>#attributes.data_processing_purpose#</cfoutput>" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-data_processing_purpose_description">
						<label class="col col-4 col-xs-12" for="data_processing_purpose_description"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="data_processing_purpose_description" id="data_processing_purpose_description" maxlength="500" ><cfoutput>#attributes.data_processing_purpose_description#</cfoutput></textarea>
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
		if(!$("#data_processing_purpose").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">');
			$("#data_processing_purpose").focus();
			return false;
		}
		return true;
    }
</script>