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
	if(Not isDefined("attributes.sensitivity_label")) attributes.sensitivity_label =  "";  
	if(Not isDefined("attributes.sensitivity_label_description")) attributes.sensitivity_label_description = '';

	if(attributes.event == "upd"){
		if(len(attributes.id)){
			gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.sensitivity_label");
			gdpr_data = gdpr_comp.get_sensitivity_label_byId(SENSITIVITY_LABEL_ID :'#attributes.id#');

			attributes.id = gdpr_data.sensitivity_label_id;
			attributes.sensitivity_label =   gdpr_data.sensitivity_label;  
			attributes.sensitivity_label_description = gdpr_data.sensitivity_label_description;
		}else{
			writeOutput("<script>alert('Hata Oluştu');history.back();</script>");
			exit;
		}
	}
	
</cfscript>

<cf_catalystHeader>
<cf_box>
	<cfform name="gdpr_sensitivity_label" id="gdpr_sensitivity_label" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=GDPR.welcome&event=upd&id=<cfoutput>#attributes.id#</cfoutput>">
		<input type="hidden" name="form_submitted" value="1" />
		<input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>" />
					<cf_box_elements>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-sensitivity_label">
								<label class="col col-4 col-xs-12" for="sensitivity_label"><cf_get_lang dictionary_id='270.Güvenlik Seviyesi'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="sensitivity_label" id="sensitivity_label" value="<cfoutput>#attributes.sensitivity_label#</cfoutput>" maxlength="50">
								</div>
							</div>
							<div class="form-group" id="item-sensitivity_label_description">
								<label class="col col-4 col-xs-12" for="sensitivity_label_description"><cf_get_lang dictionary_id='36199.Açıklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="sensitivity_label_description" id="sensitivity_label_description" maxlength="500" ><cfoutput>#attributes.sensitivity_label_description#</cfoutput></textarea>
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
								<cf_workcube_buttons is_upd='1' add_function="controlFormGdpr()" is_del="1" delete_page_url='#request.self#?fuseaction=gdpr.sensitivity_label&event=del&id=#attributes.id#'>
							<cfelse>
								<cf_workcube_buttons is_upd='0' add_function="controlFormGdpr()">
							</cfif>
						</div>
					</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
    function controlFormGdpr()
    {
		if(!$("#sensitivity_label").val().length)
		{
			alert('<cf_get_lang dictionary_id='58194.Zorunlu Alan'>');
			$("#sensitivity_label").focus();
			return false;
		}
		return true;
    }
</script>